//  KukeApp
//
//  Created by iOSDeveloper on 2018/8/23.
//  Copyright © 2018年 zhangming. All rights reserved.
//
#import "CourseDetailViewController.h"
#import "JXPagingView.h"
#import "JXCategoryView.h"
#import "CourseCatalogView.h"
#import "CourseCommentView.h"
#import "CourseIntroduceView.h"
#import "CourseDetailHeaderView.h"
#import "BottomToolView.h"
#import "PayMentViewController.h"
#import "PLVVodSkinPlayerController.h"
#import "SeckillCourseDetailView.h"
#import "DistributionBottomShareView.h"
#import "DistributionGoodsShareView.h"
#import "PLVDownloadManagerViewController.h"
#import "GoodsDetailBottomBarView.h"

@interface CourseDetailViewController () <TestListViewDelegate, JXPagingViewDelegate, JXCategoryViewDelegate,YBPopupMenuDelegate,QYConversationManagerDelegate, QYSessionViewDelegate,NoDataTipsDelegate>{
    NSString *courseID;
    NSString *liveID;
    NSString *goods_type;
    CourseCommentView *commentListView;
    UILabel *liveExamLab;
    CourseCatalogView *catalogListView;
    CGFloat headerHeight;
    CourseIntroduceView *introduceListView;
    CGFloat JXheightForHeaderInSection;

}
@property (nonatomic, strong) JXPagingView *pagingView;
@property (nonatomic, strong) CourseDetailHeaderView *userHeaderView;
@property (nonatomic, strong) JXCategoryTitleView *categoryView;
@property (nonatomic, strong) NSArray <CourseDetailListBaseView *> *listViewArray;
@property (nonatomic, strong) NSArray <NSString *> *titles;
@property (nonatomic, strong) BottomToolView *bottomView;
@property (nonatomic, strong) PLVVodSkinPlayerController *player;
@property (strong, nonatomic) UIView *playerPlaceholder;
@property (nonatomic, strong) UIImageView *images;
@property (nonatomic, strong) UIButton *playBtn;
@property (nonatomic,copy)    NSString *kf_list;
@property (nonatomic,strong)  UIButton *titleBtn;
@property (nonatomic,strong)  PLVVodVideo *videos;
@property (strong, nonatomic) UIView *headerView;
@property (strong, nonatomic) UIButton *distributeBtn;
@property (strong, nonatomic) DistributionBottomShareView *shareView;
@property (strong, nonatomic) NSString *nextLesson;
@property (nonatomic,assign)  CGFloat offset;
@property (strong, nonatomic) NSMutableDictionary *modelDict;
@property (strong, nonatomic) CourseDetailModel *model;
@property (nonatomic, strong) NoDataTipsView *loadNetView;
@property (nonatomic, strong) UIButton *menubtn;
@property (nonatomic, strong) UIButton *backbtn;
@property (nonatomic, strong) UIButton *sharebtn;
//@property (nonatomic, strong) UIView *rootView2;
@property (nonatomic, strong) UIView *lodingview;

@end

@implementation CourseDetailViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    if (![CoreStatus isNetworkEnable]) {
        
    }else{
        _backbtn.hidden = NO;
        _sharebtn.hidden = NO;
        _menubtn.hidden = NO;
    }
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    id traget = self.navigationController.interactivePopGestureRecognizer.delegate;
    UIPanGestureRecognizer * pan = [[UIPanGestureRecognizer alloc]initWithTarget:traget action:nil];
    [self.view addGestureRecognizer:pan];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hiddenBtn:) name:@"HiddenCourseBackAndShareButton" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(navUI) name:@"CloseLive" object:nil];
    //接收通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadDetailData) name:@"RelodaDetailData" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(classRoomStartLearning) name:@"ClassRoomStartLearning" object:nil];
    self.view.backgroundColor = (kIsiPhoneX? [UIColor blackColor] : [UIColor clearColor]);
    JXheightForHeaderInSection = (kIsiPhoneX? 50 : 60);
    
    [self initHeaderVideoView];
    self.title = @"详情";
    if ([self.titleIndex isEqualToString:@"4"]) {
        _titles = @[@"详情",@"评价"];
    }else{
        _titles = @[@"详情", @"大纲", @"评价"];
    }
//    self.rootView2 = [[UIApplication sharedApplication] keyWindow];
//    [self.rootView2 addSubview:self.shareBtn];
//    [self.rootView2 addSubview:self.menuBtn];
//    [self.rootView2 addSubview:self.backBtn];
//    _backBtn.hidden = NO;
//    _shareBtn.hidden = NO;
//    _menuBtn.hidden = NO;

    [self initView];
    
    
    
    if (![CoreStatus isNetworkEnable]) {
        [self.view addSubview:self.loadNetView];
        self.sharebtn.hidden = YES;
        self.menubtn.hidden = YES;
    }else{
        [self loadIntroduceData];
        [self loadData];
    }

