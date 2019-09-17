//
//  XSIAPManage.h
//  Kuke
//
//  Created by Xaofly Sho on 2016/11/1.
//  Copyright © 2016年 Xaofly Sho. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XSIAPManage : NSObject


//普通校验
+ (void)receipt:(NSData *)receipt orderSN:(NSString *)orderSN callBack:(void(^)(NSUInteger code, NSString *message))callBack;

@end
