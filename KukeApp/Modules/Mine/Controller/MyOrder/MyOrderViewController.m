//
//  MyOrderViewController.m
//  KukeApp
//
//  Created by iOSDeveloper on 2018/10/22.
//  Copyright © 2018年 zhangming. All rights reserved.
//

#import "MyOrderViewController.h"
#import "MyOrderBaseViewController.h"
#import "EvaluateViewController.h"
#import "OrderDetialViewController.h"
#import "LogisticsInfoViewController.h"
#import "PayMentViewController.h"
#import "OnlinePayment.h"
#import "CourseDetailViewController.h"
#import "ReturnGoodsViewController.h"
#import "PaySuccessViewController.h"
#define WindowsSize [UIScreen mainScreen].bounds.size
@interface MyOrderViewController ()<JXCategoryViewDelegate>{
    
    //八大类的ID
//    NSInteger index_id;
}
//滑动控件
@property (nonatomic, strong) JXCategoryTitleView *categoryView;
@property (nonatomic, strong) UIScrollView *scrollView;
//滑动页面个数数组
@property (nonatomic, strong) NSMutableArray <MyOrderBaseViewController *> *listVCArray;
@property (nonatomic, strong) NSDictionary *goodsData;

@end

@implementation MyOrderViewController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO];
    //    [AppUtiles setTabBarHidden:YES];
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [SGBrowserView hide];
}
- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"我的订单";
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
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(payResultStatus:)
                                                 name:KNotificationPayResultStatus
                                               object:nil];
    self.listVCArray = [NSMutableArray array];
    for (int i = 0; i < count; i ++) {
        MyOrderBaseViewController *listVC = [[MyOrderBaseViewController alloc] init];
        listVC.view.frame = CGRectMake(i*width, 0, width, height);
        listVC.myBlock = ^(NSString *url) {

        };
        [self.scrollView addSubview:listVC.view];
        [self.listVCArray addObject:listVC];
    }
    
    self.categoryView = [[JXCategoryTitleView alloc] init];
    self.categoryView.frame = CGRectMake(0, 0, WindowsSize.width, categoryViewHeight);

    self.categoryView.delegate = self;
    self.categoryView.contentScrollView = self.scrollView;
    self.categoryView.titles = titles;
    self.categoryView.titleLabelZoomEnabled = YES;
    self.categoryView.titleViewLineEnabled = NO;
    self.categoryView.titleFont = [UIFont systemFontOfSize:15];
    
    JXCategoryIndicatorLineView *lineView = [[JXCategoryIndicatorLineView alloc] init];
    lineView.indicatorLineViewHeight = 2;
    self.categoryView.indicators = @[lineView];
    [self.view addSubview:self.categoryView];
    self.categoryView.defaultSelectedIndex = self.index_id;
    [self.listVCArray[self.index_id] loadData:self.index_id];
    

     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(myOrderDetail:) name:@"MyOrderDetail" object:nil];
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(myOrderPay:) name:@"MyOrderPay" object:nil];

     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(myOrderLogistics:) name:@"MyOrderLogistics" object:nil];
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(myOrdeEvaliate:) name:@"MyOrdeEvaliate" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(afterSale:) name:@"AfterSale" object:nil];
}
#pragma mark ————— 类型数组初始化 --———
- (NSArray <NSString *> *)getRandomTitles {
    NSMutableArray *titles = @[@"全部",@"待付款",@"待发货",@"待收货",@"已完成",@"售后"].mutableCopy;
    
    return titles;
}

#pragma mark - JXCategoryViewDelegate

