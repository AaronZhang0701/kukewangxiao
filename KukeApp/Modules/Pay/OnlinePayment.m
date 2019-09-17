//
//  OnlinePayment.m
//  KukeApp
//
//  Created by iOSDeveloper on 2018/10/23.
//  Copyright © 2018年 zhangming. All rights reserved.
//

#import "OnlinePayment.h"

@interface OnlinePayment(){
    NSDictionary *data;
}

@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (nonatomic,copy) void(^doneBlock)(OnlinePayment *view,NSInteger selectedIndex);

@end
@implementation OnlinePayment
- (instancetype)initWithDoneBlock:(void(^)(OnlinePayment *view,NSInteger selectedIndex))block
{
    CGRect frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 300);
    self = [super initWithFrame:frame];
    if (self) {
        self.doneBlock = block;
        self.contentView = [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass([self class]) owner:self options:nil] firstObject];//(owner:self ，firstObject必要)
        self.contentView.frame = self.bounds;
        [self addSubview:self.contentView];
        self.timeLab.layer.cornerRadius = 13;
        self.timeLab.layer.masksToBounds = YES;
        
        [[ZMTimeCountDown ShareManager] zj_timeDestoryTimer];

    }
    return self;
}

- (void)setDicts:(NSDictionary *)dicts{
    data = dicts;

    //倒计时
    [[ZMTimeCountDown ShareManager] zj_timeCountDownWithStartTimeStamp:[[BaseTools currentTimeStr] longLongValue] endTimeStamp:[data[@"auto_end_time"] longLongValue]*1000 completeBlock:^(NSInteger day, NSInteger hour, NSInteger minute, NSInteger second) {
        self.timeLab.text = [NSString stringWithFormat:@"支付剩余时间:%02ld:%02ld:%02ld",hour,minute,second];
    }];
    
    
}
- (IBAction)suerAction:(id)sender {
    if (!self.twoBtn.selected && !self.threeBtn.selected) {
        [BaseTools showErrorMessage:@"请选择支付方式"];
        return;
    }
    
    NSString *str = nil;
    if (self.twoBtn.selected) {
        str = @"1";
    }
    if(self.threeBtn.selected){
        str = @"0";
    }
    NSMutableDictionary *parmDic = [NSMutableDictionary dictionary];
    [parmDic setObject:data[@"order_id"]  forKey:@"order_id"];
    [parmDic setObject:data[@"order_sn"]  forKey:@"order_sn"];
    [parmDic setObject:str forKey:@"pay_type"];
    [ZMNetworkHelper POST:@"/order/pay" parameters:parmDic cache:NO responseCache:^(id responseCache) {
        
    } success:^(id responseObject) {
        if ([responseObject[@"code"] isEqualToString:@"0"]) {
            [[OpenInstallSDK defaultManager] reportEffectPoint:@"pay" effectValue:1];
            
            if (self.twoBtn.selected) {
               [self wxpayCallBack:responseObject[@"data"]];
            }
            if(self.threeBtn.selected){
                [self alipayCallBack:responseObject[@"data"]];
            }
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
- (void)alipayCallBack:(NSString *)dict  {
    //应用注册scheme,在AliSDKDemo-Info.plist定义URL types
    NSString *appScheme = @"kuke";
    
    // NOTE: 调用支付结果开始支付
    __weak typeof(self) weakSelf = self;
    
    [[AlipaySDK defaultService] payOrder:[dict stringByRemovingHTMLMark] fromScheme:appScheme callback:^(NSDictionary *resultDic) {
        
        NSInteger resultStatus = [[NSString stringWithFormat:@"%@",resultDic[@"resultStatus"]] integerValue];
        switch (resultStatus) {
            case 9000:{//订单支付成功
                [BaseTools showErrorMessage:@"支付成功"];
                NSLog(@"支付成功");
                if (self.myBlock) {
                    self.myBlock();
                }
            }
                break;
            case 8000:{//正在处理中，支付结果未知（有可能已经支付成功），请查询商户订单列表中订单的支付状态
                 [BaseTools showErrorMessage:@"订单处理中"];
                 NSLog(@"订单处理中");
                if (self.myFailureBlock) {
                    self.myFailureBlock();
                }
            }
                break;
            case 4000:{//订单支付失败
                 [BaseTools showErrorMessage:@"订单支付失败"];
                 NSLog(@"订单支付失败");
                if (self.myFailureBlock) {
                    self.myFailureBlock();
                }
            }
                break;
            case 5000:{//重复请求
                 [BaseTools showErrorMessage:@"您已经支付过该订单"];
                if (self.myFailureBlock) {
                    self.myFailureBlock();
                }
                 NSLog(@"您已经支付过该订单");
            }
                break;
            case 6001:{//用户中途取消
               [BaseTools showErrorMessage:@"您的订单已取消"];
                if (self.myFailureBlock) {
                    self.myFailureBlock();
                }
            }
                break;
            case 6002:{//网络连接出错
               [BaseTools showErrorMessage:@"网络连接出错"];
                if (self.myFailureBlock) {
                    self.myFailureBlock();
                }
            }
                break;
            case 6004:{//支付结果未知（有可能已经支付成功），请查询商户订单列表中订单的支付状态
                 [BaseTools showErrorMessage:@"订单处理中"];
                 NSLog(@"订单处理中");
                if (self.myFailureBlock) {
                    self.myFailureBlock();
                }
            }
                break;
            default:{//其它支付错误
                 [BaseTools showErrorMessage:@"其他错误"];
                if (self.myFailureBlock) {
                    self.myFailureBlock();
                }
                 NSLog(@"其他错误");
            }
                break;
        }
    }];
}
- (void)wxpayCallBack:(NSDictionary *)dict {
    
    PayReq *request = [[PayReq alloc] init];
    request.partnerId = dict[@"partnerid"];
    request.prepayId = dict[@"prepayid"];
    request.package = dict[@"package"];
    request.nonceStr = dict[@"noncestr"];
    request.timeStamp = [dict[@"timestamp"] intValue];
    request.sign = dict[@"sign"];
    
    NSLog(@"partnerId:%@\nprepayId:%@\npackage:%@\nnonceStr:%@\ntimeStamp:%d\nsign:%@", request.partnerId, request.prepayId, request.package, request.nonceStr, request.timeStamp, request.sign);
    
   BOOL resultStatus = [WXApi sendReq:request];
    if (resultStatus) {
        
    }else{
        
    }
   
}
-(void)onResp:(BaseResp*)resp{
  
    if ([resp isKindOfClass:[PayResp class]]){
        PayResp*response=(PayResp*)resp;
        switch(response.errCode){
            caseWXSuccess:
                //服务器端查询支付通知或查询API返回的结果再提示成功
                NSLog(@"支付成功");
                [BaseTools showErrorMessage:@"支付成功"];
                if (self.myBlock) {
                    self.myBlock();
                }
                break;
            default:
                [BaseTools showErrorMessage:@"支付失败"];
                if (self.myFailureBlock) {
                    self.myFailureBlock();
                }
                NSLog(@"支付失败，retcode=%d",resp.errCode);
                break;
        }
    }
}
- (IBAction)zhifubao:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
 
        self.twoBtn.selected = NO;
    }else{
        self.twoBtn.selected = YES;

    }
    
}
- (IBAction)wexin:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {

        self.threeBtn.selected = NO;
    }else{
        self.threeBtn.selected = YES;

    }
}

@end
