//
//  ZMNetAPIClient.h
//  KukeApp
//
//  Created by iOSDeveloper on 2018/8/10.
//  Copyright © 2018年 zhangming. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <AFNetworking/AFHTTPSessionManager.h>

@interface ZMNetAPIClient : AFHTTPSessionManager

+ (void)baseUrl:(NSString *)baseUrl;
+ (void)policyWithPinningMode:(AFSSLPinningMode)pinningMode;

+ (instancetype)sharedClient;

@end
