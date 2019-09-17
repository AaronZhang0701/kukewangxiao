//
//  NSArray+ZMAdd.m
//  KukeApp
//
//  Created by iOSDeveloper on 2018/8/15.
//  Copyright © 2018年 zhangming. All rights reserved.
//

#import "NSArray+ZMAdd.h"

@implementation NSArray (ZMAdd)
#pragma mark - 数组 转 json字符串
- (NSString *)br_toJsonString {
    if ([NSJSONSerialization isValidJSONObject:self]) {
        NSError *error = nil;
        // 1.转化为 JSON 格式的 NSData
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:&error];
        if (error) {
            NSLog(@"数组转JSON字符串失败：%@", error);
        }
        // 2.转化为 JSON 格式的 NSString
        return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    return nil;
}

#pragma mark - 数组倒序
- (NSArray *)br_reverse {
    return [[self reverseObjectEnumerator] allObjects];
}

@end


