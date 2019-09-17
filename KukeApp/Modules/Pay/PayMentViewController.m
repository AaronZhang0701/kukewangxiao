//
//  PayMentViewController.m
//  KukeApp
//
//  Created by iOSDeveloper on 2018/10/24.
//  Copyright © 2018年 zhangming. All rights reserved.
//

#import "PayMentViewController.h"
#import "OnlinePayment.h"
#import "PPNumberButton.h"
#import "NY_AddressModel.h"
#import "XSIAPViewController.h"
#import "CourseDetailViewController.h"
#import "MyOrderViewController.h"
#import "UseCouponView.h"
#import "MyCouponModel.h"
#import "PaySuccessViewController.h"
#import "ReceiveAddressModel.h"
#import "PLVDownloadManagerViewController.h"
@interface PayMentViewController ()<NoDataTipsDelegate>{
    NSDictionary *dict;
    NSInteger num;
    NSDictionary *data;
    ReceiveAddressDataListModel *addModel;
    NSString *coupon_id;
    NSString *limitPrice;
    
    NSString *isGroup;
}
@property (nonatomic, strong) UseCouponView *couponView;
@property (nonatomic, strong) MyCouponListModel *couponModel;
@property (nonatomic, strong) NoDataTipsView *loadNetView;
@end

@implementation PayMentViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [BaseTools dismissHUD];
    if (![CoreStatus isNetworkEnable]) {
        self.address.hidden = YES;
        self.bottomView.hidden = YES;
        self.groupView.hidden = YES;
        self.payBtn.hidden = YES;
        [self.view addSubview:self.loadNetView];
    }else{
        [BaseTools showProgressMessage:@"加载中..."];
        [self loadData];
        [self loadAddressData];
    }
   
    [self.navigationController setNavigationBarHidden:NO];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [BaseTools dismissHUD];
    [SGBrowserView hide];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"结算中心";
    self.stuImage1.layer.cornerRadius = 25;
    self.stuImage1.layer.masksToBounds = YES;
    
    self.stuImage2.layer.cornerRadius = 25;
    self.stuImage2.layer.masksToBounds = YES;
    
    self.stuImage3.layer.cornerRadius = 25;
    self.stuImage3.layer.masksToBounds = YES;
    
    self.groupPic.layer.cornerRadius = 7;
    self.groupPic.layer.masksToBounds = YES;
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:self.navigationItem.backBarButtonItem.style target:nil action:nil];

    self.bottomView.frame = CGRectMake(0, 0, self.bottomView.width, 300);
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(payResultStatus:)
                                                 name:KNotificationPayResultStatus
                                               object:nil];
