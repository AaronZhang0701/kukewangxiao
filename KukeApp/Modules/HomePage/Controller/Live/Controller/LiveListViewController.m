//
//  LiveListViewController.m
//  KukeApp
//
//  Created by 库课 on 2019/7/17.
//  Copyright © 2019 KukeZangMing. All rights reserved.
//

#import "LiveListViewController.h"
#import "ZMTabPagerBar.h"
#import "TYPagerController.h"
#import "LiveListChildrenViewController.h"
@interface LiveListViewController ()<ZMTabPagerBarDataSource,ZMTabPagerBarDelegate,TYPagerControllerDataSource,TYPagerControllerDelegate>{
    CGFloat oldY;
    BOOL isSrollToTop;
    NSInteger pageIndex;
}
@property (nonatomic, weak) ZMTabPagerBar *tabBar;
@property (nonatomic, weak) TYPagerController *pagerController;
@property (nonatomic, strong) NSArray *datas;
@property (nonatomic, strong) LiveListChildrenViewController *VC1;
@property (nonatomic, strong) LiveListChildrenViewController *VC2;
@property (nonatomic, strong) LiveListChildrenViewController *VC3;
@property (nonatomic, strong) UIView *navView;
@end

@implementation LiveListViewController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];

}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"直播课";
    self.view.backgroundColor = [UIColor whiteColor];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stopScroll) name:@"LiveListStopScroll" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(upLoadUI:) name:@"LiveListOffSet" object:nil];
     [self addNav];

    // Do any additional setup after loading the view.
}
- (void)addNav{
    
    
    self.navView = [[UIView alloc]init];
    self.navView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.navView];
    
    
    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake(80,UI_navBar_Height-34,screenWidth()-160,20);
    label.numberOfLines = 0;
    label.font = [UIFont systemFontOfSize:18];
    label.textColor = CTitleColor;
    label.textAlignment = NSTextAlignmentCenter;
    [self.navView addSubview:label];
    label.text = @"直播课";
    
    UILabel *lineLab = [[UILabel alloc]initWithFrame:CGRectMake(0, UI_navBar_Height-1, screenWidth(), 1)];
    lineLab.backgroundColor = CBackgroundColor;
    [self.navView addSubview:lineLab];
    
    
    UIButton *backBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    backBtn.frame = CGRectMake(10, UI_navBar_Height-34, 20, 20);
    [backBtn setImage:[UIImage imageNamed:@"导航栏返回"] forState:(UIControlStateNormal)];
    [backBtn addTarget:self action:@selector(back) forControlEvents:(UIControlEventTouchUpInside)];
    [self.navView addSubview:backBtn];
    
    [self.navView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.width.left.right.mas_equalTo(0);
        make.height.mas_equalTo(UI_navBar_Height);
    }];

    [self addTabPageBar];
    
    [self addPagerController];
    
    [self loadData];
}

- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)addTabPageBar {
    ZMTabPagerBar *tabBar = [[ZMTabPagerBar alloc]init];
//    tabBar.frame = CGRectMake(0, UI_navBar_Height, CGRectGetWidth(self.view.frame), 50);
    tabBar.backgroundColor = [UIColor whiteColor];
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
    
    
    [_tabBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navView.mas_bottom);
        make.width.left.right.equalTo(self.view);
        make.height.mas_equalTo(50);
    }];
    UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(0, 49, screenWidth(), 1)];
    line.backgroundColor = CBackgroundColor;
    [tabBar addSubview:line];
}

- (void)addPagerController {
    TYPagerController *pagerController = [[TYPagerController alloc]init];
//    pagerController.view.frame = CGRectMake(0, 50+UI_navBar_Height, screenWidth(), screenHeight()-50-UI_navBar_Height);
    pagerController.layout.prefetchItemCount = 1;
    //pagerController.layout.autoMemoryCache = NO;
    // 只有当scroll滚动动画停止时才加载pagerview，用于优化滚动时性能
//    pagerController.layout.addVisibleItemOnlyWhenScrollAnimatedEnd = YES;
    pagerController.dataSource = self;
    pagerController.delegate = self;
    [self addChildViewController:pagerController];
    [self.view addSubview:pagerController.view];
    _pagerController = pagerController;
    [_pagerController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tabBar.mas_bottom);
        make.width.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
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
                LiveListChildrenViewController *VC1 = [[LiveListChildrenViewController alloc]init];
                VC1.live_cate_id = @"1";
                self.VC1 = VC1;
                return VC1;
            };
            break;
            case 1:{
                LiveListChildrenViewController *VC2 = [[LiveListChildrenViewController alloc]init];
                VC2.live_cate_id = @"3";
                self.VC2 = VC2;
                return VC2;
            };
            break;
            case 2:{
                LiveListChildrenViewController *VC3 = [[LiveListChildrenViewController alloc]init];
                VC3.live_cate_id = @"2";
                self.VC3 = VC3;
                return VC3;
            };
            break;
        default:
        {
            LiveListChildrenViewController *VC1 = [[LiveListChildrenViewController alloc]init];
            VC1.live_cate_id = @"1";
            self.VC1 = VC1;
            return VC1;
        };
            break;
    }
}

#pragma mark - TYPagerControllerDelegate

- (void)pagerController:(TYPagerController *)pagerController transitionFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex animated:(BOOL)animated {

    pageIndex = toIndex;
    if (toIndex == 1) {
        self.VC1.live_cate_id = @"1";
    }else if (toIndex == 2){
        self.VC2.live_cate_id = @"3";
    }else{
        self.VC3.live_cate_id = @"2";
    }

    [_tabBar scrollToItemFromIndex:fromIndex toIndex:toIndex animate:animated];
    
}

-(void)pagerController:(TYPagerController *)pagerController transitionFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex progress:(CGFloat)progress {
     pageIndex = toIndex;
    [_tabBar scrollToItemFromIndex:fromIndex toIndex:toIndex progress:progress];
}

- (void)reloadData {
    [_tabBar reloadData];
    [_pagerController reloadData];
}
- (void)stopScroll{
    if (isSrollToTop) {
        [self.navView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view);
        }];

        [UIView animateWithDuration:0.3 animations:^{
            [self.view layoutIfNeeded];
        }];

    }
}
- (void)upLoadUI:(NSNotification *)noti
{
    
    CGFloat offsetY = [noti.object[@"CollectionOffSet"] floatValue];
    
    if (offsetY> oldY && offsetY > 0) {//如果当前位移大于缓存位移，说明scrollView向上滑动
        isSrollToTop = YES;
        
        [self.navView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view).offset(-UI_navBar_Height-50);
        }];
        [self.tabBar mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.bottom.equalTo(self.tabBar);
        }];
        [self.pagerController.view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.bottom.equalTo(self.pagerController.view);
        }];

        [UIView animateWithDuration:0.3 animations:^{
            [self.view layoutIfNeeded];
        }];

    }else if (offsetY < oldY){
        isSrollToTop = NO;
        
        [self.navView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view);
        }];
        [UIView animateWithDuration:0.3 animations:^{
            [self.view layoutIfNeeded];
        }];
    }

    oldY = offsetY;//将当前位移变成缓存位移
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
//MyLearningListViewController
//MylearningViewController
