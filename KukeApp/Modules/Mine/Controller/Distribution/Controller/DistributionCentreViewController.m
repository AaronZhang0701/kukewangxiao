//
//  DistributionCentreViewController.m
//  KukeApp
//
//  Created by 库课 on 2019/3/14.
//  Copyright © 2019 KukeZangMing. All rights reserved.
//

#import "DistributionCentreViewController.h"
#import "DistributionCentreHeaderView.h"
#import "SPPageMenu.h"
#import "DistributionCentreListViewController.h"
#import "DistributionFourViewController.h"
#import "DistributionFiveViewController.h"
#import "DistributionFirstViewController.h"
#import "DistributionSecondViewController.h"
#import "DistributionThirdViewController.h"
#import "DistributionTableView.h"
#import "DistributionBaseViewController.h"
#import "CourseDetailViewController.h"
#import "MineViewController.h"
@interface DistributionCentreViewController  ()<SPPageMenuDelegate,UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) DistributionTableView *tableView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) DistributionCentreHeaderView *headerView;

@property (nonatomic, strong) SPPageMenu *pageMenu;
@property (nonatomic, assign) CGPoint lastPoint;

@property (nonatomic, assign) BOOL headerScrollViewScrolling;
@property (nonatomic, strong) UIScrollView *childVCScrollView;

@property (nonatomic, assign) BOOL other;


@property (nonatomic, strong) NSArray *datas;

@end

@implementation DistributionCentreViewController


- (BOOL)navigationShouldPopOnBackButton{
    
    [self.navigationController popToRootViewControllerAnimated:YES];
//    for (UIViewController *temp in self.navigationController.viewControllers) {
//        if ([temp isKindOfClass:[CourseDetailViewController class]] || [temp isKindOfClass:[MineViewController class]]) {
//            [self.navigationController popToViewController:temp animated:YES];
//        }
//    }
    return NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.translucent = NO;
    
    [self.view addSubview:self.tableView];
    if (!self.isEnable) {
        self.headerView.isEnable = self.isEnable;
        [BaseTools showErrorMessage:@"分销员资格已经被禁用"];
    }else{
        self.headerView.isEnable = YES;
    }
    // 添加4个子控制器
    DistributionFirstViewController *vc1 = [[DistributionFirstViewController alloc]init];
    vc1.isEnable = self.isEnable;
    DistributionSecondViewController *vc2 = [[DistributionSecondViewController alloc]init];
    vc2.isEnable = self.isEnable;
    DistributionThirdViewController *vc3 = [[DistributionThirdViewController alloc]init];
    vc3.isEnable = self.isEnable;
    DistributionFourViewController *vc4 = [[DistributionFourViewController alloc]init];
    vc4.isEnable = self.isEnable;
    DistributionFiveViewController *vc5 = [[DistributionFiveViewController alloc]init];
    vc5.isEnable = self.isEnable;
    
    [self addChildViewController:vc1];
    [self addChildViewController:vc2];
    [self addChildViewController:vc3];
    [self addChildViewController:vc4];
    [self addChildViewController:vc5];
    
    // 先将第一个子控制的view添加到scrollView上去
    [self.scrollView addSubview:self.childViewControllers[0].view];
    

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadData) name:@"DistributionMianLoadData" object:nil];
    // 监听子控制器发出的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(subTableViewDidScroll:) name:@"SubTableViewDidScroll" object:nil];
    
//    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//        // 下拉刷新
//        [self downPullUpdateData];
//    }];
    
    self.tableView.tg_header = [TGRefreshOC  refreshWithTarget:self action:@selector(downPullUpdateData) config:nil];
    

}

- (void)loadData{
    [ZMNetworkHelper POST:@"/distribution/index" parameters:nil cache:NO responseCache:^(id responseCache) {
        
    } success:^(id responseObject) {
        if (responseObject == nil) {
            
        }else{
            if ([responseObject[@"code"] isEqualToString:@"0"]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    // 添加头部视图
                    self.tableView.tableHeaderView = self.headerView;
                    self.headerView.userName.text = responseObject[@"data"][@"mobile"];
                    [self.headerView.headerImage sd_setImageWithURL:[NSURL URLWithString:responseObject[@"data"][@"avatar"]] placeholderImage:[UIImage imageNamed:@"个人中心未登录头像"]];
                    self.headerView.positionLab.text = responseObject[@"data"][@"dist_type_name"];
                    [self.headerView.ranksImage sd_setImageWithURL:[NSURL URLWithString:responseObject[@"data"][@"dist_level_img"]]];
//                    self.headerView.ranksLab.text = responseObject[@"data"][@"dist_level_name"];
//                    if ([responseObject[@"data"][@"dist_level"] isEqualToString:@"1"]) {
//                        self.headerView.ranksImage.image = [UIImage imageNamed:@"普通分销员背景"];
//                    }else if ([responseObject[@"data"][@"dist_level"] isEqualToString:@"2"]) {
//                        self.headerView.ranksImage.image = [UIImage imageNamed:@"中级分销员背景"];
//                    }else if ([responseObject[@"data"][@"dist_level"] isEqualToString:@"3"]) {
//                        self.headerView.ranksImage.image = [UIImage imageNamed:@"高级分销员背景"];
//                    }else{
//                        self.headerView.ranksLab.hidden = YES;
//                        self.headerView.ranksImage.hidden = YES;
//                    }
                    
                    NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"¥%@",responseObject[@"data"][@"brokerage_balance"]]];
                    [attributeStr addAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:20]} range:NSMakeRange(0, 1)];
                    self.headerView.availableMoney.attributedText = attributeStr;
                    [self.headerView.totalMoney setTitle:[NSString stringWithFormat:@"总计收益：¥%@",responseObject[@"data"][@"brokerage_total"]] forState:(UIControlStateNormal)];
                    [self.headerView.waitMoney setTitle:[NSString stringWithFormat:@"待结算收益：¥%@",responseObject[@"data"][@"brokerage_unpaid"]] forState:(UIControlStateNormal)];
                    
                    NSMutableAttributedString *attributeStr1 = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"¥%@",responseObject[@"data"][@"order_total"]]];
                    [attributeStr1 addAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:13]} range:NSMakeRange(0, 1)];
                    self.headerView.spreadLab.attributedText = attributeStr1;
                    self.headerView.totalRequest.text = responseObject[@"data"][@"invite_total"];
                    [self.tableView reloadData];
                });
                
            }else{
                
                [BaseTools showErrorMessage:responseObject[@"msg"]];
            }
        }
    } failure:^(NSError *error) {
        
        
    }];
}