//    introduceListView = [[CourseIntroduceView alloc] init];
//    [introduceListView getCourseType:self.titleIndex withDistribute:self.distribute];
//    introduceListView.delegate = self;
//
//    catalogListView = [[CourseCatalogView alloc] init];
//    [catalogListView getCourseID:self.ID withClass:[self.titleIndex integerValue]];
//
//    __weak typeof(self) weakSelf = self;
//    catalogListView.myBlock = ^(NSString *ID) {
//        __strong typeof(weakSelf) sself = weakSelf;
//        if (weakSelf.player) {
//            [weakSelf postPlayTime];
//        }
//
//        BOOL isSame = NO;
//        if ([sself->liveID isEqualToString:ID]) {
//            isSame = YES;
//        }
//        sself->liveID = ID;
//
//        if (isSame) {
//            if (self.player.playbackState == PLVVodPlaybackStatePaused) {
//                [weakSelf.player play];
//            }else if (self.player.playbackState == PLVVodPlaybackStatePlaying) {
//                [weakSelf.player pause];
//            }else if (self.player.playbackState == PLVVodPlaybackStateStopped) {
//                [weakSelf playButtonClick];
//            }
//        }else{
//            [weakSelf playButtonClick];
//        }
//    };
//    catalogListView.delegate = self;
//    commentListView = [[CourseCommentView alloc] init];
//    [commentListView getCourseID:self.ID withClass:[self.titleIndex integerValue]];
//    commentListView.delegate = self;
//    if ([self.titleIndex isEqualToString:@"4"]) {
//        _listViewArray = @[introduceListView,commentListView];
//    }else{
//        _listViewArray = @[introduceListView,catalogListView,commentListView];
//
//    }
//    _categoryView = [[JXCategoryTitleView alloc] initWithFrame:CGRectMake(0, ZM_StatusBarHeight, [UIScreen mainScreen].bounds.size.width, JXheightForHeaderInSection)];
//    self.categoryView.titles = self.titles;
//    self.categoryView.backgroundColor = [UIColor whiteColor];
//    self.categoryView.delegate = self;
//    self.categoryView.titleSelectedColor = CNavBgColor;
//    self.categoryView.titleColor = [UIColor blackColor];
//    self.categoryView.titleColorGradientEnabled = YES;
//    self.categoryView.titleLabelZoomEnabled = YES;
//    self.categoryView.titleLabelZoomEnabled = YES;
//    self.categoryView.titleViewLineEnabled = YES;
//    JXCategoryIndicatorLineView *lineView = [[JXCategoryIndicatorLineView alloc] init];
//    lineView.indicatorLineViewColor = CNavBgColor;
//    self.categoryView.indicators = @[lineView];
//    lineView.indicatorLineViewHeight = 2;
//
//    _pagingView = [[JXPagingView alloc] initWithDelegate:self];
//
//    [self.view addSubview:self.pagingView];
//    if (@available(iOS 11.0, *)) {
//        self.pagingView.mainTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
//    } else {
//        // Fallback on earlier versions
//        self.automaticallyAdjustsScrollViewInsets = NO;
//    }
//
//
//    self.categoryView.contentScrollView = self.pagingView.listContainerView.collectionView;
    
    self.navigationController.interactivePopGestureRecognizer.enabled = (self.categoryView.selectedIndex == 0);
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setMealCourse:) name:@"SetMealCourse" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setMealExams:) name:@"SetMealExams" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(SetMealBooks:) name:@"SetMealBooks" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(SetMealLives:) name:@"SetMealLives" object:nil];
    [self.view insertSubview:self.sharebtn atIndex:1000];
    [self.view insertSubview:self.menubtn atIndex:1000];
    [self.view insertSubview:self.backbtn atIndex:1000];
}
- (void)classRoomStartLearning{
    [self.categoryView selectItemAtIndex:1];
}
- (void)loadData{
    [catalogListView getCourseID:self.ID withClass:[self.titleIndex integerValue]];
    
    __weak typeof(self) weakSelf = self;
    catalogListView.myBlock = ^(NSString *ID) {
        __strong typeof(weakSelf) sself = weakSelf;
        if (weakSelf.player) {
            [weakSelf postPlayTime];
        }
        
        BOOL isSame = NO;
        if ([sself->liveID isEqualToString:ID]) {
            isSame = YES;
        }
        sself->liveID = ID;
        
        if (isSame) {
            if (self.player.playbackState == PLVVodPlaybackStatePaused) {
                [weakSelf.player play];
            }else if (self.player.playbackState == PLVVodPlaybackStatePlaying) {
                [weakSelf.player pause];
            }else if (self.player.playbackState == PLVVodPlaybackStateStopped) {
                [weakSelf playButtonClick];
            }
        }else{
            [weakSelf playButtonClick];
        }
    };
    [commentListView getCourseID:self.ID withClass:[self.titleIndex integerValue]];
}
- (void)initView{
    introduceListView = [[CourseIntroduceView alloc] init];
    [introduceListView getCourseType:self.titleIndex withDistribute:self.distribute];
    introduceListView.delegate = self;
    
    catalogListView = [[CourseCatalogView alloc] init];
    
    catalogListView.delegate = self;
    commentListView = [[CourseCommentView alloc] init];
    commentListView.delegate = self;
    if ([self.titleIndex isEqualToString:@"4"]) {
        _listViewArray = @[introduceListView,commentListView];
    }else{
        _listViewArray = @[introduceListView,catalogListView,commentListView];
        
    }
    _categoryView = [[JXCategoryTitleView alloc] initWithFrame:CGRectMake(0, ZM_StatusBarHeight, [UIScreen mainScreen].bounds.size.width, JXheightForHeaderInSection)];
    self.categoryView.titles = self.titles;
    self.categoryView.backgroundColor = [UIColor whiteColor];
    self.categoryView.delegate = self;
    self.categoryView.titleSelectedColor = CNavBgColor;
    self.categoryView.titleColor = [UIColor blackColor];
    self.categoryView.titleColorGradientEnabled = YES;
    self.categoryView.titleLabelZoomEnabled = YES;
    self.categoryView.titleLabelZoomEnabled = YES;
    self.categoryView.titleViewLineEnabled = YES;
    JXCategoryIndicatorLineView *lineView = [[JXCategoryIndicatorLineView alloc] init];
    lineView.indicatorLineViewColor = CNavBgColor;
    self.categoryView.indicators = @[lineView];
    lineView.indicatorLineViewHeight = 2;
    
    _pagingView = [[JXPagingView alloc] initWithDelegate:self];
    
    [self.view addSubview:self.pagingView];
    if (@available(iOS 11.0, *)) {
        self.pagingView.mainTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        // Fallback on earlier versions
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    
    self.categoryView.contentScrollView = self.pagingView.listContainerView.collectionView;
}
#pragma mark - 懒加载失败默认视图
- (NoDataTipsView *)loadNetView {
    if (!_loadNetView) {
        
        _loadNetView = [NoDataTipsView setTipsBackGroupWithframe:CGRectMake(0, 0, screenWidth(), self.view.height) tipsIamgeName:@"无网络" tipsStr:@"无法连接到网络,点击页面刷新"];
        _loadNetView.backgroundColor = CBackgroundColor;
        _loadNetView.noDataBtn.hidden = NO;
        _loadNetView.delegate = self;
    }
    return _loadNetView;
}
#pragma mark - <NoDataTipsDelegate> - 提示按钮点击
- (void)tipsNoDataBtnDid {
    if ([[UserDefaultsUtils valueWithKey:@"access_token"] length] !=0 ) {
        UIViewController *rootViewController = [[UIApplication sharedApplication] keyWindow].rootViewController;
        UIViewController *topViewController = [BaseTools topViewControllerWithRootViewController:rootViewController];
        PLVDownloadManagerViewController *vc = [[PLVDownloadManagerViewController alloc]init];
        [topViewController.navigationController pushViewController:vc animated:YES];
    }else{
        [BaseTools showErrorMessage:@"请登录后再操作"];
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [BaseTools alertLoginWithVC:self];
        });
    }
}
- (void)tipsRefreshBtnClicked{
    [self loadIntroduceData];

    [self loadData];
}
- (void)hiddenBtn:(NSNotification *)noti
{
    
    BOOL isHidden = [noti.object[@"isShowing"] boolValue];
    if (self.player.fullscreen) {
        
    }else{
        
        if (self.player == nil) {
            
        }else
        {
            _backbtn.hidden = isHidden;
            _sharebtn.hidden = isHidden;
            _menubtn.hidden = isHidden;
        }
    }
    
}
- (void)navUI{
//    [self.rootView2 addSubview:self.shareBtn];
//    [self.rootView2 addSubview:self.menuBtn];
//    [self.rootView2 addSubview:self.backBtn];
    [self.view insertSubview:self.sharebtn atIndex:100];
    [self.view insertSubview:self.menubtn atIndex:100];
    [self.view insertSubview:self.backbtn atIndex:100];
}

