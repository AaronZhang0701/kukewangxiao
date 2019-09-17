//
//  SeckillViewController.m
//  KukeApp
//
//  Created by 库课 on 2019/2/20.
//  Copyright © 2019 KukeZangMing. All rights reserved.
//

#import "SeckillViewController.h"
#import "TYTabPagerBar.h"
#import "TYPagerController.h"
#import "SeckillListViewController.h"
#import "PLVDownloadManagerViewController.h"
//#import "CustomViewController.h"

@interface SeckillViewController ()<NoDataTipsDelegate,TYTabPagerBarDataSource,TYTabPagerBarDelegate,TYPagerControllerDataSource,TYPagerControllerDelegate>

@property (nonatomic, weak) TYTabPagerBar *tabBar;
@property (nonatomic, weak) TYPagerController *pagerController;
@property (nonatomic, strong)dispatch_source_t time;
@property (nonatomic, strong) NSArray *datas;
@property (nonatomic, strong) NSMutableArray *datesAry;
@property (nonatomic, strong) NoDataTipsView *loadNetView;
@end

@implementation SeckillViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"库秒杀";
    self.view.backgroundColor = CBackgroundColor;
    
    [self addTabPageBar];
    
    [self addPagerController];
    if (![CoreStatus isNetworkEnable]) {
        [self.view addSubview:self.loadNetView];
    }else{
        [self loadData];
    }
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    //创建一个定时器
    self.time = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    //设置开始时间
    dispatch_time_t start = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC));
    //设置时间间隔
    uint64_t interval = (uint64_t)(1.0* NSEC_PER_SEC);
    //设置定时器
    dispatch_source_set_timer(self.time, start, interval, 0);
   
}
#pragma mark - 懒加载失败默认视图
- (NoDataTipsView *)loadNetView {
    if (!_loadNetView) {

        _loadNetView = [NoDataTipsView setTipsBackGroupWithframe:CGRectMake(0, 0, screenWidth(), self.view.height) tipsIamgeName:@"无网络" tipsStr:@"无法连接到网络,点击页面刷新"];
        _loadNetView.backgroundColor = CBackgroundColor;
        _loadNetView.noDataBtn.hidden = NO;
        _loadNetView.delegate = self;
    }
    return _loadNetView;
}
#pragma mark - <NoDataTipsDelegate> - 提示按钮点击
- (void)tipsNoDataBtnDid {
    if ([[UserDefaultsUtils valueWithKey:@"access_token"] length] !=0 ) {
        UIViewController *rootViewController = [[UIApplication sharedApplication] keyWindow].rootViewController;
        UIViewController *topViewController = [BaseTools topViewControllerWithRootViewController:rootViewController];
        PLVDownloadManagerViewController *vc = [[PLVDownloadManagerViewController alloc]init];
        [topViewController.navigationController pushViewController:vc animated:YES];
    }else{
        [BaseTools showErrorMessage:@"请登录后再操作"];
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [BaseTools alertLoginWithVC:self];
        });
    }
}
- (void)tipsRefreshBtnClicked{
    [self loadData];
}
- (void)addTabPageBar {
    TYTabPagerBar *tabBar = [[TYTabPagerBar alloc]init];
//    tabBar.layout.barStyle = TYPagerBarStyleProgressElasticView;
    tabBar.layout.barStyle = TYPagerBarStyleProgressView;
    tabBar.layout.cellWidth = CGRectGetWidth(self.view.frame)/5;
    tabBar.layout.cellSpacing = 0;
    tabBar.layout.cellEdging = 0;
    tabBar.dataSource = self;
    tabBar.delegate = self;
    tabBar.backgroundColor = [UIColor whiteColor];
    [tabBar registerClass:[TYTabPagerBarCell class] forCellWithReuseIdentifier:[TYTabPagerBarCell cellIdentifier]];
    [self.view addSubview:tabBar];
    _tabBar = tabBar;
}

- (void)addPagerController {
    TYPagerController *pagerController = [[TYPagerController alloc]init];
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

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];

    
    
    if (self.time) {
        dispatch_resume(self.time);
    }
  
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
     dispatch_suspend(_time);
    
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    _tabBar.frame = CGRectMake(0, 0, screenWidth(), 50);
    _pagerController.view.frame = CGRectMake(0, CGRectGetMaxY(_tabBar.frame)+5, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)- CGRectGetMaxY(_tabBar.frame)-5);
    
}