//    if ([self.seckill_id length] != 0) {
//        [parmDic setObject:self.seckill_id forKey:@"seckill_goods_id"];
//    }
    
    
    if (self.group_buy_goods_rule_id.length != 0 && self.token.length == 0) {//开团
        isGroup = @"1";
    }else if(self.group_buy_goods_rule_id.length != 0 && self.token.length != 0){//参团
        isGroup = @"2";
    }else{//普通商品
        isGroup = @"0";
    }

    num = 1;
    
    if ([UserDefaultsUtils boolValueWithKey:KIsAudit] || ![self.dist_id isEqualToString:@"0"]) {//分销审核隐藏优惠券
        
    }else{
        if(self.seckill_id != nil || [isGroup isEqualToString:@"1"] || [isGroup isEqualToString:@"2"]){//秒杀隐藏优惠券
            
        }else{
            self.couponbtn.hidden = NO;
            self.couponText.hidden = NO;
            self.couponMoney.hidden = NO;
            self.couponArrow.hidden = NO;
        }
        
    }
    
    // Do any additional setup after loading the view from its nib.
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
    [self loadAddressData];
}
#pragma mark ————— 付款状态通知 —————
- (void)payResultStatus:(NSNotification *)notification
{
    BOOL paySuccess = [notification.object boolValue];
    
    if (paySuccess) {//登陆成功加载主窗口控制器
        PaySuccessViewController *vc = [[PaySuccessViewController alloc]init];
        vc.dataDict = dict;
        vc.type = isGroup;
        vc.token = self.token;
        vc.group_buy_goods_rule_id = self.group_buy_goods_rule_id;
        [self.navigationController pushViewController:vc animated:YES];
        [SGBrowserView hide];
    }else{
        [SGBrowserView hide];
    }

}
- (UseCouponView *)couponView{
    if (!_couponView) {
        _couponView = [[UseCouponView alloc]init];
    }
    return _couponView;
}
- (void)useCouponAction{
    
    if ([dict[@"best_coupon_discount_amount"] isEqualToString:@"0"] || dict[@"best_coupon_discount_amount"]==nil) {
        self.discountPrice.text = @"无可用优惠券";
    }else{
        self.discountPrice.text = [NSString stringWithFormat:@"-%@",dict[@"best_coupon_discount_amount"]];
    }
    if(self.seckill_id == nil){
        coupon_id = dict[@"best_coupon_id"];
    }
 
    [self loadMoney];
    UIView *rootView = [[UIApplication sharedApplication] keyWindow];
    
    self.couponView.frame = CGRectMake(0, 0, kScreenWidth, screenHeight());
    [self.couponView getGoodsID:self.goodID  withGoodsType:self.goodType andGoodsNumber:[NSString stringWithFormat:@"%ld",num]];
    self.couponView.tag = 20001;
    self.couponView.myBlock = ^{
        [[[UIApplication sharedApplication].keyWindow viewWithTag:20001] removeFromSuperview];
    };
    __weak typeof(self) weakSelf = self;
    self.couponView.couponBlock = ^(MyCouponListModel *model) {
        weakSelf.couponModel = model;
        coupon_id = model.coupon_id;
        if (model==nil) {
            weakSelf.discountPrice.text = @"使用优惠券";

        }else{
            
            weakSelf.discountPrice.text = [NSString stringWithFormat:@"-%@",model.discount_amount];

        }
        [weakSelf loadMoney];
        
    };
    [rootView addSubview:_couponView];
    
    
}
- (void)loadAddressData{
    [ZMNetworkHelper POST:@"/stucommon/get_default_address" parameters:nil cache:NO responseCache:^(id responseCache) {
        
    } success:^(id responseObject) {
        if ([responseObject[@"code"] isEqualToString:@"0"]) {
            __weak typeof(self) weakSelf = self;
            dispatch_async(dispatch_get_main_queue(), ^{
                weakSelf.address_name.hidden = NO;
                weakSelf.address_tel.hidden = NO;
                weakSelf.address_ad.hidden = NO;
                [weakSelf.address setTitle:@"" forState:(UIControlStateNormal)];
                weakSelf.address_name.text = responseObject[@"data"][@"receiver"];
                weakSelf.address_tel.text = responseObject[@"data"][@"receive_mobile"];
                NSString *address = [NSString stringWithFormat:@"%@ %@ %@",responseObject[@"data"][@"province_name"],responseObject[@"data"][@"city_name"],responseObject[@"data"][@"county_name"]];
                weakSelf.address_ad.text = [NSString stringWithFormat:@"%@\n%@",address,responseObject[@"data"][@"address"]];
            });
           
        }else{
            __weak typeof(self) weakSelf = self;
            dispatch_async(dispatch_get_main_queue(), ^{
                weakSelf.address_name.hidden = YES;
                weakSelf.address_tel.hidden = YES;
                weakSelf.address_ad.hidden = YES;
                [weakSelf.address setTitle:@"+添加收货地址" forState:(UIControlStateNormal)];
                weakSelf.address_name.text = @"";
                weakSelf.address_tel.text = @"";
                weakSelf.address_ad.text = @"";
                
            });
//            [BaseTools showErrorMessage:responseObject[@"msg"]];
        }
        
    } failure:^(NSError *error) {
        
    }];
}
- (void)loadData{
    
    NSMutableDictionary *parmDic = [NSMutableDictionary dictionary];
    [parmDic setObject:self.goodID  forKey:@"goods_id"];
    [parmDic setObject:self.goodType forKey:@"type"];
    [parmDic setObject:self.group_buy_goods_rule_id  forKey:@"group_buy_goods_rule_id"];
    [parmDic setObject:self.token forKey:@"token"];
    if ([self.seckill_id length] != 0) {
        [parmDic setObject:self.seckill_id forKey:@"seckill_goods_id"];
    }
    BADataEntity *entity = [BADataEntity new];
    entity.urlString = @"/order/checkout";
    entity.needCache = NO;
    entity.parameters = parmDic;

    // 如果打印数据不完整，是因为 Xcode 8 版本问题，请下断点打印数据
    [BANetManager ba_request_POSTWithEntity:entity successBlock:^(id response) {
        self.address.hidden = NO;
        self.bottomView.hidden = NO;
        self.groupView.hidden = NO;
        self.payBtn.hidden = NO;
        [self.loadNetView removeFromSuperview];
        [BaseTools dismissHUD];
        if ([response[@"code"] isEqualToString:@"0"]) {
            dict = response[@"data"];
            [self loadUI];
        }else if ([response[@"code"] isEqualToString:@"-10000"]){
            [BaseTools showErrorMessage:@"请登录后再操作"];
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [BaseTools alertLoginWithVC:self];
            });
        }else if ([response[@"code"] isEqualToString:@"100"]){
            
            [[OpenInstallSDK defaultManager] reportEffectPoint:@"creatOrder" effectValue:1];
            [[OpenInstallSDK defaultManager] reportEffectPoint:@"pay" effectValue:1];
            [BaseTools showErrorMessage:response[@"msg"]];
            KPostNotification(@"PaySuccess", nil);
            
            dict = response[@"data"];
            dispatch_async(dispatch_get_main_queue(), ^{
                
                PaySuccessViewController *vc = [[PaySuccessViewController alloc]init];
                vc.dataDict = dict;
                vc.type = isGroup;
                vc.token = self.token;
                vc.group_buy_goods_rule_id = self.group_buy_goods_rule_id;
                [self.navigationController pushViewController:vc animated:YES];
            });
        }else{
            [BaseTools showErrorMessage:response[@"msg"]];
        }
    } failureBlock:^(NSError *error) {
        
    } progressBlock:^(int64_t bytesProgress, int64_t totalBytesProgress) {
        /*! 封装方法里已经回到主线程，所有这里不用再调主线程了 */
        
    }];
}
- (void)loadUI{
    //通知主线程刷新
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.pic sd_setImageWithURL:[NSURL URLWithString:dict[@"img"]] placeholderImage:[UIImage imageNamed:@"goodsImage"]];

        
//        if ([dict[@"type"] isEqualToString:@"4"]) {
//            self.pic.frame = CGRectMake((136-86/3*2)/2,17, 138/3*2,86);
//        }else{
            self.pic.frame = CGRectMake(16, 17, 136, 86);
