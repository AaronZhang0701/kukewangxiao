//
//  UserDefaultsUtils.h
//  trunk
//
//  Created by 王少锋 on 15/7/17.
//  Copyright (c) 2018年 WSF. All rights reserved.
//  NSUserDefaults 简单封装

#import <Foundation/Foundation.h>

@interface UserDefaultsUtils : NSObject
SINGLETON_FOR_HEADER(UserDefaultsUtils);
+(void)saveValue:(id) value forKey:(NSString *)key;

+(id)valueWithKey:(NSString *)key;

+(BOOL)boolValueWithKey:(NSString *)key;

+(void)saveBoolValue:(BOOL)value withKey:(NSString *)key;

+(void)print;

+(void)removeWithKey:(NSString *)key;

+ (void)removeAllKeys;
@end
