//
//  AppDelegate.m
//  KukeApp
//
//  Created by iOSDeveloper on 2018/8/9.
//  Copyright © 2018年 zhangming. All rights reserved.
//

#import "AppDelegate.h"
#import "AppDelegate+UMShare.h"
#import "ViewController.h"
#import "AppDelegate+Jpush.h"
#import "AppDelegate+Polyv.h"
#import "DHGuidePageHUD.h"
#import <Bugly/Bugly.h>
#import <BaiduMobStat.h>
#import "StatisRequestErrorData.h"
#import "MyUncaughtExceptionHandler.h"
#import <UserNotifications/UserNotifications.h>
#import "PushNotificationManager.h"
#import "EasyLoadingGlobalConfig.h"
//tencent101284054
#define BOOLVIDEOFORKEY @"RemoveVideos"
#define SYSTEM_VERSION_GRATERTHAN_OR_EQUALTO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
@interface AppDelegate ()<UIApplicationDelegate,UNUserNotificationCenterDelegate,WXApiDelegate,OpenInstallDelegate>{
    BOOL isAdView;
}

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
//    dispatch_async(dispatch_get_main_queue(), ^{
//    
//        /**显示加载框**/
//        EasyLoadingGlobalConfig *LoadingConfig = [EasyLoadingGlobalConfig shared];
//        LoadingConfig.LoadingType = LoadingAnimationTypeFade ;
//        NSMutableArray *tempArr = [NSMutableArray arrayWithCapacity:24];
//        for (int i = 0; i < 24; i++) {
//            UIImage *img = [UIImage imageNamed:[NSString stringWithFormat:@"加载中%d",i+1]];
//            [tempArr addObject:img] ;
//        }
//        LoadingConfig.playImagesArray = tempArr ;
//    });
    
    //让sdwebimage不缓存图片,每次都重新加载url
    //使用时,要使用 SDWebImageRefreshCached[myCell.iconView3 sd_setImageWithURL:iconArray[2] placeholderImage:[UIImage imageNamed:@"icon"] options:SDWebImageRefreshCached];
