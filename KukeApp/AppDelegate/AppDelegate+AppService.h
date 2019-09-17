//
//  AppDelegate+AppService.h
//  MiAiApp
//
//  Created by 张明 on 2017/5/19.
//  Copyright © 2017年 张明. All rights reserved.
//

#import "AppDelegate.h"
#import "KKGuideView.h"
#define ReplaceRootViewController(vc) [[AppDelegate shareAppDelegate] replaceRootViewController:vc]

/**
 包含第三方 和 应用内业务的实现，减轻入口代码压力
 */
@interface AppDelegate (AppService)

//初始化服务
-(void)initService;

//初始化 window
-(void)initWindow;

//初始化 UMeng
//-(void)initPLVVod;

//初始化用户系统
-(void)initUserManager;



//初始化网络配置
-(void)NetWorkConfig;

//单例
+ (AppDelegate *)shareAppDelegate;

//监听网络状态
- (void)monitorNetworkStatus;

/**
 当前顶层控制器
 */
-(UIViewController*) getCurrentVC;

-(UIViewController*) getCurrentUIVC;
@end
