//
//  XSIAPManage.m
//  Kuke
//
//  Created by Xaofly Sho on 2016/11/1.
//  Copyright © 2016年 Xaofly Sho. All rights reserved.
//

#import "XSIAPManage.h"


@implementation XSIAPManage


+ (void)removeReceiptWithOrderSN:(NSString *)orderSN {
    
    NSUserDefaults *storage = [NSUserDefaults standardUserDefaults];
    
    NSDictionary *savedReceipts = [storage dictionaryForKey:@"receipts"];
    
    if (savedReceipts) {
        
        NSMutableDictionary *updatedReceipts = [NSMutableDictionary dictionaryWithDictionary:savedReceipts];
        [updatedReceipts removeObjectForKey:orderSN];
        [storage setObject:updatedReceipts forKey:@"receipts"];
        
    }
    
    [storage synchronize];
    
}

+ (void)receipt:(NSData *)receipt orderSN:(NSString *)orderSN callBack:(void(^)(NSUInteger code, NSString *message))callBack {

    NSString *receiptBase64 = [receipt base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithCarriageReturn];

    NSMutableDictionary *parmDic = [NSMutableDictionary dictionary];
    [parmDic setObject:orderSN  forKey:@"order_sn"];
    [parmDic setObject:receiptBase64  forKey:@"receipt"];
 
    [ZMNetworkHelper POST:@"/order/iphone_recharge_validata" parameters:parmDic cache:NO responseCache:^(id responseCache) {
        
    } success:^(id responseObject) {
        if ([responseObject[@"code"] isEqualToString:@"0"]) {
//            [XSIAPManage removeReceiptWithOrderSN:orderSN];
//            if (callBack) {
//            
//                callBack(0, @"校验成功");
//            }
            
        }else if ([responseObject[@"code"] isEqualToString:@"-10000"]){
            [BaseTools showErrorMessage:@"请登录后再操作"];
        }else{
//            [XSIAPManage removeReceiptWithOrderSN:orderSN];
            [BaseTools showErrorMessage:responseObject[@"msg"]];
        }
        
    } failure:^(NSError *error) {
        
    }];
    

//
//    //    _hud.label.text = @"正在验证支付收据...";
//    
//    [XSHTTPManage requestOrderPayWithUserID:[KKUserInfoManage sharedKKUserInfoManage].m_id
//                                    orderID:nil
//                                    orderSN:orderSN
//                                    payment:@"ios"
//                                    receipt:receiptBase64
//                                   complete:^(id json, NSError *error) {
//                                       
//                                       NSString *message;
//                                       NSLog(@"%@", json);
//                                       
//                                       if (json && ([json[@"state"] intValue] == 0)) {
//                                           
//                                           [XSIAPManage removeReceiptWithOrderSN:orderSN];
//                                           
//                                           if (callBack) {
//                                               callBack(0, @"校验成功");
//                                           }
//                                           
//                                       } else if (json && ([json[@"state"] intValue] == -1)) {
//                                           //凭证无效
//                                           
//                                           [XSIAPManage removeReceiptWithOrderSN:orderSN];
//                                           
//                                           message = @"收据验证失败，凭证无效，请联系客服。";
//                                           
//                                       } else if (json && ([json[@"state"] intValue] == -2)) {
//                                           //服务器网络错误
//                                           
//                                           message = @"收据验证失败，服务器网络错误，请稍后再试。";
//                                           
//                                       } else if (json && ([json[@"state"] intValue] == -3)) {
//                                           //订单未找到
//                                           message = [NSString stringWithFormat:@"您有一张未通过验证的支付订单\n订单号:%@\n为保障您的权益请截图并联系客服", orderSN];
//                                           
//                                           [XSIAPManage removeReceiptWithOrderSN:orderSN];
//                                           
//                                       } else if (error) {
//                                           //客户端网络错误
//                                           message = [NSString stringWithFormat:@"交易验证失败，请检查网络，稍后再试。\n%@", [error userInfo][NSLocalizedDescriptionKey]];
//                                       }
//                                       if (callBack) {
//                                           callBack(1, message);
//                                       }
//                                   }];
}


@end
