//
//  HomePageViewController.m
//  KukeApp
//
//  Created by iOSDeveloper on 2018/8/23.
//  Copyright © 2018年 zhangming. All rights reserved.
//

#import "HomePageViewController.h"
#import "SDCycleScrollView.h"
#import "LoginViewController.h"
#import "HomePageBannerTableViewCell.h"
#import "HomePageExtensionTableViewCell.h"
#import "HomePageDiscountTableViewCell.h"
#import "HomePageRecommendTableViewCell.h"
#import "HomePageMenuTableViewCell.h"
#import "STQRCodeController.h"
#import "HomePageMessageViewController.h"
#import "HomePageMenuModel.h"
#import <SDWebImage/UIButton+WebCache.h>
#import "HomePageBannerViewController.h"
#import "CourseDetailViewController.h"
#import "NewsNoticeViewController.h"
#import "DHGuidePageHUD.h"
#import "NSArray+SafeKit.h"
#import "PLVDownloadManagerViewController.h"
#import "MyAnswerRecordListViewController.h"
#import "MyLearningListViewController.h"
#import "MyLearningRecordViewController.h"
#import "GroupBuyingTableViewCell.h"
#import "GroupBuyingListViewController.h"
#import "HomeSeckillTableViewCell.h"
#import "SeckillViewController.h"
#import "UploadNoticeView.h"
#import "HomePageMessageTableViewCell.h"
#import "CourseListModel.h"
#import "UIScrollView+WKRefresh.h"
#import "HomeLiveTableViewCell.h"

@interface HomePageViewController ()<SDCycleScrollViewDelegate,STQRCodeControllerDelegate>{
    NSInteger page;
    CGFloat oldY;
    CGFloat bottomOffsetY;
    BOOL isHeaderRefrish;

}

@property (nonatomic, strong) NSMutableArray *bannarAry;
@property (nonatomic, strong) NSMutableArray *bannarImageAry;
@property (nonatomic, strong) NSMutableArray *menuAry;
@property (nonatomic, strong) NSMutableArray *listAry;
@property (nonatomic, strong) NSMutableArray *groupBuyingAry;
@property (nonatomic, strong) NSMutableArray *seckillAry;
@property (nonatomic, strong) NSMutableArray *LiveAry;
@property (nonatomic, strong) UIView *view1;
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) HomePageAdModel *adModel;
@property (nonatomic, strong) HomePagePlaySeckillModel *seckillModel;
@property (nonatomic, strong) NSMutableArray *newsAry;
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) HomePagePlayModel *playModel;
@property (nonatomic, strong) NSArray *homeTypeAry;

@end

@implementation HomePageViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

//对于继承UITableViewController，如果想更改tableview样式，请重写初始化方法：
//- (instancetype)initWithStyle:(UITableViewStyle)style {
//    return [super initWithStyle: UITableViewStyleGrouped];
//}