- (UIButton *)sharebtn{
    if (!_sharebtn) {
        _sharebtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        if (kIsiPhoneX) {
            _sharebtn.frame = CGRectMake(screenWidth()-80, 40, 30, 30);
        }else{
            _sharebtn.frame = CGRectMake(screenWidth()-80, 30, 30, 30);
        }
        
        [_sharebtn addTarget:self action:@selector(sharedButtonClick:) forControlEvents:(UIControlEventTouchUpInside)];
        [_sharebtn setImage:[UIImage imageNamed:@"详情页分享按钮"] forState:(UIControlStateNormal)];
    }
    return  _sharebtn;
}
- (UIButton *)backbtn{
    if (!_backbtn) {
        _backbtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        if (kIsiPhoneX) {
            _backbtn.frame = CGRectMake(10, 40, 30, 30);
        }else{
            _backbtn.frame = CGRectMake(10, 30, 30, 30);
        }
        
        [_backbtn setImage:[UIImage imageNamed:@"详情页返回按钮"] forState:(UIControlStateNormal)];
        [_backbtn addTarget:self action:@selector(back) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _backbtn;
}
- (UIButton *)menubtn{
    if (!_menubtn) {
        _menubtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        
        if (kIsiPhoneX) {
            _menubtn.frame = CGRectMake(screenWidth()-40, 40, 30, 30);
        }else{
            _menubtn.frame = CGRectMake(screenWidth()-40, 30, 30, 30);
        }
        [_menubtn addTarget:self action:@selector(menuAction:) forControlEvents:(UIControlEventTouchUpInside)];
        [_menubtn setImage:[UIImage imageNamed:@"菜单按钮"] forState:(UIControlStateNormal)];
    }
    return _menubtn;
}
- (void)loadingView{
    self.lodingview = [[UIView alloc]initWithFrame:self.view.bounds];
    self.lodingview.backgroundColor = [UIColor whiteColor];
    YLImageView *image = [[YLImageView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
    image.center = self.lodingview.center;
    image.backgroundColor = [UIColor clearColor];
    image.image = [YLGIFImage imageNamed:@"加载中.gif"];
    [self.lodingview addSubview:image];
    [self.view insertSubview:self.lodingview atIndex:100];
}
- (void)loadIntroduceData{
    if (![CoreStatus isNetworkEnable]) {
    
    }else{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.lodingview removeFromSuperview];
            [self loadingView];
        });
    }
    
    switch ([self.titleIndex integerValue]) {
        case 0:{
        };break;
        case 1:{//请求课程数据

            NSMutableDictionary *parmDic = [NSMutableDictionary dictionary];
            [parmDic setObject:self.ID forKey:@"id"];
            [parmDic setObject:self.ac_type forKey:@"ac_type"];
            if (self.distribute.length!=0) {
                [parmDic setObject:@"1" forKey:@"distribute"];
            }
            BADataEntity *entity = [BADataEntity new];
            entity.urlString = @"/exam/detail";
            entity.needCache = NO;
            entity.parameters = parmDic;
            // 如果打印数据不完整，是因为 Xcode 8 版本问题，请下断点打印数据
            [BANetManager ba_request_POSTWithEntity:entity successBlock:^(id response) {
                
            
                    if (response == nil) {
                        
                    }else{
                        if ([response[@"code"] isEqualToString:@"0"]) {
                            
                            [self dataAnalysis:response];
                            
                        }else{
                            
                            [BaseTools showErrorMessage:response[@"msg"]];
                        }
                    }
             
                
            } failureBlock:^(NSError *error) {
                
            } progressBlock:^(int64_t bytesProgress, int64_t totalBytesProgress) {
                /*! 封装方法里已经回到主线程，所有这里不用再调主线程了 */
                
            }];
            
        };break;
        case 2:{
        };break;
        case 3:{//请求题库数据
            NSMutableDictionary *parmDic = [NSMutableDictionary dictionary];
            [parmDic setObject:self.ID forKey:@"id"];
            [parmDic setObject:self.ac_type forKey:@"ac_type"];
            if (self.distribute.length!=0) {
                [parmDic setObject:@"1" forKey:@"distribute"];
            }
            BADataEntity *entity = [BADataEntity new];
            entity.urlString = @"/course/detail";
            entity.needCache = NO;
            entity.parameters = parmDic;
            // 如果打印数据不完整，是因为 Xcode 8 版本问题，请下断点打印数据
            [BANetManager ba_request_POSTWithEntity:entity successBlock:^(id response) {
                
          
                    if (response == nil) {
                        
                    }else{
                        if ([response[@"code"] isEqualToString:@"0"]) {
                            
                            [self dataAnalysis:response];
                            
                        }else{
                            
                            [BaseTools showErrorMessage:response[@"msg"]];
                        }
                    }
                
                
            } failureBlock:^(NSError *error) {
                
            } progressBlock:^(int64_t bytesProgress, int64_t totalBytesProgress) {
                /*! 封装方法里已经回到主线程，所有这里不用再调主线程了 */
                
            }];
            
        };break;
        case 4:{//请求图书数据
            NSMutableDictionary *parmDic = [NSMutableDictionary dictionary];
            [parmDic setObject:self.ID forKey:@"id"];
            [parmDic setObject:self.ac_type forKey:@"ac_type"];
            if (self.distribute.length!=0) {
                [parmDic setObject:@"1" forKey:@"distribute"];
            }
            BADataEntity *entity = [BADataEntity new];
            entity.urlString = @"/book/book_detail";
            entity.needCache = NO;
            entity.parameters = parmDic;
            // 如果打印数据不完整，是因为 Xcode 8 版本问题，请下断点打印数据
            [BANetManager ba_request_POSTWithEntity:entity successBlock:^(id response) {
 
                    if (response == nil) {
                        
                    }else{
                        if ([response[@"code"] isEqualToString:@"0"]) {
                            
                            [self dataAnalysis:response];
                            
                        }else{
                            
                            [BaseTools showErrorMessage:response[@"msg"]];
                        }
                    }
        
                
            } failureBlock:^(NSError *error) {
                
            } progressBlock:^(int64_t bytesProgress, int64_t totalBytesProgress) {
                /*! 封装方法里已经回到主线程，所有这里不用再调主线程了 */
                
            }];
        };break;
        case 5:{//请求图书数据
            NSMutableDictionary *parmDic = [NSMutableDictionary dictionary];
            [parmDic setObject:self.ID forKey:@"id"];
            [parmDic setObject:self.ac_type forKey:@"ac_type"];
            if (self.distribute.length!=0) {
                [parmDic setObject:@"1" forKey:@"distribute"];
            }
            BADataEntity *entity = [BADataEntity new];
            entity.urlString = @"/classroom/detail";
            entity.needCache = NO;
            entity.parameters = parmDic;
            // 如果打印数据不完整，是因为 Xcode 8 版本问题，请下断点打印数据
            [BANetManager ba_request_POSTWithEntity:entity successBlock:^(id response) {
                
        
                    if (response == nil) {
                        
                    }else{
                        if ([response[@"code"] isEqualToString:@"0"]) {
                            
                            [self dataAnalysis:response];
                            
                        }else{
                            
                            [BaseTools showErrorMessage:response[@"msg"]];
                        }
                    }
        
                
            } failureBlock:^(NSError *error) {
                
            } progressBlock:^(int64_t bytesProgress, int64_t totalBytesProgress) {
                /*! 封装方法里已经回到主线程，所有这里不用再调主线程了 */
                
            }];
        };break;
        case 6:{//请求直播数据
            NSMutableDictionary *parmDic = [NSMutableDictionary dictionary];
            [parmDic setObject:self.ID forKey:@"id"];
            [parmDic setObject:self.ac_type forKey:@"ac_type"];
            if (self.distribute.length!=0) {
                [parmDic setObject:@"1" forKey:@"distribute"];
            }
            BADataEntity *entity = [BADataEntity new];
            entity.urlString = @"/live/detail";
            entity.needCache = NO;
            entity.parameters = parmDic;
            // 如果打印数据不完整，是因为 Xcode 8 版本问题，请下断点打印数据
            [BANetManager ba_request_POSTWithEntity:entity successBlock:^(id response) {
                
             
                    if (response == nil) {
                        
                    }else{
                        if ([response[@"code"] isEqualToString:@"0"]) {
                            
                            [self dataAnalysis:response];
                            
                        }else{
                            
                            [BaseTools showErrorMessage:response[@"msg"]];
                        }
                    }
 
                
            } failureBlock:^(NSError *error) {
                
            } progressBlock:^(int64_t bytesProgress, int64_t totalBytesProgress) {
                /*! 封装方法里已经回到主线程，所有这里不用再调主线程了 */
                
            }];
        };break;
        default:
            break;
    }
}
- (void)dataAnalysis:(id)data{
//    [self lq_endLoading];
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self.lodingview removeFromSuperview];
        [self.loadNetView removeFromSuperview];
        self.sharebtn.hidden = NO;
        self.menubtn.hidden = NO;
    });

    self.modelDict  = [NSMutableDictionary dictionaryWithDictionary:data[@"data"]];
    
    
    
    
    self.model = [[CourseDetailModel alloc]initWithDictionary:data[@"data"] error:nil];
    [introduceListView dataAnalysis:self.model];
    courseID = self.model.ID;
    catalogListView.play_id = data[@"data"][@"default_play_node"];
    liveID = data[@"data"][@"default_play_node"];
    catalogListView.courseDict = data[@"data"];
    self.userHeaderView.imageUrl= self.model.img;
    [self.images sd_setImageWithURL:[NSURL URLWithString:self.model.img] placeholderImage:[UIImage imageNamed:@"coursesDedault"]];
    goods_type = self.titleIndex;
    dispatch_async(dispatch_get_main_queue(), ^{
        

        [self.modelDict setObject:goods_type forKey:@"my_goods_type"];
        [self.modelDict setObject:self.ac_type forKey:@"my_ac_type"];
        [self.modelDict setObject:self.distribute forKey:@"my_click_distribute"];
        GoodsDetailBottomBarView *toolBar = [[GoodsDetailBottomBarView alloc]initWithFrame:CGRectMake(0, screenHeight()-49, screenWidth(), 49) withData:self.modelDict];
        [self.view addSubview:toolBar];
        
        if ([goods_type isEqualToString:@"1"] && [self.model.live_exam isEqualToString:@"1"]) {
            [self createLiveExamView];
        }else{
            catalogListView.isDaliankao = @"0";
        }
        [self.distributeBtn setTitle:[NSString stringWithFormat:@"%@",self.model.distribution.bro_money] forState:(UIControlStateNormal)];


//        [self.modelDict setObject:goods_type forKey:@"goods_type"];
//        [self.modelDict setObject:self.ac_type forKey:@"goods_ac_type"];
//
//
//
//        self.bottomView = [[BottomToolView alloc]initWithFrame:CGRectMake(0, screenHeight()-49, screenWidth(), 49)];
//        self.bottomView.isDistribute = self.distribute;
//        self.bottomView.backgroundColor = [UIColor whiteColor];
//        self.bottomView.goodsType = goods_type;
//        self.bottomView.goodsDict = self.modelDict;
//
//        __weak typeof(self) weakSelf = self;
//        self.bottomView.myBlock = ^(BOOL isGroup) {
//            PayMentViewController *vc = [[PayMentViewController alloc]init];
//            vc.goodID = weakSelf.model.ID;
//            vc.goodType = weakSelf.titleIndex;
//            if ([weakSelf.titleIndex isEqualToString:@"6"]) {
//                vc.dist_id = @"0";
//            }else{
//                vc.dist_id = weakSelf.model.distribution.dist_id;
//            }
//            if ([weakSelf.model.seckill_flag isEqualToString:@"1"]) {
//                vc.seckill_id = weakSelf.model.seckill_goods.seckill_goods_id;
//            }
//            if (isGroup) {
//                vc.group_buy_goods_rule_id = weakSelf.model.group.group_buy_goods_rule_id;
//            }
//
//            [weakSelf.navigationController pushViewController:vc animated:YES];
//        };
//
//        weakSelf.bottomView.myHXBlock = ^{
//            [weakSelf kefu];
//        };
//        weakSelf.bottomView.myShareBlock = ^{
//
//
//            weakSelf.shareView = [[DistributionBottomShareView alloc]initWithFrame:CGRectMake(0, screenHeight()-150, screenWidth(), 150)];
//            weakSelf.shareView.titleLab.text = @"立即分享";
//
//            weakSelf.shareView.wbImage.image = [UIImage imageNamed:@"复制链接"];
//            weakSelf.shareView.threeLab.text = @"复制链接";
//
//            weakSelf.shareView.pyqImage.image = [UIImage imageNamed:@"图文二维码"];
//            weakSelf.shareView.fourLab.text = @"图文二维码";
//            NSString *urlString = nil;
//            if ([goods_type isEqualToString:@"1"]) {
//                urlString = [NSString stringWithFormat:@"%@/exam/%@.html?distribute=%@", SERVER_HOSTPC,self.model.ID,self.model.distribution.dist_id];
//            }else if ([goods_type isEqualToString:@"3"]){
//                urlString = [NSString stringWithFormat:@"%@/course/%@.html?distribute=%@", SERVER_HOSTPC,self.model.ID,self.model.distribution.dist_id];
//            }else if ([goods_type isEqualToString:@"4"]){
//                urlString = [NSString stringWithFormat:@"%@/book/%@.html?distribute=%@", SERVER_HOSTPC,self.model.ID,self.model.distribution.dist_id];
//            }else if ([goods_type isEqualToString:@"5"]){
//                urlString = [NSString stringWithFormat:@"%@/classroom/%@.html?distribute=%@", SERVER_HOSTPC,self.model.ID,self.model.distribution.dist_id];
//            }else if ([goods_type isEqualToString:@"6"]){
//                urlString = [NSString stringWithFormat:@"%@/live/%@.html?distribute=%@", SERVER_HOSTPC,self.model.ID,self.model.distribution.dist_id];
//            }
//
//            CGPoint showCenter = CGPointMake(SCREEN_WIDTH/2,SCREEN_HEIGHT-weakSelf.shareView.height/2);
//            [SGBrowserView showMoveView:weakSelf.shareView moveToCenter:showCenter];
//
//            weakSelf.shareView.myCloseBlock = ^{
//                [SGBrowserView hide];
//            };
//            weakSelf.shareView.myWXShareBlock = ^{
//                [self shareWebPageToPlatformType:UMSocialPlatformType_WechatSession shareURLString:urlString title:self.model.title descr:@"库课网校"];
//            };
//            weakSelf.shareView.myQQShareBlock = ^{
//                [self shareWebPageToPlatformType:UMSocialPlatformType_QQ shareURLString:urlString title:self.model.title descr:@"库课网校"];
//            };
//            weakSelf.shareView.myCopyBlock = ^{
//                UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
//                pasteboard.string = urlString;
//                [BaseTools showErrorMessage:@"分销链接已复制到您的粘贴板"];
//            };
//            weakSelf.shareView.myPicBlock = ^{
//                [SGBrowserView hide];
//                [self showShareImageView:urlString];
//            };
//
//
//        };
//        [weakSelf.bottomView.collectionBtn addTarget:weakSelf action:@selector(collectionAction) forControlEvents:(UIControlEventTouchUpInside)];
//        [weakSelf.view addSubview:weakSelf.bottomView];
        
        if ([self.model.seckill_flag isEqualToString:@"1"]) {
            SeckillCourseDetailView *view  = [[SeckillCourseDetailView alloc]initWithFrame:CGRectMake(0, SCREEN_WIDTH/16*9, screenWidth(), 56) dict:self.modelDict];
            [self.pagingView.mainTableView addSubview:view];
            [self initHeaderVideoView];
            
            
        }
        [self.pagingView reloadData];
    });
    