//        }
        self.goodsName.text = dict[@"title"];
        self.price.text = dict[@"discount_price"];
        self.orderPrice.text = dict[@"discount_price"];
        
        if ([dict[@"best_coupon_discount_amount"] isEqualToString:@"0"] || dict[@"best_coupon_discount_amount"]==nil) {
             self.discountPrice.text = @"无可用优惠券";
        }else{
             self.discountPrice.text = [NSString stringWithFormat:@"-%@",dict[@"best_coupon_discount_amount"]];
        }

        if(self.seckill_id == nil){
            coupon_id = dict[@"best_coupon_id"];
        }
        [self loadMoney];
        if ([dict[@"is_ship"] isEqualToString:@"0"]) {
            if (self.group_buy_goods_rule_id.length != 0 && self.token.length == 0) {//开团
                
                self.groupView.frame = CGRectMake(0, 0, screenWidth(), 129);
                self.bottomView.frame = CGRectMake(0, 129, screenWidth(), 300);
                [self initGroupView];
            }else{//参团
                self.bottomView.frame = CGRectMake(0, 0, screenWidth(), 300);
            }
           
        }else{
            if (self.group_buy_goods_rule_id.length != 0 && self.token.length == 0) {//开团
                
                self.groupView.frame = CGRectMake(0, 89, screenWidth(), 129);
                self.bottomView.frame = CGRectMake(0, 218, screenWidth(), 300);
                [self initGroupView];
            }else{//参团
                self.bottomView.frame = CGRectMake(0, 81, screenWidth(), 300);
            }
            if ([dict[@"type"] isEqualToString:@"4"]) {
                PPNumberButton *numberButton = [PPNumberButton numberButtonWithFrame:CGRectMake(screenWidth()-110, 75, 100, 30)];
                //设置边框颜色
                numberButton.borderColor = CNavBgColor;
                numberButton.increaseTitle = @"＋";
                numberButton.decreaseTitle = @"－";
                numberButton.currentNumber = 1;
                numberButton.minValue = 1;
                numberButton.longPressSpaceTime = CGFLOAT_MAX;
                numberButton.resultBlock = ^(PPNumberButton *ppBtn, NSInteger number, BOOL increaseStatus){
                    
                    num = number;
                    self.orderPrice.text = [NSString stringWithFormat:@"%.2f",[dict[@"discount_price"] doubleValue] *num];
                    [self loadMoney];
                };
                [self.bigView addSubview:numberButton];
            }
            
        }
    });
    
}
- (void)initGroupView{
    
    
    CurrentUserInfo *info= nil;
    if ([UserInfoTool persons].count != 0) {
        info = [UserInfoTool persons][0];
        [self.stuImage1 sd_setImageWithURL:[NSURL URLWithString:info.photo] placeholderImage:[UIImage imageNamed:@"个人中心未登录头像"]];
        self.sutName1.text = info.NiName;
    }
    
    self.groupRestNum.text = [NSString stringWithFormat:@"立即开团，完成支付需再拼%@人",dict[@"rest_num"]];
    if ([dict[@"rest_num"] isEqualToString:@"1"]) {
        self.stuImage3.image = [UIImage imageNamed:@"待参与图标"];
        self.stuName3.text = @"待参与";
        self.stuImage2.hidden = YES;
        self.stuName2.hidden = YES;
    }else if([dict[@"rest_num"] isEqualToString:@"2"]){
        self.stuImage2.image = [UIImage imageNamed:@"待参与图标"];
        self.stuName2.text = @"待参与";
        self.stuImage3.image = [UIImage imageNamed:@"待参与图标"];
        self.stuName3.text = @"待参与";
    }else if([dict[@"rest_num"] integerValue]>=3){
        self.stuImage2.image = [UIImage imageNamed:@"shenglvehao"];
        self.stuName2.hidden = YES;
        self.stuImage3.image = [UIImage imageNamed:@"待参与图标"];
        self.stuName3.text = @"待参与";
    }
    
   
}
- (void)loadMoney{
    NSMutableDictionary *parmDic = [NSMutableDictionary dictionary];
    [parmDic setObject:self.goodID  forKey:@"goods_id"];
    [parmDic setObject:self.goodType forKey:@"goods_type"];
    [parmDic setObject:[NSNumber numberWithInteger:num]  forKey:@"goods_num"];
    [parmDic setObject:@"0" forKey:@"is_coin"];
    [parmDic setObject:coupon_id  forKey:@"coupon_id"];
    [parmDic setObject:@"0" forKey:@"use_account"];
    [parmDic setObject:self.group_buy_goods_rule_id  forKey:@"group_buy_goods_rule_id"];
    if ([dict[@"price_info"][@"seckill_goods_id"] length] != 0) {
        [parmDic setObject:dict[@"price_info"][@"seckill_goods_id"] forKey:@"seckill_goods_id"];
    }
    if (self.dist_id.length !=0) {
        [parmDic setObject:self.dist_id forKey:@"dist_id"];
    }
    [ZMNetworkHelper POST:@"/order/calculation_price" parameters:parmDic cache:NO responseCache:^(id responseCache) {
        
    } success:^(id responseObject) {
        if ([responseObject[@"code"] isEqualToString:@"0"]) {
            dispatch_async(dispatch_get_main_queue(), ^{
            
                NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"实付：%@",responseObject[@"data"][@"limit"]]];
                [attributeStr addAttribute:NSForegroundColorAttributeName value:CNavBgColor range:NSMakeRange(3,attributeStr.length-3)];
            
                [self.payPrice setAttributedTitle:attributeStr forState:(UIControlStateNormal)];
                limitPrice = responseObject[@"data"][@"limit"];
            });
           
        }else if ([responseObject[@"code"] isEqualToString:@"-10000"]){
            [BaseTools showErrorMessage:@"请登录后再操作"];
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [BaseTools alertLoginWithVC:self];
            });
        }else{
            [BaseTools showErrorMessage:responseObject[@"msg"]];
        }
        
    } failure:^(NSError *error) {

    }];
}
- (IBAction)addressAction:(id)sender {
    NY_AddressListVC *vc = [[NY_AddressListVC alloc]initWithNibName:@"NY_AddressListVC" bundle:nil];
    __weak typeof(self) weakSelf = self;
    vc.addressBlcok = ^(ReceiveAddressDataListModel *model){
        addModel = model;
        weakSelf.address_name.text = model.receiver;
        weakSelf.address_tel.text = model.receive_mobile;
        weakSelf.address_ad.text = [NSString stringWithFormat:@"%@ %@ %@",model.province_name,model.city_name,model.county_name];
        weakSelf.address_name.hidden = NO;
        weakSelf.address_tel.hidden = NO;
        weakSelf.address_ad.hidden = NO;
        [weakSelf.address setTitle:@"" forState:(UIControlStateNormal)];

    };
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)useCouponAction:(id)sender {
    [self useCouponAction];
    
}
- (IBAction)payAction:(id)sender {

    if ([self.goodType isEqualToString:@"1"] || [self.goodType isEqualToString:@"3"]) {//goods_type 1 3永远使用内购
        [self useIAPPay];
    }else if ([self.goodType isEqualToString:@"4"]){ //goods_type 4 永远使用支付宝和微信
        [self useThridPay];
    }else{
        if ([UserDefaultsUtils boolValueWithKey:KIsAudit]){
            [self useIAPPay];
        }else{
            [self useThridPay];
        }
    }
    
   
}
//- (void)payWithNOAudit{//审核过
//    if ([self.isOrder isEqualToString:@"1"]){//从订单页面进入付款
//        [BaseTools showProgressMessage:@""];
//        NSMutableDictionary *parmDic = [NSMutableDictionary dictionary];
//        [parmDic setObject:self.order_sn  forKey:@"order_sn"];
//        [ZMNetworkHelper POST:@"/order/pay_way" parameters:parmDic cache:NO responseCache:^(id responseCache) {
//
//        } success:^(id responseObject) {
//
//            if ([responseObject[@"code"] isEqualToString:@"0"]) {
//                [BaseTools dismissHUD];
//                data = responseObject[@"data"];
//                [self popView];
//            }else if ([responseObject[@"code"] isEqualToString:@"-10000"]){
//                [BaseTools dismissHUD];
//                [BaseTools showErrorMessage:@"请登录后再操作"];
//                dispatch_async(dispatch_get_main_queue(), ^{
//
//                    [BaseTools alertLoginWithVC:self];
//                });
//            }else if ([responseObject[@"code"] isEqualToString:@"100"]){
//                KPostNotification(@"PaySuccess", nil);
//                KPostNotification(KNotificationLoginUpdata, nil);
//                [BaseTools dismissHUD];
//                [BaseTools showErrorMessage:responseObject[@"msg"]];
//            }else{
//                [BaseTools dismissHUD];
//                [BaseTools showErrorMessage:responseObject[@"msg"]];
//            }
//
//        } failure:^(NSError *error) {
//            [BaseTools dismissHUD];
//        }];
//    }else{//从未生成订单的页面进入
//        if ([self.goodType isEqualToString:@"4"] || [dict[@"is_ship"] isEqualToString:@"1"] ) {
//            if (self.address_name.text.length==0 || self.address_tel.text.length  == 0 || self.address_ad.text.length == 0||self.address_name.text == nil || self.address_tel.text == nil || self.address_ad.text == nil) {
//                [BaseTools showErrorMessage:@"请输入收货人的相关信息"];
//            }else{
//
//                [BaseTools showProgressMessage:@""];
//                NSMutableDictionary *parmDic = [NSMutableDictionary dictionary];
//                [parmDic setObject:self.goodID  forKey:@"goods_id"];
//                [parmDic setObject:self.goodType forKey:@"type"];
//                [parmDic setObject:@"0" forKey:@"is_coin"];
//                [parmDic setObject:coupon_id forKey:@"coupon_id"];
//                [parmDic setObject:@"0" forKey:@"is_account"];
//                [parmDic setObject:@"0" forKey:@"account"];
//                [parmDic setObject:[NSString stringWithFormat:@"%ld",(long)num]  forKey:@"goods_num"];
//                [parmDic setObject:self.address_ad.text forKey:@"address"];
//                [parmDic setObject:self.address_name.text  forKey:@"receiver"];
//                [parmDic setObject:self.address_tel.text forKey:@"receive_mobile"];
//                [parmDic setObject:self.group_buy_goods_rule_id  forKey:@"group_buy_goods_rule_id"];
//                [parmDic setObject:self.token forKey:@"token"];
//                if ([dict[@"price_info"][@"seckill_goods_id"] length] != 0) {
//                    [parmDic setObject:dict[@"price_info"][@"seckill_goods_id"] forKey:@"seckill_goods_id"];
//                }
//                if (self.dist_id.length !=0) {
//                    [parmDic setObject:self.dist_id forKey:@"dist_id"];
//                }
//
//                [ZMNetworkHelper POST:@"/order/generate_order" parameters:parmDic cache:NO responseCache:^(id responseCache) {
//
//                } success:^(id responseObject) {
//                    if ([responseObject[@"code"] isEqualToString:@"0"]) {
//                        [[OpenInstallSDK defaultManager] reportEffectPoint:@"creatOrder" effectValue:1];
//                        [BaseTools dismissHUD];
//                        data = responseObject[@"data"];
//                        [self popView];
//                    }else if ([responseObject[@"code"] isEqualToString:@"-10000"]){
//                        [BaseTools dismissHUD];
//                        [BaseTools showErrorMessage:@"请登录后再操作"];
//                        dispatch_async(dispatch_get_main_queue(), ^{
//
//                            [BaseTools alertLoginWithVC:self];
//                        });
//                    }else if ([responseObject[@"code"] isEqualToString:@"100"]){//直接购买成功（实体物品不会走）
//                        [[OpenInstallSDK defaultManager] reportEffectPoint:@"creatOrder" effectValue:1];
//                        [[OpenInstallSDK defaultManager] reportEffectPoint:@"pay" effectValue:1];
//                        [BaseTools dismissHUD];
//                        [BaseTools showErrorMessage:responseObject[@"msg"]];
//                        self.token = responseObject[@"data"][@"token"];
//                        KPostNotification(@"PaySuccess", nil);
//                        KPostNotification(KNotificationLoginUpdata, nil);
//                        dispatch_async(dispatch_get_main_queue(), ^{
//
//                            PaySuccessViewController *vc = [[PaySuccessViewController alloc]init];
//                            vc.dataDict = dict;
//                            vc.type = isGroup;
//                            vc.token = self.token;
//                            vc.group_buy_goods_rule_id = self.group_buy_goods_rule_id;
//                            [self.navigationController pushViewController:vc animated:YES];
//                        });
//                    }else{
//                        [BaseTools dismissHUD];
//                        [BaseTools showErrorMessage:responseObject[@"msg"]];
//                    }
//
//                } failure:^(NSError *error) {
//                    [BaseTools dismissHUD];
//                }];
//            }
//        }else{
//            if ([limitPrice doubleValue]>[dict[@"user_account"] doubleValue]) {
//                [BaseTools showErrorMessage:@"余额不足请充值"];
//                XSIAPViewController *vc = [[XSIAPViewController alloc]init];
//                vc.money = dict[@"user_account"];
//                [self.navigationController pushViewController:vc animated:YES];
//            }else{
//                [BaseTools showProgressMessage:@""];
//                NSMutableDictionary *parmDic = [NSMutableDictionary dictionary];
//                [parmDic setObject:self.goodID  forKey:@"goods_id"];
//                [parmDic setObject:self.goodType forKey:@"type"];
//                [parmDic setObject:@"0" forKey:@"is_coin"];
//                [parmDic setObject:coupon_id forKey:@"coupon_id"];
//                [parmDic setObject:@"0" forKey:@"account"];
//                [parmDic setObject:@"1" forKey:@"is_account"];
//                [parmDic setObject:[NSString stringWithFormat:@"%ld",(long)num]  forKey:@"goods_num"];
//                [parmDic setObject:@"" forKey:@"address"];
//                [parmDic setObject:@""  forKey:@"receiver"];
//                [parmDic setObject:@"" forKey:@"receiver_mobile"];
//                [parmDic setObject:self.group_buy_goods_rule_id  forKey:@"group_buy_goods_rule_id"];
//                [parmDic setObject:self.token forKey:@"token"];
//
//                if ([dict[@"price_info"][@"seckill_goods_id"] length] != 0) {
//                    [parmDic setObject:dict[@"price_info"][@"seckill_goods_id"] forKey:@"seckill_goods_id"];
//                }
//                if (self.dist_id.length !=0) {
//                    [parmDic setObject:self.dist_id forKey:@"dist_id"];
//                }
//                [ZMNetworkHelper POST:@"/order/generate_order" parameters:parmDic cache:NO responseCache:^(id responseCache) {
//
//                } success:^(id responseObject) {
//                    if ([responseObject[@"code"] isEqualToString:@"0"]) {
//                        [[OpenInstallSDK defaultManager] reportEffectPoint:@"creatOrder" effectValue:1];
//                        [BaseTools dismissHUD];
//                        data = responseObject[@"data"];
//                        //                        [self popView];
//
//                    }else if ([responseObject[@"code"] isEqualToString:@"-10000"]){
//                        [BaseTools dismissHUD];
//                        [BaseTools showErrorMessage:@"请登录后再操作"];
//                        dispatch_async(dispatch_get_main_queue(), ^{
//
//                            [BaseTools alertLoginWithVC:self];
//                        });
//                    }else if ([responseObject[@"code"] isEqualToString:@"100"]){//直接购买成功（实体物品不会走）
//                        [[OpenInstallSDK defaultManager] reportEffectPoint:@"creatOrder" effectValue:1];
//                        [[OpenInstallSDK defaultManager] reportEffectPoint:@"pay" effectValue:1];
//                        [BaseTools dismissHUD];
//                        [BaseTools showErrorMessage:responseObject[@"msg"]];
//                        self.token = responseObject[@"data"][@"token"];
//                        KPostNotification(@"PaySuccess", nil);
//                        KPostNotification(KNotificationLoginUpdata, nil);
//                        dispatch_async(dispatch_get_main_queue(), ^{
//                            PaySuccessViewController *vc = [[PaySuccessViewController alloc]init];
//                            vc.dataDict = dict;
//                            vc.type = isGroup;
//                            vc.token = self.token;
//                            vc.group_buy_goods_rule_id = self.group_buy_goods_rule_id;
//                            [self.navigationController pushViewController:vc animated:YES];
//                        });
//                    }else{
//                        [BaseTools dismissHUD];
//                        [BaseTools showErrorMessage:responseObject[@"msg"]];
//                    }
//
//                } failure:^(NSError *error) {
//                    [BaseTools dismissHUD];
//                }];
//            }
//
//
//        }
//    }
//}
//- (void)payWithAudit{//审核中
//
//    if ([self.isOrder isEqualToString:@"1"]){//从订单页面进入付款
//        [BaseTools showProgressMessage:@""];
//        NSMutableDictionary *parmDic = [NSMutableDictionary dictionary];
//        [parmDic setObject:self.order_sn  forKey:@"order_sn"];
//        [ZMNetworkHelper POST:@"/order/pay_way" parameters:parmDic cache:NO responseCache:^(id responseCache) {
//
//        } success:^(id responseObject) {
//            if ([responseObject[@"code"] isEqualToString:@"0"]) {
//                [BaseTools dismissHUD];
//                data = responseObject[@"data"];
//                [self popView];
//            }else if ([responseObject[@"code"] isEqualToString:@"-10000"]){
//                [BaseTools dismissHUD];
//                [BaseTools showErrorMessage:@"请登录后再操作"];
//                dispatch_async(dispatch_get_main_queue(), ^{
//
//                    [BaseTools alertLoginWithVC:self];
//                });
//            }else if ([responseObject[@"code"] isEqualToString:@"100"]){
//                KPostNotification(@"PaySuccess", nil);
//                KPostNotification(KNotificationLoginUpdata, nil);
//                [BaseTools dismissHUD];
//                [BaseTools showErrorMessage:responseObject[@"msg"]];
//            }else{
//                [BaseTools dismissHUD];
//                [BaseTools showErrorMessage:responseObject[@"msg"]];
//            }
//
//        } failure:^(NSError *error) {
//            [BaseTools dismissHUD];
//        }];
//    }else{//从未生成订单的页面进入
//        if ([self.goodType isEqualToString:@"4"]) {
//            if (self.address_name.text.length==0 || self.address_tel.text.length  == 0 || self.address_ad.text.length == 0||self.address_name.text == nil || self.address_tel.text == nil || self.address_ad.text == nil) {
//                [BaseTools showErrorMessage:@"请输入收货人的相关信息"];
//            }else{
//
//                NSMutableDictionary *parmDic = [NSMutableDictionary dictionary];
//                [parmDic setObject:self.goodID  forKey:@"goods_id"];
//                [parmDic setObject:self.goodType forKey:@"type"];
//                [parmDic setObject:@"0" forKey:@"is_coin"];
//                [parmDic setObject:coupon_id forKey:@"coupon_id"];
//                [parmDic setObject:@"0" forKey:@"is_account"];
//                [parmDic setObject:@"0" forKey:@"account"];
//                [parmDic setObject:[NSString stringWithFormat:@"%ld",(long)num]  forKey:@"goods_num"];
//                [parmDic setObject:self.address_ad.text forKey:@"address"];
//                [parmDic setObject:self.address_name.text  forKey:@"receiver"];
//                [parmDic setObject:self.address_tel.text forKey:@"receive_mobile"];
//                [parmDic setObject:self.group_buy_goods_rule_id  forKey:@"group_buy_goods_rule_id"];
//                [parmDic setObject:self.token forKey:@"token"];
//                if ([dict[@"price_info"][@"seckill_goods_id"] length] != 0) {
//                    [parmDic setObject:dict[@"price_info"][@"seckill_goods_id"] forKey:@"seckill_goods_id"];
//                }
//                if (self.dist_id.length !=0) {
//                    [parmDic setObject:self.dist_id forKey:@"dist_id"];
//                }
//
//                [ZMNetworkHelper POST:@"/order/generate_order" parameters:parmDic cache:NO responseCache:^(id responseCache) {
//
//                } success:^(id responseObject) {
//                    if ([responseObject[@"code"] isEqualToString:@"0"]) {
//                        [[OpenInstallSDK defaultManager] reportEffectPoint:@"creatOrder" effectValue:1];
//                        [BaseTools dismissHUD];
//                        data = responseObject[@"data"];
//                        [self popView];
//                    }else if ([responseObject[@"code"] isEqualToString:@"-10000"]){
//                        [BaseTools dismissHUD];
//                        [BaseTools showErrorMessage:@"请登录后再操作"];
//                        dispatch_async(dispatch_get_main_queue(), ^{
//
//                            [BaseTools alertLoginWithVC:self];
//                        });
//                    }else if ([responseObject[@"code"] isEqualToString:@"100"]){//直接购买成功（实体物品不会走）
//                        [[OpenInstallSDK defaultManager] reportEffectPoint:@"creatOrder" effectValue:1];
//                        [[OpenInstallSDK defaultManager] reportEffectPoint:@"pay" effectValue:1];
//                        [BaseTools dismissHUD];
//                        [BaseTools showErrorMessage:responseObject[@"msg"]];
//                        self.token = responseObject[@"data"][@"token"];
//                        KPostNotification(@"PaySuccess", nil);
//                        KPostNotification(KNotificationLoginUpdata, nil);
//                        dispatch_async(dispatch_get_main_queue(), ^{
//
//                            PaySuccessViewController *vc = [[PaySuccessViewController alloc]init];
//                            vc.dataDict = dict;
//                            vc.type = isGroup;
//                            vc.token = self.token;
//                            vc.group_buy_goods_rule_id = self.group_buy_goods_rule_id;
//                            [self.navigationController pushViewController:vc animated:YES];
//                        });
//                    }else{
//                        [BaseTools dismissHUD];
//                        [BaseTools showErrorMessage:responseObject[@"msg"]];
//                    }
//
//                } failure:^(NSError *error) {
//                    [BaseTools dismissHUD];
//                }];
//            }
//        }else if ([self.goodType isEqualToString:@"5"] && [dict[@"is_ship"] isEqualToString:@"1"] ){
//
//            if (self.address_name.text.length==0 || self.address_tel.text.length  == 0 || self.address_ad.text.length == 0||self.address_name.text == nil || self.address_tel.text == nil || self.address_ad.text == nil) {
//                [BaseTools showErrorMessage:@"请输入收货人的相关信息"];
//            }else{
//                if ([limitPrice doubleValue]>[dict[@"user_account"] doubleValue]) {
//                    [BaseTools showErrorMessage:@"余额不足请充值"];
//                    XSIAPViewController *vc = [[XSIAPViewController alloc]init];
//                    vc.money = dict[@"user_account"];
//                    [self.navigationController pushViewController:vc animated:YES];
//                }else{
//                    NSMutableDictionary *parmDic = [NSMutableDictionary dictionary];
//                    [parmDic setObject:self.goodID  forKey:@"goods_id"];
//                    [parmDic setObject:self.goodType forKey:@"type"];
//                    [parmDic setObject:@"0" forKey:@"is_coin"];
//                    [parmDic setObject:coupon_id forKey:@"coupon_id"];
//                    [parmDic setObject:@"1" forKey:@"is_account"];
//                    [parmDic setObject:@"0" forKey:@"account"];
//                    [parmDic setObject:[NSString stringWithFormat:@"%ld",(long)num]  forKey:@"goods_num"];
//                    [parmDic setObject:self.address_ad.text forKey:@"address"];
//                    [parmDic setObject:self.address_name.text  forKey:@"receiver"];
//                    [parmDic setObject:self.address_tel.text forKey:@"receive_mobile"];
//                    [parmDic setObject:self.group_buy_goods_rule_id  forKey:@"group_buy_goods_rule_id"];
//                    [parmDic setObject:self.token forKey:@"token"];
//                    if ([dict[@"price_info"][@"seckill_goods_id"] length] != 0) {
//                        [parmDic setObject:dict[@"price_info"][@"seckill_goods_id"] forKey:@"seckill_goods_id"];
//                    }
//                    if (self.dist_id.length !=0) {
//                        [parmDic setObject:self.dist_id forKey:@"dist_id"];
//                    }
//
//                    [ZMNetworkHelper POST:@"/order/generate_order" parameters:parmDic cache:NO responseCache:^(id responseCache) {
//
//                    } success:^(id responseObject) {
//                        if ([responseObject[@"code"] isEqualToString:@"0"]) {
//                            [[OpenInstallSDK defaultManager] reportEffectPoint:@"creatOrder" effectValue:1];
//                            [BaseTools dismissHUD];
//                            data = responseObject[@"data"];
//                            //                            [self popView];
//                        }else if ([responseObject[@"code"] isEqualToString:@"-10000"]){
//                            [BaseTools dismissHUD];
//                            [BaseTools showErrorMessage:@"请登录后再操作"];
//                            dispatch_async(dispatch_get_main_queue(), ^{
//
//                                [BaseTools alertLoginWithVC:self];
//                            });
//                        }else if ([responseObject[@"code"] isEqualToString:@"100"]){//直接购买成功（实体物品不会走）
//                            [[OpenInstallSDK defaultManager] reportEffectPoint:@"creatOrder" effectValue:1];
//                            [[OpenInstallSDK defaultManager] reportEffectPoint:@"pay" effectValue:1];
//                            [BaseTools dismissHUD];
//                            [BaseTools showErrorMessage:responseObject[@"msg"]];
//                            self.token = responseObject[@"data"][@"token"];
//                            KPostNotification(@"PaySuccess", nil);
//                            KPostNotification(KNotificationLoginUpdata, nil);
//                            dispatch_async(dispatch_get_main_queue(), ^{
//
//                                PaySuccessViewController *vc = [[PaySuccessViewController alloc]init];
//                                vc.dataDict = dict;
//                                vc.type = isGroup;
//                                vc.token = self.token;
//                                vc.group_buy_goods_rule_id = self.group_buy_goods_rule_id;
//                                [self.navigationController pushViewController:vc animated:YES];
//                            });
//                        }else{
//                            [BaseTools dismissHUD];
//                            [BaseTools showErrorMessage:responseObject[@"msg"]];
//                        }
//
//                    } failure:^(NSError *error) {
//                        [BaseTools dismissHUD];
//                    }];
//                }
//            }
//
//
//        }else{
//            if ([limitPrice doubleValue]>[dict[@"user_account"] doubleValue]) {
//                [BaseTools showErrorMessage:@"余额不足请充值"];
//                XSIAPViewController *vc = [[XSIAPViewController alloc]init];
//                vc.money = dict[@"user_account"];
//                [self.navigationController pushViewController:vc animated:YES];
//            }else{
//
//                NSMutableDictionary *parmDic = [NSMutableDictionary dictionary];
//                [parmDic setObject:self.goodID  forKey:@"goods_id"];
//                [parmDic setObject:self.goodType forKey:@"type"];
//                [parmDic setObject:@"0" forKey:@"is_coin"];
//                [parmDic setObject:coupon_id forKey:@"coupon_id"];
//                [parmDic setObject:@"0" forKey:@"account"];
//                [parmDic setObject:@"1" forKey:@"is_account"];
//                [parmDic setObject:[NSString stringWithFormat:@"%ld",(long)num]  forKey:@"goods_num"];
//                [parmDic setObject:@"" forKey:@"address"];
//                [parmDic setObject:@""  forKey:@"receiver"];
//                [parmDic setObject:@"" forKey:@"receiver_mobile"];
//                [parmDic setObject:self.group_buy_goods_rule_id  forKey:@"group_buy_goods_rule_id"];
//                [parmDic setObject:self.token forKey:@"token"];
//
//                if ([dict[@"price_info"][@"seckill_goods_id"] length] != 0) {
//                    [parmDic setObject:dict[@"price_info"][@"seckill_goods_id"] forKey:@"seckill_goods_id"];
//                }
//                if (self.dist_id.length !=0) {
//                    [parmDic setObject:self.dist_id forKey:@"dist_id"];
//                }
//                [ZMNetworkHelper POST:@"/order/generate_order" parameters:parmDic cache:NO responseCache:^(id responseCache) {
//
//                } success:^(id responseObject) {
//                    if ([responseObject[@"code"] isEqualToString:@"0"]) {
//                        [[OpenInstallSDK defaultManager] reportEffectPoint:@"creatOrder" effectValue:1];
//                        [BaseTools dismissHUD];
//                        data = responseObject[@"data"];
//                        //                        [self popView];
//
//                    }else if ([responseObject[@"code"] isEqualToString:@"-10000"]){
//                        [BaseTools dismissHUD];
//                        [BaseTools showErrorMessage:@"请登录后再操作"];
//                        dispatch_async(dispatch_get_main_queue(), ^{
//
//                            [BaseTools alertLoginWithVC:self];
//                        });
//                    }else if ([responseObject[@"code"] isEqualToString:@"100"]){//直接购买成功（实体物品不会走）
//                        [[OpenInstallSDK defaultManager] reportEffectPoint:@"creatOrder" effectValue:1];
//                        [[OpenInstallSDK defaultManager] reportEffectPoint:@"pay" effectValue:1];
//                        [BaseTools dismissHUD];
//                        [BaseTools showErrorMessage:responseObject[@"msg"]];
//                        self.token = responseObject[@"data"][@"token"];
//                        KPostNotification(@"PaySuccess", nil);
//                        KPostNotification(KNotificationLoginUpdata, nil);
//                        dispatch_async(dispatch_get_main_queue(), ^{
//                            PaySuccessViewController *vc = [[PaySuccessViewController alloc]init];
//                            vc.dataDict = dict;
//                            vc.type = isGroup;
//                            vc.token = self.token;
//                            vc.group_buy_goods_rule_id = self.group_buy_goods_rule_id;
//                            [self.navigationController pushViewController:vc animated:YES];
//                        });
//                    }else{
//                        [BaseTools dismissHUD];
//                        [BaseTools showErrorMessage:responseObject[@"msg"]];
//                    }
//
//                } failure:^(NSError *error) {
//                    [BaseTools dismissHUD];
//                }];
//            }
//
//
//        }
//    }
//
//}
/**
 *   使用苹果内购  goods_type 1 3永远使用内购  或者 审核中的 非 图书商品
 */
