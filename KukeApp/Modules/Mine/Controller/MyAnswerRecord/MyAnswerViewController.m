//
//  MyAnswerViewController.m
//  KukeApp
//
//  Created by 库课 on 2018/12/24.
//  Copyright © 2018 zhangming. All rights reserved.
//

#import "MyAnswerViewController.h"
#import "CourseCatalogTableViewCell.h"
#import "TestPaperWebViewController.h"
#import "ExamWebViewController.h"
@interface MyAnswerViewController ()<YBPopupMenuDelegate>{
    UIButton *backBtn;
    UIButton *shareBtn;
    UILabel *liveExamLab;
    NSDictionary *models;
    UIButton *menuBtn;
}
@property (strong, nonatomic) UIView *headerView;//header

@property (nonatomic, strong) UIImageView *images;//占位图片

@property (nonatomic, strong) UILabel *titleLabs;



@property (strong, nonatomic) NSMutableArray *countArray;

@end

@implementation MyAnswerViewController


- (void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    
        self.countArray = [NSMutableArray array];
        [self loadData];
//    });
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[ZMTimeCountDown ShareManager] zj_timeDestoryTimer];
}
- (void)viewDidLoad {
    [super viewDidLoad];

    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    self.tableView.frame = CGRectMake(0, 0, KScreenWidth, screenHeight());
    
    [self.tableView registerNib:[UINib nibWithNibName:@"CourseCatalogTableViewCell" bundle:nil] forCellReuseIdentifier:@"CourseCatalogTableViewCell"];
    
    [self createNav];
    [self loadLiveExamData];
    
    // Do any additional setup after loading the view.
}
#pragma mark - 点击背景刷新时执行
- (void)noDataBeginRefresh {
    [self lq_endLoading];
    [self loadData];
    [self loadLiveExamData];
}
- (void)createNav{
    backBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    if (kIsiPhoneX) {
        backBtn.frame = CGRectMake(10, 30, 30, 30);
    }else{
        backBtn.frame = CGRectMake(10, 20, 30, 30);
    }
    
    [backBtn setImage:[UIImage imageNamed:@"详情页返回按钮"] forState:(UIControlStateNormal)];
    [backBtn addTarget:self action:@selector(back) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:backBtn];
    
    
    shareBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    if (kIsiPhoneX) {
        shareBtn.frame = CGRectMake(screenWidth()-80, 30, 30, 30);
    }else{
        shareBtn.frame = CGRectMake(screenWidth()-80, 20, 30, 30);
    }
    
    [shareBtn addTarget:self action:@selector(sharedButtonClick:) forControlEvents:(UIControlEventTouchUpInside)];
    [shareBtn setImage:[UIImage imageNamed:@"详情页分享按钮"] forState:(UIControlStateNormal)];
    [self.view addSubview:shareBtn];
    
    menuBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    
    if (kIsiPhoneX) {
        menuBtn.frame = CGRectMake(screenWidth()-40, 30, 30, 30);
    }else{
        menuBtn.frame = CGRectMake(screenWidth()-40, 20, 30, 30);
    }
    [menuBtn addTarget:self action:@selector(menuAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [menuBtn setImage:[UIImage imageNamed:@"菜单按钮"] forState:(UIControlStateNormal)];
    [self.view addSubview:menuBtn];
}
- (void)loadLiveExamData{
    NSMutableDictionary *parmDic = [NSMutableDictionary dictionary];
    [parmDic setObject:self.testPaper_id forKey:@"id"];
    
    [ZMNetworkHelper POST:@"/exam/detail" parameters:parmDic cache:YES responseCache:^(id responseCache) {
        
    } success:^(id responseObject) {
        if (responseObject == nil) {
            
        }else{
            if ([responseObject[@"code"] isEqualToString:@"0"]) {
                models = responseObject[@"data"];
                if ([responseObject[@"data"][@"live_exam"] isEqualToString:@"1"]) {
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self createLiveExamView];
                    });
                }
            }else{
                
                [BaseTools showErrorMessage:responseObject[@"msg"]];
            }
        }
        
    } failure:^(NSError *error) {
        
    }];
}
- (void)createLiveExamView{
    
    liveExamLab = [[UILabel alloc]initWithFrame:CGRectMake(0, SCREEN_WIDTH/16*9-50, screenWidth(), 50)];
    
    liveExamLab.hidden = YES;
    
    liveExamLab.backgroundColor = CNavBgColor;
    liveExamLab.textColor = [UIColor whiteColor];
    liveExamLab.font = [UIFont systemFontOfSize:14];
    liveExamLab.textAlignment = NSTextAlignmentCenter;
    [self.headerView addSubview:liveExamLab];
    if ([models[@"live_start"] longLongValue]*1000 > [[BaseTools currentTimeStr] longLongValue]) {//考试还未开始
        //倒计时
        [[ZMTimeCountDown ShareManager] zj_timeCountDownWithStartTimeStamp:[[BaseTools currentTimeStr] longLongValue] endTimeStamp:[models[@"live_start"] longLongValue]*1000 completeBlock:^(NSInteger day, NSInteger hour, NSInteger minute, NSInteger second) {
            liveExamLab.hidden = NO;
            liveExamLab.text = [NSString stringWithFormat:@"距离考试开始 %02ld天%02ld小时%02ld分%02ld秒",day,hour,minute,second];
        }];
    }else{
        if ([[BaseTools currentTimeStr] longLongValue] < [models[@"live_end"] longLongValue]*1000) {
            //倒计时
            [[ZMTimeCountDown ShareManager] zj_timeCountDownWithStartTimeStamp:[[BaseTools currentTimeStr] longLongValue] endTimeStamp:[models[@"live_end"] longLongValue]*1000 completeBlock:^(NSInteger day, NSInteger hour, NSInteger minute, NSInteger second) {
                liveExamLab.hidden = NO;
                liveExamLab.text = [NSString stringWithFormat:@"距离考试结束 %02ld天%02ld小时%02ld分%02ld秒",day,hour,minute,second];
            }];
        }
    }
}

