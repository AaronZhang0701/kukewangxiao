//
//  MyOrderTableViewCell.m
//  KukeApp
//
//  Created by iOSDeveloper on 2018/10/22.
//  Copyright © 2018年 zhangming. All rights reserved.
//

#import "MyOrderTableViewCell.h"
#import "OYCountDownManager.h"
#import "CancelOrderView.h"
@implementation MyOrderTableViewCell{
    NSTimer   *_timer;
    NSInteger _second;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerRun:) userInfo:nil repeats:YES];
    //将定时器加入NSRunLoop，保证滑动表时，UI依然刷新
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
}


- (void)setModel:(MyOrderDataModel *)model{
    self.data = model;
    self.timeLab.text = [BaseTools getDateStringWithTimeStr:model.order_time];
    
    self.ohterBtn.layer.borderWidth = 0.5;
    self.ohterBtn.layer.borderColor = [[UIColor blackColor] CGColor];
    self.ohterBtn.layer.cornerRadius = 3;
    self.ohterBtn.layer.masksToBounds = YES;
    
    self.afterSaleBtn.layer.borderWidth = 0.5;
    self.afterSaleBtn.layer.borderColor = [[UIColor blackColor] CGColor];
    self.afterSaleBtn.layer.cornerRadius = 3;
    self.afterSaleBtn.layer.masksToBounds = YES;
    
    self.seeDetialBtn.layer.borderWidth = 0.5;
    self.seeDetialBtn.layer.borderColor = [[UIColor blackColor] CGColor];
    self.seeDetialBtn.layer.cornerRadius = 3;
    self.seeDetialBtn.layer.masksToBounds = YES;

    
    self.payAction.layer.cornerRadius = 3;
    self.payAction.layer.masksToBounds = YES;
    
    self.shareBtn.layer.cornerRadius = 3;
    self.shareBtn.layer.masksToBounds = YES;
    
    self.evaluateBtn.layer.cornerRadius = 3;
    self.evaluateBtn.layer.masksToBounds = YES;
    
    self.receipetBtn.layer.cornerRadius = 3;
    self.receipetBtn.layer.masksToBounds = YES;
    
    self.price.text = [NSString stringWithFormat:@"%@",model.order_price];
    [self.orderStatus setTitle:model.status_name forState:(UIControlStateNormal)];
    
    
    self.pic.layer.cornerRadius = 5;
    self.pic.layer.masksToBounds = YES;

    if ([model.order_type isEqualToString:@"3"]) {
        self.groupStatusLab.hidden = NO;
        if ([model.group_status isEqualToString:@"0"]) {
            [self.groupStatusLab setTitle:@"拼团中" forState:(UIControlStateNormal)];
        }else if ([model.group_status isEqualToString:@"1"]) {
            [self.groupStatusLab setTitle:@"拼团成功" forState:(UIControlStateNormal)];
        }else if ([model.group_status isEqualToString:@"2"]) {
            [self.groupStatusLab setTitle:@"拼团失败" forState:(UIControlStateNormal)];
        }
        
        
    }
    
    
//    if ([[model.goods valueForKey:@"goods_type"] isEqualToString:@"4"]) {
//        self.pic.frame = CGRectMake((105-70/3*2)/2, 55, 105/3*2,70);
//    }else{
        self.pic.frame = CGRectMake(15, 55, 105, 70);
//    }
    
    self.name.text = [model.goods valueForKey:@"goods_name"];
    [self.pic sd_setImageWithURL:[NSURL URLWithString:[model.goods valueForKey:@"goods_image"]] placeholderImage:[UIImage imageNamed:@"goodsImage"]];
    switch ([model.order_status integerValue]) {
        case 0:
        {
            self.payPrice.text = [NSString stringWithFormat:@"应付:%@",model.third_pay];
            self.groupStatusLab.hidden = YES;
            NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"应付：%@",model.third_pay]];
            [attributeStr addAttribute:NSForegroundColorAttributeName value:CNavBgColor range:NSMakeRange(3,attributeStr.length-3)];
            self.payPrice.attributedText = attributeStr;
            
            
        };
            break;
            
        case 1:
        {
            self.payPrice.text = [NSString stringWithFormat:@"实付:%@",model.third_pay];
            self.endTime.hidden = YES;
            self.seeDetialBtn.hidden = NO;
            if ([model.allow_apply isEqualToString:@"0"]) {
                
            }else{
                self.afterSaleBtn.hidden = NO;
            }
            
        };
            break;
        case 2:
        {
            
            self.payPrice.text = [NSString stringWithFormat:@"实付:%@",model.third_pay];
            self.endTime.hidden = YES;
            
            self.receipetBtn.hidden = NO;

            
        };
            break;
        case 3:
         
           
            
            self.payPrice.text = [NSString stringWithFormat:@"实付:%@",model.third_pay];
            self.endTime.hidden = YES;
            self.groupStatusLab.hidden = YES;
            self.seeDetialBtn.hidden = NO;
            
            break;
        case 4:
        {
            if ([model.is_discuss isEqualToString:@"0"]) {
              
                [self.orderStatus setTitle:@"未评价" forState:(UIControlStateNormal)];
                [self.orderStatus setTitleColor:[UIColor colorWithHexString:@"41a45f"] forState:(UIControlStateNormal)];
                self.payPrice.text = [NSString stringWithFormat:@"实付:%@",model.third_pay];
                self.endTime.hidden = YES;
                if ([model.allow_apply isEqualToString:@"0"]) {
                    
                }else{
                    self.afterSaleBtn.hidden = NO;
                }
                self.evaluateBtn.hidden = NO;
            }else{
                [self.orderStatus setTitle:@"已评价" forState:(UIControlStateNormal)];
                self.payPrice.text = [NSString stringWithFormat:@"实付:%@",model.third_pay];
                self.endTime.hidden = YES;
                if ([model.allow_apply isEqualToString:@"0"]) {
                    
                }else{
                    self.afterSaleBtn.hidden = NO;
                }
                self.seeDetialBtn.hidden = NO;
            }
    
        };
            break;
        case 5:
        {
            
            [self.orderStatus setTitleColor:CNavBgColor forState:(UIControlStateNormal)];
            
            self.payPrice.text = [NSString stringWithFormat:@"实付:%@",model.third_pay];
            self.endTime.hidden = YES;
            self.seeDetialBtn.hidden = NO;

            
        };
            break;
        case 6:
            
            
            [self.orderStatus setTitleColor:CNavBgColor forState:(UIControlStateNormal)];
            
            self.payPrice.text = [NSString stringWithFormat:@"实付:%@",model.third_pay];
            self.endTime.hidden = YES;
            self.seeDetialBtn.hidden = NO;

            
            break;
        case 7:
            [self.orderStatus setTitleColor:CNavBgColor forState:(UIControlStateNormal)];
            
            self.payPrice.text = [NSString stringWithFormat:@"实付:%@",model.third_pay];
            self.endTime.hidden = YES;
            self.seeDetialBtn.hidden = NO;

            break;
        case 8:
             [self.orderStatus setTitleColor:[UIColor colorWithHexString:@"41a45f"] forState:(UIControlStateNormal)];
            
            self.payPrice.text = [NSString stringWithFormat:@"实付:%@",model.third_pay];
            self.endTime.hidden = YES;
            self.seeDetialBtn.hidden = NO;

            break;
        case 100:
            [self.orderStatus setTitleColor:CNavBgColor forState:(UIControlStateNormal)];
            self.payPrice.text = [NSString stringWithFormat:@"实付:%@",model.third_pay];
            self.endTime.hidden = NO;
            self.shareBtn.hidden = NO;
            self.seeDetialBtn.hidden = NO;
            
            break;
        default:
            break;
    }
    
    
    
    
    
}
- (IBAction)seeDetiel:(id)sender {
    //添加 字典，将label的值通过key值设置传递
    NSDictionary *dict =[[NSDictionary alloc]initWithObjectsAndKeys:self.data,@"Order_data", nil];
    KPostNotification(@"MyOrderDetail",dict);
}
- (void)payActions{
    NSDictionary *dict =[[NSDictionary alloc]initWithObjectsAndKeys:self.data,@"Order_data", nil];
    KPostNotification(@"MyOrderPay",dict);
}
//- (void)cancelAction{
//    [self cancelOrder];
////    BaseAlertView *deliveryView = [[BaseAlertView alloc]initWithFrame:CGRectMake(30, 120, screenWidth()-60, 150) title:@"确定取消该订单吗？" leftBtn:@"否" rightBtn:@"是"];
////    [SGBrowserView showZoomView:deliveryView yDistance:20];
////    [deliveryView.NOBtn addTarget:self action:@selector(noAction) forControlEvents:(UIControlEventTouchUpInside)];
////    [deliveryView.YesBtn addTarget:self action:@selector(yesAction) forControlEvents:(UIControlEventTouchUpInside)];
// 
//}
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
        [parmDic setObject:self.data.order_sn forKey:@"order_sn"];
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
- (void)afterSaleAction{
    NSDictionary *dict =[[NSDictionary alloc]initWithObjectsAndKeys:self.data.order_sn,@"Order_sn", nil];
    KPostNotification(@"AfterSale",dict);
}
- (void)noAction{
    [SGBrowserView hide];
}
- (void)yesAction{
    if (self.cancelActionBlock) {
        self.cancelActionBlock(self.data.order_sn);
    }
    [SGBrowserView hide];
}
- (void)receiptAction{
    if (self.receiptActionBlock) {
        self.receiptActionBlock(self.data.order_sn);
    }
}
- (void)logisticsAction{
    NSDictionary *dict =[[NSDictionary alloc]initWithObjectsAndKeys:self.data.order_sn,@"Order_sn", nil];
    KPostNotification(@"MyOrderLogistics",dict);
}
- (void)evaliateAction{
    NSDictionary *dict =[[NSDictionary alloc]initWithObjectsAndKeys:self.data,@"Order_data", nil];
    KPostNotification(@"MyOrdeEvaliate",dict);
}
- (void)deleteAction{
    BaseAlertView *deliveryView = [[BaseAlertView alloc]initWithFrame:CGRectMake(30, 120, screenWidth()-60, 150) title:@"确定删除该订单吗？" leftBtn:@"否" rightBtn:@"是"];
    [SGBrowserView showZoomView:deliveryView yDistance:20];
    [deliveryView.NOBtn addTarget:self action:@selector(delete) forControlEvents:(UIControlEventTouchUpInside)];
    [deliveryView.YesBtn addTarget:self action:@selector(noDelete) forControlEvents:(UIControlEventTouchUpInside)];
    
}
- (void)delete{
    [SGBrowserView hide];
}
- (void)noDelete{
    
    if (self.deleteActionBlock) {
        self.deleteActionBlock(self.data.order_sn);
    }
    [SGBrowserView hide];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)seeDetialAction:(id)sender {
    NSDictionary *dict =[[NSDictionary alloc]initWithObjectsAndKeys:self.data,@"Order_data", nil];
    KPostNotification(@"MyOrderDetail",dict);
}
- (IBAction)afterSaleAction:(id)sender {
    NSDictionary *dict =[[NSDictionary alloc]initWithObjectsAndKeys:self.data,@"Order_data", nil];
    KPostNotification(@"AfterSale",dict);
}
- (IBAction)payAction:(id)sender {
    NSDictionary *dict =[[NSDictionary alloc]initWithObjectsAndKeys:self.data,@"Order_data", nil];
    KPostNotification(@"MyOrderPay",dict);
}
- (IBAction)receiptAction:(id)sender {
    if (self.receiptActionBlock) {
        self.receiptActionBlock(self.data.order_sn);
    }
}
- (IBAction)evaluateAction:(id)sender {
    NSDictionary *dict =[[NSDictionary alloc]initWithObjectsAndKeys:self.data,@"Order_data", nil];
    KPostNotification(@"MyOrdeEvaliate",dict);
}
- (IBAction)cancelAction:(id)sender {
    [self cancelOrder];
//    BaseAlertView *deliveryView = [[BaseAlertView alloc]initWithFrame:CGRectMake(30, 120, screenWidth()-60, 150) title:@"确定取消该订单吗？" leftBtn:@"否" rightBtn:@"是"];
//    [SGBrowserView showZoomView:deliveryView yDistance:20];
//    [deliveryView.NOBtn addTarget:self action:@selector(noAction) forControlEvents:(UIControlEventTouchUpInside)];
//    [deliveryView.YesBtn addTarget:self action:@selector(yesAction) forControlEvents:(UIControlEventTouchUpInside)];
}
- (IBAction)shareAction:(id)sender {
    NSString *urlString = [NSString stringWithFormat:@"%@/join_group_detail/%@/%@", SERVER_HOSTPC,self.data.token,self.data.group_buy_goods_rule_id];

    if (self.shareBlock) {
        self.shareBlock(urlString, self.data.goods[@"goods_name"]);
    }
    
}

