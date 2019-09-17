//
//  NSArray+ZMAdd.h
//  KukeApp
//
//  Created by iOSDeveloper on 2018/8/15.
//  Copyright © 2018年 zhangming. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (ZMAdd)
/** 数组/字典 转 json字符串 */
- (nullable NSString *)br_toJsonString;
/** 数组倒序 */
- (NSArray *)br_reverse;


@end
