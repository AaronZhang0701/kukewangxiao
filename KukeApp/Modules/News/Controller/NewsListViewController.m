//
//  NewsListViewController.m
//  KukeApp
//
//  Created by 库课 on 2019/5/13.
//  Copyright © 2019 KukeZangMing. All rights reserved.
//

#import "NewsListViewController.h"
#import "ZMTabPagerBar.h"
#import "TYPagerController.h"
#import "NewsChildrenListVC.h"
@interface NewsListViewController ()<ZMTabPagerBarDataSource,ZMTabPagerBarDelegate,TYPagerControllerDataSource,TYPagerControllerDelegate>{

    CGFloat oldY;
}

@property (nonatomic, weak) ZMTabPagerBar *tabBar;
@property (nonatomic, weak) TYPagerController *pagerController;
@property (nonatomic, strong) NSArray *datas;
@property (nonatomic, strong)NewsChildrenListVC *VC1;
@property (nonatomic, strong)NewsChildrenListVC *VC2;
@property (nonatomic, strong)NewsChildrenListVC *VC3;
@end

@implementation NewsListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stopScroll) name:@"NewsListStopScroll" object:nil];
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(upLoadUI:) name:@"NewsListOffSet" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushAction:) name:@"Push_News" object:nil];
    
    [self addTabPageBar];
    
    [self addPagerController];
    
    [self loadData];
}
- (void)pushAction:(NSNotification *)noti{

        if ([noti.object[@"id"] length] != 0 ) {
            if ([noti.object[@"id"] isEqualToString:@"2"]) {
                [_pagerController scrollToControllerAtIndex:2 animate:YES];
                self.VC3.push_oid = noti.object[@"oid"];
            }else if ([noti.object[@"id"] isEqualToString:@"3"]){
                [_pagerController scrollToControllerAtIndex:1 animate:YES];
                self.VC2.push_oid = noti.object[@"oid"];
            }else{
                [_pagerController scrollToControllerAtIndex:[noti.object[@"id"] integerValue]-1 animate:YES];
                self.VC1.push_oid = noti.object[@"oid"];
            }

        }

}
- (void)upLoadUI:(NSNotification *)noti
{
    
    CGFloat offsetY = [noti.object[@"CollectionOffSet"] floatValue];
    
    if (offsetY> oldY && offsetY > 0) {//如果当前位移大于缓存位移，说明scrollView向上滑动
        [UIView transitionWithView:_tabBar duration:0.3 options:UIViewAnimationOptionTransitionNone animations:^{
            self.tabBar.frame = CGRectMake(0, -44, screenWidth(), 44);
        } completion:NULL];
        [UIView transitionWithView:self.pagerController.view duration:0.3 options:UIViewAnimationOptionTransitionNone animations:^{
//            self.headerBtnView.frame = CGRectMake(0, -47, screenWidth(), 47);
            _pagerController.view.frame = CGRectMake(0, PLV_StatusBarHeight, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)- CGRectGetMaxY(_tabBar.frame));
        } completion:NULL];
        
        
    }else if (offsetY < oldY){
        [UIView transitionWithView:self.tabBar duration:0.3 options:UIViewAnimationOptionTransitionNone animations:^{
            self.tabBar.frame = CGRectMake(0, PLV_StatusBarHeight, screenWidth(), 44);
        } completion:NULL];
        
        [UIView transitionWithView:self.pagerController.view duration:0.3 options:UIViewAnimationOptionTransitionNone animations:^{
//            self.headerBtnView.frame = CGRectMake(0, maxY(_tabBar), screenWidth(), 47);
            _pagerController.view.frame = CGRectMake(0, CGRectGetMaxY(_tabBar.frame), CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)- CGRectGetMaxY(_tabBar.frame));
        } completion:NULL];
        
    }
    
    
    oldY = offsetY;//将当前位移变成缓存位移
    
}



