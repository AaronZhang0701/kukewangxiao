//
//  NewCourseViewController.m
//  KukeApp
//
//  Created by 库课 on 2019/4/11.
//  Copyright © 2019 KukeZangMing. All rights reserved.
//

#import "NewCourseViewController.h"
#import "ZMTabPagerBar.h"
#import "TYPagerController.h"
#import "TypeSwitchingAndSearchView.h"
#import "SearchResultListViewController.h"
@interface NewCourseViewController ()<ZMTabPagerBarDataSource,ZMTabPagerBarDelegate,TYPagerControllerDataSource,TYPagerControllerDelegate>{
    CGFloat oldY;
    NSString *isChangeCate_id;
}

@property (nonatomic, weak) ZMTabPagerBar *tabBar;
@property (nonatomic, weak) TYPagerController *pagerController;
@property (nonatomic, strong) TypeSwitchingAndSearchView *headerBtnView;
@property (nonatomic, strong) NSArray *datas;
@property (nonatomic, strong) NewCourseListViewController *viewController;
@property (nonatomic, strong) NewCourseListViewController *viewController1;
@property (nonatomic, strong) NewCourseListViewController *viewController2;
@property (nonatomic, strong) NewCourseListViewController *viewController3;
@property (nonatomic, strong) NewCourseListViewController *viewController4;
@property (nonatomic, strong) NewCourseListViewController *viewController5;
@property (nonatomic, strong) NewCourseListViewController *viewController6;
@property (nonatomic, strong) NewCourseListViewController *viewController7;
@property (nonatomic, strong) NewCourseListViewController *viewController8;
@property (nonatomic, strong)NSMutableArray *ary;
@end

@implementation NewCourseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _ary = [NSMutableArray array];
    // Do any additional setup after loading the view.
//    self.title = @"PagerControllerDmeoController";
    self.view.backgroundColor = [UIColor whiteColor];
    isChangeCate_id =[UserDefaultsUtils valueWithKey:@"CateID"];
    //接收通知  点击首页课程图标后切换到课程界面
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(switchToCourseViewController:) name:@"SwitchToCourseViewController" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(upLoadUI:) name:@"CourseOffSet" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(upLoad:) name:@"SwitchGoodsType" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushAction:) name:@"Push_Course" object:nil];
    [self addTabPageBar];
    
    [self.view addSubview:self.headerBtnView];
    
    [self addPagerController];
    
    [self loadData];
}

- (void)pushAction:(NSNotification *)noti{
    [UserDefaultsUtils saveValue:noti.object[@"cate_id"] forKey:@"CateID"];
    
    [UserDefaultsUtils saveValue:noti.object[@"goods_type"] forKey:[NSString stringWithFormat:@"course_goods_type_%@",noti.object[@"cate_id"]]];
    
    NSArray *ary = @[noti.object[@"cate_son_id"],noti.object[@"subject_id"],@"-1"];
    
    [UserDefaultsUtils saveValue:ary forKey:[NSString stringWithFormat:@"Pick_Conditions_%@_%@",noti.object[@"cate_id"],noti.object[@"goods_type"]]];
    
    _headerBtnView.cate_id = noti.object[@"cate_id"];
    
    switch ([noti.object[@"cate_id"] integerValue]-1) {
            
        case 0:
            [_pagerController scrollToControllerAtIndex:[noti.object[@"cate_id"] integerValue]-1 animate:YES];
            [self.viewController1 pushUpLoadData];
//            [self.viewController1 upLoadData1];
            break;
        case 1:
            [_pagerController scrollToControllerAtIndex:2 animate:YES];
            [self.viewController3 pushUpLoadData];
//            [self.viewController3 upLoadData1];
            break;
        case 2:
            [_pagerController scrollToControllerAtIndex:1 animate:YES];
            [self.viewController2 pushUpLoadData];
//            [self.viewController2 upLoadData1];
            break;
        case 3:
            [_pagerController scrollToControllerAtIndex:[noti.object[@"cate_id"] integerValue]-1 animate:YES];
            [self.viewController4 pushUpLoadData];
//            [self.viewController4 upLoadData1];
            break;
        case 4:
            [_pagerController scrollToControllerAtIndex:[noti.object[@"cate_id"] integerValue]-1 animate:YES];
            [self.viewController5 pushUpLoadData];
//            [self.viewController5 upLoadData1];
            break;
        case 5:
            [_pagerController scrollToControllerAtIndex:[noti.object[@"cate_id"] integerValue]-1 animate:YES];
            [self.viewController6 pushUpLoadData];
//            [self.viewController6 upLoadData1];
            break;
        case 6:
            [_pagerController scrollToControllerAtIndex:[noti.object[@"cate_id"] integerValue]-1 animate:YES];
            [self.viewController7 pushUpLoadData];
//            [self.viewController7 upLoadData1];
            break;
        case 7:
            [_pagerController scrollToControllerAtIndex:[noti.object[@"cate_id"] integerValue]-1 animate:YES];
            [self.viewController8 pushUpLoadData];
//            [self.viewController8 upLoadData1];
            break;
        default:
            break;
    }
    
}
- (void)upLoad:(NSNotification *)noti
{
    //noti.object 就是当前点击的goodsType的cate_id；
    //isChangeCate_id 是上次点击到哪个cate_id；
    
    NSString *str = nil;
    if ([isChangeCate_id isEqualToString:noti.object]) {//当前和上次点击的是同一个cate_id
        str = @"1";
    }else{
        str = @"0";
    }
    isChangeCate_id = noti.object;
    [UserDefaultsUtils saveValue:str forKey:[NSString stringWithFormat:@"GoodsType_Swith_%@",noti.object]];
    
    switch ([noti.object integerValue]-1) {
        
        case 0:
            [self.viewController1 upLoadData1];
            break;
        case 1:
            [self.viewController3 upLoadData1];
            break;
        case 2:
            [self.viewController2 upLoadData1];
            break;
        case 3:
            [self.viewController4 upLoadData1];
            break;
        case 4:
            [self.viewController5 upLoadData1];
            break;
        case 5:
            [self.viewController6 upLoadData1];
            break;
        case 6:
            [self.viewController7 upLoadData1];
            break;
        case 7:
            [self.viewController8 upLoadData1];
            break;
        default:
            break;
    }

    
}