- (void)useIAPPay{//优先使用余额
    if ([dict[@"is_ship"] isEqualToString:@"1"] ) {//判断用不用填写收获地址 1用 else不用
        if (self.address_name.text.length==0 || self.address_tel.text.length  == 0 || self.address_ad.text.length == 0||self.address_name.text == nil || self.address_tel.text == nil || self.address_ad.text == nil) {
            [BaseTools showErrorMessage:@"请输入收货人的相关信息"];
            
        }else{
            if ([limitPrice doubleValue]>[dict[@"user_account"] doubleValue]) {//判断余额是否充足
                [BaseTools showErrorMessage:@"余额不足请充值"];
                XSIAPViewController *vc = [[XSIAPViewController alloc]init];
                vc.money = dict[@"user_account"];
                [self.navigationController pushViewController:vc animated:YES];
            }else{//余额充足
                [self postGenerateOrderDataIsUseBalance:@"1"];
            }
        }
    }else{
        if ([limitPrice doubleValue]>[dict[@"user_account"] doubleValue]) {//判断余额是否充足
            [BaseTools showErrorMessage:@"余额不足请充值"];
            XSIAPViewController *vc = [[XSIAPViewController alloc]init];
            vc.money = dict[@"user_account"];
            [self.navigationController pushViewController:vc animated:YES];
        }else{//余额充足
            [self postGenerateOrderDataIsUseBalance:@"1"];
        }
    }
}
/**
 *   使用第三方支付  goods_type 4 永远使用支付宝和微信 或者 审核过后的 非 goodstype = 1 3 类商品
 */
