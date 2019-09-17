//
//  AppDelegate+AppService.m
//  MiAiApp
//
//  Created by 张明 on 2017/5/19.
//  Copyright © 2017年 张明. All rights reserved.
//

#import "AppDelegate+AppService.h"
#import <UMSocialCore/UMSocialCore.h>
#import "LoginViewController.h"
#import "OpenUDID.h"

//#import "CourseDetailViewController.h"
//#import "MyOrderViewController.h"
//#import "CourseDetailViewController.h"
//#import "MyLearningRecordViewController.h"
////#import "PLVVodDBManager.h"
//#import "PLVLiveViewController.h"
@implementation AppDelegate (AppService)


#pragma mark ————— 初始化服务 —————
-(void)initService{
    //注册登录状态监听
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loginStateChange:)
                                                 name:KNotificationLoginStateChange
                                               object:nil];    
    
//    网络状态监听
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(netWorkStateChange:)
                                                 name:KNotificationNetWorkStateChange
                                               object:nil];
}

#pragma mark ————— 初始化window —————
-(void)initWindow{
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = KWhiteColor;
    [self.window makeKeyAndVisible];

  
    
    [[UIButton appearance] setExclusiveTouch:YES];
    [UIActivityIndicatorView appearanceWhenContainedIn:[MBProgressHUD class], nil].color = KWhiteColor;
    if (@available(iOS 11.0, *)){
        [[UIScrollView appearance] setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentNever];
    }
}

#pragma mark ————— 初始化网络配置 —————
-(void)NetWorkConfig{
//    YTKNetworkConfig *config = [YTKNetworkConfig sharedConfig];
//    config.baseUrl = URL_main;
}

#pragma mark ————— 初始化用户系统 —————
-(void)initUserManager{
    self.mainTabBar = [[MainTabBarController alloc]init];
    
    CATransition *anima = [CATransition animation];
    anima.type = @"cube";//设置动画的类型
    anima.subtype = kCATransitionFromRight; //设置动画的方向
    anima.duration = 0.3f;
    
    self.window.rootViewController = self.mainTabBar;
    
    [kAppWindow.layer addAnimation:anima forKey:@"revealAnimation"];

    DLog(@"设备IMEI ：%@",[OpenUDID value]);
//
//    if ([UserInfoTool persons].count !=0 ) {
//
//
//        //如果有本地数据，先展示TabBar 随后异步自动登录
//        self.mainTabBar = [MainTabBarController new];
//        self.window.rootViewController = self.mainTabBar;
//
//
//
//        //自动登录
//        NSMutableDictionary *parmDic = [NSMutableDictionary dictionary];
//        [parmDic setObject:[UserDefaultsUtils valueWithKey:@"userPassword"] forKey:@"password"];
//        [parmDic setObject:[UserDefaultsUtils valueWithKey:@"userMobile"] forKey:@"mobile"];
//        [ZMNetworkHelper POST:@"/user/login" parameters:parmDic cache:NO responseCache:^(id responseCache) {
//
//        } success:^(id responseObject) {
//            if (responseObject == nil) {
//
//            }else{
//                if ([responseObject[@"code"] isEqualToString:@"0"]) {
//                    [UserInfoTool initialize];
//                    [UserInfoTool deleteListData];
//                    CurrentUserInfo *userInfo = [[CurrentUserInfo alloc]init];
//                    userInfo.token = responseObject[@"data"][@"access_token"];
//                    userInfo.NiName = responseObject[@"data"][@"stu_name"];
//                    userInfo.Tel = responseObject[@"data"][@"mobile"];
//                    userInfo.StudentID = responseObject[@"data"][@"stu_id"];
//                    userInfo.photo = responseObject[@"data"][@"photo"];
//                    [UserInfoTool addPerson:userInfo];
//                    [UserDefaultsUtils saveValue:responseObject[@"data"][@"access_token"] forKey:@"access_token"];
//                    KPostNotification(KNotificationLoginUpdata, nil);
//                    dispatch_async(dispatch_get_main_queue(), ^{
//                         KPostNotification(KNotificationLoginStateChange, @YES)
//                    });
//
//                }else{
//                    [BaseTools showErrorMessage:responseObject[@"msg"]];
//                }
//            }
//        } failure:^(NSError *error) {
//
//        }];
//
//    }else{
//        //没有登录过，展示登录页面
//        KPostNotification(KNotificationLoginStateChange, @NO)
////        [MBProgressHUD showErrorMessage:@"需要登录"];
//    }
}
#pragma mark - 请求某个视图可以横屏
- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window {
    
//    if (self.allowRotation == YES) {
//        //横屏
//        return UIInterfaceOrientationMaskLandscape;
//
//    }else{
//        //竖屏
//        return UIInterfaceOrientationMaskPortrait;
//
//    }
    
    UIViewController* topViewController = [self.mainTabBar.selectedViewController topViewController];

    if ([topViewController isMemberOfClass:NSClassFromString(@"CourseDetailViewController")] || [topViewController isMemberOfClass:NSClassFromString(@"PLVSimpleDetailController")]  || [topViewController isMemberOfClass:NSClassFromString(@"MyLearningRecordViewController")] ) {

        return UIInterfaceOrientationMaskAllButUpsideDown;
    }else {

        return UIInterfaceOrientationMaskPortrait;
    }
    
    
    
}
#pragma mark ————— 登录状态处理 —————
- (void)loginStateChange:(NSNotification *)notification
{
    BOOL loginSuccess = [notification.object boolValue];

    if (loginSuccess) {//登陆成功加载主窗口控制器

        //为避免自动登录成功刷新tabbar
        if (!self.mainTabBar || ![self.window.rootViewController isKindOfClass:[MainTabBarController class]]) {
            self.mainTabBar = [MainTabBarController new];

            CATransition *anima = [CATransition animation];
            anima.type = @"cube";//设置动画的类型
            anima.subtype = kCATransitionFromRight; //设置动画的方向
            anima.duration = 0.3f;

            self.window.rootViewController = self.mainTabBar;

            [kAppWindow.layer addAnimation:anima forKey:@"revealAnimation"];

        }
    
    }
//    else {//登陆失败加载登陆页面控制器
//
//        self.mainTabBar = nil;
//        RootNavigationController *loginNavi =[[RootNavigationController alloc] initWithRootViewController:[LoginViewController new]];
//
//        CATransition *anima = [CATransition animation];
//        anima.type = @"fade";//设置动画的类型
//        anima.subtype = kCATransitionFromRight; //设置动画的方向
//        anima.duration = 0.3f;
//
//        self.window.rootViewController = loginNavi;
//
//        [kAppWindow.layer addAnimation:anima forKey:@"revealAnimation"];
//
//    }
}