- (void)addTabPageBar {
    ZMTabPagerBar *tabBar = [[ZMTabPagerBar alloc]init];
    tabBar.frame = CGRectMake(0, PLV_StatusBarHeight, CGRectGetWidth(self.view.frame), 44);
    tabBar.dataSource = self;
    tabBar.delegate = self;
    tabBar.layout.progressHeight = 3;
    tabBar.layout.barStyle = ZMPagerBarStyleProgressView;
    tabBar.layout.cellSpacing = 0;
    tabBar.layout.cellEdging = 0;
    tabBar.layout.adjustContentCellsCenter = YES;
    tabBar.layout.cellWidth = CGRectGetWidth(self.view.frame)/3;
    tabBar.layout.progressColor = CNavBgColor;
    tabBar.layout.normalTextFont = [UIFont systemFontOfSize:15];
    tabBar.layout.selectedTextFont = [UIFont systemFontOfSize:17];
    tabBar.layout.normalTextColor = [UIColor colorWithRed:73/255.0 green:73/255.0 blue:73/255.0 alpha:1];
    tabBar.layout.selectedTextColor = CNavBgColor;
    [tabBar registerClass:[ZMTabPagerBarCell class] forCellWithReuseIdentifier:[ZMTabPagerBarCell cellIdentifier]];
    [self.view addSubview:tabBar];
    _tabBar = tabBar;
    
    UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(0, 43, screenWidth(), 1)];
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
 
//    if ([[UserDefaultsUtils valueWithKey:@"CateID"] isEqualToString:@"2"]) {
//        [_pagerController scrollToControllerAtIndex:2 animate:YES];
//    }else if ([[UserDefaultsUtils valueWithKey:@"CateID"] isEqualToString:@"3"]){
//        [_pagerController scrollToControllerAtIndex:1 animate:YES];
//    }else{
//        [_pagerController scrollToControllerAtIndex:[[UserDefaultsUtils valueWithKey:@"CateID"] integerValue]-1 animate:YES];
//    }
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
}

- (void)loadData {
    NSArray *datas = @[@"专升本",@"教师招聘",@"教师资格"];
    
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
            NewsChildrenListVC *VC = [[NewsChildrenListVC alloc]init];
            VC.news_cate_id = @"1";
            self.VC1 = VC;
            return VC;
        };
            break;
        case 1:{
            NewsChildrenListVC *VC = [[NewsChildrenListVC alloc]init];
            VC.news_cate_id = @"3";
            self.VC2 = VC;
            return VC;
        };
            break;
        case 2:{
            NewsChildrenListVC *VC = [[NewsChildrenListVC alloc]init];
            VC.news_cate_id = @"2";
            self.VC3 = VC;
            return VC;
        };
            break;
        default:
        {
            NewsChildrenListVC *VC = [[NewsChildrenListVC alloc]init];
            VC.news_cate_id = @"2";
            self.VC3 = VC;
            return VC;
        };
            break;
    }
}

#pragma mark - TYPagerControllerDelegate

- (void)pagerController:(TYPagerController *)pagerController transitionFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex animated:(BOOL)animated {
    

    if (toIndex == 1) {
        self.VC1.news_cate_id = @"1";
    }else if (toIndex == 2){
       self.VC2.news_cate_id = @"3";
    }else{
       self.VC3.news_cate_id = @"2";
    }

    
    [_tabBar scrollToItemFromIndex:fromIndex toIndex:toIndex animate:animated];
 
}

-(void)pagerController:(TYPagerController *)pagerController transitionFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex progress:(CGFloat)progress {
    [_tabBar scrollToItemFromIndex:fromIndex toIndex:toIndex progress:progress];
}

- (void)reloadData {
    [_tabBar reloadData];
    [_pagerController reloadData];
}
- (void)stopScroll{
//    [UIView transitionWithView:self.tabBar duration:0.3 options:UIViewAnimationOptionTransitionNone animations:^{
//        self.tabBar.frame = CGRectMake(0, PLV_StatusBarHeight, screenWidth(), 44);
//    } completion:NULL];
//    
//    [UIView transitionWithView:self.pagerController.view duration:0.3 options:UIViewAnimationOptionTransitionNone animations:^{
//        //            self.headerBtnView.frame = CGRectMake(0, maxY(_tabBar), screenWidth(), 47);
//        _pagerController.view.frame = CGRectMake(0, CGRectGetMaxY(_tabBar.frame), CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)- CGRectGetMaxY(_tabBar.frame));
//    } completion:NULL];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