// 下拉刷新
- (void)downPullUpdateData {
    
    [self loadData];
    // 模拟网络请求，1秒后结束刷新
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tableView.tg_header endRefreshing];
//        //                            self.tableView.tg_header.refreshResultStr = @"数据刷新成功";
    });
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    }
    // 添加分页菜单
    [cell.contentView addSubview:self.pageMenu];
    [cell.contentView addSubview:self.scrollView];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return screenHeight();
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.tableView == scrollView) {
        if ((self.childVCScrollView && _childVCScrollView.contentOffset.y > 0) || (scrollView.contentOffset.y > HeaderViewH)) {
            self.tableView.contentOffset = CGPointMake(0, HeaderViewH);
        }
        CGFloat offSetY = scrollView.contentOffset.y;
        
        if (offSetY < HeaderViewH) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"headerViewToTop" object:nil];
        }
    } else if (scrollView == self.scrollView) {
        
    }
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
}

- (void)subTableViewDidScroll:(NSNotification *)noti {
    UIScrollView *scrollView = noti.object;
    self.childVCScrollView = scrollView;
    if (self.tableView.contentOffset.y < HeaderViewH) {
        scrollView.contentOffset = CGPointZero;
        scrollView.showsVerticalScrollIndicator = NO;
        
    } else {
        //        self.tableView.contentOffset = CGPointMake(0, HeaderViewH);
        scrollView.showsVerticalScrollIndicator = YES;
    }
}


#pragma mark - SPPageMenuDelegate
- (void)pageMenu:(SPPageMenu *)pageMenu itemSelectedFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex {
    if (!self.childViewControllers.count) { return;}
    // 如果上一次点击的button下标与当前点击的buton下标之差大于等于2,说明跨界面移动了,此时不动画.
    if (labs(toIndex - fromIndex) >= 2) {
        [self.scrollView setContentOffset:CGPointMake(_scrollView.frame.size.width * toIndex, 0) animated:NO];
    } else {
        [self.scrollView setContentOffset:CGPointMake(_scrollView.frame.size.width * toIndex, 0) animated:YES];
    }
    
    UIViewController *targetViewController = self.childViewControllers[toIndex];
    // 如果已经加载过，就不再加载
    if ([targetViewController isViewLoaded]) return;
    
    targetViewController.view.frame = CGRectMake(screenWidth()*toIndex, 0, screenWidth(), screenHeight()-insert);
    UIScrollView *s = targetViewController.view.subviews[0];
    CGPoint contentOffset = s.contentOffset;
    if (contentOffset.y >= HeaderViewH) {
        contentOffset.y = HeaderViewH;
    }
    s.contentOffset = contentOffset;
    [self.scrollView addSubview:targetViewController.view];
}

- (UIScrollView *)scrollView {
    
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.frame = CGRectMake(0, PageMenuH, screenWidth(), screenHeight()-UI_navBar_Height-50);
        _scrollView.delegate = self;
        _scrollView.pagingEnabled = YES;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.contentSize = CGSizeMake(screenWidth()*5, 0);
        _scrollView.backgroundColor = [UIColor colorWithWhite:1 alpha:0];
    }
    return _scrollView;
}

- (DistributionTableView *)tableView {
    
    if (!_tableView) {
        _tableView = [[DistributionTableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.showsVerticalScrollIndicator = NO;
        //_tableView.sectionHeaderHeight = PageMenuH;
    }
    return _tableView;
}


- (DistributionCentreHeaderView *)headerView {
    
    if (!_headerView) {
        _headerView = [[DistributionCentreHeaderView alloc] initWithFrame:CGRectMake(0, 0, screenWidth(), HeaderViewH)];
        

    }
    return _headerView;
}


- (SPPageMenu *)pageMenu {
    
    if (!_pageMenu) {
        _pageMenu = [SPPageMenu pageMenuWithFrame:CGRectMake(0, 0, screenWidth(), PageMenuH) trackerStyle:SPPageMenuTrackerStyleLine];
        [_pageMenu setItems:@[@"全部",@"推广订单",@"自购订单",@"下级分佣",@"提现"] selectedItemIndex:0];
  
        _pageMenu.delegate = self;
        _pageMenu.unSelectedItemTitleColor = [UIColor blackColor];
        _pageMenu.itemTitleFont = [UIFont systemFontOfSize:13];
        _pageMenu.selectedItemTitleColor = CNavBgColor;
        _pageMenu.tracker.backgroundColor = CNavBgColor;
        _pageMenu.itemPadding = 0;
        _pageMenu.permutationWay = SPPageMenuPermutationWayNotScrollEqualWidths;
        _pageMenu.bridgeScrollView = self.scrollView;
    }
    return _pageMenu;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
     [self loadData];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}


@end