- (void)loadData {
    NSMutableArray *datas = [NSMutableArray array];
    self.datesAry = [NSMutableArray array];

    BADataEntity *entity = [BADataEntity new];
    entity.urlString = @"/seckill/rounds";
    entity.needCache = NO;
    entity.parameters = nil;
    // 如果打印数据不完整，是因为 Xcode 8 版本问题，请下断点打印数据
    [BANetManager ba_request_POSTWithEntity:entity successBlock:^(id response) {
        [self.loadNetView removeFromSuperview];
        if (response == nil) {
            
        }else{
            if ([response[@"code"] isEqualToString:@"0"]) {
                [datas addObjectsFromArray:response[@"data"]];
                for (NSDictionary *dict in datas) {
                    [self.datesAry addObject:dict[@"start_time"]];
                    [self.datesAry addObject:dict[@"end_time"]];
                }
                
                _datas = [datas copy];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self reloadData];
                    
                });
                [self updata];
            }else if ([response[@"code"] isEqualToString:@"-10000"]){
                [BaseTools showErrorMessage:@"请登录后再操作"];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [BaseTools alertLoginWithVC:self];
                });
            }else{
                [BaseTools showErrorMessage:response[@"msg"]];
            }
        }
        
    } failureBlock:^(NSError *error) {
        
    } progressBlock:^(int64_t bytesProgress, int64_t totalBytesProgress) {
        /*! 封装方法里已经回到主线程，所有这里不用再调主线程了 */
        
    }];
}
- (void)updata{

    //设置回调
    dispatch_source_set_event_handler(self.time, ^{

        if ([self.datesAry containsObject:[BaseTools getNowTimeTimestamp]]) {
            [self loadData];
        }
        
    });
    
}
#pragma mark - TYTabPagerBarDataSource

- (NSInteger)numberOfItemsInPagerTabBar {
    return _datas.count;
}

- (UICollectionViewCell<TYTabPagerBarCellProtocol> *)pagerTabBar:(TYTabPagerBar *)pagerTabBar cellForItemAtIndex:(NSInteger)index {
//    long long startNow =[_datas[index][@"start_time"] longLongValue]-[[BaseTools getNowTimeTimestamp] longLongValue];
//    long long endNow = [_datas[index][@"end_time"] longLongValue]-[[BaseTools getNowTimeTimestamp] longLongValue];

    UICollectionViewCell<TYTabPagerBarCellProtocol> *cell = [pagerTabBar dequeueReusableCellWithReuseIdentifier:[TYTabPagerBarCell cellIdentifier] forIndex:index];
     cell.titleLabel.text = [BaseTools getDateStringWithTimeHM:_datas[index][@"start_time"]];
    
    if ([_datas[index][@"seckill_status"] isEqualToString:@"0" ]) {
         cell.titleLabel1.text = @"即将开抢";
    }else if ([_datas[index][@"seckill_status"] isEqualToString:@"1" ]) {
        if ([_datas[index][@"current_flag"] isEqualToString:@"1" ]) {
            cell.titleLabel1.text = @"抢购中";
            [_pagerController scrollToControllerAtIndex:index animate:YES];
        }else{
            cell.titleLabel1.text = @"已开抢";
        }
    }else if ([_datas[index][@"seckill_status"] isEqualToString:@"2" ]) {
    
    }

    return cell;
}

#pragma mark - TYTabPagerBarDelegate

//- (CGFloat)pagerTabBar:(TYTabPagerBar *)pagerTabBar widthForItemAtIndex:(NSInteger)index {
////    NSString *title = _datas[index][@"start_time"];;
//    return [pagerTabBar cellWidthForTitle:@"已经结束"];
//}

- (void)pagerTabBar:(TYTabPagerBar *)pagerTabBar didSelectItemAtIndex:(NSInteger)index {
    [_pagerController scrollToControllerAtIndex:index animate:YES];
}

#pragma mark - TYPagerControllerDataSource

- (NSInteger)numberOfControllersInPagerController {
    return _datas.count;
}

- (UIViewController *)pagerController:(TYPagerController *)pagerController controllerForIndex:(NSInteger)index prefetching:(BOOL)prefetching {
//    if (index%3 == 0) {
//        CustomViewController *VC = [[CustomViewController alloc]init];
//        VC.text = [@(index) stringValue];
//        return VC;
//    }else if (index%3 == 1) {
//        ListViewController *VC = [[ListViewController alloc]init];
//        VC.text = [@(index) stringValue];
//        return VC;
//    }else {
//        CollectionViewController *VC = [[CollectionViewController alloc]init];
//        VC.text = [@(index) stringValue];
//        return VC;
//    }
//    NSLog(@"%ld",index);
//    if (index !=0) {
    SeckillListViewController *vc = [[SeckillListViewController alloc]init];
    vc.seckill_id = _datas[index][@"id"];
    return vc;
//    }else{
//        return nil;
//    }
    
}

#pragma mark - TYPagerControllerDelegate

- (void)pagerController:(TYPagerController *)pagerController transitionFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex animated:(BOOL)animated {
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
