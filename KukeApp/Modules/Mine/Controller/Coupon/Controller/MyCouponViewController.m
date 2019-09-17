//
//  MyCouponViewController.m
//  KukeApp
//
//  Created by iOSDeveloper on 2018/12/11.
//  Copyright © 2018年 zhangming. All rights reserved.
//

#import "MyCouponViewController.h"

#import "CanUseCouponController.h"

#import "XLPageViewController.h"
@interface MyCouponViewController ()<XLPageViewControllerDelegate,XLPageViewControllerDataSrouce>
@property (nonatomic, strong) XLPageViewController *pageViewController;
//标题组
@property (nonatomic, strong) NSArray *titles;

@property (nonatomic, strong) NSMutableArray *cateIDs;
//配置信息
@property (nonatomic, strong) XLPageViewControllerConfig *config;

@property (nonatomic, strong) CanUseCouponController *oneVC;

@end

@implementation MyCouponViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"卡券";
    self.view.backgroundColor = [UIColor whiteColor];

    self.titles = @[@"待使用",@"已使用",@"已过期"];
    
    [self initPageViewController];
}
- (void)initPageViewController {
    self.config = [XLPageViewControllerConfig defaultConfig];
    

    self.config.titleViewHeight = 50;
    
    self.config.titleSpace = 0;
    self.config.titleWidth = self.view.bounds.size.width/self.titles.count;
    self.config.shadowLineWidth = self.view.bounds.size.width/self.titles.count;
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
    CanUseCouponController *vc = [[CanUseCouponController alloc] init];

    
    vc.type = [NSString stringWithFormat:@"%ld",index];
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
