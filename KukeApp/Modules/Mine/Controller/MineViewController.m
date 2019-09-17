//
//  MineViewController.m
//  KukeApp
//
//  Created by iOSDeveloper on 2018/8/23.
//  Copyright © 2018年 zhangming. All rights reserved.
//

#import "MineViewController.h"
#import "MineHeaderTableViewCell.h"
#import "MineCourseTableViewCell.h"
#import "MineListTableViewCell.h"
#import "SettingViewController.h"
#import "AboutOursViewController.h"
#import "CommissionViewController.h"
#import "MyCollectionViewController.h"
#import "MyOrderViewController.h"
#import "MyBalanceViewController.h"
#import "HomePageBannerViewController.h"
#import "PLVDownloadManagerViewController.h"
#import "MyCouponViewController.h"
#import "MyInformationViewController.h"
#import "MyLearningRecordViewController.h"
#import "MyAnswerRecord/MyAnswerRecordListViewController.h"
#import "MyCourseAndTestTableViewController.h"
#import "Distribution/Controller/RegisterDistributionViewController.h"
#import "DistributionCentreViewController.h"
#import "FeedbackViewController.h"
#import "MyPurchasedCourseViewController.h"
#import "MyPurchasedCourseViewController.h"
@interface MineViewController ()<UITableViewDataSource, UITableViewDelegate,NoDataTipsDelegate>{
   BOOL isChangeImage;
    NSString *courseRecordNum;
    NSString *testPaperRecordNum;
    NSString *distributeStatus;
    NSString *unread1;
    NSString *unread2;
    NSString *unread3;
    NSString *number;
    NSString *messageNureadNumber;
}
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) NoDataTipsView *loadNetView;
@end

