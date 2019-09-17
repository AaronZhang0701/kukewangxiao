//
//  MyPurchasedCourseViewController.m
//  KukeApp
//
//  Created by 库课 on 2019/7/18.
//  Copyright © 2019 KukeZangMing. All rights reserved.
//

#import "MyPurchasedCourseViewController.h"
#import "ZMTabPagerBar.h"
#import "TYPagerController.h"
#import "MyPurchasedCourseChildrenVC.h"
@interface MyPurchasedCourseViewController ()<ZMTabPagerBarDataSource,ZMTabPagerBarDelegate,TYPagerControllerDataSource,TYPagerControllerDelegate>
@property (nonatomic, weak) ZMTabPagerBar *tabBar;
@property (nonatomic, weak) TYPagerController *pagerController;
@property (nonatomic, strong) NSArray *datas;
@property (nonatomic, strong)MyPurchasedCourseChildrenVC *VC1;
@property (nonatomic, strong)MyPurchasedCourseChildrenVC *VC2;
@end

@implementation MyPurchasedCourseViewController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO];
    //    [self.tableView.mj_header beginRefreshing];
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"已购课程";
    self.view.backgroundColor = [UIColor whiteColor];
    [self addTabPageBar];
    
    [self addPagerController];
    
    [self loadData];
    // Do any additional setup after loading the view.
}

- (void)addTabPageBar {
    ZMTabPagerBar *tabBar = [[ZMTabPagerBar alloc]init];
    tabBar.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 50);
    tabBar.dataSource = self;
    tabBar.delegate = self;
    tabBar.layout.progressHeight = 3;
    tabBar.layout.barStyle = ZMPagerBarStyleProgressView;
    tabBar.layout.cellSpacing = 0;
    tabBar.layout.cellEdging = 0;
    tabBar.layout.adjustContentCellsCenter = YES;
    tabBar.layout.cellWidth = CGRectGetWidth(self.view.frame)/2;
    tabBar.layout.progressColor = CNavBgColor;
    tabBar.layout.normalTextFont = [UIFont systemFontOfSize:15];
    tabBar.layout.selectedTextFont = [UIFont systemFontOfSize:17];
    tabBar.layout.normalTextColor = [UIColor colorWithRed:73/255.0 green:73/255.0 blue:73/255.0 alpha:1];
    tabBar.layout.selectedTextColor = CNavBgColor;
    [tabBar registerClass:[ZMTabPagerBarCell class] forCellWithReuseIdentifier:[ZMTabPagerBarCell cellIdentifier]];
    [self.view addSubview:tabBar];
    _tabBar = tabBar;
    
    UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(0, 49, screenWidth(), 1)];
    line.backgroundColor = CBackgroundColor;
    [tabBar addSubview:line];
    
}

- (void)addPagerController {
    TYPagerController *pagerController = [[TYPagerController alloc]init];
    pagerController.view.frame = CGRectMake(0, CGRectGetMaxY(_tabBar.frame), screenWidth(), CGRectGetHeight(self.view.frame)- CGRectGetMaxY(_tabBar.frame));
    pagerController.layout.prefetchItemCount = 1;
    //pagerController.layout.autoMemoryCache = NO;
    // 只有当scroll滚动动画停止时才加载pagerview，用于优化滚动时性能
    pagerController.layout.addVisibleItemOnlyWhenScrollAnimatedEnd = YES;
    pagerController.dataSource = self;
    pagerController.delegate = self;
    [self addChildViewController:pagerController];
    [self.view addSubview:pagerController.view];
    _pagerController = pagerController;
    
    
    
}



- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
}

- (void)loadData {
    NSArray *datas = @[@"录播课",@"直播课"];
    
    _datas = [datas copy];
    
    [self reloadData];
}

#pragma mark - TYTabPagerBarDataSource

- (NSInteger)numberOfItemsInPagerTabBar {
    return _datas.count;
}

- (UICollectionViewCell<ZMTabPagerBarCellProtocol> *)pagerTabBar:(ZMTabPagerBar *)pagerTabBar cellForItemAtIndex:(NSInteger)index {
    UICollectionViewCell<ZMTabPagerBarCellProtocol> *cell = [pagerTabBar dequeueReusableCellWithReuseIdentifier:[ZMTabPagerBarCell cellIdentifier] forIndex:index];
    cell.titleLabel.text = _datas[index];
    return cell;
}

#pragma mark - TYTabPagerBarDelegate

- (CGFloat)pagerTabBar:(ZMTabPagerBar *)pagerTabBar widthForItemAtIndex:(NSInteger)index {
    NSString *title = _datas[index];
    return [pagerTabBar cellWidthForTitle:title];
}

- (void)pagerTabBar:(ZMTabPagerBar *)pagerTabBar didSelectItemAtIndex:(NSInteger)index {
    [_pagerController scrollToControllerAtIndex:index animate:YES];
}

#pragma mark - TYPagerControllerDataSource

- (NSInteger)numberOfControllersInPagerController {
    return self.datas.count;
}

- (UIViewController *)pagerController:(TYPagerController *)pagerController controllerForIndex:(NSInteger)index prefetching:(BOOL)prefetching {
    
    switch (index) {
            case 0:{
                MyPurchasedCourseChildrenVC *VC = [[MyPurchasedCourseChildrenVC alloc]init];
                VC.cate_id = @"2";
                self.VC1 = VC;
                return VC;
            };
            break;
            case 1:{
                MyPurchasedCourseChildrenVC *VC = [[MyPurchasedCourseChildrenVC alloc]init];
                VC.cate_id = @"1";
                self.VC2 = VC;
                return VC;
            };
            break;
            
        default:
        {
            MyPurchasedCourseChildrenVC *VC = [[MyPurchasedCourseChildrenVC alloc]init];
            VC.cate_id = @"1";
            self.VC1 = VC;
            return VC;
        };
            break;
    }
}

#pragma mark - TYPagerControllerDelegate

- (void)pagerController:(TYPagerController *)pagerController transitionFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex animated:(BOOL)animated {
    
    
//    if (toIndex == 1) {
//        self.VC1.cate_id = @"1";
//    }else if (toIndex == 2){
//        self.VC2.cate_id = @"2";
//    }
    
    
    
    [_tabBar scrollToItemFromIndex:fromIndex toIndex:toIndex animate:animated];
    
}

-(void)pagerController:(TYPagerController *)pagerController transitionFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex progress:(CGFloat)progress {
    [_tabBar scrollToItemFromIndex:fromIndex toIndex:toIndex progress:progress];
}

- (void)reloadData {
    [_tabBar reloadData];
    [_pagerController reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