- (void)loadData{
    NSMutableDictionary *parmDic = [NSMutableDictionary dictionary];
    [parmDic setObject:self.testPaper_id forKey:@"id"];
    BADataEntity *entity = [BADataEntity new];
    entity.urlString = @"/exam/testpaper";
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
                [self dataAnalysis:response];
            }else if ([response[@"code"] isEqualToString:@"-10000"]){
                [BaseTools showErrorMessage:@"请登录后再操作"];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [BaseTools alertLoginWithVC:self];
                });
            }else{
                [BaseTools showErrorMessage:response[@"msg"]];
            }
        }
       
    } failureBlock:^(NSError *error) {
        [self setEmptyViewDelegeta];
    } progressBlock:^(int64_t bytesProgress, int64_t totalBytesProgress) {
        /*! 封装方法里已经回到主线程，所有这里不用再调主线程了 */
        
    }];
    
}
#pragma mark —————  请求到的数据进行解析  --———
- (void)dataAnalysis:(id)data{

    [self.countArray addObjectsFromArray:data[@"data"]];
    [self setEmptyViewDelegeta];
    
    [self.tableView reloadData];
}


#pragma mark - UITableViewDataSource, UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.countArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 70;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CourseCatalogTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CourseCatalogTableViewCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.titleLab.text = self.countArray[indexPath.row][@"title"];
    cell.titleLab.font = [UIFont systemFontOfSize:13];
    cell.pic.image = [UIImage imageNamed:@"试卷图标"];
    cell.arrow.image = [UIImage imageNamed:@"套餐试卷答题图标"];
    cell.arrow.frame = CGRectMake(screenWidth()-40, 27.5, 15, 15);
    cell.numberLab.text = [NSString stringWithFormat:@"题数 %@",self.countArray[indexPath.row][@"item_count"]];
    cell.scoreLab.text = [NSString stringWithFormat:@"总分 %@",self.countArray[indexPath.row][@"score"]];
    cell.btn.layer.cornerRadius = 3;
    cell.btn.layer.borderWidth = 0.5f;
    cell.btn.layer.borderColor = [CTitleColor CGColor];
    if ([self.countArray[indexPath.row][@"study_status"] isEqualToString:@"0"]) {
        cell.isMakeLab.text = @"未开始";
        cell.isMakeLab.textColor = [UIColor darkGrayColor];
        cell.btn.hidden = YES;
    }else if ([self.countArray[indexPath.row][@"study_status"] isEqualToString:@"1"]){
        cell.isMakeLab.text = @"进行中";
        cell.arrow.image = [UIImage imageNamed:@"答题图标进行中红色"];
        cell.isMakeLab.textColor = CNavBgColor;
        cell.btn.hidden = YES;
    }else if ([self.countArray[indexPath.row][@"study_status"] isEqualToString:@"2"]){
        cell.btn.hidden = NO;
//        cell.btn.hidden = YES;
        cell.pic.image = [UIImage imageNamed:@"学完绿色对勾图标"];
        cell.isMakeLab.text =[NSString stringWithFormat:@"得分 %@",self.countArray[indexPath.row][@"stu_score"]];
        cell.isMakeLab.textColor = [UIColor colorWithRed:65/255.0 green:164/255.0 blue:95/255.0 alpha:1];
    }

    
    return cell;

}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (![CoreStatus isNetworkEnable]) {
        return  0.0001;
    }else{
        
         return  SCREEN_WIDTH/16*9+50;;
    }
   
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    if (![CoreStatus isNetworkEnable]) {
        return [[UIView alloc]init];
    }else{
        
        UIView *allBgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenHeight(), 10)];
        allBgView.backgroundColor = [UIColor whiteColor];
        
        self.images = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH/16*9)];
        [self.images sd_setImageWithURL:[NSURL URLWithString:self.imageUrl] placeholderImage:[UIImage imageNamed:@"coursesDedault"]];
        self.images.userInteractionEnabled = YES;
        self.images.contentMode=UIViewContentModeScaleAspectFill;
        self.images.clipsToBounds=YES;//  是否剪切掉超出 UIImageView 范围的图片
        [self.images setContentScaleFactor:[[UIScreen mainScreen] scale]];
        [allBgView addSubview:self.images];
        
        self.titleLabs = [[UILabel alloc]initWithFrame:CGRectMake(0, maxY(self.images), screenWidth(), 50)];
        self.titleLabs.text = @"大纲";
        self.titleLabs.backgroundColor = [UIColor whiteColor];
        self.titleLabs.textAlignment = NSTextAlignmentCenter;
        self.titleLabs.font = [UIFont systemFontOfSize:15];
        [allBgView addSubview:self.titleLabs];
        [self.titleLabs LX_SetShadowPathWith:[UIColor blackColor] shadowOpacity:0.3 shadowRadius:2 shadowSide:LXShadowPathBottom shadowPathWidth:2];
        self.headerView = allBgView;
        return allBgView;
    }
    
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *model = [self.countArray objectAtIndex:indexPath.row];
    if ([models[@"live_exam"] isEqualToString:@"1"]) {
        if ([models[@"live_start"] longLongValue]*1000 > [[BaseTools currentTimeStr] longLongValue]) {//考试还未开始

            [BaseTools showErrorMessage:@"大联考还未开始～"];

        }else if ([models[@"live_end"] longLongValue]*1000 < [[BaseTools currentTimeStr] longLongValue]) {//考试已经结束

            [BaseTools showErrorMessage:@"大联考已经结束～"];

        }else{
            NSDictionary *model = [self.countArray objectAtIndex:indexPath.row];
            NSMutableDictionary *parmDic = [NSMutableDictionary dictionary];
            [parmDic setObject:model[@"exam_id"] forKey:@"exam_id"];
            [ZMNetworkHelper POST:@"/exam/is_buy_exam" parameters:parmDic cache:YES responseCache:^(id responseCache) {
                
            } success:^(id responseObject) {
                if (responseObject == nil) {
                    
                }else{
                    if ([responseObject[@"code"] isEqualToString:@"0"]) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            
                            ExamWebViewController *vc = [[ExamWebViewController alloc]init];
                            vc.url =[NSString stringWithFormat:@"%@%@",SERVER_HOSTM,model[@"url"]];
                            [[[AppDelegate shareAppDelegate] getCurrentUIVC].navigationController pushViewController:vc animated:YES];
                        });
                        
                    }else{
                        
                        [BaseTools showErrorMessage:responseObject[@"msg"]];
                    }
                }
                
            } failure:^(NSError *error) {
                
            }];
            

        }
    }else{

        NSDictionary *model = [self.countArray objectAtIndex:indexPath.row];
        NSMutableDictionary *parmDic = [NSMutableDictionary dictionary];
        [parmDic setObject:model[@"exam_id"] forKey:@"exam_id"];
        [ZMNetworkHelper POST:@"/exam/is_buy_exam" parameters:parmDic cache:YES responseCache:^(id responseCache) {
            
        } success:^(id responseObject) {
            if (responseObject == nil) {
                
            }else{
                if ([responseObject[@"code"] isEqualToString:@"0"]) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        ExamWebViewController *vc = [[ExamWebViewController alloc]init];
                        vc.url =[NSString stringWithFormat:@"%@%@",SERVER_HOSTM,model[@"url"]];
                        [[[AppDelegate shareAppDelegate] getCurrentUIVC].navigationController pushViewController:vc animated:YES];
                    });
                    
                }else{
                    
                    [BaseTools showErrorMessage:responseObject[@"msg"]];
                }
            }
            
        } failure:^(NSError *error) {
            
        }];
    }
