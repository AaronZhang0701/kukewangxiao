//
//  AppManager.m
//  MiAiApp
//
//  Created by 张明 on 2017/5/21.
//  Copyright © 2017年 张明. All rights reserved.
//

#import "AppManager.h"
#import "AdPageView.h"
#import "RootWebViewController.h"
#import "LoginViewController.h"
#import "HomePageBannerViewController.h"
#import "AdWebViewController.h"
//#import "YYFPSLabel.h"

@implementation AppManager


+(void)appStart{
    //加载广告
    AdPageView *adView = [[AdPageView alloc] initWithFrame:kScreen_Bounds withTapBlock:^{
        if ([UserDefaultsUtils boolValueWithKey:KIsAudit]){
            
        }else{
            AdWebViewController *vc = [[AdWebViewController alloc]init];
            vc.url =[kUserDefaults valueForKey:adUrl];
            vc.title = @"库课网校";
            RootNavigationController *loginNavi =[[RootNavigationController alloc] initWithRootViewController: vc];
            [kRootViewController presentViewController:loginNavi animated:YES completion:nil];
        }
        
    }];
    adView = adView;
}
//#pragma mark ————— FPS 监测 —————
//+(void)showFPS{
//    YYFPSLabel *_fpsLabel = [YYFPSLabel new];
//    [_fpsLabel sizeToFit];
//    _fpsLabel.bottom = KScreenHeight - 55;
//    _fpsLabel.right = KScreenWidth - 10;
//    //    _fpsLabel.alpha = 0;
//    [kAppWindow addSubview:_fpsLabel];
//}

@end
