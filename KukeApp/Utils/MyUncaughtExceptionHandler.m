//
//  MyUncaughtExceptionHandler.m
//  KukeApp
//
//  Created by iOSDeveloper on 2018/11/30.
//  Copyright © 2018年 zhangming. All rights reserved.
//

#import "MyUncaughtExceptionHandler.h"
// 返回沙盒地址
NSString * applicationDocumentsDirectory()
{
    return [NSSearchPathForDirectoriesInDomains (NSCachesDirectory , NSUserDomainMask , YES ) firstObject];
}

// 出现崩溃时的回调函数
void UncaughtExceptionHandler(NSException * exception)
{
    NSArray * arr = [exception callStackSymbols];
    // 崩溃的原因  可以有崩溃的原因(数组越界,字典nil,调用未知方法...) 崩溃的控制器以及方法
    NSString * reason = [exception reason];
    NSString * name = [exception name];
    
    NSString * url = [NSString stringWithFormat:@"========异常错误报告========\nname:%@\nreason:\n%@\ncallStackSymbols:\n%@",name,reason,[arr componentsJoinedByString:@"\n"]];
    NSString * path = [applicationDocumentsDirectory() stringByAppendingPathComponent:@"ExceptionLog.txt"];
    // 将txt文件写入沙盒
    [url writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:nil];
    
}


@implementation MyUncaughtExceptionHandler

+ (void)setDefaultHandler
{
    NSSetUncaughtExceptionHandler(&UncaughtExceptionHandler);
}

+ (NSUncaughtExceptionHandler *)getHandler
{
    return NSGetUncaughtExceptionHandler();
}

+ (void)TakeException:(NSException *)exception
{
    NSArray * arr = [exception callStackSymbols];
    NSString * reason = [exception reason];
    NSString * name = [exception name];
    NSString * url = [NSString stringWithFormat:@"========异常错误报告========\nname:%@\nreason:\n%@\ncallStackSymbols:\n%@",name,reason,[arr componentsJoinedByString:@"\n"]];
    NSString * path = [applicationDocumentsDirectory() stringByAppendingPathComponent:@"ExceptionLog.txt"];
    [url writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:nil];
}


@end
