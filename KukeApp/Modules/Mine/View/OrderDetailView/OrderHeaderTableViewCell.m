//
//  OrderHeaderTableViewCell.m
//  KukeApp
//
//  Created by 库课 on 2019/1/3.
//  Copyright © 2019 zhangming. All rights reserved.
//

#import "OrderHeaderTableViewCell.h"
#import "ReturnGoodsViewController.h"
#import "EvaluateViewController.h"
#import "PayMentViewController.h"
#import "OnlinePayment.h"
#import "OrderAllStateViewController.h"
#import "PaySuccessViewController.h"
#import "CancelOrderView.h"
@implementation OrderHeaderTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.cancelBtn.layer.borderWidth = 0.5;
    self.cancelBtn.layer.borderColor = [[UIColor blackColor] CGColor];
    self.cancelBtn.layer.cornerRadius = 3;
    self.cancelBtn.layer.masksToBounds = YES;
    
    self.afterSaleBtn.layer.borderWidth = 0.5;
    self.afterSaleBtn.layer.borderColor = [[UIColor blackColor] CGColor];
    self.afterSaleBtn.layer.cornerRadius = 3;
    self.afterSaleBtn.layer.masksToBounds = YES;

    self.shareBtn.layer.cornerRadius = 3;
    self.shareBtn.layer.masksToBounds = YES;
    
    self.afterSale_right.layer.borderWidth = 0.5;
    self.afterSale_right.layer.borderColor = [[UIColor blackColor] CGColor];
    self.afterSale_right.layer.cornerRadius = 3;
    self.afterSale_right.layer.masksToBounds = YES;
    
    self.payBtn.layer.cornerRadius = 3;
    self.payBtn.layer.masksToBounds = YES;
    
    self.evaluationBtn.layer.cornerRadius = 3;
    self.evaluationBtn.layer.masksToBounds = YES;
    
    self.ReceivingBtn.layer.cornerRadius = 3;
    self.ReceivingBtn.layer.masksToBounds = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(payResultStatus:)
                                                 name:KNotificationPayResultStatus
                                               object:nil];

}
-(void)setModel:(NSDictionary *)model{
    self.data = model;
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)allState:(id)sender {
    OrderAllStateViewController *vc = [[OrderAllStateViewController alloc]init];
    vc.order_sn = self.data[@"order_sn"];
    [[[AppDelegate shareAppDelegate] getCurrentUIVC].navigationController pushViewController:vc animated:YES];
}
- (IBAction)cancelAction:(id)sender {
    [self cancelOrder];
//    BaseAlertView *deliveryView = [[BaseAlertView alloc]initWithFrame:CGRectMake(30, 120, screenWidth()-60, 150) title:@"确定取消该订单吗？" leftBtn:@"否" rightBtn:@"是"];
//    [SGBrowserView showZoomView:deliveryView yDistance:20];
//    [deliveryView.NOBtn addTarget:self action:@selector(noAction) forControlEvents:(UIControlEventTouchUpInside)];
//    [deliveryView.YesBtn addTarget:self action:@selector(yesAction) forControlEvents:(UIControlEventTouchUpInside)];
}

- (void)noAction{
    [SGBrowserView hide];
}
- (void)yesAction{
    [self cancelOrder];
    [SGBrowserView hide];
}