@implementation MineViewController


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    number = @"0";
    if (![CoreStatus isNetworkEnable]) {

        self.loadNetView.frame = CGRectMake(0, 0, screenWidth(), self.view.height);
        [self.view addSubview:self.loadNetView];
    }else{
        [self loadData];
    }
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
}
- (void)loadData{
    [ZMNetworkHelper POST:@"/user/profile" parameters:nil cache:YES responseCache:^(id responseCache) {
        
    } success:^(id responseObject) {
        dispatch_async(dispatch_get_main_queue(), ^{
           [self.loadNetView removeFromSuperview];
        });
        
        if (responseObject == nil) {
            
        }else{
            if ([responseObject[@"code"] isEqualToString:@"0"]) {
                [UserInfoTool initialize];
                [UserInfoTool deleteListData];
                CurrentUserInfo *userInfo = [[CurrentUserInfo alloc]init];
                userInfo.NiName = responseObject[@"data"][@"stu_name"];
                userInfo.Tel = responseObject[@"data"][@"mobile"];
                userInfo.StudentID = responseObject[@"data"][@"stu_id"];
                userInfo.photo = responseObject[@"data"][@"photo"];
                [UserInfoTool addPerson:userInfo];
                courseRecordNum = responseObject[@"data"][@"course_log_count"];
                testPaperRecordNum = responseObject[@"data"][@"testpaper_log_count"];
                distributeStatus = responseObject[@"data"][@"distributeStatus"];
                
                unread1 = responseObject[@"data"][@"pend_pay"];
                unread2 = responseObject[@"data"][@"pend_deliver"];
                unread3 = responseObject[@"data"][@"pend_receipt"];
                number = responseObject[@"data"][@"coupon_total"];
                messageNureadNumber = responseObject[@"data"][@"notice_num"];
                if ([distributeStatus isEqualToString:@"0"]) {
                    [self initData:@"0"];
                }else{
                    [self initData:@"1"];
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.tableView reloadData];
                });
                
            }else if ([responseObject[@"code"] isEqualToString:@"-10000"]){
                [self initData:@"1"];
                [UserDefaultsUtils saveValue:@"" forKey:@"access_token"];
            }else{
                [self initData:@"1"];
                [BaseTools showErrorMessage:responseObject[@"msg"]];
            }
        }
        
    } failure:^(NSError *error) {
  
        
    }];
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
    [self loadData];
}
- (void)initData:(NSString *)isDistribution{
    
    
    if ([isDistribution isEqualToString:@"0"] ) {
        if ([UserDefaultsUtils boolValueWithKey:KIsAudit] || [[UserDefaultsUtils valueWithKey:@"access_token"] length] == 0) {
            _dataArray = @[
                           @[
                               @{@"title":@"已购课程", @"image":@"个人中心-已购课程-1", @"content":@"", @"id":@"1"},
                               @{@"title":@"已购题库", @"image":@"个人中心-已购试卷-1", @"content":@"", @"id":@"2"},
                               @{@"title":@"我的下载", @"image":@"个人中心-我的下载", @"content":@"", @"id":@"3"},
                               @{@"title":@"我的收藏", @"image":@"个人中心-我的收藏", @"content":@"", @"id":@"4"},
                               ],
                           @[
                               @{@"title":@"我的余额", @"image":@"个人中心-我的余额", @"content":@"", @"id":@"5"},
                               ],
                           @[
                               @{@"title":@"在线咨询", @"image":@"个人中心-在线咨询", @"content":@"周一至周日 08:00-20:00", @"id":@"7"},
                               @{@"title":@"电话咨询", @"image":@"个人中心-电话咨询", @"content":@"400-6529-888", @"id":@"8"},
                               @{@"title":@"意见反馈", @"image":@"个人中心-意见反馈", @"content":@"", @"id":@"9"},
                               @{@"title":@"帮助中心", @"image":@"个人中心-帮助中心", @"content":@"", @"id":@"10"},
                               ],
                           @[
                               @{@"title":@"关于我们", @"image":@"个人中心-关于", @"content":@"", @"id":@"11"},
                               @{@"title":@"设置", @"image":@"个人中心-设置", @"content":@"", @"id":@"12"},
                               ],
                           ];
        }else{
            _dataArray = @[
                           @[
                               @{@"title":@"我要赚学费", @"image":@"个人中心-我要赚学费图标", @"content":@"审核中", @"id":@"0"},
                               @{@"title":@"已购课程", @"image":@"个人中心-已购课程-1", @"content":@"", @"id":@"1"},
                               @{@"title":@"已购题库", @"image":@"个人中心-已购试卷-1", @"content":@"", @"id":@"2"},
                               @{@"title":@"我的下载", @"image":@"个人中心-我的下载", @"content":@"", @"id":@"3"},
                               @{@"title":@"我的收藏", @"image":@"个人中心-我的收藏", @"content":@"", @"id":@"4"},
                               ],
                           @[
                               @{@"title":@"我的余额", @"image":@"个人中心-我的余额", @"content":@"", @"id":@"5"},
                               @{@"title":@"我的卡券", @"image":@"个人中心_优惠券", @"content":@"", @"id":@"6"},
                               ],
                           @[
                               @{@"title":@"在线咨询", @"image":@"个人中心-在线咨询", @"content":@"周一至周日 08:00-20:00", @"id":@"7"},
                               @{@"title":@"电话咨询", @"image":@"个人中心-电话咨询", @"content":@"400-6529-888", @"id":@"8"},
                               @{@"title":@"意见反馈", @"image":@"个人中心-意见反馈", @"content":@"", @"id":@"9"},
                               @{@"title":@"帮助中心", @"image":@"个人中心-帮助中心", @"content":@"", @"id":@"10"},
                               ],
                           @[
                               @{@"title":@"关于我们", @"image":@"个人中心-关于", @"content":@"", @"id":@"11"},
                               @{@"title":@"设置", @"image":@"个人中心-设置", @"content":@"", @"id":@"12"},
                               ],
                           ];
        }
    }else{
        if ([UserDefaultsUtils boolValueWithKey:KIsAudit] || [[UserDefaultsUtils valueWithKey:@"access_token"] length] == 0) {
            _dataArray = @[
                           @[
                               @{@"title":@"已购课程", @"image":@"个人中心-已购课程-1", @"content":@"", @"id":@"1"},
                               @{@"title":@"已购题库", @"image":@"个人中心-已购试卷-1", @"content":@"", @"id":@"2"},
                               @{@"title":@"我的下载", @"image":@"个人中心-我的下载", @"content":@"", @"id":@"3"},
                               @{@"title":@"我的收藏", @"image":@"个人中心-我的收藏", @"content":@"", @"id":@"4"},
                               ],
                           @[
                               @{@"title":@"我的余额", @"image":@"个人中心-我的余额", @"content":@"", @"id":@"5"},
                               ],
                           @[
                               @{@"title":@"在线咨询", @"image":@"个人中心-在线咨询", @"content":@"周一至周日 08:00-20:00", @"id":@"7"},
                               @{@"title":@"电话咨询", @"image":@"个人中心-电话咨询", @"content":@"400-6529-888", @"id":@"8"},
                               @{@"title":@"意见反馈", @"image":@"个人中心-意见反馈", @"content":@"", @"id":@"9"},
                               @{@"title":@"帮助中心", @"image":@"个人中心-帮助中心", @"content":@"", @"id":@"10"},
                               ],
                           @[
                               @{@"title":@"关于我们", @"image":@"个人中心-关于", @"content":@"", @"id":@"11"},
                               @{@"title":@"设置", @"image":@"个人中心-设置", @"content":@"", @"id":@"12"},
                               ],
                           ];
        }else{
            _dataArray = @[
                           @[
                               @{@"title":@"我要赚学费", @"image":@"个人中心-我要赚学费图标", @"content":@"", @"id":@"0"},
                               @{@"title":@"已购课程", @"image":@"个人中心-已购课程-1", @"content":@"", @"id":@"1"},
                               @{@"title":@"已购题库", @"image":@"个人中心-已购试卷-1", @"content":@"", @"id":@"2"},
                               @{@"title":@"我的下载", @"image":@"个人中心-我的下载", @"content":@"", @"id":@"3"},
                               @{@"title":@"我的收藏", @"image":@"个人中心-我的收藏", @"content":@"", @"id":@"4"},
                               ],
                           @[
                               @{@"title":@"我的余额", @"image":@"个人中心-我的余额", @"content":@"", @"id":@"5"},
                               @{@"title":@"我的卡券", @"image":@"个人中心_优惠券", @"content":@"", @"id":@"6"},
                               ],
                           @[
                               @{@"title":@"在线咨询", @"image":@"个人中心-在线咨询", @"content":@"周一至周日 08:00-20:00", @"id":@"7"},
                               @{@"title":@"电话咨询", @"image":@"个人中心-电话咨询", @"content":@"400-6529-888", @"id":@"8"},
                               @{@"title":@"意见反馈", @"image":@"个人中心-意见反馈", @"content":@"", @"id":@"9"},
                               @{@"title":@"帮助中心", @"image":@"个人中心-帮助中心", @"content":@"", @"id":@"10"},
                               ],
                           @[
                               @{@"title":@"关于我们", @"image":@"个人中心-关于", @"content":@"", @"id":@"11"},
                               @{@"title":@"设置", @"image":@"个人中心-设置", @"content":@"", @"id":@"12"},
                               ],
                           ];
        }
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [_tableView reloadData];
    });
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
 
    isChangeImage = NO;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadData) name:KNotificationLoginUpdata object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadData) name:@"OutLogin" object:nil];
    [self.view addSubview:self.tableView];
    
    // Do any additional setup after loading the view.
}
- (void)reloadData{
    [_tableView reloadData];
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, screenWidth(), screenHeight()-UI_tabBar_Height) style:UITableViewStyleGrouped];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = CBackgroundColor;
 
        self.tableView.estimatedRowHeight = 0;
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
        [self.tableView registerNib:[UINib nibWithNibName:@"MineHeaderTableViewCell" bundle:nil] forCellReuseIdentifier:@"MineHeaderTableViewCell"];
        [self.tableView registerNib:[UINib nibWithNibName:@"MineCourseTableViewCell" bundle:nil] forCellReuseIdentifier:@"MineCourseTableViewCell"];
        [self.tableView registerNib:[UINib nibWithNibName:@"MineListTableViewCell" bundle:nil] forCellReuseIdentifier:@"MineListTableViewCell"];

    }
    return _tableView;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count+2;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0: return 280; break;
        case 1: return 80; break;
        case 2: return 50; break;
        case 3: return 50; break;
        case 4: return 50; break;
        case 5: return 50; break;