- (void)viewDidLoad {

    [super viewDidLoad];
    isHeaderRefrish = NO;

//    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:BOOLFORKEY];
//     使用NSUserDefaults判断程序是否第一次启动(其他方法也可以)
    if (![[NSUserDefaults standardUserDefaults] boolForKey:BOOLFORKEY]) {

        // 在这里写初始化图片数组和DHGuidePageHUD库引导页的代码
        NSArray *imageNameArray = [NSArray array];
        if (kIsiPhoneX) {
            imageNameArray = @[@"1242-2688引导1.jpg",@"1242-2688新人福利.jpg"];
        }else{
            imageNameArray = @[@"750-1334引导1.jpg",@"750-1334新人福利.jpg"];
        }
        
        UIView *rootView = [[UIApplication sharedApplication] keyWindow];
        DHGuidePageHUD *guide  = [[DHGuidePageHUD alloc]dh_initWithFrame:rootView.frame imageNameArray:imageNameArray buttonIsHidden:NO];
        [rootView insertSubview:guide atIndex:10];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:BOOLFORKEY];

        guide.loginBtnBlock = ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [BaseTools alertLoginWithVC:self];
            });
        };
        guide.registeBtnBlock = ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [BaseTools alertRegisterWithVC:self];
            });
        };
        
    }

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadPlayData) name:@"uploadHomePageCourseRecord" object:nil];

    [self queryVersion];
    [self loadData];
    [self loadListData];
    
    self.tableView.frame = CGRectMake(0, 0, KScreenWidth, KScreenHeight -UI_tabBar_Height);
    [self.tableView registerClass:[HomePageBannerTableViewCell class] forCellReuseIdentifier:@"HomePageBannerTableViewCell"];
    [self.tableView registerClass:[HomePageMenuTableViewCell class] forCellReuseIdentifier:@"HomePageMenuTableViewCell"];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"HomePageDiscountTableViewCell" bundle:nil] forCellReuseIdentifier:@"HomePageDiscountTableViewCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"HomePageExtensionTableViewCell" bundle:nil] forCellReuseIdentifier:@"HomePageExtensionTableViewCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"HomePageRecommendTableViewCell" bundle:nil] forCellReuseIdentifier:@"HomePageRecommendTableViewCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"GroupBuyingTableViewCell" bundle:nil] forCellReuseIdentifier:@"GroupBuyingTableViewCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"HomeSeckillTableViewCell" bundle:nil] forCellReuseIdentifier:@"HomeSeckillTableViewCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"HomePageMessageTableViewCell" bundle:nil] forCellReuseIdentifier:@"HomePageMessageTableViewCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"HomeLiveTableViewCell" bundle:nil] forCellReuseIdentifier:@"HomeLiveTableViewCell"];
    
    
    
    [self initRefresh];
    
    __weak typeof(self) weakSelf = self;
    self.header_block = ^{
        isHeaderRefrish = YES;
        [weakSelf loadData];
        
//
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [weakSelf loadListData];
//        });

    };
    self.footre_block = ^{
        [weakSelf endRefreshWithFooterHidden];
    };
    
    _view1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth(), UI_navBar_Height)];
    _view1.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0];
    _view1.hidden = YES;
    [self.view addSubview:_view1];

    _label = [[UILabel alloc] initWithFrame:CGRectMake(0, midY(_view1)-10 , screenWidth(), 40)];
    _label.text=@"库课网校";
    _label.textColor = [UIColor clearColor];
    _label.textAlignment = NSTextAlignmentCenter;
    _label.font = [UIFont systemFontOfSize:18];
    [_view1 addSubview:_label];
    
    
}
#pragma mark - 点击背景刷新时执行
- (void)noDataBeginRefresh {
    [self lq_endLoading];
    [self loadData];
    [self loadListData];
}
- (void)initBottomView:(HomePagePlayModel *)model{
    
    [self.bottomView removeFromSuperview];
    
    self.playModel = model;
    
    self.bottomView = [[UIView alloc]initWithFrame:CGRectMake(15, screenHeight()-UI_tabBar_Height -70, screenWidth()-30, 60)];
    
    UIColor *color = [UIColor blackColor];
    self.bottomView.backgroundColor = [color colorWithAlphaComponent:0.8];
    self.bottomView.layer.cornerRadius = 5;
    self.bottomView.layer.masksToBounds = YES;
    [self.view addSubview:self.bottomView];
    
    
    UIImageView *openImage = [[UIImageView alloc]initWithFrame:CGRectMake(10, 22, 16, 16)];
    openImage.image = [UIImage imageNamed:@"移动端弹窗关闭按钮"];
    [self.bottomView addSubview:openImage];
    openImage.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapClose = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeAction)];
    tapClose.cancelsTouchesInView = NO;
    [openImage addGestureRecognizer:tapClose];
    
    UIImageView *courseImage = [[UIImageView alloc]initWithFrame:CGRectMake(maxX(openImage)+10, 5, 72, 50)];
    [courseImage sd_setImageWithURL:[NSURL URLWithString:model.course_img] placeholderImage:nil];
    courseImage.layer.cornerRadius = 3;
    courseImage.layer.masksToBounds = YES;
    courseImage.backgroundColor = [UIColor blackColor];
    courseImage.alpha = 1;
    [self.bottomView addSubview:courseImage];
    
    UILabel *titleLab = [[UILabel alloc]initWithFrame:CGRectMake(maxX(courseImage)+10, 0, screenWidth()-200, 35)];
    titleLab.numberOfLines = 0;
    titleLab.font = [UIFont systemFontOfSize:13];
    titleLab.text = model.last_node_title;
    titleLab.textColor = [UIColor whiteColor];
    [self.bottomView addSubview:titleLab];
    
    UILabel *recordLab = [[UILabel alloc]initWithFrame:CGRectMake(maxX(courseImage)+10, 40, screenWidth()-200, 20)];
    recordLab.font = [UIFont systemFontOfSize:10];
    recordLab.text = [NSString stringWithFormat:@"上次学习到:%@",model.last_time_point];
    recordLab.textColor = [UIColor whiteColor];
    [self.bottomView addSubview:recordLab];
    
    
    UIImageView *playImage = [[UIImageView alloc]initWithFrame:CGRectMake(screenWidth()-42-30, 14, 32, 32)];
    playImage.image = [UIImage imageNamed:@"首页记录播放按钮"];
    [self.bottomView addSubview:playImage];
    playImage.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapPlay = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(playAction)];
    tapPlay.cancelsTouchesInView = NO;
    [playImage addGestureRecognizer:tapPlay];

}