//    SDWebImageDownloader *imgDownloader = SDWebImageManager.sharedManager.imageDownloader;
//    imgDownloader.headersFilter  = ^NSDictionary *(NSURL *url, NSDictionary *headers) {
//
//        NSFileManager *fm = [[NSFileManager alloc] init];
//        NSString *imgKey = [SDWebImageManager.sharedManager cacheKeyForURL:url];
//        NSString *imgPath = [SDWebImageManager.sharedManager.imageCache defaultCachePathForKey:imgKey];
//        NSDictionary *fileAttr = [fm attributesOfItemAtPath:imgPath error:nil];
//
//        NSMutableDictionary *mutableHeaders = [headers mutableCopy];
//
//        NSDate *lastModifiedDate = nil;
//
//        if (fileAttr.count > 0) {
//            if (fileAttr.count > 0) {
//                lastModifiedDate = (NSDate *)fileAttr[NSFileModificationDate];
//            }
//
//        }
//        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//        formatter.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
//        formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
//        formatter.dateFormat = @"EEE, dd MMM yyyy HH:mm:ss z";
//
//        NSString *lastModifiedStr = [formatter stringFromDate:lastModifiedDate];
//        lastModifiedStr = lastModifiedStr.length > 0 ? lastModifiedStr : @"";
//        [mutableHeaders setValue:lastModifiedStr forKey:@"If-Modified-Since"];
//
//        return mutableHeaders;
//    };
    
    for (int i = 0; i<8; i++) {
        if (i != [[UserDefaultsUtils valueWithKey:@"CateID"] integerValue]) {
            NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
            
            [defaults removeObjectForKey:[NSString stringWithFormat:@"course_goods_type_%@",[NSString stringWithFormat:@"%d",i]]];
            
            [defaults synchronize];
        }
    }
    
    NSUserDefaults *defs = [NSUserDefaults standardUserDefaults];
    NSDictionary* defaults = [defs dictionaryRepresentation];
    for (NSString *str in defaults) {
        if ([str containsString:@"Pick_Conditions_"]) {
            [defs removeObjectForKey:str];
            [defs synchronize];
        } else {

        }
    }
   
    NSMutableDictionary *parmDic = [NSMutableDictionary dictionary];
    [parmDic setObject:@"app_start_up"  forKey:@"field"];
    [ZMNetworkHelper POST:@"/app/app_start_up" parameters:parmDic cache:NO responseCache:^(id responseCache) {
        
    } success:^(id responseObject) {
        if ([responseObject[@"code"] isEqualToString:@"0"]) {
            
            isAdView = YES;
        }
        
    } failure:^(NSError *error) {
        
    }];
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];

    
    [WXApi registerApp:@"wx078bf89b74f643c6"];
    
    // 需要在startWithAppId之前调用，设置是否开启Crash日志收集
    [[BaiduMobStat defaultStat] setEnableExceptionLog:YES];
    
    [Bugly startWithAppId:@"d8ff4a797b"];
    
    // 设置您在mtj网站上添加的app的appkey,此处AppId即为应用的appKey
    [[BaiduMobStat defaultStat] startWithAppId:@"6b6065dd64"];

    //设置渠道Id
    [[BaiduMobStat defaultStat] setChannelId:@"AppStore"];

    //注意在里面  先初始化应用窗口 再初始化友盟  最后设置根控制器
    [self initWindow];
    
    //初始化友盟分享
    [self setupUSharePlatforms];
    
    //初始化极光
    [self setupWithJpushOption:launchOptions];
    
    //初始化保利威
    [self setupWithPolyvOption:launchOptions];
    
    [ZMNetworkHelper POST:@"/vv_number" parameters:nil cache:YES responseCache:^(id responseCache) {
        
    } success:^(id responseObject) {
        if (responseObject == nil) {
            
        }else{
            if ([responseObject[@"code"] isEqualToString:@"0"]) {
                if ([responseObject[@"data"][@"vv_number"] isEqualToString:KAuditNumnber]) {
                    [UserDefaultsUtils saveBoolValue:YES withKey:KIsAudit];
                }else{
                    [UserDefaultsUtils saveBoolValue:NO withKey:KIsAudit];
                }
                
            }else{
                [BaseTools showErrorMessage:responseObject[@"msg"]];
            }
        }
        //初始化app服务
        [self initService];
    } failure:^(NSError *error) {
        //初始化app服务
        [self initService];
    }];

    
    [OpenInstallSDK initWithDelegate:self];
    
    //初始化用户系统
    [self initUserManager];

    [[[QYSDK sharedSDK] customUIConfig] setCustomerMessageBubblePressedImage: [[UIImage imageNamed:@"icon_sender_node_pressed"] resizableImageWithCapInsets:UIEdgeInsetsMake(35, 10, 35, 15) resizingMode:UIImageResizingModeStretch] ];
    [[[QYSDK sharedSDK] customUIConfig] setCustomerMessageBubbleNormalImage:[[UIImage imageNamed:@"icon_sender_node_normal"] resizableImageWithCapInsets:UIEdgeInsetsMake(35, 10, 35, 15) resizingMode:UIImageResizingModeStretch] ];
    
    [[[QYSDK sharedSDK] customUIConfig] setRightItemStyleGrayOrWhite:NO];
    [[QYSDK sharedSDK] registerAppId:@"63bd8952f58bbc54f13b2142585c095b" appName:@"库课网校"];
    [[[QYSDK sharedSDK] conversationManager] setDelegate:self];
    //推送消息相关处理
    if ([[UIApplication sharedApplication] respondsToSelector:@selector(registerForRemoteNotifications)])
    {
        UIUserNotificationType types = UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound |         UIRemoteNotificationTypeAlert;
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:types
                                                                                 categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }
    else
    {
        UIRemoteNotificationType types = UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound |         UIRemoteNotificationTypeBadge;
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:types];
    }
    
    
    NSDictionary *remoteNotificationInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    if (remoteNotificationInfo) {
//        [self showChatViewController:remoteNotificationInfo];
    }
   
//    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:BOOLFORKEY];
    if ([[NSUserDefaults standardUserDefaults] boolForKey:BOOLFORKEY]) {
        [self adView];
    }
    

    //注册远程通知
    [self setRomoteNotifi];
    
    [self monitorNetworkStatus];

//    if (![[NSUserDefaults standardUserDefaults] boolForKey:BOOLVIDEOFORKEY]) {
//        [DownLoadVideoDataBaseTool deleteListData];
//        PLVVodDownloadManager *downloadManager = [PLVVodDownloadManager sharedManager];
//        [downloadManager requestDownloadInfosWithCompletion:^(NSArray<PLVVodDownloadInfo *> *downloadInfos) {
//            for (PLVVodDownloadInfo *info in downloadInfos) {
//                [downloadManager removeDownloadWithVid:info.vid error:nil];
//
//            }
//        }];
//        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:BOOLVIDEOFORKEY];
//
//    }

   
    
    //注册崩溃处理