- (void)upLoadUI:(NSNotification *)noti
{
    
    CGFloat offsetY = [noti.object[@"CollectionOffSet"] floatValue];

    if (offsetY> oldY && offsetY > 0) {//如果当前位移大于缓存位移，说明scrollView向上滑动
        [UIView transitionWithView:_tabBar duration:0.3 options:UIViewAnimationOptionTransitionNone animations:^{
            self.tabBar.frame = CGRectMake(0, -44, screenWidth(), 44);
        } completion:NULL];
        [UIView transitionWithView:self.headerBtnView duration:0.3 options:UIViewAnimationOptionTransitionNone animations:^{
            self.headerBtnView.frame = CGRectMake(0, -47, screenWidth(), 47);
            _pagerController.view.frame = CGRectMake(0, PLV_StatusBarHeight, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)- CGRectGetMaxY(_tabBar.frame));
        } completion:NULL];
 
        
    }else if (offsetY < oldY){
        [UIView transitionWithView:self.tabBar duration:0.3 options:UIViewAnimationOptionTransitionNone animations:^{
            self.tabBar.frame = CGRectMake(0, PLV_StatusBarHeight, screenWidth(), 44);
        } completion:NULL];
        
        [UIView transitionWithView:self.headerBtnView duration:0.3 options:UIViewAnimationOptionTransitionNone animations:^{
            self.headerBtnView.frame = CGRectMake(0, maxY(_tabBar), screenWidth(), 47);
             _pagerController.view.frame = CGRectMake(0, CGRectGetMaxY(_tabBar.frame)+47, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)- CGRectGetMaxY(_tabBar.frame));
        } completion:NULL];
        
    }
   
    
    oldY = offsetY;//将当前位移变成缓存位移
    
}