- (void)playAction{
    MyLearningRecordViewController *vc = [[MyLearningRecordViewController alloc]init];
    vc.imageUrl = self.playModel.course_img;
    vc.course_name = self.playModel.course_title;
    vc.continueLearningID = self.playModel.last_node_id;
    vc.course_id = self.playModel.course_id;
    [self.navigationController pushViewController:vc animated:YES];
    
}
- (void)closeAction{
    [self.bottomView setHidden:YES];
}
- (void)loadPlayData{

    [ZMNetworkHelper POST:@"/index/index" parameters:nil cache:YES responseCache:^(id responseCache) {
        
    } success:^(id responseObject) {
        
        if ([responseObject[@"code"] isEqualToString:@"0"]) {
            HomePageMenuModel *model = [[HomePageMenuModel alloc]initWithDictionary:responseObject error:nil];
    
            if (model.data.course_last_play.course_id.length !=0) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [self initBottomView:model.data.course_last_play];
                });
            }
            
        }else{
            [BaseTools showErrorMessage:responseObject[@"msg"]];
        }
        
    } failure:^(NSError *error) {
        
    }];
    
}

- (void)loadData{
    self.menuAry = [NSMutableArray array];
    self.bannarAry = [NSMutableArray array];
    self.bannarImageAry = [NSMutableArray array];
    self.groupBuyingAry =  [NSMutableArray array];
    self.seckillAry = [NSMutableArray array];
    self.newsAry = [NSMutableArray array];
    self.LiveAry = [NSMutableArray array];

    NSMutableDictionary *parmDic = [NSMutableDictionary dictionary];
    [parmDic setObject:[NSString stringWithFormat:@"%d",[UserDefaultsUtils boolValueWithKey:KIsAudit]] forKey:@"is_audit"];
    
    BADataEntity *entity = [BADataEntity new];
    entity.urlString = @"/index/index";
    entity.needCache = NO;
    entity.parameters = parmDic;
    if (![CoreStatus isNetworkEnable]) {
        [self lq_showFailLoadWithType:(LQTableViewFailLoadViewTypeNoData) tipsString:@"无法连接到网络,点击页面刷新"];
        return;
    }else{
        
        self.tableView.loading = YES;
    }
    
    // 如果打印数据不完整，是因为 Xcode 8 版本问题，请下断点打印数据
    [BANetManager ba_request_POSTWithEntity:entity successBlock:^(id response) {
        
        if (response == nil) {
            
        }else{
            if ([response[@"code"] isEqualToString:@"0"]) {
                HomePageMenuModel *model = [[HomePageMenuModel alloc]initWithDictionary:response error:nil];
                
                for (HomePageBannerModel *obj in model.data.carousel) {
                    [self.bannarImageAry addObject:obj.image];
                }
                [self.newsAry addObjectsFromArray:model.data.news];
                [self.bannarAry addObjectsFromArray:model.data.carousel];
                [self.menuAry addObjectsFromArray:model.data.category];
                [self.groupBuyingAry addObjectsFromArray:model.data.group];
                [self.seckillAry addObjectsFromArray:model.data.seckill.goods];
                [self.LiveAry addObjectsFromArray:model.data.lives];
                self.adModel = model.data.ad;
                self.seckillModel = model.data.seckill;
                
                
                if (self.LiveAry.count == 0 && self.groupBuyingAry.count == 0 && self.seckillAry.count == 0) {
                    
                    self.homeTypeAry = @[@"Banner",@"Menu",@"Ad",@"News",@"Like"];
                }else if (self.LiveAry.count == 0 && self.groupBuyingAry.count == 0 && self.seckillAry.count != 0){
                    
                    self.homeTypeAry = @[@"Banner",@"Menu",@"Ad",@"Seckill",@"News",@"Like"];
                }else if (self.LiveAry.count == 0 && self.groupBuyingAry.count != 0 && self.seckillAry.count == 0){
                    
                    self.homeTypeAry = @[@"Banner",@"Menu",@"Group",@"Ad",@"News",@"Like"];
                }else if (self.LiveAry.count == 0 && self.groupBuyingAry.count != 0 && self.seckillAry.count != 0){
                    
                    self.homeTypeAry = @[@"Banner",@"Menu",@"Group",@"Ad",@"Seckill",@"News",@"Like"];
                }else if (self.LiveAry.count != 0 && self.groupBuyingAry.count == 0 && self.seckillAry.count == 0){
                    
                    self.homeTypeAry = @[@"Banner",@"Menu",@"Live",@"Ad",@"News",@"Like"];
                }else if (self.LiveAry.count != 0 && self.groupBuyingAry.count == 0 && self.seckillAry.count != 0){
                    
                    self.homeTypeAry = @[@"Banner",@"Menu",@"Live",@"Ad",@"Seckill",@"News",@"Like"];
                }else if (self.LiveAry.count != 0 && self.groupBuyingAry.count != 0 && self.seckillAry.count == 0){
                    
                    self.homeTypeAry = @[@"Banner",@"Menu",@"Live",@"Group",@"Ad",@"News",@"Like"];
                }else if (self.LiveAry.count != 0 && self.groupBuyingAry.count != 0 && self.seckillAry.count != 0){
                    
                    self.homeTypeAry = @[@"Banner",@"Menu",@"Live",@"Group",@"Ad",@"Seckill",@"News",@"Like"];
                }
                
                [MenuDataTool deleteListData];
                [MenuDataTool initialize];
                for (HomePageCategoryModel *dict in model.data.category) {
                    [MenuDataTool addMenu:dict];
                }
                
                if (model.data.course_last_play.course_id.length !=0) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        [self initBottomView:model.data.course_last_play];
                    });
                }
            }else if ([response[@"code"] isEqualToString:@"-10000"]){
                [BaseTools showErrorMessage:@"请登录后再操作"];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [BaseTools alertLoginWithVC:self];
                });
            }else{
                [BaseTools showErrorMessage:response[@"msg"]];
            }
        }
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
             [self endWaterDropRefreshWithHeaderHidden];
        });

       

        [self setEmptyViewDelegeta];