#pragma mark ————— 网络状态变化 —————
- (void)netWorkStateChange:(NSNotification *)notification
{
    BOOL isNetWork = [notification.object boolValue];
    
    if (isNetWork) {//有网络
        if ([userManager loadUserInfo] && !isLogin) {//有用户数据 并且 未登录成功 重新来一次自动登录
            [userManager autoLoginToServer:^(BOOL success, NSString *des) {
                if (success) {
                    DLog(@"网络改变后，自动登录成功");
//                    [MBProgressHUD showSuccessMessage:@"网络改变后，自动登录成功"];
                    KPostNotification(KNotificationAutoLoginSuccess, nil);
                }else{
                    [MBProgressHUD showErrorMessage:NSStringFormat(@"自动登录失败：%@",des)];
                }
            }];
        }
        
    }else {//登陆失败加载登陆页面控制器
        [MBProgressHUD showTopTipMessage:@"网络状态不佳" isWindow:YES];
    }
}



// 为后台下载进行桥接
- (void)application:(UIApplication *)application handleEventsForBackgroundURLSession:(NSString *)identifier completionHandler:(void (^)(void))completionHandler {
    [PLVVodDownloadManager sharedManager].backgroundCompletionHandler = completionHandler;
}
#pragma mark ————— 配置第三方 —————
-(void)configUSharePlatforms{
    /* 设置微信的appKey和appSecret */
//    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:kAppKey_Wechat appSecret:kSecret_Wechat redirectURL:nil];
    /*
     * 移除相应平台的分享，如微信收藏
     */
    //[[UMSocialManager defaultManager] removePlatformProviderWithPlatformTypes:@[@(UMSocialPlatformType_WechatFavorite)]];
    
    /* 设置分享到QQ互联的appID
     * U-Share SDK为了兼容大部分平台命名，统一用appKey和appSecret进行参数设置，而QQ平台仅需将appID作为U-Share的appKey参数传进即可。
     */
//    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_QQ appKey:kAppKey_Tencent/*设置QQ平台的appID*/  appSecret:nil redirectURL:nil];
}

#pragma mark ————— OpenURL 回调 —————
// 支持所有iOS系统。注：此方法是老方法，建议同时实现 application:openURL:options: 若APP不支持iOS9以下，可直接废弃当前，直接使用application:openURL:options:
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    //6.3的新的API调用，是为了兼容国外平台(例如:新版facebookSDK,VK等)的调用[如果用6.2的api调用会没有回调],对国内平台没有影响
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url sourceApplication:sourceApplication annotation:annotation];
    if (!result) {
        // 其他如支付等SDK的回调
    }
    return result;
}