//        case 4: return 50; break;
        default: return 0; break;
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0: return 1; break;
        case 1: return 1; break;
        case 2: return [_dataArray[0] count]; break;
        case 3: return [_dataArray[1] count]; break;
        case 4: return [_dataArray[2] count]; break;
        case 5: return [_dataArray[3] count]; break;
//        case 4: return 3; break;
        default: return 0; break;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.section == 0) {
        MineHeaderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MineHeaderTableViewCell" forIndexPath:indexPath];
        if ([messageNureadNumber integerValue] == 0) {
            cell.messgeUnreadNumberLab.hidden = YES;
        }
        else{
            cell.messgeUnreadNumberLab.hidden = NO;
        }
        cell.messgeUnreadNumberLab.text = messageNureadNumber;
        [cell loadView];
        if (courseRecordNum.length == 0) {
            
        }else{
            [cell.courseRecord setTitle:[NSString stringWithFormat:@" 听课记录（%@)",courseRecordNum] forState:(UIControlStateNormal)];
        }
        if (testPaperRecordNum.length == 0) {
            
        }else{
            [cell.testPaperRecord setTitle:[NSString stringWithFormat:@" 答题记录（%@)",testPaperRecordNum] forState:(UIControlStateNormal)];
        }
        
        
        cell.headerActionBlock = ^{
            if ([cell.headImage.currentTitle containsString:@"登录"]) {
                [BaseTools alertLoginWithVC:self];
            }else{
                MyInformationViewController *vc = [[MyInformationViewController alloc]init];
                [self.navigationController pushViewController:vc animated:YES];
            }
        };
        cell.singinActionBlock = ^{
            
        };

        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell ;
    }else if (indexPath.section == 1){
        MineCourseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MineCourseTableViewCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if ([unread1 integerValue] == 0) {
            cell.unread1.hidden = YES;
        }else{
            cell.unread1.hidden = NO;
        }
        if ([unread2 integerValue] == 0) {
            cell.unread2.hidden = YES;
        }
        else{
            cell.unread2.hidden = NO;
        }
        if ([unread3 integerValue] == 0) {
            cell.unread3.hidden = YES;
        }else{
            cell.unread3.hidden = NO;
        }
        cell.unread1.text = unread1;
        cell.unread2.text = unread2;
        cell.unread3.text = unread3;
        return cell;
    }else {
        MineListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MineListTableViewCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        NSArray *sectionArray = self.dataArray[indexPath.section-2];
        NSDictionary *dic = sectionArray[indexPath.row];
        [cell configWithDic:dic];
        if (![number isEqualToString:@"0"]) {
            if ([dic[@"title"] isEqualToString:@"我的卡券"]) {
                cell.numBer.text = [NSString stringWithFormat:@"%@张优惠券待使用",number];
            }
        }
        if ([dic[@"title"] isEqualToString:@"在线咨询"] || [dic[@"title"] isEqualToString:@"电话咨询"]) {
            cell.numBer.textColor = [UIColor colorWithHexString:@"#8A8A8A"];
        }
        
        return cell;
    }

}

