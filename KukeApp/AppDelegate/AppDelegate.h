//
//  AppDelegate.h
//  KukeApp
//
//  Created by iOSDeveloper on 2018/8/9.
//  Copyright © 2018年 zhangming. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainTabBarController.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate>
/**
 * 是否允许转向
 */

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) MainTabBarController *mainTabBar;

@end

