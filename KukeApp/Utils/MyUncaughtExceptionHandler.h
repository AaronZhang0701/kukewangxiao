//
//  MyUncaughtExceptionHandler.h
//  KukeApp
//
//  Created by iOSDeveloper on 2018/11/30.
//  Copyright © 2018年 zhangming. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface MyUncaughtExceptionHandler : NSObject
+ (void)setDefaultHandler;


+ (NSUncaughtExceptionHandler *)getHandler;


+ (void)TakeException:(NSException *) exception;
@end