//    if ([self.model.is_collect isEqualToString:@"1"]) {
//
//        dispatch_async(dispatch_get_main_queue(), ^{
//
//            [self.bottomView.collectionBtn setTitle:@"已收藏" forState:(UIControlStateNormal)];
//            [self.bottomView.collectionBtn setImage:[UIImage imageNamed:@"已收藏"] forState:(UIControlStateNormal)];
//            [self.bottomView.collectionBtn br_layoutButtonWithEdgeInsetsStyle:(BRButtonEdgeInsetsStyleTop) imageTitleSpace:2];
//        });
//    }else{
//
//        dispatch_async(dispatch_get_main_queue(), ^{
//
//            [self.bottomView.collectionBtn setTitle:@"收藏" forState:(UIControlStateNormal)];
//            [self.bottomView.collectionBtn setImage:[UIImage imageNamed:@"收藏"] forState:(UIControlStateNormal)];
//            [self.bottomView.collectionBtn br_layoutButtonWithEdgeInsetsStyle:(BRButtonEdgeInsetsStyleTop) imageTitleSpace:2];
//        });
//    }
    

    
}
- (void)reloadDetailData{
    [self loadIntroduceData];

}
- (void)initHeaderVideoView{
    if ([self.model.seckill_flag isEqualToString:@"1"]) {
        headerHeight =SCREEN_WIDTH/16*9 +56;
        if ([self.titleIndex isEqualToString:@"3"] || [self.titleIndex isEqualToString:@"6"] ) {
            self.navigationController.navigationBar.translucent = false;
            self.headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, headerHeight)];
            self.playerPlaceholder = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH/16*9)];
            self.images = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH/16*9)];
            [self.images sd_setImageWithURL:[NSURL URLWithString:self.model.img] placeholderImage:[UIImage imageNamed:@"coursesDedault"]];
            self.images.userInteractionEnabled = YES;
            self.images.contentMode = UIViewContentModeScaleAspectFill;
            self.images.clipsToBounds=YES;//  是否剪切掉超出 UIImageView 范围的图片
            [self.images setContentScaleFactor:[[UIScreen mainScreen] scale]];
            [self.playerPlaceholder addSubview:self.images];
            [self.headerView addSubview:self.playerPlaceholder];
            
            _playBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
            _playBtn.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH/16*9);
            _playBtn.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
            [_playBtn setImage:[UIImage imageNamed:@"播放(1)"] forState:(UIControlStateNormal)];

            [_playBtn addTarget:self action:@selector(playButtonClick) forControlEvents:(UIControlEventTouchUpInside)];
            [self.images addSubview:_playBtn];
        }else{
            _userHeaderView = [[CourseDetailHeaderView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, headerHeight) goodsType:self.titleIndex];
            _userHeaderView.isBook = goods_type;
            _userHeaderView.imageUrl= self.model.img;
        }
    }else{
        headerHeight =SCREEN_WIDTH/16*9;
        if ([self.titleIndex isEqualToString:@"3"]|| [self.titleIndex isEqualToString:@"6"]) {
            self.navigationController.navigationBar.translucent = false;
            self.playerPlaceholder = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH/16*9)];
            self.images = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH/16*9)];
            [self.images sd_setImageWithURL:[NSURL URLWithString:self.model.img] placeholderImage:[UIImage imageNamed:@"coursesDedault"]];
            self.images.userInteractionEnabled = YES;
            self.images.contentMode=UIViewContentModeScaleAspectFill;
            self.images.clipsToBounds=YES;//  是否剪切掉超出 UIImageView 范围的图片
            [self.images setContentScaleFactor:[[UIScreen mainScreen] scale]];
            [self.playerPlaceholder addSubview:self.images];
            
            
            _playBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
            _playBtn.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH/16*9);
            _playBtn.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
            [_playBtn setImage:[UIImage imageNamed:@"播放(1)"] forState:(UIControlStateNormal)];
            [_playBtn addTarget:self action:@selector(playButtonClick) forControlEvents:(UIControlEventTouchUpInside)];
            [self.images addSubview:_playBtn];
        }else{
            _userHeaderView = [[CourseDetailHeaderView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, SCREEN_WIDTH/16*9) goodsType:self.titleIndex];
            _userHeaderView.isBook = goods_type;
            _userHeaderView.imageUrl= self.model.img;
            
        }
    }
    
    
}
- (void)createLiveExamView{

    liveExamLab = [[UILabel alloc]initWithFrame:CGRectMake(0, SCREEN_WIDTH/16*9-50, screenWidth(), 50)];

    liveExamLab.hidden = YES;
    
    
    liveExamLab.backgroundColor = CNavBgColor;
    liveExamLab.textColor = [UIColor whiteColor];
    liveExamLab.font = [UIFont systemFontOfSize:14];
    liveExamLab.textAlignment = NSTextAlignmentCenter;
    [_userHeaderView addSubview:liveExamLab];
    if ([self.model.live_start longLongValue]*1000 > [[BaseTools currentTimeStr] longLongValue]) {//考试还未开始
        //倒计时
        [[ZMTimeCountDown ShareManager] zj_timeCountDownWithStartTimeStamp:[[BaseTools currentTimeStr] longLongValue] endTimeStamp:[self.model.live_start longLongValue]*1000 completeBlock:^(NSInteger day, NSInteger hour, NSInteger minute, NSInteger second) {
            liveExamLab.hidden = NO;
            liveExamLab.text = [NSString stringWithFormat:@"距离考试开始 %02ld天%02ld小时%02ld分%02ld秒",day,hour,minute,second];
        }];
    }else{
        if ([[BaseTools currentTimeStr] longLongValue] < [self.model.live_end longLongValue]*1000) {
            //倒计时
            [[ZMTimeCountDown ShareManager] zj_timeCountDownWithStartTimeStamp:[[BaseTools currentTimeStr] longLongValue] endTimeStamp:[self.model.live_end longLongValue]*1000 completeBlock:^(NSInteger day, NSInteger hour, NSInteger minute, NSInteger second) {
                liveExamLab.hidden = NO;
                liveExamLab.text = [NSString stringWithFormat:@"距离考试结束 %02ld天%02ld小时%02ld分%02ld秒",day,hour,minute,second];
            }];
            catalogListView.isDaliankao = @"0";
        }
    }
    if ([self.model.live_start longLongValue]*1000 > [[BaseTools currentTimeStr] longLongValue]) {//考试还未开始
        
        catalogListView.isDaliankao = @"1";
        
    }else if ([self.model.live_end longLongValue]*1000 < [[BaseTools currentTimeStr] longLongValue]) {//考试已经结束
        
        catalogListView.isDaliankao = @"2";
        
    }
}
- (void)back{
    if (self.player) {
        [self postPlayTime];
    }
    [self.player destroyPlayer];
//    _shareBtn.hidden = YES;
//    _backBtn.hidden = YES;
//    _menuBtn.hidden = YES;
//    [_backBtn removeFromSuperview];
//    [_shareBtn removeFromSuperview];
//    [_menuBtn removeFromSuperview];
    [self.navigationController popViewControllerAnimated:YES];
}
//- (void)collectionAction{
//    NSMutableDictionary *parmDic = [NSMutableDictionary dictionary];
//    [parmDic setObject:goods_type forKey:@"goods_type"];
//    [parmDic setObject:self.model.ID  forKey:@"goods_id"];
//    [ZMNetworkHelper POST:@"/stucommon/stu_collect" parameters:parmDic cache:YES responseCache:^(id responseCache) {
//
//    } success:^(id responseObject) {
//        if (responseObject == nil) {
//
//        }else{
//            if ([responseObject[@"code"] isEqualToString:@"0"]) {
//
//                if ([responseObject[@"msg"] isEqualToString:@"收藏成功"]) {
//                    dispatch_async(dispatch_get_main_queue(), ^{
//
//                        [self.bottomView.collectionBtn setTitle:@"已收藏" forState:(UIControlStateNormal)];
//                        [self.bottomView.collectionBtn setImage:[UIImage imageNamed:@"已收藏"] forState:(UIControlStateNormal)];
//                        [self.bottomView.collectionBtn br_layoutButtonWithEdgeInsetsStyle:(BRButtonEdgeInsetsStyleTop) imageTitleSpace:2];
//                    });
//                }else{
//                    dispatch_async(dispatch_get_main_queue(), ^{
//
//                        [self.bottomView.collectionBtn setTitle:@"收藏" forState:(UIControlStateNormal)];
//                        [self.bottomView.collectionBtn setImage:[UIImage imageNamed:@"收藏"] forState:(UIControlStateNormal)];
//                        [self.bottomView.collectionBtn br_layoutButtonWithEdgeInsetsStyle:(BRButtonEdgeInsetsStyleTop) imageTitleSpace:2];
//                    });
//
//                }
//            }else if ([responseObject[@"code"] isEqualToString:@"-10000"]){
//                [BaseTools showErrorMessage:@"请登录后再操作"];
//                dispatch_async(dispatch_get_main_queue(), ^{
//
//                    [BaseTools alertLoginWithVC:self];
//                });
//            }else{
//                [BaseTools showErrorMessage:responseObject[@"msg"]];
//            }
//        }
//    } failure:^(NSError *error) {
//
//    }];
//
//}
//- (void)kefu{
//
//    if ([[UserDefaultsUtils valueWithKey:@"access_token"] length] !=0 ) {
////        [BaseTools openKefuWithObj:self];
//        NSString *urlString = nil;
//        if ([goods_type isEqualToString:@"1"]) {
//            urlString = [NSString stringWithFormat:@"%@/exam/%@.html", SERVER_HOSTPC,self.model.ID];
//        }else if ([goods_type isEqualToString:@"3"]){
//            urlString = [NSString stringWithFormat:@"%@/course/%@.html", SERVER_HOSTPC,self.model.ID];
//        }else if ([goods_type isEqualToString:@"4"]){
//            urlString = [NSString stringWithFormat:@"%@/book/%@.html", SERVER_HOSTPC,self.model.ID];
//        }else if ([goods_type isEqualToString:@"5"]){
//            urlString = [NSString stringWithFormat:@"%@/classroom/%@.html", SERVER_HOSTPC,self.model.ID];
//        }else if ([goods_type isEqualToString:@"6"]){
//            urlString = [NSString stringWithFormat:@"%@/live/%@.html", SERVER_HOSTPC,self.model.ID];
//        }
//        QYSource *source = [[QYSource alloc] init];
//        source.title =  @"库课网校";
//        source.urlString = @"https://www.kuke99.com/";
//        QYCommodityInfo *commodityInfo = [[QYCommodityInfo alloc] init];
//        commodityInfo.title = self.model.title;
//        commodityInfo.desc = self.model.subtitle;
//        commodityInfo.sendByUser = YES;
//        commodityInfo.actionTextColor =CNavBgColor;
//        commodityInfo.actionText = @"发送商品";
//        commodityInfo.pictureUrlString = self.model.img;
//        commodityInfo.urlString = urlString;
//        commodityInfo.note =self.model.discount_price;
//        commodityInfo.show = YES;
//
//
//        QYSessionViewController *sessionViewController = [[QYSDK sharedSDK] sessionViewController];
//        sessionViewController.delegate = self;
//        sessionViewController.sessionTitle = @"库课网校";
//        sessionViewController.source = source;
//        sessionViewController.commodityInfo = commodityInfo;
//        if (IS_PAD) {
//            UINavigationController* navi = [[UINavigationController alloc]initWithRootViewController:sessionViewController];
//            navi.modalPresentationStyle = UIModalPresentationFormSheet;
//            [self presentViewController:navi animated:YES completion:nil];
//        }
//        else{
//            sessionViewController.hidesBottomBarWhenPushed = YES;
//            [self.navigationController pushViewController:sessionViewController animated:YES];
//        }
//
//        [[QYSDK sharedSDK] customUIConfig].bottomMargin = 0;
//        [[[QYSDK sharedSDK] customActionConfig] setLinkClickBlock:^(NSString *linkAddress) {
//            HomePageBannerViewController *vc = [[HomePageBannerViewController alloc]init];
//            vc.url = linkAddress;
//            vc.title = @"商品详情";
//            [self.navigationController pushViewController:vc animated:YES];
//        }];
//
//    }else{
//        [BaseTools showErrorMessage:@"请登录后再操作"];
//        dispatch_async(dispatch_get_main_queue(), ^{
//
//            [BaseTools alertLoginWithVC:self];
//        });
//    }
//
//}