//        self.tableView.contentInset = UIEdgeInsetsMake(0, 0, -UI_tabBar_Height, 0); //首先改变内边距 -105是底部的距离
//        CGRect rectInTableView = [self.tableView rectForRowAtIndexPath:[NSIndexPath indexPathForRow:5 inSection:2]]; //现在是写死的 你可以根据模型数据 写成变量
//        CGRect rect = [self.tableView convertRect:rectInTableView toView:[self.tableView superview]];//这是是最后cell row的高度
//        if(rect.origin.y<=-1288){ //-1288  这个位置 是可以根据你的位置调整出来
//            self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
//        }else{
//            self.tableView.contentInset = UIEdgeInsetsMake(0, 0, -UI_tabBar_Height, 0);
//        }
        [self.tableView reloadData];
        if (isHeaderRefrish ) {
            [self loadListData];
        }
    } failureBlock:^(NSError *error) {
        [self setEmptyViewDelegeta];
    } progressBlock:^(int64_t bytesProgress, int64_t totalBytesProgress) {
        /*! 封装方法里已经回到主线程，所有这里不用再调主线程了 */
        
    }];
}

- (void)loadListData{
    self.listAry = [NSMutableArray array];
    NSMutableDictionary *parmDic = [NSMutableDictionary dictionary];
    [parmDic setObject:[NSString stringWithFormat:@"%ld",page] forKey:@"page"];
    BADataEntity *entity = [BADataEntity new];
    entity.urlString = @"/index/like";
    entity.needCache = NO;
    entity.parameters = parmDic;
//    if (![CoreStatus isNetworkEnable]) {
//        [self lq_showFailLoadWithType:(LQTableViewFailLoadViewTypeNoData) tipsString:@"无法连接到网络,点击页面刷新"];
//        return;
//    }else{
//
//        self.tableView.loading = YES;
//    }
    
    // 如果打印数据不完整，是因为 Xcode 8 版本问题，请下断点打印数据
    [BANetManager ba_request_POSTWithEntity:entity successBlock:^(id response) {
        
        if (response == nil) {
            
        }else{
            if ([response[@"code"] isEqualToString:@"0"]) {
                CourseListModel *model = [[CourseListModel alloc]initWithDictionary:response error:nil];
                [self.listAry addObjectsFromArray:model.data];
            }else if ([response[@"code"] isEqualToString:@"-10000"]){
                [BaseTools showErrorMessage:@"请登录后再操作"];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [BaseTools alertLoginWithVC:self];
                });
            }else{
                [BaseTools showErrorMessage:response[@"msg"]];
            }
        }
        [self endWaterDropRefreshWithHeaderHidden];
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
//        [self setEmptyViewDelegeta];
        [self.tableView reloadData];
       
    } failureBlock:^(NSError *error) {
        [self setEmptyViewDelegeta];
    } progressBlock:^(int64_t bytesProgress, int64_t totalBytesProgress) {
        /*! 封装方法里已经回到主线程，所有这里不用再调主线程了 */
        
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.homeTypeAry.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if ([self.homeTypeAry[section] isEqualToString:@"News"]) {
         return self.newsAry.count;
    }else if ([self.homeTypeAry[section] isEqualToString:@"Like"]){
         return self.listAry.count;
    }else{
        return 1;
    }

}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    if ([self.homeTypeAry[indexPath.section] isEqualToString:@"Banner"]) {
        return screenHeight()/3.5;
    }else if ([self.homeTypeAry[indexPath.section] isEqualToString:@"Menu"]){
        return screenWidth()/4*2+8;
    }else if ([self.homeTypeAry[indexPath.section] isEqualToString:@"Live"]){
        return 223;
    }else if ([self.homeTypeAry[indexPath.section] isEqualToString:@"Group"]){
        return 226;
    }else if ([self.homeTypeAry[indexPath.section] isEqualToString:@"Ad"]){
        return 97;
    }else if ([self.homeTypeAry[indexPath.section] isEqualToString:@"Seckill"]){
        return 226;
    }else if ([self.homeTypeAry[indexPath.section] isEqualToString:@"News"]){
        return 97;
    }else if ([self.homeTypeAry[indexPath.section] isEqualToString:@"Like"]){
        return 123;
    }else{
        return 0;
    }

    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    
    if ([self.homeTypeAry[indexPath.section] isEqualToString:@"Banner"]) {
        HomePageBannerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HomePageBannerTableViewCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.imageAry = self.bannarImageAry;
        cell.myQRcodeBlock = ^{
            if ([[UserDefaultsUtils valueWithKey:@"access_token"] length] !=0 ) {
                STQRCodeController *codeVC = [[STQRCodeController alloc]init];
                codeVC.delegate = self;
                UINavigationController *navVC = [[UINavigationController alloc]initWithRootViewController:codeVC];
                [self presentViewController:navVC animated:YES completion:nil];
            }else{
                [BaseTools showErrorMessage:@"请登录后再操作"];
                dispatch_async(dispatch_get_main_queue(), ^{

                    [BaseTools alertLoginWithVC:self];
                });
            }
        };
        cell.myDownLoadBlock = ^{

            if ([[UserDefaultsUtils valueWithKey:@"access_token"] length] !=0 ) {
                PLVDownloadManagerViewController *vc = [[PLVDownloadManagerViewController alloc]init];
                [self.navigationController pushViewController:vc animated:YES];
            }else{
                [BaseTools showErrorMessage:@"请登录后再操作"];
                dispatch_async(dispatch_get_main_queue(), ^{

                    [BaseTools alertLoginWithVC:self];
                });
            }
        };
        cell.myRecordBlock = ^{
            if ([[UserDefaultsUtils valueWithKey:@"access_token"] length] !=0 ) {
                MyLearningListViewController *vc = [[MyLearningListViewController alloc]init];
                [self.navigationController pushViewController:vc animated:YES];
            }else{
                [BaseTools showErrorMessage:@"请登录后再操作"];
                dispatch_async(dispatch_get_main_queue(), ^{

                    [BaseTools alertLoginWithVC:self];
                });
            }

        };
        cell.myBannarBlock = ^(NSInteger index) {
            
            if ([UserDefaultsUtils boolValueWithKey:KIsAudit]){
  
                NSDictionary *dict = @{@"ID":@"1", @"Name":@"专升本"};
                [[NSNotificationCenter defaultCenter] postNotificationName:@"SwitchToCourseViewController" object:dict];
            }else{
                HomePageBannerViewController *vc = [[HomePageBannerViewController alloc]init];
                HomePageBannerModel *model  = self.bannarAry[index];
                vc.url = model.url;
                vc.title = @"详情";
                [self.navigationController pushViewController:vc animated:YES];
            }
            


        };
        return cell;
    }else if ([self.homeTypeAry[indexPath.section] isEqualToString:@"Menu"]){
        HomePageMenuTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HomePageMenuTableViewCell" forIndexPath:indexPath];
        cell.menuAry = self.menuAry;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else if ([self.homeTypeAry[indexPath.section] isEqualToString:@"Live"]){
        HomeLiveTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HomeLiveTableViewCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.modelAry = self.LiveAry;
        return cell;
    }else if ([self.homeTypeAry[indexPath.section] isEqualToString:@"Group"]){
        GroupBuyingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GroupBuyingTableViewCell" forIndexPath:indexPath];
        [cell.groupBuyingListBtn addTarget:self action:@selector(groupBuyingListAction) forControlEvents:(UIControlEventTouchUpInside)];
        cell.ary = self.groupBuyingAry;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else if ([self.homeTypeAry[indexPath.section] isEqualToString:@"Ad"]){
        HomePageDiscountTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HomePageDiscountTableViewCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.adImage sd_setImageWithURL:[NSURL URLWithString:self.adModel.image] forState:(UIControlStateNormal) placeholderImage:[UIImage imageNamed:@"app圆形广告位"]];
        [cell.adImage addTarget:self action:@selector(adAction) forControlEvents:(UIControlEventTouchUpInside)];

        return cell;
    }else if ([self.homeTypeAry[indexPath.section] isEqualToString:@"Seckill"]){
        HomeSeckillTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HomeSeckillTableViewCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.ary = self.seckillAry;
        [cell.seckillBtn addTarget:self action:@selector(seckillListAction) forControlEvents:(UIControlEventTouchUpInside)];

        if ([self.seckillModel.seckill_status isEqualToString:@"1"]) {
            [cell.textLab setTitle:@"距离本场结束" forState:(UIControlStateNormal)];
            //倒计时
            [self beginCountDown: ^(id receiver, NSInteger leftTime, BOOL *isStop) {
                if (leftTime > 0) {
                    NSInteger hours   = (NSInteger)((leftTime)/3600);
                    NSInteger minute  = (NSInteger)(leftTime- hours*3600)/60;
                    NSInteger second  = (NSInteger)leftTime- hours*3600 - minute*60;
                    cell.hourLab.text = [NSString stringWithFormat:@"%02ld",(long)hours];
                    cell.minuteLab.text = [NSString stringWithFormat:@"%02ld",(long)minute];
                    cell.secondLab.text = [NSString stringWithFormat:@"%02ld",(long)second];
                } else {
                    [self loadData];
                }
            } WithStartTimeStamp:[[BaseTools currentTimeStr] longLongValue] endTimeStamp:[self.seckillModel.end_time longLongValue]*1000];
        }else{
            [cell.textLab setTitle:@"距离下场开始" forState:(UIControlStateNormal)];
            //倒计时

            [self beginCountDown: ^(id receiver, NSInteger leftTime, BOOL *isStop) {
                if (leftTime > 0) {
                    NSInteger hours   = (NSInteger)((leftTime)/3600);
                    NSInteger minute  = (NSInteger)(leftTime- hours*3600)/60;
                    NSInteger second  = (NSInteger)leftTime- hours*3600 - minute*60;
                    cell.hourLab.text = [NSString stringWithFormat:@"%02ld",(long)hours];
                    cell.minuteLab.text = [NSString stringWithFormat:@"%02ld",(long)minute];
                    cell.secondLab.text = [NSString stringWithFormat:@"%02ld",(long)second];
                } else {
                    [self loadData];
                }
            } WithStartTimeStamp:[[BaseTools currentTimeStr] longLongValue] endTimeStamp:[self.seckillModel.start_time longLongValue]*1000];
        }
        return cell;
    }else if ([self.homeTypeAry[indexPath.section] isEqualToString:@"News"]){
        HomePageMessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HomePageMessageTableViewCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (self.newsAry.count != 0) {
            cell.model = self.newsAry[indexPath.row];
        }
        return cell;
    }else if ([self.homeTypeAry[indexPath.section] isEqualToString:@"Like"]){
        HomePageRecommendTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HomePageRecommendTableViewCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.model = self.listAry[indexPath.row];

        return cell;
    }else{
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;

    }

}

