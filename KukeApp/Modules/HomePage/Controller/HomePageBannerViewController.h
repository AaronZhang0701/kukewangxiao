//
//  HomePageBannerViewController.h
//  KukeApp
//
//  Created by iOSDeveloper on 2018/10/8.
//  Copyright © 2018年 zhangming. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZMBaseViewController.h"
@interface HomePageBannerViewController : ZMBaseViewController

@property (nonatomic, strong) NSString *rootVC;
@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) UIWebView *web;
@end