-(void)setUpUI{
  
    self.images.hidden = YES;
    
    PLVVodSkinPlayerController *player = [[PLVVodSkinPlayerController alloc] initWithNibName:nil bundle:nil];
    player.is_hideNav = @"1";
    player.videoInfo = self.modelDict;
    [player addPlayerOnPlaceholderView:self.playerPlaceholder rootViewController:self];
    player.rememberLastPosition = YES;
     __weak typeof(self) weakSelf = self;
    player.reachEndHandler = ^(PLVVodPlayerViewController *player) {
        [weakSelf postPlayTime];
        if ([weakSelf.nextLesson isEqualToString:@"0"]) {
            if ([weakSelf.titleIndex integerValue] == 6) {
                [BaseTools showErrorMessage:@"课程已播放完毕"];
            }else{
                [BaseTools showErrorMessage:@"免费课程已播放完毕"];
            }
            weakSelf.backbtn.hidden = NO;
            weakSelf.sharebtn.hidden = NO;
            weakSelf.menubtn.hidden = NO;
        }else{
            liveID = weakSelf.nextLesson;
            if (![CoreStatus isNetworkEnable]) {
                [BaseTools showErrorMessage:@"无法连接到网络"];
            }else{
                [weakSelf getVid];
            }
        }
    };

    player.playbackStateHandler = ^(PLVVodPlayerViewController *player) {
        __strong typeof(weakSelf) sself = weakSelf;
        sself->catalogListView.myPlayBackState = player.playbackState;
 
    };
    self.player = player;
    [self.view insertSubview:self.sharebtn atIndex:100];
    [self.view insertSubview:self.menubtn atIndex:100];
    [self.view insertSubview:self.backbtn atIndex:100];
}
- (void)playButtonClick{
    
    if ([BaseTools getCurrentNetworkState] == 1 ) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"当前为非wifi环境，播放将消耗流量，确定播放吗？" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *actionOne = [UIAlertAction actionWithTitle:@"继续播放" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            if (![CoreStatus isNetworkEnable]) {
                [BaseTools showErrorMessage:@"无法连接到网络"];
            }else{
                [self getVid];
            }
            
        }];
        UIAlertAction *actionTwo = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alertController addAction:actionOne];
        [alertController addAction:actionTwo];
        
        [self presentViewController:alertController animated:YES completion:nil];
        
    }else{
        if (![CoreStatus isNetworkEnable]) {
            [BaseTools showErrorMessage:@"无法连接到网络"];
        }else{
            [self getVid];
        }
        
    }
    
}
- (void)getVid{
    if (![CoreStatus isNetworkEnable]) {
        
    }else{
        _backbtn.hidden = NO;
        _sharebtn.hidden = NO;
        _menubtn.hidden = NO;
    }
    if ([self.titleIndex integerValue] == 6) {
//        catalogListView.play_id = courseID;
        NSMutableDictionary *parmDic = [NSMutableDictionary dictionary];
        [parmDic setObject:liveID forKey:@"id"];
        [parmDic setObject:courseID forKey:@"live_id"];//只传课程返回第一节，课程和课时都传是学习记录，用于没播放过的课程
        [ZMNetworkHelper POST:@"/live/lesson" parameters:parmDic cache:YES responseCache:^(id responseCache) {
            
        } success:^(id responseObject) {
            if (responseObject == nil) {
                
            }else{
                if ([responseObject[@"code"] isEqualToString:@"0"]) {
                    
                    if ([responseObject[@"data"][@"view_type"] isEqualToString:@"1"]) {
                        self.nextLesson = responseObject[@"data"][@"next_node"];
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            
                            if (self.player) {
                                
                            }else{
                                [self setUpUI];
                            }
                            self.player.lessonInfo = responseObject[@"data"];
                            [PLVVodVideo requestVideoWithVid:responseObject[@"data"][@"video_id"] completion:^(PLVVodVideo *video, NSError *error) {
                                if (video) {
                                    self.player.video = video;
                                    
                                }
                            }];
                            catalogListView.play_id = responseObject[@"data"][@"id"];
                        });
                    }else{
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self.player pause];
//                            [_backBtn removeFromSuperview];
//                            [_shareBtn removeFromSuperview];
//                            [_menuBtn removeFromSuperview];

                            [PolyvLiveOrVodPlayerManager zm_verifyPermissionWithChannelId:responseObject[@"data"][@"live_channel_id"] vid:@"" playerType:@"Live" ToPlayerFromViewController:[[AppDelegate shareAppDelegate] getCurrentUIVC] dataSource:responseObject[@"data"]];
                            catalogListView.play_id = responseObject[@"data"][@"id"];
                        });
                        
                    }
                    
                }else if ([responseObject[@"code"] isEqualToString:@"-10000"]){
                    [BaseTools showErrorMessage:@"请登录后再操作"];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        [BaseTools alertLoginWithVC:self];
                    });
                }else{
                    [BaseTools showErrorMessage:responseObject[@"msg"]];
                }
            }
        } failure:^(NSError *error) {
            
        }];
    }else{
//        catalogListView.play_id = courseID;
        NSMutableDictionary *parmDic = [NSMutableDictionary dictionary];
        [parmDic setObject:liveID forKey:@"id"];
        [parmDic setObject:courseID forKey:@"course_id"];
        [ZMNetworkHelper POST:@"/course/lesson" parameters:parmDic cache:YES responseCache:^(id responseCache) {
            
        } success:^(id responseObject) {
            if (responseObject == nil) {
                
            }else{
                if ([responseObject[@"code"] isEqualToString:@"0"]) {
                    
                    self.nextLesson = responseObject[@"data"][@"next_node"];
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        if (self.player) {
                            
                        }else{
                            [self setUpUI];
                        }
                        self.player.lessonInfo = responseObject[@"data"];
                        [PLVVodVideo requestVideoWithVid:responseObject[@"data"][@"video_id"] completion:^(PLVVodVideo *video, NSError *error) {
                            if (video) {
                                self.player.video = video;
                                
                            }
                        }];
                        catalogListView.play_id = responseObject[@"data"][@"id"];
                    });
                    
                }else if ([responseObject[@"code"] isEqualToString:@"-10000"]){
                    [BaseTools showErrorMessage:@"请登录后再操作"];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        [BaseTools alertLoginWithVC:self];
                    });
                }else{
                    [BaseTools showErrorMessage:responseObject[@"msg"]];
                }
            }
        } failure:^(NSError *error) {
            
        }];
    }
    
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    self.pagingView.frame = CGRectMake(0, ZM_StatusBarHeight, screenWidth(), screenHeight()-ZM_StatusBarHeight - 49);
}