- (void)setConfigWithSecond:(NSInteger)second {
    _second = second;
    if (_second > 0) {
        
        NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"剩余时间:%@",[self ll_timeWithSecond:_second]]];
        [attributeStr addAttribute:NSForegroundColorAttributeName value:CNavBgColor range:NSMakeRange(5,attributeStr.length-5)];
        self.endTime.attributedText = attributeStr;
    }
    else {
       self.endTime.hidden  = YES;
    }
}

- (void)timerRun:(NSTimer *)timer {
    if (_second > 0) {
        NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"剩余时间:%@",[self ll_timeWithSecond:_second]]];
        [attributeStr addAttribute:NSForegroundColorAttributeName value:CNavBgColor range:NSMakeRange(5,attributeStr.length-5)];
        self.endTime.attributedText = attributeStr;
        
        
        _second -= 1;
    }
    else {
        self.endTime.hidden  = YES;
    }
}

//重写父类方法，保证定时器被销毁
- (void)removeFromSuperview {
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
    [super removeFromSuperview];
}

//将秒数转换为字符串格式
- (NSString *)ll_timeWithSecond:(NSInteger)second
{
    NSString *time;
    if (second < 60) {
        time = [NSString stringWithFormat:@"00:00:%02ld",(long)second];
    }
    else {
        if (second < 3600) {
            time = [NSString stringWithFormat:@"00:%02ld:%02ld",second/60,second%60];
        }
        else {
            time = [NSString stringWithFormat:@"%02ld:%02ld:%02ld",second/3600,(second-second/3600*3600)/60,second%60];
        }
    }
    return time;
}

- (void)dealloc {
    NSLog(@"cell释放");
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

@end