//头视图高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = [UIColor clearColor];
    return headerView;
}

//脚视图高度
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 5;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth(), 5)];
    footerView.backgroundColor = CBackgroundColor;
    return footerView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section != 0 && indexPath.section != 0) {
        NSString *str = self.dataArray[indexPath.section-2][indexPath.row][@"id"];

        switch ([str integerValue]) {
            case 0:{
                
                
                if ([[UserDefaultsUtils valueWithKey:@"access_token"] length] !=0 ) {
                    
                    if ([[UserDefaultsUtils valueWithKey:@"IsYouKe"] isEqualToString:@"1"]) {
                        
                        [BaseTools showErrorMessage:@"游客登录不允许注册分销员"];
                    }else{
                        if ([distributeStatus isEqualToString:@"-20000"]) {
                            HomePageBannerViewController *vc = [[HomePageBannerViewController alloc]init];
                            vc.url = [NSString stringWithFormat:@"%@/distribution/explain",SERVER_HOSTM];
                            vc.title = @"分销员注册说明";
                            vc.rootVC = @"个人中心";
                            [[[AppDelegate shareAppDelegate] getCurrentUIVC].navigationController pushViewController:vc animated:YES];
                        }else if ([distributeStatus isEqualToString:@"0"]){
                            [BaseTools showErrorMessage:@"申请正在审核中请耐心等待"];
                        }else if ([distributeStatus isEqualToString:@"1"]){
                            DistributionCentreViewController *vc = [[DistributionCentreViewController alloc]init];
                            vc.title = @"分销员中心";
                            vc.isEnable = YES;
                            [self.navigationController pushViewController:vc animated:YES];
                        }else if ([distributeStatus isEqualToString:@"2"]){
                            DistributionCentreViewController *vc = [[DistributionCentreViewController alloc]init];
                            vc.title = @"分销员中心";
                            vc.isEnable = NO;
                            [self.navigationController pushViewController:vc animated:YES];
                        }else if ([distributeStatus isEqualToString:@"3"]){
                            [BaseTools showErrorMessage:@"您已被禁用"];
                        }else if ([distributeStatus isEqualToString:@"4"]){
                            //                             [BaseTools showErrorMessage:@"分销员注册申请失败，请重新提交"];
                            HomePageBannerViewController *vc = [[HomePageBannerViewController alloc]init];
                            vc.url = [NSString stringWithFormat:@"%@/distribution/explain",SERVER_HOSTM];
                            vc.title = @"分销员注册说明";
                            vc.rootVC = @"个人中心";
                            [[[AppDelegate shareAppDelegate] getCurrentUIVC].navigationController pushViewController:vc animated:YES];
                        }
                    }
                    
                }else{
                    [BaseTools showErrorMessage:@"请登录后再操作"];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        [BaseTools alertLoginWithVC:self];
                    });
                }
            };break;
            case 1:{
                
                
                if ([[UserDefaultsUtils valueWithKey:@"access_token"] length] !=0 ) {
                    MyPurchasedCourseViewController *vc = [[MyPurchasedCourseViewController alloc]init];
                    vc.title = @"已购课程";
                    [self.navigationController pushViewController:vc animated:YES];
                }else{
                    [BaseTools showErrorMessage:@"请登录后再操作"];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        [BaseTools alertLoginWithVC:self];
                    });
                }
            };break;
            case 2:{
                if ([[UserDefaultsUtils valueWithKey:@"access_token"] length] != 0) {
                    MyCourseAndTestTableViewController *vc = [[MyCourseAndTestTableViewController alloc]init];
                    vc.type = 2;
                    vc.title = @"已购题库";
                    [self.navigationController pushViewController:vc animated:YES];
                }else{
                    [BaseTools showErrorMessage:@"请登录后再操作"];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        [BaseTools alertLoginWithVC:self];
                    });
                }
                
            };break;
            case 3:{
                
                
                if ([[UserDefaultsUtils valueWithKey:@"access_token"] length] !=0 ) {
                    PLVDownloadManagerViewController *vc = [[PLVDownloadManagerViewController alloc]init];
                    [self.navigationController pushViewController:vc animated:YES];
                }else{
                    [BaseTools showErrorMessage:@"请登录后再操作"];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        [BaseTools alertLoginWithVC:self];
                    });
                }
            };break;
            case 4:{
                if ([[UserDefaultsUtils valueWithKey:@"access_token"] length] != 0) {
                    MyCollectionViewController *vc = [[MyCollectionViewController alloc]init];
                    [self.navigationController pushViewController:vc animated:YES];
                }else{
                    [BaseTools showErrorMessage:@"请登录后再操作"];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        [BaseTools alertLoginWithVC:self];
                    });
                }
                
            };break;
            case 5:{
                if ([[UserDefaultsUtils valueWithKey:@"access_token"] length] != 0) {
                    MyBalanceViewController *vc = [[MyBalanceViewController alloc]init];
                    [self.navigationController pushViewController:vc animated:YES];
                }else{
                    [BaseTools showErrorMessage:@"请登录后再操作"];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        [BaseTools alertLoginWithVC:self];
                    });
                }
                
            };break;
            case 6:{
                
                if ([[UserDefaultsUtils valueWithKey:@"access_token"] length] != 0) {
                    MyCouponViewController *vc = [[MyCouponViewController alloc]init];
                    [self.navigationController pushViewController:vc animated:YES];
                }else{
                    [BaseTools showErrorMessage:@"请登录后再操作"];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        [BaseTools alertLoginWithVC:self];
                    });
                }
                
            };break;
            case 7:{
                if ([[UserDefaultsUtils valueWithKey:@"access_token"] length] !=0 ) {
                    
                    QYSource *source = [[QYSource alloc] init];
                    source.title =  @"库课网校";
                    source.urlString = @"https://www.kuke99.com/";
                    
                    QYSessionViewController *sessionViewController = [[QYSDK sharedSDK] sessionViewController];
                    sessionViewController.delegate = self;
                    sessionViewController.sessionTitle = @"库课网校";
                    sessionViewController.source = source;
                    
                    if (IS_PAD) {
                        UINavigationController* navi = [[UINavigationController alloc]initWithRootViewController:sessionViewController];
                        navi.modalPresentationStyle = UIModalPresentationFormSheet;
                        [self presentViewController:navi animated:YES completion:nil];
                    }
                    else{
                        sessionViewController.hidesBottomBarWhenPushed = YES;
                        [self.navigationController pushViewController:sessionViewController animated:YES];
                    }
                    
                    [[QYSDK sharedSDK] customUIConfig].bottomMargin = 0;
                }else{
                    [BaseTools showErrorMessage:@"请登录后再操作"];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        [BaseTools alertLoginWithVC:self];
                    });
                }
           
                
            };break;
            case 8:{
                NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",@"400-6529-888"];
                UIWebView * callWebview = [[UIWebView alloc] init];
                [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
                [self.view addSubview:callWebview];

            };break;
            case 9:{
                
                if ([[UserDefaultsUtils valueWithKey:@"access_token"] length] !=0 ) {
                    FeedbackViewController *vc = [[FeedbackViewController alloc]init];
                    [self.navigationController pushViewController:vc animated:YES];
                }else{
                    [BaseTools showErrorMessage:@"请登录后再操作"];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        [BaseTools alertLoginWithVC:self];
                    });
                }
                
            };break;
            case 10:{
                
                HomePageBannerViewController *vc = [[HomePageBannerViewController alloc]init];
                vc.url = [NSString stringWithFormat:@"%@/help/index",SERVER_HOSTM];
                vc.title = @"帮助中心";
                [self.navigationController pushViewController:vc animated:YES];
                
            };break;
            case 11:{
                
                AboutOursViewController *vc = [[AboutOursViewController alloc]init];
                [self.navigationController pushViewController:vc animated:YES];
                
            };break;
            case 12:{
                
                if ([[UserDefaultsUtils valueWithKey:@"access_token"] length] !=0 ) {
                    SettingViewController *vc = [[SettingViewController alloc]init];
                    [self.navigationController pushViewController:vc animated:YES];
                }else{
                    [BaseTools showErrorMessage:@"请登录后再操作"];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        [BaseTools alertLoginWithVC:self];
                    });
                }
                
            };break;
            
                
            default:
                break;
        }
    }

    
}


-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (_tableView.contentOffset.y <= 0) {
        _tableView.bounces = NO;
    }else if (_tableView.contentOffset.y >= 0){
        _tableView.bounces = YES;
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