- (void)setMealCourse:(NSNotification *)noti{
    CourseDetailViewController *vc = [[CourseDetailViewController alloc]init];
    vc.ID = noti.object[@"id"];

    vc.titleIndex = @"3";
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)setMealExams:(NSNotification *)noti{
    CourseDetailViewController *vc = [[CourseDetailViewController alloc]init];
    vc.ID = noti.object[@"id"];
    vc.titleIndex = @"1";
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)SetMealBooks:(NSNotification *)noti{
    CourseDetailViewController *vc = [[CourseDetailViewController alloc]init];
    vc.ID = noti.object[@"id"];
    vc.titleIndex = @"4";
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)SetMealLives:(NSNotification *)noti{
    CourseDetailViewController *vc = [[CourseDetailViewController alloc]init];
    vc.ID = noti.object[@"id"];
    vc.titleIndex = @"6";
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark - TestListViewDelegate

- (void)listViewDidScroll:(UIScrollView *)scrollView {
    [self.pagingView listViewDidScroll:scrollView];
}

#pragma mark - JXPagingViewDelegate

- (UIView *)tableHeaderViewInPagingView:(JXPagingView *)pagingView {
    
   if ([self.model.seckill_flag isEqualToString:@"1"]) {
        if ([self.titleIndex isEqualToString:@"3"]|| [self.titleIndex isEqualToString:@"6"]) {
            if ([self.model.distribution.distribute_status isEqualToString:@"1"] && [self.model.is_sell isEqualToString:@"1"]) {
                [self.headerView addSubview:self.distributeBtn];
            }
            return self.headerView;
        }else{
            if ([self.model.distribution.distribute_status isEqualToString:@"1"] && [self.model.is_sell isEqualToString:@"1"]) {
                [self.userHeaderView addSubview:self.distributeBtn];
            }
            
            return _userHeaderView;
        }
    }else{
        if ([self.titleIndex isEqualToString:@"3"]|| [self.titleIndex isEqualToString:@"6"]) {
            if ([self.model.distribution.distribute_status isEqualToString:@"1"] && [self.model.is_sell isEqualToString:@"1"]) {
                [self.playerPlaceholder addSubview:self.distributeBtn];
            }
            
            return self.playerPlaceholder;
        }else{
            if ([self.model.distribution.distribute_status isEqualToString:@"1"] && [self.model.is_sell isEqualToString:@"1"]) {
                [self.userHeaderView addSubview:self.distributeBtn];
            }
            
            return _userHeaderView;
        }
    }
    
    
}
- (UIButton *)distributeBtn{
    if (!_distributeBtn) {
        _distributeBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        _distributeBtn.frame = CGRectMake(11, headerHeight-63, 85, 28);
        _distributeBtn.backgroundColor = CNavBgColor;
        [_distributeBtn setImage:[UIImage imageNamed:@"赚-图标"] forState:(UIControlStateNormal)];
        [_distributeBtn setTitle:@"123" forState:(UIControlStateNormal)];
        [_distributeBtn setImageEdgeInsets:UIEdgeInsetsMake(0,-10, 0, 0)];
        _distributeBtn.layer.cornerRadius = 14;
        _distributeBtn.layer.masksToBounds = YES;
        _distributeBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [_distributeBtn addTarget:self action:@selector(distributeAction) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _distributeBtn;
}
-(void)distributeAction{
    
    if ([[UserDefaultsUtils valueWithKey:@"access_token"] length] != 0) {

        if ([[UserDefaultsUtils valueWithKey:@"IsYouKe"] isEqualToString:@"1"]) {
          
            [BaseTools showErrorMessage:@"游客登录不允许注册分销员"];
        }else{
            if (![self.distribute isEqualToString:@"1"] ) {
                
                if ([self.model.distribution.distributor_status isEqualToString:@"1"]) {
                    CourseDetailViewController *vc = [[CourseDetailViewController alloc]init];
                    vc.ID = self.ID;
                    vc.titleIndex = goods_type;
                    vc.coursePrice = self.model.discount_price;
                    vc.courseTitle = self.model.title;
                    vc.distribute  = @"1";
                    [self.navigationController pushViewController:vc animated:YES];
                }else if ([self.model.distribution.distributor_status  isEqualToString:@"-20000"] || [self.model.distribution.distributor_status  isEqualToString:@"4"] ) {
                    HomePageBannerViewController *vc = [[HomePageBannerViewController alloc]init];
                    vc.url = [NSString stringWithFormat:@"%@/distribution/explain",SERVER_HOSTM];
                    vc.title = @"分销员注册说明";
                    vc.rootVC = @"商品详情";
                    [[[AppDelegate shareAppDelegate] getCurrentUIVC].navigationController pushViewController:vc animated:YES];
                }else if ([self.model.distribution.distributor_status isEqualToString:@"0"]) {
                    [BaseTools showErrorMessage:@"申请正在审核中请耐心等待"];
                }else{
                    [BaseTools showErrorMessage:@"您已被禁用"];
                }
                
            }else{
                self.shareView = [[DistributionBottomShareView alloc]initWithFrame:CGRectMake(0, screenHeight()-150, screenWidth(), 150)];
                self.shareView.titleLab.text = @"立即分享";
                self.shareView.wbImage.image = [UIImage imageNamed:@"复制链接"];
                self.shareView.threeLab.text = @"复制链接";
                self.shareView.pyqImage.image = [UIImage imageNamed:@"图文二维码"];
                self.shareView.fourLab.text = @"图文二维码";
                NSString *urlString = nil;
                if ([goods_type isEqualToString:@"1"]) {
                    urlString = [NSString stringWithFormat:@"%@/exam/%@.html?distribute=%@", SERVER_HOSTPC,self.model.ID,self.model.distribution.dist_id];
                }else if ([goods_type isEqualToString:@"3"]){
                    urlString = [NSString stringWithFormat:@"%@/course/%@.html?distribute=%@", SERVER_HOSTPC,self.model.ID,self.model.distribution.dist_id];
                }else if ([goods_type isEqualToString:@"4"]){
                    urlString = [NSString stringWithFormat:@"%@/book/%@.html?distribute=%@", SERVER_HOSTPC,self.model.ID,self.model.distribution.dist_id];
                }else if ([goods_type isEqualToString:@"5"]){
                    urlString = [NSString stringWithFormat:@"%@/classroom/%@.html?distribute=%@", SERVER_HOSTPC,self.model.ID,self.model.distribution.dist_id];
                }else if ([goods_type isEqualToString:@"6"]){
                    urlString = [NSString stringWithFormat:@"%@/live/%@.html?distribute=%@", SERVER_HOSTPC,self.model.ID,self.model.distribution.dist_id];
                }
                CGPoint showCenter = CGPointMake(SCREEN_WIDTH/2,SCREEN_HEIGHT-self.shareView.height/2);
                [SGBrowserView showMoveView:self.shareView moveToCenter:showCenter];
                __weak typeof(self) weakSelf = self;
                self.shareView.myCloseBlock = ^{
                    [SGBrowserView hide];
                };
                self.shareView.myWXShareBlock = ^{
                    [weakSelf shareWebPageToPlatformType:UMSocialPlatformType_WechatSession shareURLString:urlString title:weakSelf.model.title descr:@"库课网校"];
                };
                self.shareView.myQQShareBlock = ^{
                    [weakSelf shareWebPageToPlatformType:UMSocialPlatformType_QQ shareURLString:urlString title:weakSelf.model.title descr:@"库课网校"];
                };
                self.shareView.myCopyBlock = ^{
                    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
                    pasteboard.string = urlString;
                    [BaseTools showErrorMessage:@"分销链接已复制到您的粘贴板"];
                };
                self.shareView.myPicBlock = ^{
                    [SGBrowserView hide];
                    [weakSelf showShareImageView:urlString];
                };
            }
            
        }
    }else{
        [BaseTools showErrorMessage:@"请登录后再操作"];
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [BaseTools alertLoginWithVC:self];
        });
    }
   
}

- (CGFloat)tableHeaderViewHeightInPagingView:(JXPagingView *)pagingView {
    return headerHeight;
}

- (CGFloat)heightForPinSectionHeaderInPagingView:(JXPagingView *)pagingView {
    return JXheightForHeaderInSection;
}

- (UIView *)viewForPinSectionHeaderInPagingView:(JXPagingView *)pagingView {
    return self.categoryView;
}

- (NSInteger)numberOfListViewsInPagingView:(JXPagingView *)pagingView {
    return self.titles.count;
}

- (UIView<JXPagingViewListViewDelegate> *)pagingView:(JXPagingView *)pagingView listViewInRow:(NSInteger)row {
    return self.listViewArray[row];
}

- (void)mainTableViewDidScroll:(UIScrollView *)scrollView {
    
    if (self.player.playbackState == PLVVodPlaybackStatePlaying) {
        
    }else{
        
        self.offset = scrollView.contentOffset.y;
        [self setNeedsStatusBarAppearanceUpdate];
        if (scrollView.contentOffset.y>headerHeight) {
            
            self.categoryView.cellWidth = 60;
            self.categoryView.averageCellWidthEnabled = NO;
            if (_titles.count == 2) {
                self.categoryView.collectionView.frame = CGRectMake((screenWidth()-180)/2, 0, 180, JXheightForHeaderInSection);
            }else{
                self.categoryView.collectionView.frame = CGRectMake((screenWidth()-260)/2, 0, 260, JXheightForHeaderInSection);
            }
            self.view.backgroundColor = [UIColor whiteColor];

            [self.categoryView reloadData];
            [_backbtn setImage:[UIImage imageNamed:@"导航栏返回"] forState:(UIControlStateNormal)];
            [_sharebtn setImage:[UIImage imageNamed:@"分享-hei"] forState:(UIControlStateNormal)];
            [_menubtn setImage:[UIImage imageNamed:@"caidan-hei"] forState:(UIControlStateNormal)];
        }else{
            
            self.view.backgroundColor = [UIColor blackColor];
            self.categoryView.averageCellWidthEnabled = YES;
            self.categoryView.collectionView.frame = CGRectMake(0, 0, screenWidth(), JXheightForHeaderInSection);
            [self.categoryView reloadData];
            [_backbtn setImage:[UIImage imageNamed:@"详情页返回按钮"] forState:(UIControlStateNormal)];
            [_sharebtn setImage:[UIImage imageNamed:@"详情页分享按钮"] forState:(UIControlStateNormal)];
            [_menubtn setImage:[UIImage imageNamed:@"菜单按钮"] forState:(UIControlStateNormal)];
        }
    }

}
- (BOOL)prefersStatusBarHidden {
    return self.player.prefersStatusBarHidden;
}
- (UIStatusBarStyle)preferredStatusBarStyle {
    
    
    if (self.offset>headerHeight) {
        return UIStatusBarStyleDefault;

    }else{
        return UIStatusBarStyleLightContent;
    }

}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation {

    return UIStatusBarAnimationFade;
}

- (void)showShareImageView:(NSString *)url{
    NSMutableDictionary *parmDic = [NSMutableDictionary dictionary];
    [parmDic setObject:self.model.distribution.coalition_id forKey:@"coalition_id"];
    [ZMNetworkHelper POST:@"/distribution/draw_goods_poster" parameters:parmDic cache:YES responseCache:^(id responseCache) {

    } success:^(id responseObject) {
        if (responseObject == nil) {

        }else{
            if ([responseObject[@"code"] isEqualToString:@"0"]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    DistributionGoodsShareView *shareview = [[DistributionGoodsShareView alloc]initWithFrame:self.view.bounds];
                    UIColor *color = [UIColor blackColor];
                    shareview.url = responseObject[@"data"];
                    shareview.backgroundColor = [color colorWithAlphaComponent:0.8];
                    CGPoint showCenter = CGPointMake(SCREEN_WIDTH/2,SCREEN_HEIGHT-shareview.height/2);
                    [SGBrowserView showMoveView:shareview moveToCenter:showCenter];
                    [shareview.shareImage sd_setImageWithURL:[NSURL URLWithString:responseObject[@"data"]]];
                    shareview.myCloseBlock = ^{
                        [SGBrowserView hide];
                    };

                });
            }else if ([responseObject[@"code"] isEqualToString:@"-10000"]){
                [BaseTools showErrorMessage:@"请登录后再操作"];
                dispatch_async(dispatch_get_main_queue(), ^{

                    [BaseTools alertLoginWithVC:self];
                });
            }else{
                [BaseTools showErrorMessage:responseObject[@"msg"]];
            }
        }

    } failure:^(NSError *error) {

    }];


}
- (void)menuAction:(UIButton *)sender{
    [YBPopupMenu showRelyOnView:sender titles:TITLES icons:ICONS menuWidth:120 otherSettings:^(YBPopupMenu *popupMenu) {
        popupMenu.fontSize = 13;
        popupMenu.textColor = CTitleColor;
        popupMenu.delegate = self;
    }];
}
#pragma mark - YBPopupMenuDelegate
- (void)ybPopupMenu:(YBPopupMenu *)ybPopupMenu didSelectedAtIndex:(NSInteger)index
{
    [self.player pause];
    [self.player destroyPlayer];
    NSInteger tabbarIndex =  [self.tabBarController selectedIndex];
//    //拿到tabbar的当前分栏的NavigationController
//    UINavigationController *nav = [self.tabBarController.viewControllers objectAtIndex:self.tabBarController.selectedIndex];
//    [_backBtn removeFromSuperview];
//    [_shareBtn removeFromSuperview];
//    [_menuBtn removeFromSuperview];
//    shareBtn.hidden = YES;
//    menuBtn.hidden = YES;
    if (index == tabbarIndex) {
        
        [[[AppDelegate shareAppDelegate] getCurrentUIVC].navigationController popToRootViewControllerAnimated:YES];
    }else{
        // 这是从一个模态出来的页面跳到tabbar的某一个页面
        [[[AppDelegate shareAppDelegate] getCurrentUIVC].navigationController popToRootViewControllerAnimated:NO];
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        
        UITabBarController *tabViewController = (UITabBarController *) appDelegate.window.rootViewController;
        
        [tabViewController setSelectedIndex:index];
    }
    
    
}
- (IBAction)sharedButtonClick:(id)sender {

    
    NSString *urlString;

    if ([goods_type isEqualToString:@"1"]) {
        urlString = [NSString stringWithFormat:@"%@/exam/%@.html", SERVER_HOSTPC,self.model.ID];
    }else if ([goods_type isEqualToString:@"3"]){
        urlString = [NSString stringWithFormat:@"%@/course/%@.html", SERVER_HOSTPC,self.model.ID];
    }else if ([goods_type isEqualToString:@"4"]){
        urlString = [NSString stringWithFormat:@"%@/book/%@.html", SERVER_HOSTPC,self.model.ID];
    }else if ([goods_type isEqualToString:@"5"]){
        urlString = [NSString stringWithFormat:@"%@/classroom/%@.html", SERVER_HOSTPC,self.model.ID];
    }else if ([goods_type isEqualToString:@"6"]){
        urlString = [NSString stringWithFormat:@"%@/live/%@.html", SERVER_HOSTPC,self.model.ID];
    }

    [UMSocialShareUIConfig shareInstance].sharePageGroupViewConfig.sharePageGroupViewPostionType = UMSocialSharePageGroupViewPositionType_Bottom;
    [UMSocialShareUIConfig shareInstance].sharePageScrollViewConfig.shareScrollViewPageItemStyleType = UMSocialPlatformItemViewBackgroudType_None;
    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
        if (platformType == UMSocialPlatformType_UserDefine_Begin+2) {
            //自定义图标的点击事件
        }
        else{
            [self shareWebPageToPlatformType:platformType shareURLString:urlString title:self.model.title descr:@"库课网校"];
        }
    }];
}
//网页分享
- (void)shareWebPageToPlatformType:(UMSocialPlatformType)platformType shareURLString:(NSString *)string title:(NSString *)title descr:(NSString *)descr{
    /*
     创建网页内容对象
     根据不同需求设置不同分享内容，一般为图片，标题，描述，url
     */
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:title descr:descr thumImage:[UIImage imageNamed:@"1024"]];
    
    //设置网页地址
    shareObject.webpageUrl = string;
    
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
        if (error) {
            UMSocialLogInfo(@"************Share fail with error %@*********",error);
        }else{
            [[OpenInstallSDK defaultManager] reportEffectPoint:@"goodshare" effectValue:1];
            if ([data isKindOfClass:[UMSocialShareResponse class]]) {
                UMSocialShareResponse *resp = data;
                //分享结果消息
                UMSocialLogInfo(@"response message is %@",resp.message);
                //第三方原始返回的数据
                UMSocialLogInfo(@"response originalResponse data is %@",resp.originalResponse);
            }else{
                UMSocialLogInfo(@"response data is %@",data);
            }
        }
    }];
}


