//
//  AppDelegate+Jpush.m
//  KukeApp
//
//  Created by iOSDeveloper on 2018/8/15.
//  Copyright © 2018年 zhangming. All rights reserved.
//

#import "AppDelegate+Jpush.h"
// 引入JPush功能所需头文件
#import "JPUSHService.h"
#import "MyPurchasedCourseViewController.h"
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif


@interface AppDelegate ()<JPUSHRegisterDelegate>

@end

@implementation AppDelegate (Jpush)


-(void)setupWithJpushOption:(NSDictionary *)launchOptions {
    
    //Required
    //notice: 3.0.0及以后版本注册可以这样写，也可以继续用之前的注册方式
    
    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
    entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        // 可以添加自定义categories
        // NSSet<UNNotificationCategory *> *categories for iOS10 or later
        // NSSet<UIUserNotificationCategory *> *categories for iOS8 and iOS9
    }
    [JPUSHService crashLogON];
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    NSString *JPushAppKey = @"8f9bea56a4e193c8f8b393ed";
    BOOL isProduction = NO;
    
    // Required
    // init Push
    // notice: 2.1.5版本的SDK新增的注册方法，改成可上报IDFA，如果没有使用IDFA直接传nil
    // 如需继续使用pushConfig.plist文件声明appKey等配置内容，请依旧使用[JPUSHService setupWithOption:launchOptions]方式初始化。
    [JPUSHService setupWithOption:launchOptions appKey:JPushAppKey
                          channel:@"App Store"
                 apsForProduction:isProduction
            advertisingIdentifier:nil];
    
}


- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    //Optional
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}
- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    /// Required - 注册 DeviceToken
    [JPUSHService registerDeviceToken:deviceToken];
    [[QYSDK sharedSDK] updateApnsToken:deviceToken];
//    [[ZCLibClient getZCLibClient] setToken:deviceToken];
    static dispatch_once_t one;
    //只执行一次
    dispatch_once(&one, ^{
        [JPUSHService setAlias:[UserDefaultsUtils valueWithKey:@"user_id"] completion:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
            NSLog(@"iResCode = %ld, iTags = %ld, iAlias = %@",iResCode,seq,iAlias);
        } seq:1];
        
//        [JPUSHService setTags:nil alias:[UserDefaultsUtils valueWithKey:@"user_id"] fetchCompletionHandle:^(int iResCode, NSSet *iTags, NSString *iAlias) {
//
//            NSLog(@"iResCode = %d, iTags = %@, iAlias = %@",iResCode,iTags,iAlias);
//
//        }];

        
    });
}
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_7_1
- (void)application:(UIApplication *)application
didRegisterUserNotificationSettings:
(UIUserNotificationSettings *)notificationSettings {
}

// Called when your app has been activated by the user selecting an action from
// a local notification.
// A nil action identifier indicates the default action.
// You should call the completion handler as soon as you've finished handling
// the action.
- (void)application:(UIApplication *)application
handleActionWithIdentifier:(NSString *)identifier
forLocalNotification:(UILocalNotification *)notification
  completionHandler:(void (^)(void))completionHandler {
}

// Called when your app has been activated by the user selecting an action from
// a remote notification.
// A nil action identifier indicates the default action.
// You should call the completion handler as soon as you've finished handling
// the action.
- (void)application:(UIApplication *)application
handleActionWithIdentifier:(NSString *)identifier
forRemoteNotification:(NSDictionary *)userInfo
  completionHandler:(void (^)(void))completionHandler {
}
#endif

- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [JPUSHService handleRemoteNotification:userInfo];
    NSLog(@"iOS6及以下系统，收到通知:%@", [self logDic:userInfo]);
//    [rootViewController addNotificationCount];
}

- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo
fetchCompletionHandler:
(void (^)(UIBackgroundFetchResult))completionHandler {
    [JPUSHService handleRemoteNotification:userInfo];
    NSLog(@"iOS7及以上系统，收到通知:%@", [self logDic:userInfo]);
    
    if ([[UIDevice currentDevice].systemVersion floatValue]<10.0 || application.applicationState>0) {
//        [rootViewController addNotificationCount];
    }
    
    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)application:(UIApplication *)application
didReceiveLocalNotification:(UILocalNotification *)notification {
    [JPUSHService showLocalNotificationAtFront:notification identifierKey:nil];
}