- (void)categoryView:(JXCategoryBaseView *)categoryView didSelectedItemAtIndex:(NSInteger)index {
//    [NSThread sleepForTimeInterval:1];
    [self.scrollView setContentOffset:CGPointMake(self.scrollView.bounds.size.width*index, 0) animated:YES];
    //侧滑手势处理
    self.navigationController.interactivePopGestureRecognizer.enabled = (index == 0);
    
    
    [self.listVCArray[index] loadData:index ];
    
}
- (void)myOrderDetail:(NSNotification *)noti
{
    OrderDetialViewController *vc = [[OrderDetialViewController alloc]init];

    vc.model = noti.object[@"Order_data"];
    [self.navigationController pushViewController:vc animated:YES];

    
}
#pragma mark ————— 付款状态通知 —————
- (void)payResultStatus:(NSNotification *)notification
{
    BOOL paySuccess = [notification.object boolValue];
    
    if (paySuccess) {//登陆成功加载主窗口控制器
        PaySuccessViewController *vc = [[PaySuccessViewController alloc]init];
        vc.dataDict =  self.goodsData;
        [self.navigationController pushViewController:vc animated:YES];
        [SGBrowserView hide];
    }else{
        [SGBrowserView hide];
    }
    
}
- (void)myOrderPay:(NSNotification *)noti
{
    MyOrderDataModel *model = noti.object[@"Order_data"];
    self.goodsData = model.goods;
    OnlinePayment *messageView = [[OnlinePayment alloc] initWithDoneBlock:nil];
    messageView.dicts = [self dicFromObject:model];
    CGPoint showCenter = CGPointMake(SCREEN_WIDTH/2,SCREEN_HEIGHT-messageView.height/2);
    [SGBrowserView showMoveView:messageView moveToCenter:showCenter];
    messageView.myFailureBlock = ^{
        [SGBrowserView hide];
    };
    messageView.myBlock = ^{
//        NSArray *controllers =  self.navigationController.viewControllers;
//        if ([controllers[controllers.count-2] isMemberOfClass:NSClassFromString(@"MyOrderViewController")] || [controllers[controllers.count-2] isMemberOfClass:NSClassFromString(@"CourseDetailViewController")]) {//如果倒数第二个为确认页面
//            [self.navigationController popToViewController:controllers[controllers.count-3] animated:YES];
//        } else {
//            [self.navigationController popViewControllerAnimated:YES];
//        }
        PaySuccessViewController *vc = [[PaySuccessViewController alloc]init];
        vc.dataDict = self.goodsData;
        [self.navigationController pushViewController:vc animated:YES];
        [SGBrowserView hide];
    };

}
//model转化为字典
- (NSDictionary *)dicFromObject:(NSObject *)object {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    unsigned int count;
    objc_property_t *propertyList = class_copyPropertyList([object class], &count);
    
    for (int i = 0; i < count; i++) {
        objc_property_t property = propertyList[i];
        const char *cName = property_getName(property);
        NSString *name = [NSString stringWithUTF8String:cName];
        NSObject *value = [object valueForKey:name];//valueForKey返回的数字和字符串都是对象
        
        if ([value isKindOfClass:[NSString class]] || [value isKindOfClass:[NSNumber class]]) {
            //string , bool, int ,NSinteger
            [dic setObject:value forKey:name];
            
        } else if ([value isKindOfClass:[NSArray class]] || [value isKindOfClass:[NSDictionary class]]) {
            //字典或字典
            [dic setObject:[self arrayOrDicWithObject:(NSArray*)value] forKey:name];
            
        } else if (value == nil) {
            //null
            //[dic setObject:[NSNull null] forKey:name];//这行可以注释掉?????
            
        } else {
            //model
            [dic setObject:[self dicFromObject:value] forKey:name];
        }
    }
    
    return [dic copy];
}
//将可能存在model数组转化为普通数组
- (id)arrayOrDicWithObject:(id)origin {
    if ([origin isKindOfClass:[NSArray class]]) {
        //数组
        NSMutableArray *array = [NSMutableArray array];
        for (NSObject *object in origin) {
            if ([object isKindOfClass:[NSString class]] || [object isKindOfClass:[NSNumber class]]) {
                //string , bool, int ,NSinteger
                [array addObject:object];
                
            } else if ([object isKindOfClass:[NSArray class]] || [object isKindOfClass:[NSDictionary class]]) {
                //数组或字典
                [array addObject:[self arrayOrDicWithObject:(NSArray *)object]];
                
            } else {
                //model
                [array addObject:[self dicFromObject:object]];
            }
        }
        
        return [array copy];
        
    } else if ([origin isKindOfClass:[NSDictionary class]]) {
        //字典
        NSDictionary *originDic = (NSDictionary *)origin;
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        for (NSString *key in originDic.allKeys) {
            id object = [originDic objectForKey:key];
            
            if ([object isKindOfClass:[NSString class]] || [object isKindOfClass:[NSNumber class]]) {
                //string , bool, int ,NSinteger
                [dic setObject:object forKey:key];
                
            } else if ([object isKindOfClass:[NSArray class]] || [object isKindOfClass:[NSDictionary class]]) {
                //数组或字典
                [dic setObject:[self arrayOrDicWithObject:object] forKey:key];
                
            } else {
                //model
                [dic setObject:[self dicFromObject:object] forKey:key];
            }
        }
        
        return [dic copy];
    }
    
    return [NSNull null];
}

- (void)myOrderLogistics:(NSNotification *)noti
{
    LogisticsInfoViewController *vc = [[LogisticsInfoViewController alloc]init];
    vc.orderID = noti.object[@"Order_sn"];
    [self.navigationController pushViewController:vc animated:YES];
    
}
- (void)myOrdeEvaliate:(NSNotification *)noti
{
    EvaluateViewController *vc = [[EvaluateViewController alloc]init];
    vc.model = noti.object[@"Order_data"];
    [self.navigationController pushViewController:vc animated:YES];
   
    
}
- (void)afterSale:(NSNotification *)noti
{
    ReturnGoodsViewController *vc = [[ReturnGoodsViewController alloc]init];
    vc.orderData = noti.object[@"Order_data"];
    [self.navigationController pushViewController:vc animated:YES];
    
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