//头视图高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {

    if ([self.homeTypeAry[section] isEqualToString:@"News"] || [self.homeTypeAry[section] isEqualToString:@"Like"]) {
        return 48;
    }else{
        return 0;
    }

    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth(), 48)];
    headerView.backgroundColor = CBackgroundColor;
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 8, screenWidth(), 40)];
    view.backgroundColor = [UIColor whiteColor];
    [headerView addSubview:view];
    
    UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, 200, 30)];
    lab.text = @"课程推荐";
    lab.font = [UIFont systemFontOfSize:15];
    lab.textColor = [UIColor colorWithHexString:@"#494949"];
    [view addSubview:lab];
    
    UIButton *btn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    btn.frame = CGRectMake(screenWidth()-100, 5, 100, 30);
    [btn setTitle:@"换一换" forState:(UIControlStateNormal)];
    [btn setTitleColor:[UIColor lightGrayColor] forState:(UIControlStateNormal)];
    [btn setImage:[UIImage imageNamed:@"换一换"] forState:(UIControlStateNormal)];
    btn.titleLabel.textAlignment = NSTextAlignmentRight;
    btn.titleLabel.font = [UIFont systemFontOfSize:15];
    [btn br_layoutButtonWithEdgeInsetsStyle:(BRButtonEdgeInsetsStyleLeft) imageTitleSpace:5];
    
    [btn addTarget:self action:@selector(changeList) forControlEvents:(UIControlEventTouchUpInside)];
    [view addSubview:btn];
    
    UILabel *lineLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 40, screenWidth(), 1)];
    lineLab.backgroundColor = CBackgroundColor;
    [view addSubview:lineLab];
    
    UIView *headerView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth(), 0)];
    headerView1.backgroundColor = CBackgroundColor;
    
    if ([self.homeTypeAry[section] isEqualToString:@"News"] ) {
        lab.text = @"热点资讯";
        btn.hidden = YES;
        return headerView;
    }else if([self.homeTypeAry[section] isEqualToString:@"Like"]){
        return headerView;
    }else{
        return headerView1;
    }

}

