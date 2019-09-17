//
//  PLVDownloadManagerViewController.m
//  PolyvVodSDKDemo
//
//  Created by mac on 2018/7/24.
//  Copyright © 2018年 POLYV. All rights reserved.
//

#import "PLVDownloadManagerViewController.h"
#import "PLVDownloadCompleteViewController.h"
#import "PLVDownloadProcessingViewController.h"
#import "DLTabedSlideView.h"
#import <Masonry/Masonry.h>
#import "MemorySizeView.h"
@interface PLVDownloadManagerViewController ()<DLTabedSlideViewDelegate>

@property (nonatomic, strong) DLTabedSlideView *tabedSlideView;

@property (nonatomic, strong) NSArray<UIViewController *> *subViewControllers;

@end

@implementation PLVDownloadManagerViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [EasyLoadingView hidenLoading];
    });
    // Do any additional setup after loading the view.
    self.title = @"我的下载";
    [self initUI];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma init --
- (void)initUI{
    
    [self.view addSubview:self.tabedSlideView];
    self.tabedSlideView.frame = CGRectMake(0, 0, PLV_ScreenWidth, PLV_ScreenHeight - PLV_StatusAndNaviBarHeight-25);
    self.tabedSlideView.backgroundColor = [UIColor whiteColor];
    [self setupTabedSlideView];
    
    MemorySizeView *view = [[MemorySizeView alloc]initWithFrame:CGRectMake(0, screenHeight()-PLV_StatusAndNaviBarHeight-25, screenWidth(), 25)];
    [self.view addSubview:view];
    
    
}

- (void)setupTabedSlideView{
    // setup slide view
    self.tabedSlideView.delegate = self;
    self.tabedSlideView.baseViewController = self;
    self.tabedSlideView.tabbarHeight = 50;
    self.tabedSlideView.tabItemNormalColor = [UIColor blackColor];
    self.tabedSlideView.tabItemSelectedColor = CNavBgColor;
    self.tabedSlideView.tabbarTrackColor = CNavBgColor;
    
    DLTabedbarItem *item0 = [DLTabedbarItem itemWithTitle:@"已下载" image:nil selectedImage:nil];
    DLTabedbarItem *item1 = [DLTabedbarItem itemWithTitle:@"正在下载" image:nil selectedImage:nil];
    self.tabedSlideView.tabbarItems = @[item0, item1];
    self.tabedSlideView.canScroll = NO;
    
    [self.tabedSlideView buildTabbar];
    self.tabedSlideView.selectedIndex = 0;

    UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(0, 49, screenWidth(), 1)];
    lab.backgroundColor = CBackgroundColor;
    [self.tabedSlideView addSubview:lab];
}

#pragma getter --
- (DLTabedSlideView *)tabedSlideView{
    if (!_tabedSlideView){
        _tabedSlideView = [[DLTabedSlideView alloc] init];
    }
    
    return _tabedSlideView;
}

- (NSArray<UIViewController *> *)subViewControllers{
    if (!_subViewControllers){
        
        PLVDownloadCompleteViewController *completeVC = [[PLVDownloadCompleteViewController alloc]init];
        PLVDownloadProcessingViewController *processVC = [[PLVDownloadProcessingViewController alloc]init];
        
        _subViewControllers = @[completeVC, processVC];
    }
    
    return _subViewControllers;
}

#pragma mark -- DLTabedSlideViewDelegate

- (NSInteger)numberOfTabsInDLTabedSlideView:(DLTabedSlideView *)sender{
    return self.subViewControllers.count;
}
- (UIViewController *)DLTabedSlideView:(DLTabedSlideView *)sender controllerAt:(NSInteger)index{
    return self.subViewControllers[index];
}


@end
