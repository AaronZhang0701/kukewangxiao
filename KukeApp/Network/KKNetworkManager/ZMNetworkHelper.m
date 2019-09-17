//
//  ZMNetworkHelper.m
//  KukeApp
//
//  Created by iOSDeveloper on 2018/8/10.
//  Copyright © 2018年 zhangming. All rights reserved.
//

#import "ZMNetworkHelper.h"
#import "OpenUDID.h"
@implementation ZMNetworkHelper
static BOOL _isOpenLog;   // 是否已开启日志打印
+ (NSURLSessionTask *)GET:(NSString *)URL
               parameters:(id)parameters
                    cache:(BOOL)cache
            responseCache:(HttpRequestCache)responseCache
                  success:(HttpRequestSuccess)success
                  failure:(HttpRequestFailed)failure {
    NSString *cacheKey = URL;
    if (parameters) {
        cacheKey = [URL stringByAppendingString:[self convertJsonStringFromDictionaryOrArray:parameters]];
    }
    if (responseCache) {
        responseCache([ZMNetworkCache getResponseCacheForKey:cacheKey]);
    }
    AFHTTPSessionManager *manager = [self manager];
    
    return [manager GET:URL parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        dispatch_async(dispatch_get_main_queue(), ^{
//
//            [EasyLoadingView hidenLoading];
//        });
        if (cache) {
            [ZMNetworkCache saveResponseCache:responseObject forKey:cacheKey];
        }
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        dispatch_async(dispatch_get_main_queue(), ^{
//
//            [EasyLoadingView hidenLoading];
//        });
        failure ? failure(error) : nil;
    }];
}

+ (NSURLSessionTask *)POST:(NSString *)URL
                parameters:(id)parameters
                     cache:(BOOL)cache
             responseCache:(HttpRequestCache)responseCache
                   success:(HttpRequestSuccess)success
                   failure:(HttpRequestFailed)failure {

    NSString *cacheKey = URL;
    if (parameters) {
        cacheKey = [URL stringByAppendingString:[self convertJsonStringFromDictionaryOrArray:parameters]];
    }
    if (responseCache) {
        responseCache([ZMNetworkCache getResponseCacheForKey:cacheKey]);
    }
    AFHTTPSessionManager *manager = [self manager];
    //向请求头中添加参数
    //vType为参数名，1为参数的值
    [manager.requestSerializer setValue:[UserDefaultsUtils valueWithKey:@"access_token"] forHTTPHeaderField:@"accessToken"];
    [manager.requestSerializer setValue:[NSString stringWithFormat:@"%@",[[[NSBundle mainBundle]infoDictionary]objectForKey:@"CFBundleShortVersionString"]] forHTTPHeaderField:@"version"];
    [manager.requestSerializer setValue:@"4" forHTTPHeaderField:@"clientType"];
    [manager.requestSerializer setValue:[OpenUDID value] forHTTPHeaderField:@"UUID"];
    return [manager POST:URL parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        dispatch_async(dispatch_get_main_queue(), ^{
//
//            [EasyLoadingView hidenLoading];
//        });
        
        if (cache) {
            [ZMNetworkCache saveResponseCache:responseObject forKey:cacheKey];
        }
        if (success) {
            success(responseObject);
        }


    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        dispatch_async(dispatch_get_main_queue(), ^{
//            
//            [EasyLoadingView hidenLoading];
//        });
        if (failure) {
            failure(error);
        }

    }];
}

+ (NSURLSessionTask *)uploadWithURL:(NSString *)URL
                         parameters:(NSDictionary *)parameters
                             images:(NSArray<UIImage *> *)images
                               name:(NSString *)name
                           mimeType:(NSString *)mimeType
                           progress:(HttpProgress)progress
                            success:(HttpRequestSuccess)success
                            failure:(HttpRequestFailed)failure {
    AFHTTPSessionManager *manager = [self manager];
    return [manager POST:URL parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [images enumerateObjectsUsingBlock:^(UIImage * _Nonnull image, NSUInteger idx, BOOL * _Nonnull stop) {
            NSData *imageData = UIImageJPEGRepresentation(image, 0.5);
            long index = idx;
            NSTimeInterval interval = [[NSDate date] timeIntervalSince1970];
            long long totalMilliseconds = interval * 1000 ;
            NSString *fileName = [NSString stringWithFormat:@"%lld.png", totalMilliseconds];
            NSString *name1 = [NSString stringWithFormat:@"%@%ld", name, index];
            [formData appendPartWithFileData:imageData name:name1 fileName:fileName mimeType:[NSString stringWithFormat:@"image/%@",mimeType?mimeType:@"jpeg"]];
        }];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        progress ? progress(uploadProgress) : nil;
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure ? failure(error) : nil;
    }];
}

+ (NSURLSessionTask *)downloadWithURL:(NSString *)URL
                              fileDir:(NSString *)fileDir
                             progress:(HttpProgress)progress
                              success:(void(^)(NSString *))success
                              failure:(HttpRequestFailed)failure {
    AFHTTPSessionManager *manager = [self manager];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:URL]];
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        progress ? progress(downloadProgress) : nil;
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        NSString *downloadDir = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:fileDir ? fileDir : @"PGNetworkHelper"];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        [fileManager createDirectoryAtPath:downloadDir withIntermediateDirectories:YES attributes:nil error:nil];
        NSString *filePath = [downloadDir stringByAppendingPathComponent:response.suggestedFilename];
        return [NSURL fileURLWithPath:filePath];
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        success ? success(filePath.absoluteString /** NSURL->NSString*/) : nil;
        failure && error ? failure(error) : nil;
    }];
    [downloadTask resume];
    return downloadTask;
}