//脚视图高度
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
  
    if ([self.homeTypeAry[section] isEqualToString:@"Menu"]  ) {
        
        return 8;
    }else if([self.homeTypeAry[section] isEqualToString:@"Live"]){
        return 8;
    }else{
        return 0;
    }

  
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth(), 8)];
    footerView.backgroundColor = CBackgroundColor;
    return footerView;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([self.homeTypeAry[indexPath.section] isEqualToString:@"News"]) {
        
        if ([UserDefaultsUtils boolValueWithKey:KIsAudit]){

        }else{
            HomeNewsModel *model = self.newsAry[indexPath.row];
            HomePageBannerViewController *vc = [[HomePageBannerViewController alloc]init];
            vc.url = model.url;
            vc.title = @"资讯详情";
            [self.navigationController pushViewController:vc animated:YES];
        }
        
    }else if ([self.homeTypeAry[indexPath.section] isEqualToString:@"Like"]){
        CourseDataAryModel *model = self.listAry[indexPath.row];
        CourseDetailViewController *vc = [[CourseDetailViewController alloc]init];
        vc.ID = model.ID;
        vc.titleIndex = model.goods_type;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - --- QRcode delegate 视图委托 ---
- (void)qrcodeController:(STQRCodeController *)qrcodeController readerScanResult:(NSString *)readerScanResult type:(STQRCodeResultType)resultType
{

    if ((resultType == STQRCodeResultTypeError) || (resultType == STQRCodeResultTypeNoInfo)) {
        readerScanResult = @"没有扫描到结果";
    }else{
        HomePageBannerViewController *vc = [[HomePageBannerViewController alloc]init];
        vc.url = readerScanResult;
        vc.title = @"扫描结果";
        [self.navigationController pushViewController:vc animated:YES];
    }

}


-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    _view1.hidden = NO;
    CGFloat offsetY = self.tableView.contentOffset.y;
    if (offsetY < 150)
    {
        _label.textColor = [UIColor colorWithHexString:@"494949"];
        _view1.backgroundColor = [UIColor whiteColor];
        _view1.alpha =offsetY/100;
    }else
    {
        _view1.backgroundColor = [UIColor whiteColor];
    }
    //判断滑动到底部
    if (scrollView.contentOffset.y == scrollView.contentSize.height - self.tableView.frame.size.height) {
        [UIView transitionWithView:self.bottomView duration:0.1 options:UIViewAnimationOptionTransitionNone animations:^{
            self.bottomView.frame = CGRectMake(15, screenHeight()-UI_tabBar_Height - 70, screenWidth()-30, 60);
        } completion:NULL];
    }
    
    if (scrollView.contentOffset.y > oldY && scrollView.contentOffset.y > 0) {//如果当前位移大于缓存位移，说明scrollView向上滑动
        [UIView transitionWithView:self.bottomView duration:0.1 options:UIViewAnimationOptionTransitionNone animations:^{
            self.bottomView.frame = CGRectMake(15, screenHeight()-UI_tabBar_Height, screenWidth()-30, 60);
        } completion:NULL];
    }else if (scrollView.contentOffset.y < oldY){
        [UIView transitionWithView:self.bottomView duration:0.1 options:UIViewAnimationOptionTransitionNone animations:^{
            self.bottomView.frame = CGRectMake(15, screenHeight()-UI_tabBar_Height - 70, screenWidth()-30, 60);
        } completion:NULL];
    }
    oldY = scrollView.contentOffset.y;//将当前位移变成缓存位移
    if (scrollView == self.tableView)
    {
        UITableView *tableview = (UITableView *)scrollView;
        CGFloat sectionHeaderHeight = 48;
        CGFloat sectionFooterHeight = 8;
        CGFloat offsetY = tableview.contentOffset.y;
        if (offsetY >= 0 && offsetY <= sectionHeaderHeight)
        {
            tableview.contentInset = UIEdgeInsetsMake(-offsetY, 0, -sectionFooterHeight, 0);
            
        }else if (offsetY >= sectionHeaderHeight && offsetY <= tableview.contentSize.height - tableview.frame.size.height - sectionFooterHeight)
        {
            tableview.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, -sectionFooterHeight, 0);
        }else if (offsetY >= tableview.contentSize.height - tableview.frame.size.height - sectionFooterHeight && offsetY <= tableview.contentSize.height - tableview.frame.size.height)
        {
            tableview.contentInset = UIEdgeInsetsMake(-offsetY, 0, -(tableview.contentSize.height - tableview.frame.size.height - sectionFooterHeight), 0);
        }
    }
