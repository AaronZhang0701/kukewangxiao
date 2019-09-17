//
//  HXAddressManager.h
//  中安生态商城
//
//  Created by NewYear on 2017/7/18.
//  Copyright © 2017年 王鑫年. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WXNAddressManager : NSObject

+ (instancetype)shareInstance;

@property (nonatomic,strong) NSArray *provinceDicAry;//省字典数组

#define kAddressManager [WXNAddressManager shareInstance]

@end
