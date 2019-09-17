//
//  ExamPageViewController.m
//  KukeApp
//
//  Created by 库课 on 2019/8/7.
//  Copyright © 2019 KukeZangMing. All rights reserved.
//

#import "ExamPageViewController.h"
#import "XLPageViewController.h"
#import "ExamTableViewController.h"
#import "ExamListViewModel.h"
#import "PLVDownloadManagerViewController.h"
@interface ExamPageViewController ()<XLPageViewControllerDelegate,XLPageViewControllerDataSrouce,NoDataTipsDelegate>

@property (nonatomic, strong) XLPageViewController *pageViewController;
//标题组
@property (nonatomic, strong) NSMutableArray *titles;

@property (nonatomic, strong) NSMutableArray *cateIDs;
//配置信息
@property (nonatomic, strong) XLPageViewControllerConfig *config;

@property (nonatomic, strong) ExamListViewModel *viewModel;

@property (nonatomic, strong) NoDataTipsView *loadNetView;
@property (nonatomic, strong) NoDataTipsView *loadNetView1;
@end

@implementation ExamPageViewController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO];

    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"答题记录";
    self.view.backgroundColor = [UIColor whiteColor];
    if (![CoreStatus isNetworkEnable]) {
        [self.view addSubview:self.loadNetView];
    }else{
        [self loadData];
    }
}
- (void)loadData{
    self.viewModel = [[ExamListViewModel alloc]init];
    [self.viewModel loadTitleDataWithTitleBack:^(id  _Nullable data) {
        [self.loadNetView removeFromSuperview];
        if (![data[@"code"] isEqualToString:@"0"]) {
            [self.view addSubview:self.loadNetView1];
        }else{
            self.titles = [NSMutableArray array];
            self.cateIDs = [NSMutableArray array];
            //        [EasyLoadingView hidenLoading];
            for (NSDictionary *dict in data[@"data"]) {
                [self.titles addObject:dict[@"name"]];
                [self.cateIDs addObject:dict[@"id"]];
            }
            [self initPageViewController:self.titles.count];
        }
   
    } fromController:self];
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
#pragma mark - 懒加载失败默认视图
- (NoDataTipsView *)loadNetView1 {
    if (!_loadNetView1) {
        
        _loadNetView1 = [NoDataTipsView setTipsBackGroupWithframe:CGRectMake(0, 0, screenWidth(), self.view.height) tipsIamgeName:@"无试卷" tipsStr:@"暂无数据哦~"];
        _loadNetView1.backgroundColor = CBackgroundColor;
        _loadNetView1.noDataBtn.hidden = YES;
//        _loadNetView1.delegate = self;
    }
    return _loadNetView1;
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
- (void)initPageViewController:(NSInteger)titleCount {
    
    self.config = [XLPageViewControllerConfig defaultConfig];
    
    if (titleCount <= 1 ) {
        self.config.titleViewHeight = 0;
    }else{
        self.config.titleViewHeight = 50;
    }
    
    if (titleCount <= 4 && titleCount > 1) {
        self.config.titleSpace = 0;
        self.config.titleWidth = self.view.bounds.size.width/titleCount;
        self.config.shadowLineWidth = self.view.bounds.size.width/titleCount;
    }else{
        self.config.titleWidth = 80;
        self.config.titleSpace = 0;
        self.config.shadowLineWidth = 30;
    }

    self.config.titleViewInset = UIEdgeInsetsZero;
    self.config.titleNormalFont = [UIFont systemFontOfSize:15];
    self.config.titleSelectedFont = [UIFont systemFontOfSize:15];
    self.config.titleNormalColor = CTitleColor;
    self.config.titleSelectedColor = CNavBgColor;
    self.config.separatorLineHeight = 1;
    self.config.separatorLineColor = CBackgroundColor;
    self.config.shadowLineColor = CNavBgColor;
    self.config.shadowLineHeight = 1;
    self.pageViewController = [[XLPageViewController alloc] initWithConfig:self.config];
    self.pageViewController.view.frame = self.view.bounds;
    self.pageViewController.delegate = self;
    self.pageViewController.dataSource = self;
    [self addChildViewController:self.pageViewController];
    [self.view addSubview:self.pageViewController.view];
}

#pragma mark -
#pragma mark TableViewDelegate&DataSource
- (UIViewController *)pageViewController:(XLPageViewController *)pageViewController viewControllerForIndex:(NSInteger)index {
    ExamTableViewController *vc = [[ExamTableViewController alloc] init];
    vc.exam_cate_id = self.cateIDs[index];
    vc.number = self.titles.count;
    return vc;
}

- (NSString *)pageViewController:(XLPageViewController *)pageViewController titleForIndex:(NSInteger)index {

    return self.titles[index];
}

- (NSInteger)pageViewControllerNumberOfPage {
    return self.titles.count;
}

- (void)pageViewController:(XLPageViewController *)pageViewController didSelectedAtIndex:(NSInteger)index {
    NSLog(@"切换到了：%@",self.titles[index]);
}

@end