//
//    CGFloat sectionFooterH = 10;
//    if (scrollView.contentOffset.y<=sectionFooterH && scrollView.contentOffset.y>=0) {
//        scrollView.contentInset = UIEdgeInsetsMake(0, 0, -sectionFooterH, 0);
//    } else if (scrollView.contentOffset.y>= sectionFooterH) {
//        scrollView.contentInset = UIEdgeInsetsMake(0, 0, -sectionFooterH, 0);
//    }
    
    
    
}
- (void)groupBuyingListAction{
    GroupBuyingListViewController *vc = [[GroupBuyingListViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)seckillListAction{
    SeckillViewController *vc = [[SeckillViewController alloc]init];
    vc.seckillDate = self.seckillModel.seckill_date;
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)adAction{
    if ([UserDefaultsUtils boolValueWithKey:KIsAudit]){
        
    }else{
        HomePageBannerViewController *vc = [[HomePageBannerViewController alloc]init];
        vc.url = self.adModel.url;
        vc.title = @"库课网校";
        [self.navigationController pushViewController:vc animated:YES];
    }

}
- (void)changeList{
    page++;
    [self loadListData];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
  
}
/**
 *   获取最新版本号   检测版本更新
 */
- (void)queryVersion
{
    NSMutableDictionary *parmDic = [NSMutableDictionary dictionary];
    [parmDic setObject:[[[NSBundle mainBundle]infoDictionary]objectForKey:@"CFBundleShortVersionString"] forKey:@"ver_name"];
    [ZMNetworkHelper POST:@"/app/ios_version_con" parameters:parmDic cache:NO responseCache:^(id responseCache) {
        
    } success:^(id responseObject) {
        if ([responseObject[@"code"] isEqualToString:@"0"]) {
            
            if ([responseObject[@"data"][@"is_force"] isEqualToString:@"0"]) {//非强制更新每天只提醒一次
                
                if ([self allowShowLocationAlert]) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        UploadNoticeView *uploadView = [[UploadNoticeView alloc]initWithFrame:CGRectMake(0, 0,314,370)];
                        uploadView.contentLab.text = responseObject[@"data"][@"content"];
                        uploadView.closeBtn.hidden = NO;
                        CGPoint showCenter = CGPointMake(SCREEN_WIDTH/2,SCREEN_HEIGHT-self.view.height/2-50);
                        [SGBrowserView showMoveView:uploadView moveToCenter:showCenter];
                        uploadView.closeBlock = ^{
                            [SGBrowserView hide];
                        };
                        uploadView.uploadBlock = ^{
                            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/cn/app/jie-zou-da-shi/id1110639107?mt=8"]];
                        };
                        
                    });
                }
                
            }else{//强制更新每次都提醒
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    UploadNoticeView *uploadView = [[UploadNoticeView alloc]initWithFrame:CGRectMake(0, 0,314,370)];
                    uploadView.contentLab.text = responseObject[@"data"][@"content"];
               
                    CGPoint showCenter = CGPointMake(SCREEN_WIDTH/2,SCREEN_HEIGHT-self.view.height/2-50);
                    [SGBrowserView showMoveView:uploadView moveToCenter:showCenter];
                    uploadView.closeBtn.hidden = YES;
                    [SGBrowserView setCanAutoHide:NO];
                    uploadView.closeBlock = ^{

                        
                    };
                    uploadView.uploadBlock = ^{
                        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/cn/app/jie-zou-da-shi/id1110639107?mt=8"]];
                    };
                    
                });
            }

        }
        
    } failure:^(NSError *error) {
        
    }];
    
    
}
/**
 *   是否允许弹窗
 */
