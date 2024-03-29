//
//  EnableCashWithdrawalListViewController.m
//  KukeApp
//
//  Created by 库课 on 2019/3/18.
//  Copyright © 2019 KukeZangMing. All rights reserved.
//

#import "EnableCashWithdrawalListViewController.h"
#import "TotalCashWithdrawViewController.h"
#import "DistributionCashWithdrawalListVC.h"
@interface EnableCashWithdrawalListViewController ()<ZMTabPagerControllerDataSource,ZMTabPagerControllerDelegate>

@property (nonatomic, strong) NSArray *datas;

@end

@implementation EnableCashWithdrawalListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"可提现佣金";
    self.view.backgroundColor = [UIColor whiteColor];
    self.datas = [@[@"推广订单",@"自购订单",@"下级分佣",@"提现"] copy];
    self.tabBarHeight = 50;
    self.tabBar.layout.barStyle = ZMPagerBarStyleProgressView;
    self.tabBar.layout.cellWidth = CGRectGetWidth(self.view.frame)/4;
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
    
    if (index == 3) {
        TotalCashWithdrawViewController *vc = [[TotalCashWithdrawViewController alloc]init];
        vc.isHeader = YES;
        return vc;
    }else{
        DistributionCashWithdrawalListVC *VC = [[DistributionCashWithdrawalListVC alloc]init];
        
        
        if (index == 0) {
            VC.type = @"TGDD";
            VC.tab = @"sp";
            VC.status = @"1";
        }else if (index == 1){
            VC.type = @"ZGDD";
            VC.tab = @"in";
            VC.status = @"1";
        }else if (index == 2){
            VC.type = @"XJFY";
            VC.tab = @"sub";
            VC.status = @"1";
        }
        return VC;
    }
    

}

- (NSString *)tabPagerController:(ZMTabPagerController *)tabPagerController titleForIndex:(NSInteger)index {
    NSString *title = _datas[index];
    return title;
}


@end