- (void)addTabPageBar {
    ZMTabPagerBar *tabBar = [[ZMTabPagerBar alloc]init];
    tabBar.frame = CGRectMake(0, PLV_StatusBarHeight, CGRectGetWidth(self.view.frame), 44);
    tabBar.layout.barStyle = ZMPagerBarStyleProgressElasticView;
    tabBar.dataSource = self;
    tabBar.delegate = self;
    tabBar.layout.progressHeight = 3;
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
- (TypeSwitchingAndSearchView *)headerBtnView{
    if (!_headerBtnView) {
        _headerBtnView = [[TypeSwitchingAndSearchView alloc]initWithFrame:CGRectMake(0, maxY(_tabBar), screenWidth(), 47)];

    }
    return _headerBtnView;
}
- (void)addPagerController {
    TYPagerController *pagerController = [[TYPagerController alloc]init];
    pagerController.view.frame = CGRectMake(0, CGRectGetMaxY(_tabBar.frame)+47, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)- CGRectGetMaxY(_tabBar.frame));
    pagerController.layout.prefetchItemCount = 1;
    //pagerController.layout.autoMemoryCache = NO;
    // 只有当scroll滚动动画停止时才加载pagerview，用于优化滚动时性能
    pagerController.layout.addVisibleItemOnlyWhenScrollAnimatedEnd = YES;
    pagerController.dataSource = self;
    pagerController.delegate = self;
    [self addChildViewController:pagerController];
    [self.view addSubview:pagerController.view];
    _pagerController = pagerController;
    
    if ([[UserDefaultsUtils valueWithKey:@"CateID"] isEqualToString:@"2"]) {
        [_pagerController scrollToControllerAtIndex:2 animate:YES];
    }else if ([[UserDefaultsUtils valueWithKey:@"CateID"] isEqualToString:@"3"]){
        [_pagerController scrollToControllerAtIndex:1 animate:YES];
    }else{
        [_pagerController scrollToControllerAtIndex:[[UserDefaultsUtils valueWithKey:@"CateID"] integerValue]-1 animate:YES];
    }
    
}
- (void)switchToCourseViewController:(NSNotification *)noti {

    if ([[UserDefaultsUtils valueWithKey:@"CateID"] isEqualToString:@"2"]) {
        [_pagerController scrollToControllerAtIndex:2 animate:YES];
    }else if ([[UserDefaultsUtils valueWithKey:@"CateID"] isEqualToString:@"3"]){
        [_pagerController scrollToControllerAtIndex:1 animate:YES];
    }else{
        [_pagerController scrollToControllerAtIndex:[[UserDefaultsUtils valueWithKey:@"CateID"] integerValue]-1 animate:YES];
    }
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
    NSArray *datas = @[@"专升本",@"教师招聘",@"教师资格",@"初级会计",@"中级会计",@"护士资格",@"基金从业",@"学位英语"];
    
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
            NewCourseListViewController *VC = [[NewCourseListViewController alloc]init];
            VC.cate_id = 0;
            self.viewController1 = VC;
            return VC;
        };
            break;
        case 1:{
            NewCourseListViewController *VC = [[NewCourseListViewController alloc]init];
            VC.cate_id = 2;
            self.viewController2 = VC;
            return VC;
        };
            break;
        case 2:{
            NewCourseListViewController *VC = [[NewCourseListViewController alloc]init];
            VC.cate_id = 1;
            self.viewController3 = VC;
            return VC;
            };
            break;
        case 3:{
            NewCourseListViewController *VC = [[NewCourseListViewController alloc]init];
            VC.cate_id = 3;
            self.viewController4 = VC;
            return VC;
            };
            break;
        case 4:{
            NewCourseListViewController *VC = [[NewCourseListViewController alloc]init];
            VC.cate_id = index;
            self.viewController5 = VC;
            return VC;
            };
            break;
        case 5:{
            NewCourseListViewController *VC = [[NewCourseListViewController alloc]init];
            VC.cate_id = index;
            self.viewController6 = VC;
            return VC;
            };
            break;
        case 6:{
            NewCourseListViewController *VC = [[NewCourseListViewController alloc]init];
            VC.cate_id = index;
            self.viewController7 = VC;
            return VC;
            };
            break;
        case 7:{
            NewCourseListViewController *VC = [[NewCourseListViewController alloc]init];
            VC.cate_id = index;
            self.viewController8 = VC;
            return VC;
            };
            break;
        default:
        {
            NewCourseListViewController *VC = [[NewCourseListViewController alloc]init];
            VC.cate_id = index;
            self.viewController8 = VC;
            return VC;
        };
            break;
    }
//    NewCourseListViewController *VC = [[NewCourseListViewController alloc]init];
//
//    VC.cate_id = index;
////
////    [VC upLoadData];
//    self.viewController = VC;
////
////    [self.ary addObject:VC];
//    return VC;

}

#pragma mark - TYPagerControllerDelegate

- (void)pagerController:(TYPagerController *)pagerController transitionFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex animated:(BOOL)animated {
    
    
    if (toIndex == 1) {
        _headerBtnView.cate_id = [NSString stringWithFormat:@"%d",3];
        [UserDefaultsUtils saveValue:[NSString stringWithFormat:@"%d",3] forKey:@"CateID"];
    }else if (toIndex == 2){
        _headerBtnView.cate_id = [NSString stringWithFormat:@"%d", 2];
        [UserDefaultsUtils saveValue:[NSString stringWithFormat:@"%d",2] forKey:@"CateID"];
    }else{
        _headerBtnView.cate_id = [NSString stringWithFormat:@"%ld",toIndex + 1];
        [UserDefaultsUtils saveValue:[NSString stringWithFormat:@"%ld",toIndex + 1] forKey:@"CateID"];
    }
    
    [UserDefaultsUtils saveValue:@"1" forKey:@"SwicthTab"];

    [_tabBar scrollToItemFromIndex:fromIndex toIndex:toIndex animate:animated];
    
//    NSString *str = nil;
//    if (fromIndex != toIndex) {
//        str = @"0";
//    }else{
//        str = @"1";
//    }
//    [UserDefaultsUtils saveValue:str forKey:[NSString stringWithFormat:@"GoodsType_Swith_%@",[NSString stringWithFormat:@"%ld",toIndex]]];
//    NSString *str = nil;
//    if ([isChangeCate_id isEqualToString:noti.object]) {//当前和上次点击的是同一个cate_id
//        str = @"1";
//    }else{
//        str = @"0";z
//    }
//    isChangeCate_id = noti.object;
//    [UserDefaultsUtils saveValue:str forKey:[NSString stringWithFormat:@"GoodsType_Swith_%@",noti.object]];
    
//    [self.viewController upLoadData];
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