-(BOOL)allowShowLocationAlert{
    
    NSDate *now = [NSDate date];
    //当前时间的时间戳
    NSTimeInterval nowStamp = [now timeIntervalSince1970];
    //当天零点的时间戳
    NSTimeInterval zeroStamp = [[[NSUserDefaults standardUserDefaults] objectForKey:@"zeroStamp"] doubleValue];
    //一天的时间戳
    NSTimeInterval oneDay = 60* 60 * 24;
    
    /**
     "showedLocation"代表了是否当天是否提醒过开启定位，NO代表没有提醒过，YES代表已经提醒过
     */
    
    if(nowStamp - zeroStamp> oneDay){
        
        zeroStamp = [self getTodayZeroStampWithDate:now];
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithDouble:zeroStamp] forKey:@"zeroStamp"];
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES] forKey:@"showedLocation"];
        return YES;
        
    }else{
        
        if ([[NSUserDefaults standardUserDefaults] objectForKey:@"showedLocation"]) {
            return NO;
            
        }else{
            return YES;
        }
        
    }
    
}

/**
 * 获取当天零点时间戳
 */
- (double)getTodayZeroStampWithDate:(NSDate *)date{
    
    NSDateFormatter *dateFomater = [[NSDateFormatter alloc]init];
    dateFomater.dateFormat = @"yyyy年MM月dd日";
    NSString *original = [dateFomater stringFromDate:date];
    NSDate *ZeroDate = [dateFomater dateFromString:original];
    // 今天零点的时间戳
    NSTimeInterval zeroStamp = [ZeroDate timeIntervalSince1970];
    return zeroStamp;
    
}




@end