//    NSSetUncaughtExceptionHandler (&CaughtExceptionHandler);

    return YES;
}
- (void)onReceiveMessage:(QYMessageInfo *)message{
//    [self sendLocalNotification];
    UIApplicationState state = [UIApplication sharedApplication].applicationState;
    BOOL result = (state == UIApplicationStateActive);
    if (result) {
        [[PushNotificationManager sharedInstance]normalPushNotificationWithTitle:@"您有新的客服消息" subTitle:nil body:message.text identifier:@"1-1" timeInterval:1 repeat:NO];
    }
    
}



- (void)adView{
    if (isAdView) {
        [AppManager appStart];
    }
    
}
//不在appIcon上显示推送数量，但是在系统通知栏保留推送通知的方法
-(void)resetBageNumber{
    if(IS_IOS11_LATER){
        
        [UIApplication sharedApplication].applicationIconBadgeNumber = -1;
    }else{
        UILocalNotification *clearEpisodeNotification = [[UILocalNotification alloc] init];
        clearEpisodeNotification.fireDate = [NSDate dateWithTimeIntervalSinceNow:(0.3)];
        clearEpisodeNotification.timeZone = [NSTimeZone defaultTimeZone];
        clearEpisodeNotification.applicationIconBadgeNumber = -1;
        [[UIApplication sharedApplication] scheduleLocalNotification:clearEpisodeNotification];
    }
}
//通过OpenInstall获取已经安装App被唤醒时的参数（如果是通过渠道页面唤醒App时，会返回渠道编号）
-(void)getWakeUpParams:(OpeninstallData *)appData{
    if (appData.data) {//(动态唤醒参数)
        //e.g.如免填邀请码建立邀请关系、自动加好友、自动进入某个群组或房间等
    }
    if (appData.channelCode) {//(通过渠道链接或二维码唤醒会返回渠道编号)
        //e.g.可自己统计渠道相关数据等
    }
//    //弹出提示框(便于调试，调试完成后删除此代码)。
//    NSLog(@"OpenInstallSDK:\n动态参数：%@;\n渠道编号：%@",appData.data,appData.channelCode);
//    NSString *parameter = [NSString stringWithFormat:@"如果没有任何参数返回，请确认：\n是否通过含有动态参数的分享链接(或二维码)唤醒的app\n\n动态参数：\n%@\n渠道编号：%@",appData.data,appData.channelCode];
//    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"唤醒参数" message:parameter delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//    [alert show];
}

//Universal Links 通用链接
- (BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void (^)(NSArray * _Nullable))restorationHandler
{
    //判断是否通过OpenInstall Universal Link 唤起App
    if ([OpenInstallSDK continueUserActivity:userActivity]){//如果使用了Universal link ，此方法必写
        return YES;
    }
    //其他第三方回调；
    return YES;
}


