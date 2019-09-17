//
//  ZMNetAPIClient.m
//  KukeApp
//
//  Created by iOSDeveloper on 2018/8/10.
//  Copyright © 2018年 zhangming. All rights reserved.
//

#import "ZMNetAPIClient.h"

@implementation ZMNetAPIClient

static NSString *_baseUrl = SERVER_HOST;
static AFSSLPinningMode _pinningMode = AFSSLPinningModeNone;

+ (instancetype)sharedClient{
    
    static ZMNetAPIClient *_sharedClient = nil;

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration ephemeralSessionConfiguration];
        _sharedClient = [[ZMNetAPIClient alloc] initWithBaseURL:[NSURL URLWithString:_baseUrl] sessionConfiguration:sessionConfiguration];
        _sharedClient.securityPolicy = [AFSecurityPolicy policyWithPinningMode:_pinningMode];
    });
    return _sharedClient;
}

+ (void)baseUrl:(NSString *)baseUrl {
    _baseUrl = baseUrl;
}

+ (void)policyWithPinningMode:(AFSSLPinningMode)pinningMode {
    _pinningMode = pinningMode;
}
@end