- (void)useThridPay{//都不使用余额
    if ([dict[@"is_ship"] isEqualToString:@"1"] ) {//判断用不用填写收获地址 1用 else不用
        if (self.address_name.text.length==0 || self.address_tel.text.length  == 0 || self.address_ad.text.length == 0||self.address_name.text == nil || self.address_tel.text == nil || self.address_ad.text == nil) {
            [BaseTools showErrorMessage:@"请输入收货人的相关信息"];
        }else{
            [self postGenerateOrderDataIsUseBalance:@"0"];
        }
    }else{
        [self postGenerateOrderDataIsUseBalance:@"0"];
    }
}
/**
 *   下单时是否用余额 余额充足下单时直接购买
 */
- (void)postGenerateOrderDataIsUseBalance:(NSString *)is_useBalance{
    [BaseTools showProgressMessage:@""];
    NSMutableDictionary *parmDic = [NSMutableDictionary dictionary];
    [parmDic setObject:self.goodID  forKey:@"goods_id"];
    [parmDic setObject:self.goodType forKey:@"type"];
    [parmDic setObject:@"0" forKey:@"is_coin"];
    [parmDic setObject:coupon_id forKey:@"coupon_id"];
    [parmDic setObject:is_useBalance forKey:@"is_account"];
    [parmDic setObject:@"0" forKey:@"account"];
    [parmDic setObject:[NSString stringWithFormat:@"%ld",(long)num]  forKey:@"goods_num"];
    [parmDic setObject:self.address_ad.text forKey:@"address"];
    [parmDic setObject:self.address_name.text  forKey:@"receiver"];
    [parmDic setObject:self.address_tel.text forKey:@"receive_mobile"];
    [parmDic setObject:self.group_buy_goods_rule_id  forKey:@"group_buy_goods_rule_id"];
    [parmDic setObject:self.token forKey:@"token"];
    if ([dict[@"price_info"][@"seckill_goods_id"] length] != 0) {
        [parmDic setObject:dict[@"price_info"][@"seckill_goods_id"] forKey:@"seckill_goods_id"];
    }
    if (self.dist_id.length !=0) {
        [parmDic setObject:self.dist_id forKey:@"dist_id"];
    }
    BADataEntity *entity = [BADataEntity new];
    entity.urlString = @"/order/generate_order";
    entity.needCache = NO;
    entity.parameters = parmDic;
    // 如果打印数据不完整，是因为 Xcode 8 版本问题，请下断点打印数据
    [BANetManager ba_request_POSTWithEntity:entity successBlock:^(id response) {
        
        if (response == nil) {
            
        }else{
            if ([response[@"code"] isEqualToString:@"0"]) {//余额充足下单时直接购买不会走这里
                [[OpenInstallSDK defaultManager] reportEffectPoint:@"creatOrder" effectValue:1];
                [BaseTools dismissHUD];
                data = response[@"data"];
                if (![is_useBalance isEqualToString:@"1"]) {
                    [self popView];
                }
            }else if ([response[@"code"] isEqualToString:@"-10000"]){
                [BaseTools dismissHUD];
                [BaseTools showErrorMessage:@"请登录后再操作"];
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [BaseTools alertLoginWithVC:self];
                });
            }else if ([response[@"code"] isEqualToString:@"100"]){//直接购买成功（实体物品不会走）
                [[OpenInstallSDK defaultManager] reportEffectPoint:@"creatOrder" effectValue:1];
                [[OpenInstallSDK defaultManager] reportEffectPoint:@"pay" effectValue:1];
                [BaseTools dismissHUD];
                [BaseTools showErrorMessage:response[@"msg"]];
                self.token = response[@"data"][@"token"];
                KPostNotification(@"PaySuccess", nil);
                KPostNotification(KNotificationLoginUpdata, nil);
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    PaySuccessViewController *vc = [[PaySuccessViewController alloc]init];
                    vc.dataDict = dict;
                    vc.type = isGroup;
                    vc.token = self.token;
                    vc.group_buy_goods_rule_id = self.group_buy_goods_rule_id;
                    [self.navigationController pushViewController:vc animated:YES];
                });
            }else{
                [BaseTools dismissHUD];
                [BaseTools showErrorMessage:response[@"msg"]];
            }
        }
      
    } failureBlock:^(NSError *error) {
        [BaseTools dismissHUD];
    } progressBlock:^(int64_t bytesProgress, int64_t totalBytesProgress) {
        /*! 封装方法里已经回到主线程，所有这里不用再调主线程了 */
        
    }];
}

-(void)popView{

    //通知主线程刷新
    dispatch_async(dispatch_get_main_queue(), ^{
        OnlinePayment *messageView = [[OnlinePayment alloc] initWithDoneBlock:nil];
        messageView.dicts = data;
        CGPoint showCenter = CGPointMake(SCREEN_WIDTH/2,SCREEN_HEIGHT-messageView.height/2);
        [SGBrowserView showMoveView:messageView moveToCenter:showCenter];
        messageView.myFailureBlock = ^{
            [SGBrowserView hide];
        };
        messageView.myBlock = ^{
            PaySuccessViewController *vc = [[PaySuccessViewController alloc]init];
            vc.dataDict = dict;
            vc.type = isGroup;
            vc.token = self.token;
            vc.group_buy_goods_rule_id = self.group_buy_goods_rule_id;
            [self.navigationController pushViewController:vc animated:YES];
            [SGBrowserView hide];

        };
    });
   
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
