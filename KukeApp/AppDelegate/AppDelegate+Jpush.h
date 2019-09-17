//
//  AppDelegate+Jpush.h
//  KukeApp
//
//  Created by iOSDeveloper on 2018/8/15.
//  Copyright © 2018年 zhangming. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate (Jpush)
-(void)setupWithJpushOption:(NSDictionary *)launchOptions;

@property (strong, nonatomic) MainTabBarController *mainTabBar;

@end