+ (ZMNetAPIClient *)manager {
    static ZMNetAPIClient *manager = NULL;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [ZMNetAPIClient sharedClient];
        manager.completionQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        manager.requestSerializer.cachePolicy = NSURLCacheStorageNotAllowed;
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
//        [manager setSecurityPolicy:[self customSecurityPolicy]];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/css",@"text/xml",@"text/plain", @"application/javascript", nil];
        manager.requestSerializer.timeoutInterval = 20.0f;
    });
    return manager;
}
+ (AFSecurityPolicy *)customSecurityPolicy {
    
    // 先导入证书 证书由服务端生成，具体由服务端人员操作
    NSString *cerPath = [[NSBundle mainBundle] pathForResource:@"kukeHttps" ofType:@"cer"];//证书的路径 xx.cer
    NSData *cerData = [NSData dataWithContentsOfFile:cerPath];
    
    // AFSSLPinningModeCertificate 使用证书验证模式
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
    // allowInvalidCertificates 是否允许无效证书（也就是自建的证书），默认为NO
    // 如果是需要验证自建证书，需要设置为YES
    securityPolicy.allowInvalidCertificates = YES;
    
    //validatesDomainName 是否需要验证域名，默认为YES;
    //假如证书的域名与你请求的域名不一致，需把该项设置为NO；如设成NO的话，即服务器使用其他可信任机构颁发的证书，也可以建立连接，这个非常危险，建议打开。
    //置为NO，主要用于这种情况：客户端请求的是子域名，而证书上的是另外一个域名。因为SSL证书上的域名是独立的，假如证书上注册的域名是www.google.com，那么mail.google.com是无法验证通过的；当然，有钱可以注册通配符的域名*.google.com，但这个还是比较贵的。
    //如置为NO，建议自己添加对应域名的校验逻辑。
    securityPolicy.validatesDomainName = NO;
    
    securityPolicy.pinnedCertificates = [[NSSet alloc] initWithObjects:cerData, nil];
    return securityPolicy;
}
+ (void)timeoutInterval:(NSTimeInterval)timeInterval {
    AFHTTPSessionManager *manager = [self manager];
    manager.requestSerializer.timeoutInterval = timeInterval;
}

+ (void)cancelAllOperations {
    [[self manager].operationQueue cancelAllOperations];
}

+ (NSString *)convertJsonStringFromDictionaryOrArray:(id)parameter {
    NSData *data = [NSJSONSerialization dataWithJSONObject:parameter options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonStr = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    return jsonStr;
}

@end