#pragma mark - JXCategoryViewDelegate

- (void)categoryView:(JXCategoryBaseView *)categoryView didSelectedItemAtIndex:(NSInteger)index {
    self.navigationController.interactivePopGestureRecognizer.enabled = (index == 0);
    _sharebtn.hidden = NO;
    _backbtn.hidden = NO;
    _menubtn.hidden = NO;
}
#pragma mark - 转屏设置相关
- (BOOL)shouldAutorotate {
    return YES;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    if (self.player.fullscreen) {
        _backbtn.hidden = YES;
        _sharebtn.hidden = YES;
        _menubtn.hidden = YES;
        
    }else{
        _backbtn.hidden = NO;
        _sharebtn.hidden = NO;
        _menubtn.hidden = NO;
    }
    return UIInterfaceOrientationPortrait;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    if (self.player.fullscreen) {
        _backbtn.hidden = YES;
        _sharebtn.hidden = YES;
        _menubtn.hidden = YES;
       
    }else{
        _backbtn.hidden = NO;
        _sharebtn.hidden = NO;
        _menubtn.hidden = NO;
    }
    return UIInterfaceOrientationMaskAllButUpsideDown;
}
- (void)postPlayTime{
    if ([self.titleIndex integerValue] == 6) {
        NSMutableDictionary *parmDic = [NSMutableDictionary dictionary];
        [parmDic setObject:liveID forKey:@"node_id"];
        [parmDic setObject:[NSString stringWithFormat:@"%lf",self.player.currentPlaybackTime] forKey:@"time_point"];
        if (self.player.currentPlaybackTime<self.player.duration) {
            [parmDic setObject:@"0" forKey:@"play_over"];
        }else{
            [parmDic setObject:@"1" forKey:@"play_over"];
        }
        
        [ZMNetworkHelper POST:@"/live/progress" parameters:parmDic cache:YES responseCache:^(id responseCache) {
            
        } success:^(id responseObject) {
            if (responseObject == nil) {
                
            }else{
                if ([responseObject[@"code"] isEqualToString:@"0"]) {
                    KPostNotification(@"uploadHomePageCourseRecord", nil);
                    
                }else{
                    
                    [BaseTools showErrorMessage:responseObject[@"msg"]];
                }
            }
            
        } failure:^(NSError *error) {
            
        }];
    }else{
        NSMutableDictionary *parmDic = [NSMutableDictionary dictionary];
        [parmDic setObject:liveID forKey:@"node_id"];
        [parmDic setObject:[NSString stringWithFormat:@"%lf",self.player.currentPlaybackTime] forKey:@"time_point"];
        if (self.player.currentPlaybackTime<self.player.duration) {
            [parmDic setObject:@"0" forKey:@"play_over"];
        }else{
            [parmDic setObject:@"1" forKey:@"play_over"];
        }
        
        [ZMNetworkHelper POST:@"/course/progress" parameters:parmDic cache:YES responseCache:^(id responseCache) {
            
        } success:^(id responseObject) {
            if (responseObject == nil) {
                
            }else{
                if ([responseObject[@"code"] isEqualToString:@"0"]) {
                    KPostNotification(@"uploadHomePageCourseRecord", nil);
                    
                }else{
                    
                    [BaseTools showErrorMessage:responseObject[@"msg"]];
                }
            }
            
        } failure:^(NSError *error) {
            
        }];
    }
    
    
}

-(void)dealloc
{
//    _shareBtn.hidden = YES;
//    _backBtn.hidden = YES;
//    _menuBtn.hidden = YES;
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
//    _shareBtn.hidden = YES;
//    _backBtn.hidden = YES;
//    _menuBtn.hidden = YES;
    [[ZMTimeCountDown ShareManager] zj_timeDestoryTimer];
    if (self.player) {
        [self postPlayTime];
    }
    [self.player pause];

    
    
}

@end


