//
//  StatisRequestErrorData.m
//  KukeApp
//
//  Created by iOSDeveloper on 2018/11/30.
//  Copyright © 2018年 zhangming. All rights reserved.
//

#import "StatisRequestErrorData.h"
#import "MyUncaughtExceptionHandler.h"

@implementation StatisRequestErrorData

#pragma mark -- 崩溃日志
+ (void)showXcodeInfo{
    
    [MyUncaughtExceptionHandler setDefaultHandler];
    
    // 发送崩溃日志
    NSString *path = [NSSearchPathForDirectoriesInDomains (NSCachesDirectory , NSUserDomainMask , YES ) firstObject];
    NSString *dataPath = [path stringByAppendingPathComponent:@"ExceptionLog.txt"];
    NSData *data = [NSData dataWithContentsOfFile:dataPath];
    if (data != nil) {
        [StatisRequestErrorData sendExceptionLogWithData:data];
    }else{
        NSLog(@"没有崩溃日志");
    }
}

#pragma mark -- 发送崩溃日志
+ (void)sendExceptionLogWithData:(NSData *)data
{
    NSLog(@"======数据上传奔溃日志成功=========");
    NSString * path = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:@"ExceptionLog.txt"];
    [StatisRequestErrorData removeDocumentWithFilePath:path];
}

// 删除本地奔溃日志
+ (BOOL)removeDocumentWithFilePath:(NSString*)filePath{
    
    BOOL isRemove = false;
    NSFileManager* fileManager=[NSFileManager defaultManager];
    if ([[NSFileManager defaultManager]fileExistsAtPath:filePath]) {
        isRemove = [fileManager removeItemAtPath:filePath error:nil];
    }
    return isRemove;
}


@end