#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#pragma mark- JPUSHRegisterDelegate
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler  API_AVAILABLE(ios(10.0)){
    NSDictionary * userInfo = notification.request.content.userInfo;
    
    UNNotificationRequest *request = notification.request; // 收到推送的请求
    UNNotificationContent *content = request.content; // 收到推送的消息内容
    
    NSNumber *badge = content.badge;  // 推送消息的角标
    NSString *body = content.body;    // 推送消息体
    UNNotificationSound *sound = content.sound;  // 推送消息的声音
    NSString *subtitle = content.subtitle;  // 推送消息的副标题
    NSString *title = content.title;  // 推送消息的标题
    
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
        NSLog(@"iOS10 前台收到远程通知:%@", [self logDic:userInfo]);
//        [self clickAction:userInfo];
//        [rootViewController addNotificationCount];
        
    }
    else {
//            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"您有新的客服消息，请及时查看" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"查看", nil];
//            [alertView show];


        // 判断为本地通知
        NSLog(@"iOS10 前台收到本地通知:{\nbody:%@，\ntitle:%@,\nsubtitle:%@,\nbadge：%@，\nsound：%@，\nuserInfo：%@\n}",body,title,subtitle,badge,sound,userInfo);
    }
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    [JPUSHService setBadge:0];
//    NSInteger number = [badge integerValue];
//    //角标问题处理我们获取推送内容里的角标 -1 就是当前的角标
//    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:number - 1];
//    [JPUSHService setBadge:number - 1];//相当于告诉极光服务器我现在的角标是多少
    completionHandler(UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionSound|UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以设置
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        UIViewController *rootViewController = [[UIApplication sharedApplication] keyWindow].rootViewController;
        UIViewController *topViewController = [BaseTools topViewControllerWithRootViewController:rootViewController];
        QYSource *source = [[QYSource alloc] init];
        source.title =  @"库课网校";
        source.urlString = @"https://8.163.com/";
        
        QYSessionViewController *sessionViewController = [[QYSDK sharedSDK] sessionViewController];
        sessionViewController.sessionTitle = @"库课网校";
        sessionViewController.source = source;
        if (IS_PAD) {
            UINavigationController* navi = [[UINavigationController alloc]initWithRootViewController:sessionViewController];
            navi.modalPresentationStyle = UIModalPresentationFormSheet;
            [topViewController presentViewController:navi animated:YES completion:nil];
        }
        else{
            sessionViewController.hidesBottomBarWhenPushed = YES;
            [topViewController.navigationController pushViewController:sessionViewController animated:YES];
        }
        
        [[QYSDK sharedSDK] customUIConfig].bottomMargin = 0;
    }

}

- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler  API_AVAILABLE(ios(10.0)){
    
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    UNNotificationRequest *request = response.notification.request; // 收到推送的请求
    UNNotificationContent *content = request.content; // 收到推送的消息内容
    
    NSNumber *badge = content.badge;  // 推送消息的角标
    NSString *body = content.body;    // 推送消息体
    UNNotificationSound *sound = content.sound;  // 推送消息的声音
    NSString *subtitle = content.subtitle;  // 推送消息的副标题
    NSString *title = content.title;  // 推送消息的标题
    
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
        NSLog(@"iOS10 收到远程通知:%@", [self logDic:userInfo]);
        id object = [userInfo objectForKey:@"nim"]; //含有“nim”字段，就表示是七鱼的消息
        if (object)
        {
            UIViewController *rootViewController = [[UIApplication sharedApplication] keyWindow].rootViewController;
            UIViewController *topViewController = [BaseTools topViewControllerWithRootViewController:rootViewController];
            if ([[UserDefaultsUtils valueWithKey:@"access_token"] length] !=0 ) {
//                [BaseTools openKefuWithObj:topViewController];
                
                QYSource *source = [[QYSource alloc] init];
                source.title =  @"库课网校";
                source.urlString = @"https://8.163.com/";
                
                QYSessionViewController *sessionViewController = [[QYSDK sharedSDK] sessionViewController];
                sessionViewController.sessionTitle = @"库课网校";
                sessionViewController.source = source;
                if (IS_PAD) {
                    UINavigationController* navi = [[UINavigationController alloc]initWithRootViewController:sessionViewController];
                    navi.modalPresentationStyle = UIModalPresentationFormSheet;
                    [topViewController presentViewController:navi animated:YES completion:nil];
                }
                else{
                    sessionViewController.hidesBottomBarWhenPushed = YES;
                    [topViewController.navigationController pushViewController:sessionViewController animated:YES];
                }
                
                [[QYSDK sharedSDK] customUIConfig].bottomMargin = 0;
            }else{
                [BaseTools showErrorMessage:@"请登录后再操作"];
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [BaseTools alertLoginWithVC:topViewController];
                });
            }
        }else{
            [self clickAction:userInfo];
        }

        
    }
    else {
        UIViewController *rootViewController = [[UIApplication sharedApplication] keyWindow].rootViewController;
        UIViewController *topViewController = [BaseTools topViewControllerWithRootViewController:rootViewController];
        if ([[UserDefaultsUtils valueWithKey:@"access_token"] length] !=0 ) {
            
            QYSource *source = [[QYSource alloc] init];
            source.title =  @"库课网校";
            source.urlString = @"https://8.163.com/";
            
            QYSessionViewController *sessionViewController = [[QYSDK sharedSDK] sessionViewController];
            sessionViewController.sessionTitle = @"库课网校";
            sessionViewController.source = source;
            
            if (IS_PAD) {
                UINavigationController* navi = [[UINavigationController alloc]initWithRootViewController:sessionViewController];
                navi.modalPresentationStyle = UIModalPresentationFormSheet;
                [topViewController presentViewController:navi animated:YES completion:nil];
            }
            else{
                sessionViewController.hidesBottomBarWhenPushed = YES;
                [topViewController.navigationController pushViewController:sessionViewController animated:YES];
            }
            
            [[QYSDK sharedSDK] customUIConfig].bottomMargin = 0;
        }else{
            [BaseTools showErrorMessage:@"请登录后再操作"];
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [BaseTools alertLoginWithVC:topViewController];
            });
        }
        // 判断为本地通知
        NSLog(@"iOS10 收到本地通知:{\nbody:%@，\ntitle:%@,\nsubtitle:%@,\nbadge：%@，\nsound：%@，\nuserInfo：%@\n}",body,title,subtitle,badge,sound,userInfo);
    }
//    NSInteger number = [badge integerValue];
//    //角标问题处理我们获取推送内容里的角标 -1 就是当前的角标
//    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:number - 1];
//    [JPUSHService setBadge:number - 1];//相当于告诉极光服务器我现在的角标是多少
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    [JPUSHService setBadge:0];
    completionHandler();  // 系统要求执行这个方法
}
#endif

#ifdef __IPHONE_12_0
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center openSettingsForNotification:(UNNotification *)notification API_AVAILABLE(ios(10.0)){
    NSString *title = nil;
    if (notification) {
        title = @"从通知界面直接进入应用";
    }else{
        title = @"从系统设置界面进入应用";
    }
    UIAlertView *test = [[UIAlertView alloc] initWithTitle:title
                                                   message:@"pushSetting"
                                                  delegate:self
                                         cancelButtonTitle:@"yes"
                                         otherButtonTitles:nil, nil];
    [test show];
    
}
#endif