#pragma mark - 网页跳转app
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url];
    if (!result) {
        // 其他如支付等SDK的回调
        
        //支付宝回调
        if ([url.host isEqualToString:@"safepay"]) {
            __weak typeof(self) weakSelf = self;
            // 支付跳转支付宝钱包进行支付，处理支付结果
            [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
                NSInteger resultStatus = [[NSString stringWithFormat:@"%@",resultDic[@"resultStatus"]] integerValue];
                switch (resultStatus) {
                    case 9000:{//订单支付成功
                        [BaseTools showErrorMessage:@"支付成功"];
                        NSLog(@"支付成功");
                        KPostNotification(KNotificationPayResultStatus, @YES)
                     
                    }
                        break;
                    case 8000:{//正在处理中，支付结果未知（有可能已经支付成功），请查询商户订单列表中订单的支付状态
                        [BaseTools showErrorMessage:@"订单处理中"];
                        NSLog(@"订单处理中");
                         KPostNotification(KNotificationPayResultStatus, @NO)
                    }
                        break;
                    case 4000:{//订单支付失败
                        [BaseTools showErrorMessage:@"订单支付失败"];
                        NSLog(@"订单支付失败");
                        KPostNotification(KNotificationPayResultStatus, @NO)
                    }
                        break;
                    case 5000:{//重复请求
                        [BaseTools showErrorMessage:@"您已经支付过该订单"];
                         KPostNotification(KNotificationPayResultStatus, @NO)
                        NSLog(@"您已经支付过该订单");
                    }
                        break;
                    case 6001:{//用户中途取消
                        [BaseTools showErrorMessage:@"您的订单已取消"];
                         KPostNotification(KNotificationPayResultStatus, @NO)
                    }
                        break;
                    case 6002:{//网络连接出错
                        [BaseTools showErrorMessage:@"网络连接出错"];
                         KPostNotification(KNotificationPayResultStatus, @NO)
                    }
                        break;
                    case 6004:{//支付结果未知（有可能已经支付成功），请查询商户订单列表中订单的支付状态
                        [BaseTools showErrorMessage:@"订单处理中"];
                        NSLog(@"订单处理中");
                        KPostNotification(KNotificationPayResultStatus, @NO)
                    }
                        break;
                    default:{//其它支付错误
                        [BaseTools showErrorMessage:@"其他错误"];
                        KPostNotification(KNotificationPayResultStatus, @NO)
                        NSLog(@"其他错误");
                    }
                        break;
                }
            }];
            
        } else if ([url.scheme isEqualToString:@"wx078bf89b74f643c6"]) {//微信回调
            if ([url.host isEqualToString:@"pay"]) {//微信支付回调
                NSURLComponents *components = [NSURLComponents componentsWithString:url.relativeString];
                
                NSMutableDictionary *queryItems = [[NSMutableDictionary alloc]init];
                for (NSURLQueryItem * item in components.queryItems) {
                    [queryItems setValue:item.value forKey:item.name];
                }
                
//                NSString *title;
//                BOOL isOK = false;
                
                if ([[queryItems objectForKey:@"ret"] isEqualToString:@"0"]) {
                    [BaseTools showErrorMessage:@"支付成功"];
                    NSLog(@"支付成功");
                    KPostNotification(KNotificationPayResultStatus, @YES)
//                    title = @"支付成功";
                    
//                    isOK = YES;
                } else {
//                    isOK = NO;
                    if ([[queryItems objectForKey:@"ret"] isEqualToString:@"-1"]) {
//                        title = @"订单异常";
                        [BaseTools showErrorMessage:@"订单异常"];
                        NSLog(@"订单处理中");
                        KPostNotification(KNotificationPayResultStatus, @NO)
                    } else if ([[queryItems objectForKey:@"ret"] isEqualToString:@"-2"]) {
//                        title = @"用户取消";
                        [BaseTools showErrorMessage:@"用户取消"];
                        NSLog(@"订单处理中");
                        KPostNotification(KNotificationPayResultStatus, @NO)
                    }
                    
                    //                    title = [NSString stringWithFormat:@"%@ %@", queryItems[@"returnKey"], queryItems[@"ret"]];
                }
                
//                [self finishedTheOrderMassage:title isOK:isOK];
                
            }
            
        } else if ([url.host isEqualToString:@"www.kuke99.com"]) {
//            [url.relativeString urlStringWithComplete:^(__kindof UIViewController *viewController) {
//                UIViewController *visibleController = [self getVisibleViewControllerFrom:self.window.rootViewController];
//
//                if ([viewController isMemberOfClass:[KKRegisterViewController class]]) {
//                    [visibleController presentViewController:viewController animated:YES completion:nil];
//                } else {
//                    viewController.hidesBottomBarWhenPushed = YES;
//
//                    [visibleController.navigationController pushViewController:viewController animated:YES];
//                }
//            }];
        }
        return YES;
    }
    return result;
}
//- (void)finishedTheOrderMassage:(NSString *)massage isOK:(BOOL)isOK{
//
//    UIViewController *rootViewController = [[UIApplication sharedApplication] keyWindow].rootViewController;
//    UIViewController *topViewController = [BaseTools topViewControllerWithRootViewController:rootViewController];
//    if (isOK) {//正常结束
//
//
//        UITabBarController *tabBarController = (UITabBarController *)self.window.rootViewController;
//        UINavigationController *navController = tabBarController.selectedViewController;
//        UIViewController *serviceViewController = navController.topViewController;
//        NSArray *controllers =  navController.viewControllers;
//
//        if ([controllers[controllers.count-2] isMemberOfClass:NSClassFromString(@"CourseDetailViewController")]) {//如果倒数第二个为确认页面
//            [navController popToViewController:controllers[controllers.count-2] animated:YES];
//        } else {
//            [navController popViewControllerAnimated:YES];
//        }
//    } else {//非正常情况
//        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"支付异常" message:massage preferredStyle:UIAlertControllerStyleAlert];
//        __weak typeof(self) weakSelf = self;
//
//        [alertController addAction:[UIAlertAction actionWithTitle:@"退出支付" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//            UITabBarController *tabBarController = (UITabBarController *)weakSelf.window.rootViewController;
//            UINavigationController *navController = tabBarController.selectedViewController;
//            NSArray *controllers =  navController.viewControllers;
//            if ( [controllers[controllers.count-2] isMemberOfClass:NSClassFromString(@"CourseDetailViewController")]) {//如果倒数第二个为确认页面
//                [navController popToViewController:controllers[controllers.count-2] animated:YES];
//            } else {
//                [navController popViewControllerAnimated:YES];
//            }
//        }]];
//
//        [alertController addAction:[UIAlertAction actionWithTitle:@"继续支付" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//
//        }]];
//
//        UIViewController *visibleController = [self getVisibleViewControllerFrom:self.window.rootViewController];
//        [visibleController presentViewController:alertController animated:YES completion:nil];
//    }
//}
- (UIViewController *) getVisibleViewControllerFrom:(UIViewController *) vc {
    if ([vc isKindOfClass:[UINavigationController class]]) {
        return [self getVisibleViewControllerFrom:[((UINavigationController *) vc) visibleViewController]];
    } else if ([vc isKindOfClass:[UITabBarController class]]) {
        return [self getVisibleViewControllerFrom:[((UITabBarController *) vc) selectedViewController]];
    } else {
        if (vc.presentedViewController) {
            return [self getVisibleViewControllerFrom:vc.presentedViewController];
        } else {
            return vc;
        }
    }
}


