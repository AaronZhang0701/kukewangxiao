//
//  YFMPaymentView.h
//  YFMBottomPayView
//
//  Created by YFM on 2018/8/7.
//  Copyright © 2018年 iOS. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "STPopup.h"

@interface SelectDownLoadTypeView : UIViewController
- (instancetype)initTovc:(UIViewController *)vc dataSource:(NSArray *)dataSource downLoadType:(NSString *)downLoadType;
//支付方式
@property (nonatomic, copy) void(^payType)(NSString *type ,NSString *balance);
@property (nonatomic, strong) NSString *downLoadType;
@end