// log NSSet with UTF8
// if not ,log will be \Uxxx
- (NSString *)logDic:(NSDictionary *)dic {
    if (![dic count]) {
        return nil;
    }
    NSString *tempStr1 =
    [[dic description] stringByReplacingOccurrencesOfString:@"\\u"
                                                 withString:@"\\U"];
    NSString *tempStr2 =
    [tempStr1 stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    NSString *tempStr3 =
    [[@"\"" stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    NSString *str =
    [NSPropertyListSerialization propertyListFromData:tempData
                                     mutabilityOption:NSPropertyListImmutable
                                               format:NULL
                                     errorDescription:NULL];
    return str;
}
#pragma mark -JPUSHGeofenceDelegate
//进入地理围栏区域
- (void)jpushGeofenceIdentifer:(NSString * _Nonnull)geofenceId didEnterRegion:(NSDictionary * _Nullable)userInfo error:(NSError * _Nullable)error{
    NSLog(@"进入地理围栏区域");
    if (error) {
        NSLog(@"error = %@",error);
        return;
    }
    if ([UIApplication sharedApplication].applicationState == UIApplicationStateActive) {
        [self testAlert:userInfo];
    }else{
        // 进入后台
        [self geofenceBackgroudTest:userInfo];
    }
}
//离开地理围栏区域
- (void)jpushGeofenceIdentifer:(NSString * _Nonnull)geofenceId didExitRegion:(NSDictionary * _Nullable)userInfo error:(NSError * _Nullable)error{
    NSLog(@"离开地理围栏区域");
    if (error) {
        NSLog(@"error = %@",error);
        return;
    }
    if ([UIApplication sharedApplication].applicationState == UIApplicationStateActive) {
        [self testAlert:userInfo];
    }else{
        // 进入后台
        [self geofenceBackgroudTest:userInfo];
    }
}
//
- (void)geofenceBackgroudTest:(NSDictionary * _Nullable)userInfo{
    //静默推送：
    if(!userInfo){
        NSLog(@"静默推送的内容为空");
        return;
    }
    //TODO
    
}

- (void)testAlert:(NSDictionary*)userInfo{
    if(!userInfo){
        NSLog(@"messageDict 为 nil ");
        return;
    }
    NSString *title = userInfo[@"title"];
    NSString *body = userInfo[@"content"];
    if (title &&  body ) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:body delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
    }
}
- (void)clickAction:(NSDictionary *)dict{
    

    UIViewController *rootViewController = [[UIApplication sharedApplication] keyWindow].rootViewController;
    UIViewController *topViewController = [BaseTools topViewControllerWithRootViewController:rootViewController];
    switch ([dict[@"app_page_id"] integerValue]) {
        case 1:{
            if (self.mainTabBar) {
                self.mainTabBar.selectedIndex = 0;
            }
        };
            break;
        case 2:
            if (self.mainTabBar) {
                self.mainTabBar.selectedIndex = 1;
                [[[AppDelegate shareAppDelegate] getCurrentUIVC].navigationController popToRootViewControllerAnimated:YES];
                double delayInSeconds = 1.0;
                
                dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
                
                dispatch_after(popTime, dispatch_get_main_queue(), ^(void) {
                    KPostNotification(@"Push_Course", dict);
                });
            }
            break;
        case 3:
            if (self.mainTabBar) {
                self.mainTabBar.selectedIndex = 2;
                
                double delayInSeconds = 1.0;
                
                dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
                
                dispatch_after(popTime, dispatch_get_main_queue(), ^(void) {
                   KPostNotification(@"Push_News", dict);
                });

            }
            break;
        case 4:
            if (self.mainTabBar) {
                self.mainTabBar.selectedIndex = 3;
            }
            break;
        case 5:{
            CourseDetailViewController *vc = [[CourseDetailViewController alloc]init];
            vc.ID = dict[@"goods_id"];
            vc.titleIndex = dict[@"goods_type"];
            [topViewController.navigationController pushViewController:vc animated:YES];
        };
            break;
        case 6:{
            HomePageBannerViewController *vc = [[HomePageBannerViewController alloc]init];
            vc.url = dict[@"url"];
            vc.title = @"详情";
            [topViewController.navigationController pushViewController:vc animated:YES];
        };
            break;
        case 7:
            if ([dict[@"ucenter_action"] isEqualToString:@"course_log"]) {
                MyLearningListViewController *vc = [[MyLearningListViewController alloc]init];
                [topViewController.navigationController pushViewController:vc animated:YES];
            }else if ([dict[@"ucenter_action"] isEqualToString:@"exam_log"]) {
                MyAnswerRecordListViewController *vc = [[MyAnswerRecordListViewController alloc]init];
                [topViewController.navigationController pushViewController:vc animated:YES];
            }else if ([dict[@"ucenter_action"] isEqualToString:@"exam"]){
                MyCourseAndTestTableViewController *vc = [[MyCourseAndTestTableViewController alloc]init];
                vc.type = 2;
                vc.title = @"已购题库";
                [topViewController.navigationController pushViewController:vc animated:YES];
            }else if ([dict[@"ucenter_action"] isEqualToString:@"course"]){
                MyPurchasedCourseViewController *vc = [[MyPurchasedCourseViewController alloc]init];
                vc.title = @"已购课程";
                [topViewController.navigationController pushViewController:vc animated:YES];
            }
            
        case 8:
            
            break;
        
        default:
            break;
    }
}
@end