+ (AppDelegate *)shareAppDelegate{
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

#pragma mark ————— 网络状态监听 —————
- (void)monitorNetworkStatus
{
    
    //1.创建网络监听管理者
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    
    //2.监听网络状态的改变
    /*
     AFNetworkReachabilityStatusUnknown     = 未知
     AFNetworkReachabilityStatusNotReachable   = 没有网络
     AFNetworkReachabilityStatusReachableViaWWAN = 3G
     AFNetworkReachabilityStatusReachableViaWiFi = WIFI
     */
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
                NSLog(@"未知");
                break;
            case AFNetworkReachabilityStatusNotReachable:
                NSLog(@"没有网络");
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
                NSLog(@"3G");
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
                NSLog(@"WIFI");
                break;
                
            default:
                break;
        }
    }];
    
    //3.开始监听
    [manager startMonitoring];
}
-(UIViewController *)getCurrentVC{
    
    UIViewController *result = nil;
    
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    
    if ([nextResponder isKindOfClass:[UIViewController class]])
        result = nextResponder;
    else
        result = window.rootViewController;
    
    return result;
}

-(UIViewController *)getCurrentUIVC
{
    UIViewController  *superVC = [self getCurrentVC];
    
    if ([superVC isKindOfClass:[UITabBarController class]]) {
        
        UIViewController  *tabSelectVC = ((UITabBarController*)superVC).selectedViewController;
        
        if ([tabSelectVC isKindOfClass:[UINavigationController class]]) {
            
            return ((UINavigationController*)tabSelectVC).viewControllers.lastObject;
        }
        return tabSelectVC;
    }else
        if ([superVC isKindOfClass:[UINavigationController class]]) {
            
            return ((UINavigationController*)superVC).viewControllers.lastObject;
        }
    return superVC;
}


@end