//    if ([models[@"live_exam"] isEqualToString:@"1"]) {
//        if ([models[@"live_start"] longLongValue]*1000 > [[BaseTools currentTimeStr] longLongValue]) {//考试还未开始
//
//            [BaseTools showErrorMessage:@"大联考还未开始～"];
//
//        }else if ([models[@"live_end"] longLongValue]*1000 < [[BaseTools currentTimeStr] longLongValue]) {//考试已经结束
//
//            [BaseTools showErrorMessage:@"大联考已经结束～"];
//
//        }else{
//            TestPaperWebViewController *vc = [[TestPaperWebViewController alloc]init];
//            NSDictionary *model = [self.countArray objectAtIndex:indexPath.row];
//            vc.dict = model;
//            [self.navigationController pushViewController:vc animated:YES];
//        }
//    }else{
//        TestPaperWebViewController *vc = [[TestPaperWebViewController alloc]init];
//        NSDictionary *model = [self.countArray objectAtIndex:indexPath.row];
//        vc.dict = model;
//        [self.navigationController pushViewController:vc animated:YES];
//    }
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if(scrollView == self.tableView ) {
        
        CGFloat sectionHeaderHeight = SCREEN_WIDTH/16*9-20; //headerView高度
        //         NSLog(@"%lf ====%f",scrollView.contentOffset.y,sectionHeaderHeight);
        if (scrollView.contentOffset.y <= sectionHeaderHeight && scrollView.contentOffset.y >=0) {
             [self.images sd_setImageWithURL:[NSURL URLWithString:self.imageUrl] placeholderImage:[UIImage imageNamed:@"coursesDedault"]];
//            self.images.image = [UIImage imageNamed:@""];
            [backBtn setImage:[UIImage imageNamed:@"详情页返回按钮"] forState:(UIControlStateNormal)];
            [shareBtn setImage:[UIImage imageNamed:@"详情页分享按钮"] forState:(UIControlStateNormal)];
            [menuBtn setImage:[UIImage imageNamed:@"菜单按钮"] forState:(UIControlStateNormal)];
            scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
        }
        else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
            self.headerView.backgroundColor = [UIColor whiteColor];
            self.images.image = [UIImage imageNamed:@""];
            [backBtn setImage:[UIImage imageNamed:@"导航栏返回"] forState:(UIControlStateNormal)];
            [shareBtn setImage:[UIImage imageNamed:@"导航栏分享"] forState:(UIControlStateNormal)];
            [menuBtn setImage:[UIImage imageNamed:@"caidan-hei"] forState:(UIControlStateNormal)];
            scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
        }
        //        else if (scrollView.contentOffset.y<sectionHeaderHeight){
        //            self.headerView.backgroundColor = [UIColor redColor];
        //            scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        //        }
    }
}
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIImage imageNamed:@"无试卷"];
}
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *title = @"暂无做题记录哦～";
    NSDictionary *attributes = @{
                                 NSFontAttributeName:[UIFont systemFontOfSize:13.0f],
                                 NSForegroundColorAttributeName:[UIColor colorWithHexString:@"8a8a8a"]
                                 };
    return [[NSAttributedString alloc] initWithString:title attributes:attributes];
}
- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)sharedButtonClick:(id)sender {
    

    NSString *urlString;

    urlString = [NSString stringWithFormat:@"%@/exam/%@.html", SERVER_HOSTPC,self.testPaper_id];

    [UMSocialShareUIConfig shareInstance].sharePageGroupViewConfig.sharePageGroupViewPostionType = UMSocialSharePageGroupViewPositionType_Bottom;
    [UMSocialShareUIConfig shareInstance].sharePageScrollViewConfig.shareScrollViewPageItemStyleType = UMSocialPlatformItemViewBackgroudType_None;
    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
        if (platformType == UMSocialPlatformType_UserDefine_Begin+2) {
            //自定义图标的点击事件
        }
        else{
            [self shareWebPageToPlatformType:platformType shareURLString:urlString title:self.testPaper_title descr:@"库课网校"];
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

    NSInteger tabbarIndex =  [self.tabBarController selectedIndex];
    //    //拿到tabbar的当前分栏的NavigationController
    //    UINavigationController *nav = [self.tabBarController.viewControllers objectAtIndex:self.tabBarController.selectedIndex];
    [backBtn removeFromSuperview];
    [shareBtn removeFromSuperview];
    [menuBtn removeFromSuperview];
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
@end
