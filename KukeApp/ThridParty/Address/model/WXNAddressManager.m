//
//  HXAddressManager.m
//  中安生态商城
//
//  Created by NewYear on 2017/7/18.
//  Copyright © 2017年 王鑫年. All rights reserved.
//

#import "WXNAddressManager.h"

@interface WXNAddressManager ()

@end

@implementation WXNAddressManager

+ (instancetype)shareInstance {
    static WXNAddressManager *_addressManager = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _addressManager = [[self alloc] init];
    });
    return _addressManager;
}

- (NSArray *)provinceDicAry {
    if (!_provinceDicAry) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"addressData" ofType:@"plist"];
        NSDictionary *dict = [[NSDictionary alloc]initWithContentsOfFile: path];
        _provinceDicAry = [dict valueForKey:@"data"];
    }
    return _provinceDicAry;
}

@end
