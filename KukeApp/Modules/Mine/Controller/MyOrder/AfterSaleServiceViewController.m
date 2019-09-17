//
//  AfterSaleServiceViewController.m
//  KukeApp
//
//  Created by iOSDeveloper on 2018/10/23.
//  Copyright © 2018年 zhangming. All rights reserved.
//

#import "AfterSaleServiceViewController.h"
#import "AfterSaleBaseTableViewController.h"
#import "ReturnGoodsViewController.h"
#import "OrderDetialViewController.h"
#define WindowsSize [UIScreen mainScreen].bounds.size
@interface AfterSaleServiceViewController ()<JXCategoryViewDelegate>{
    
    //八大类的ID
    NSInteger index_id;
}
//滑动控件
@property (nonatomic, strong) JXCategoryTitleView *categoryView;
@property (nonatomic, strong) UIScrollView *scrollView;
//滑动页面个数数组
@property (nonatomic, strong) NSMutableArray <AfterSaleBaseTableViewController *> *listVCArray;

@end

@implementation AfterSaleServiceViewController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO];
    //    [AppUtiles setTabBarHidden:YES];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    index_id = 0;
    self.title = @"售后服务";
    self.view.backgroundColor = [UIColor whiteColor];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    CGFloat naviHeight = 64;
    if (@available(iOS 11.0, *)) {
        if (WindowsSize.height == 812) {
            naviHeight = [UIApplication sharedApplication].keyWindow.safeAreaInsets.top + 44;
        }
    }
    NSArray *titles = [self getRandomTitles];
    NSUInteger count = titles.count;
    CGFloat categoryViewHeight = 50;
    CGFloat width = WindowsSize.width;
    CGFloat height = WindowsSize.height - naviHeight - categoryViewHeight;
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, categoryViewHeight, width, height)];
    self.scrollView.pagingEnabled = YES;
    self.scrollView.contentSize = CGSizeMake(width*count, height);
    [self.view addSubview:self.scrollView];
    
    self.listVCArray = [NSMutableArray array];
    for (int i = 0; i < count; i ++) {
        AfterSaleBaseTableViewController *listVC = [[AfterSaleBaseTableViewController alloc] initWithStyle:UITableViewStylePlain];
        listVC.view.frame = CGRectMake(i*width, 0, width, height);
//        listVC.myBlock = ^(NSString *url) {
            //            HomePageBannerViewController *vc = [[HomePageBannerViewController alloc]init];
            //            vc.url = url;
            //            vc.title = @"资讯详情";
            //            [self.navigationController pushViewController:vc animated:YES];
//        };
        [self.scrollView addSubview:listVC.view];
        [self.listVCArray addObject:listVC];
    }
    
    self.categoryView = [[JXCategoryTitleView alloc] init];
    self.categoryView.frame = CGRectMake(0, 0, WindowsSize.width, categoryViewHeight);
    self.categoryView.delegate = self;
    self.categoryView.contentScrollView = self.scrollView;
    self.categoryView.titles = titles;
    self.categoryView.titleViewLineEnabled = NO;
    self.categoryView.titleFont = [UIFont systemFontOfSize:15];
    JXCategoryIndicatorLineView *lineView = [[JXCategoryIndicatorLineView alloc] init];
    self.categoryView.indicators = @[lineView];
    lineView.indicatorLineViewHeight = 2;
    lineView.indicatorLineWidth = screenWidth()/2;
    [self.view addSubview:self.categoryView];
    
    [self.listVCArray[index_id] loadData:index_id];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(myOrderDetail:) name:@"MyAfterSaleDetail" object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(afterSale:) name:@"AfterSale" object:nil];
    
}
- (void)myOrderDetail:(NSNotification *)noti
{
//    OrderDetialViewController *vc = [[OrderDetialViewController alloc]init];
//    vc.orderID = noti.object[@"AfterSaleOrder_sn"];
//    [self.navigationController pushViewController:vc animated:YES];
    
    
}
#pragma mark ————— 类型数组初始化 --———
- (NSArray <NSString *> *)getRandomTitles {
    NSMutableArray *titles = @[@"申请退款",@"售后记录"].mutableCopy;
    
    return titles;
}

#pragma mark - JXCategoryViewDelegate

- (void)categoryView:(JXCategoryBaseView *)categoryView didSelectedItemAtIndex:(NSInteger)index {
    [self.scrollView setContentOffset:CGPointMake(self.scrollView.bounds.size.width*index, 0) animated:YES];
    //侧滑手势处理
    self.navigationController.interactivePopGestureRecognizer.enabled = (index == 0);
    [self.listVCArray[index] loadData:index ];
    
}
- (void)afterSale:(NSNotification *)noti
{
    ReturnGoodsViewController *vc = [[ReturnGoodsViewController alloc]init];
    vc.orderData = noti.object[@"Order_data"];
    [self.navigationController pushViewController:vc animated:YES];
    
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