#pragma mark json转字典
-(NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString
{
    if (jsonString == nil) {
        return @{};
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    if (!jsonData) {
        return nil;
    }
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err)
    {
        return @{};
    }
    return dic;
}
#pragma mark - crash catch

void CaughtExceptionHandler(NSException *exception) {
    
    //应用版本
    NSBundle *mainBundle = [NSBundle mainBundle];
    
    NSString *version = [mainBundle objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    
    if(nil == version) {
        
        version = @"";
        
    }
    //设备版本
    //    NSString *deviceModel = [UIDevice currentDevice].platform;
    NSString *deviceModel = @"iPhone";
    //系统版本
    NSString *sysVersion = [UIDevice currentDevice].systemVersion;
    //邮件主题
    NSString *subject = [NSString stringWithFormat:@"[Crash][kukeStudent][%@][%@][%@]", version, sysVersion, deviceModel];
    //邮箱
    NSString *mailAddress = @"1054767856@qq.com";
    
    //调用栈
    NSArray *stackSysbolsArray = [exception callStackSymbols];
    
    //崩溃原因
    NSString *reason = [exception reason];
    
    //崩溃原因
    NSString *name = [exception name];
    
    
    
//    NSMutableDictionary *parmDic = [NSMutableDictionary dictionary];
//    [parmDic setObject:reason forKey:@"content"];
//    [parmDic setObject:@"" forKey:@"imgs"];
//    [parmDic setObject:@"1" forKey:@"client_type"];
//    [parmDic setObject:name forKey:@"email"];
//    [parmDic setObject:@"" forKey:@"remark"];
//    [ZMNetworkHelper POST:@"/app/feedback_add" parameters:parmDic cache:YES responseCache:^(id responseCache) {
//
//    } success:^(id responseObject) {
//
//        if (responseObject == nil) {
//
//        }else{
//
//        }
//
//    } failure:^(NSError *error) {
//
//    }];
    
    
    //邮件正文
    NSString *body = [NSString stringWithFormat:@"<br>----------------------------------------------------<br>当你看到这个页面的时候别慌,简单的描述下刚才的操作,然后邮件我<br><br>----------------------------------------------------<br>崩溃标识:<br><br>%@<br>----------------------------------------------------<br>崩溃原因:<br><br>%@<br>----------------------------------------------------<br>崩溃详情:<br><br>%@<br>",
                      
                      name,
                      
                      reason,
                      
                      [stackSysbolsArray componentsJoinedByString:@"<br>"]];
    
    
    //邮件url
    NSString *urlStr = [NSString stringWithFormat:@"mailto:%@?subject=%@&body=%@",
                        
                        mailAddress,subject,body];
    
    
    NSURL *url = [NSURL URLWithString:[urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]]];
    
    [[UIApplication sharedApplication] openURL:url];
}


#pragma mark - 推送 ---------------start-----------------------
- (void)setRomoteNotifi{
    //注册通知
    [[UIApplication sharedApplication] registerForRemoteNotifications];
    [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeSound | UIUserNotificationTypeBadge | UIUserNotificationTypeAlert categories:nil]];
}
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings{
    if (notificationSettings.types != UIUserNotificationTypeNone) {
        [application registerForRemoteNotifications];
    }
}
- (void)applicationWillTerminate:(UIApplication *)application {
    
    /**结束IAP工具类*/
    [[IAPManager shared] stopManager];
    
}
//- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
////    [CSManager registerDeviceToken:deviceToken];
//}
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    
    //判断是否通过OpenInstall URL Scheme 唤起App
    if  ([OpenInstallSDK handLinkURL:url]){//必写
        return YES;
    }
    
    if ([url.host isEqualToString:@"safepay"]) {
        // 支付跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
        }];
        
        // 授权跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processAuth_V2Result:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
            // 解析 auth code
            NSString *result = resultDic[@"result"];
            NSString *authCode = nil;
            if (result.length>0) {
                NSArray *resultArr = [result componentsSeparatedByString:@"&"];
                for (NSString *subResult in resultArr) {
                    if (subResult.length > 10 && [subResult hasPrefix:@"auth_code="]) {
                        authCode = [subResult substringFromIndex:10];
                        break;
                    }
                }
            }
            NSLog(@"授权结果 authCode = %@", authCode?:@"");
        }];
    }
    return YES;
}

// NOTE: 9.0以后使用新API接口
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options
{
    
    //判断是否通过OpenInstall URL Scheme 唤起App
    if  ([OpenInstallSDK handLinkURL:url]){//必写
        return YES;
    }

    if ([url.host isEqualToString:@"safepay"]) {
        // 支付跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
        }];
        
        // 授权跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processAuth_V2Result:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
            // 解析 auth code
            NSString *result = resultDic[@"result"];
            NSString *authCode = nil;
            if (result.length>0) {
                NSArray *resultArr = [result componentsSeparatedByString:@"&"];
                for (NSString *subResult in resultArr) {
                    if (subResult.length > 10 && [subResult hasPrefix:@"auth_code="]) {
                        authCode = [subResult substringFromIndex:10];
                        break;
                    }
                }
            }
            NSLog(@"授权结果 authCode = %@", authCode?:@"");
        }];
    }
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {

}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    if ([UIApplication sharedApplication].applicationIconBadgeNumber>0){
        
        [self resetBageNumber];
        
    }
    [application setApplicationIconBadgeNumber:0];   //清除角标
    [JPUSHService setBadge:0];//同样的告诉极光角标为0了
    [application cancelAllLocalNotifications];
    

}
- (void)applicationDidEnterBackground:(UIApplication *)application {

}
@end


@implementation NSURLRequest(DataController)

+ (BOOL)allowsAnyHTTPSCertificateForHost:(NSString *)host
{
    return YES;
}
@end