#pragma mark ————— 付款状态通知 —————
- (void)payResultStatus:(NSNotification *)notification
{
    BOOL paySuccess = [notification.object boolValue];
    
    if (paySuccess) {//登陆成功加载主窗口控制器
        PaySuccessViewController *vc = [[PaySuccessViewController alloc]init];
        vc.dataDict =  self.data[@"goods"];
        [[[AppDelegate shareAppDelegate] getCurrentUIVC].navigationController pushViewController:vc animated:YES];
        [SGBrowserView hide];
    }else{
        [SGBrowserView hide];
    }
    
    
}
- (IBAction)shareAction:(id)sender {
    NSString *urlString = [NSString stringWithFormat:@"%@/join_group_detail/%@/%@", SERVER_HOSTPC,self.data[@"token"],self.data[@"group_buy_goods_rule_id"]];
    
    if (self.shareBlock) {
        self.shareBlock(urlString, self.data[@"goods"][@"goods_name"]);
    }
}
- (IBAction)payAction:(id)sender {
   
    //    PayMentViewController *vc = [[PayMentViewController alloc]init];
    //    vc.goodID = model.goods[@"goods_id"];
    //    vc.goodType = model.goods[@"goods_type"];
    //    vc.order_sn = model.order_sn;
    //    vc.isOrder = @"1";
    //    [self.navigationController pushViewController:vc animated:YES];
    //
    //    dispatch_async(dispatch_get_main_queue(), ^{
    OnlinePayment *messageView = [[OnlinePayment alloc] initWithDoneBlock:nil];
    messageView.dicts = self.data;
    //        messageView.balance.text = [NSString stringWithFormat:@"我的余额:%@",dict[@"user_account"]];
    CGPoint showCenter = CGPointMake(SCREEN_WIDTH/2,SCREEN_HEIGHT-messageView.height/2);
    [SGBrowserView showMoveView:messageView moveToCenter:showCenter];
    messageView.myFailureBlock = ^{
        [SGBrowserView hide];
    };
    messageView.myBlock = ^{
        NSArray *controllers =  [[AppDelegate shareAppDelegate] getCurrentUIVC].navigationController.viewControllers;
        if ([controllers[controllers.count-2] isMemberOfClass:NSClassFromString(@"MyOrderViewController")] || [controllers[controllers.count-2] isMemberOfClass:NSClassFromString(@"CourseDetailViewController")]) {//如果倒数第二个为确认页面
            [[[AppDelegate shareAppDelegate] getCurrentUIVC].navigationController popToViewController:controllers[controllers.count-3] animated:YES];
        } else {
            [[[AppDelegate shareAppDelegate] getCurrentUIVC].navigationController popViewControllerAnimated:YES];
        }
    };
    //    });
}
- (IBAction)receivingAction:(id)sender {
    [self receiptOrder];
}
- (IBAction)evaluationAction:(id)sender {
    EvaluateViewController *vc = [[EvaluateViewController alloc]init];
    vc.data = self.data;
    [[[AppDelegate shareAppDelegate] getCurrentUIVC].navigationController pushViewController:vc animated:YES];
}
- (IBAction)afterSaleAction:(id)sender {
    ReturnGoodsViewController *vc = [[ReturnGoodsViewController alloc]init];
    vc.data = self.data;
    [[[AppDelegate shareAppDelegate] getCurrentUIVC].navigationController pushViewController:vc animated:YES];
    
}
- (IBAction)afterSale_right:(id)sender {
    ReturnGoodsViewController *vc = [[ReturnGoodsViewController alloc]init];
    vc.data = self.data;
    [[[AppDelegate shareAppDelegate] getCurrentUIVC].navigationController pushViewController:vc animated:YES];
    
}
- (void)cancelOrder{
    
    NSArray *payTypeArr = @[@{@"pic":@"pic_alipay",
                              @"title":@"授课老师/课程内容不合适",
                              @"type":@"alipay"},
                            @{@"pic":@"pic_wxpay",
                              @"title":@"平台/视频效果不佳",
                              @"type":@"wxpay"},
                            @{@"pic":@"pic_blance",
                              @"title":@"多买/买错/更换",
                              @"type":@"balance"},
                            @{@"pic":@"pic_blance",
                              @"title":@"其他原因",
                              @"type":@"balance"}];
    
    CancelOrderView *pop = [[CancelOrderView alloc]initTovc:[[AppDelegate shareAppDelegate] getCurrentUIVC] dataSource:payTypeArr];
    STPopupController *popVericodeController = [[STPopupController alloc] initWithRootViewController:pop];
    popVericodeController.style = STPopupStyleBottomSheet;
    [popVericodeController presentInViewController:[[AppDelegate shareAppDelegate] getCurrentUIVC]];
    
    pop.payType = ^(NSString *type,NSString *balance) {
        NSMutableDictionary *parmDic = [NSMutableDictionary dictionary];
        [parmDic setObject:self.data[@"order_sn"] forKey:@"order_sn"];
        [parmDic setObject:type forKey:@"cancel_reason"];
        [ZMNetworkHelper POST:@"/order_handler/cancel" parameters:parmDic cache:YES responseCache:^(id responseCache) {
            
        } success:^(id responseObject) {
            
            [[OpenInstallSDK defaultManager] reportEffectPoint:@"cancelorder" effectValue:1];
            if (responseObject == nil) {
                
            }else{
                if ([responseObject[@"code"] isEqualToString:@"0"]) {
                    [BaseTools showErrorMessage:responseObject[@"msg"]];
                    dispatch_async(dispatch_get_main_queue(), ^{
//                        [[[AppDelegate shareAppDelegate] getCurrentUIVC].navigationController popViewControllerAnimated:YES];
                        KPostNotification(KNotificationLoginUpdata, nil);
                    });
                }else if ([responseObject[@"code"] isEqualToString:@"-10000"]){
                    [BaseTools showErrorMessage:@"请登录后再操作"];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        [BaseTools alertLoginWithVC:[[AppDelegate shareAppDelegate]getCurrentUIVC]];
                    });
                }else{
                    [BaseTools showErrorMessage:responseObject[@"msg"]];
                }
            }
        } failure:^(NSError *error) {
            
        }];
    };
    
    
    
    
}
- (void)receiptOrder{
    NSMutableDictionary *parmDic = [NSMutableDictionary dictionary];
    [parmDic setObject:self.data[@"order_sn"]  forKey:@"order_sn"];
    
    [ZMNetworkHelper POST:@"/order_handler/confirm" parameters:parmDic cache:YES responseCache:^(id responseCache) {
        
    } success:^(id responseObject) {
        if (responseObject == nil) {
            
        }else{
            if ([responseObject[@"code"] isEqualToString:@"0"]) {
                [BaseTools showErrorMessage:responseObject[@"msg"]];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[[AppDelegate shareAppDelegate] getCurrentUIVC].navigationController popViewControllerAnimated:YES];
                    KPostNotification(KNotificationLoginUpdata, nil);
                });
            }else if ([responseObject[@"code"] isEqualToString:@"-10000"]){
                [BaseTools showErrorMessage:@"请登录后再操作"];
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [BaseTools alertLoginWithVC:[[AppDelegate shareAppDelegate]getCurrentUIVC]];
                });
            }else{
                [BaseTools showErrorMessage:responseObject[@"msg"]];
            }
        }
    } failure:^(NSError *error) {
        
    }];
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

@end
