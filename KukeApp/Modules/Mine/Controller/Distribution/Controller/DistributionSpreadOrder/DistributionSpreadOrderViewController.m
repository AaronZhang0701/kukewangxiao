//
//  DistributionSpreadOrderViewController.m
//  KukeApp
//
//  Created by 库课 on 2019/3/20.
//  Copyright © 2019 KukeZangMing. All rights reserved.
//

#import "DistributionSpreadOrderViewController.h"
#import "DistributionCashWithdrawalListVC.h"
@interface DistributionSpreadOrderViewController ()<ZMTabPagerControllerDataSource,ZMTabPagerControllerDelegate>

@property (nonatomic, strong) NSArray *datas;

@end

@implementation DistributionSpreadOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"推广订单";
    self.view.backgroundColor = [UIColor whiteColor];
    self.datas = [@[@"推广订单",@"自购订单"] copy];
    self.tabBarHeight = 50;
    self.tabBar.layout.barStyle = ZMPagerBarStyleProgressView;
    self.tabBar.layout.cellWidth = CGRectGetWidth(self.view.frame)/2;
    self.tabBar.layout.cellSpacing = 0;
    self.tabBar.layout.cellEdging = 0;
    self.tabBar.layout.adjustContentCellsCenter = YES;
    self.dataSource = self;
    self.delegate = self;
    [self scrollToControllerAtIndex:0 animate:YES];
    
    [self reloadData];
    
}
#pragma mark - TYTabPagerControllerDataSource

- (NSInteger)numberOfControllersInTabPagerController {
    return _datas.count;
}

- (UIViewController *)tabPagerController:(ZMTabPagerController *)tabPagerController controllerForIndex:(NSInteger)index prefetching:(BOOL)prefetching {
    
    DistributionCashWithdrawalListVC *VC = [[DistributionCashWithdrawalListVC alloc]init];
    VC.type = @"TGDD";

    if (index == 0) {
    
        VC.tab = @"sp";
    }else{

        VC.tab = @"in";
    }
    return VC;
    
}
- (void)tabPagerController:(ZMTabPagerController *)tabPagerController didSelectTabBarItemAtIndex:(NSInteger)index{
    NSLog(@"sada");
}

// scrolling
- (void)tabPagerControllerWillBeginScrolling:(ZMTabPagerController *)tabPagerController animate:(BOOL)animate{
    NSLog(@"sada");
}
- (void)tabPagerControllerDidEndScrolling:(ZMTabPagerController *)tabPagerController animate:(BOOL)animate{
    NSLog(@"sada");
}
- (NSString *)tabPagerController:(ZMTabPagerController *)tabPagerController titleForIndex:(NSInteger)index {
    NSString *title = _datas[index];
    return title;
}
@end
