//
//  ZMBaseViewController.m
//  KukeApp
//
//  Created by iOSDeveloper on 2018/11/8.
//  Copyright © 2018年 zhangming. All rights reserved.
//

#import "ZMBaseViewController.h"
#import "PLVDownloadManagerViewController.h"
@interface ZMBaseViewController ()<CoreStatusProtocol>
@property (nonatomic ,weak) TGRefreshOC *refreshCtl;//高级用法时这行可以去掉

@end

@implementation ZMBaseViewController


- (void)viewWillAppear:(BOOL)animated
{
//    [self network];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:self.navigationItem.backBarButtonItem.style target:nil action:nil];
    
//    self.LoadingV = [EasyLoadingView showLoadingText:@"" config:^EasyLoadingConfig *{
//        static int a = 0 ;
//        int type = ++a%2 ? LoadingShowTypePlayImagesLeft : LoadingShowTypePlayImages ;
//        return [EasyLoadingConfig shared].setLoadingType(type).setSuperReceiveEvent(NO).setBgColor(CBackgroundColor);
//    }];
    
    // Do any additional setup after loading the view.
}
//- (void)initDataSource{
//
//}
//- (void)network{
//    [CoreStatus beginNotiNetwork:self];
//
//    if (![CoreStatus isNetworkEnable]) {
//        [EasyEmptyView showEmptyInView:[[UIApplication sharedApplication] keyWindow] part:^EasyEmptyPart *{
//            return [EasyEmptyPart shared].setTitle(@"无法连接到网络").setImageName(@"无网络").setButtonArray(@[@"查看已下载课程"]);
//        } config:^EasyEmptyConfig *{
//            return [EasyEmptyConfig shared].setTitleColor([UIColor colorWithHexString:@"#8A8A8A"]).setTitleFont([UIFont systemFontOfSize:14]).setScrollVerticalEnable(NO).setBgColor(CBackgroundColor).setButtonColor(CNavBgColor).setButtonFont([UIFont systemFontOfSize:14]).setButtonBgColor([UIColor clearColor]);
//        } callback:^(EasyEmptyView *view, UIButton *button, callbackType callbackType) {
//
//            [EasyEmptyView hiddenEmptyInView:[[UIApplication sharedApplication] keyWindow]];
//            if ([[UserDefaultsUtils valueWithKey:@"access_token"] length] !=0 ) {
//                UIViewController *rootViewController = [[UIApplication sharedApplication] keyWindow].rootViewController;
//                UIViewController *topViewController = [BaseTools topViewControllerWithRootViewController:rootViewController];
//                PLVDownloadManagerViewController *vc = [[PLVDownloadManagerViewController alloc]init];
//                [topViewController.navigationController pushViewController:vc animated:YES];
//            }else{
//                [BaseTools showErrorMessage:@"请登录后再操作"];
//                dispatch_async(dispatch_get_main_queue(), ^{
//
//                    [BaseTools alertLoginWithVC:self];
//                });
//            }
//        }];
//    }
//}
//-(void)coreNetworkChangeNoti:(NSNotification *)noti{
//
//    NSString * statusString = [CoreStatus currentNetWorkStatusString];
//
//    if ([statusString isEqualToString:@"无网络"]) {
//        if (![CoreStatus isNetworkEnable]) {
//            [EasyEmptyView showEmptyInView:[[UIApplication sharedApplication] keyWindow] part:^EasyEmptyPart *{
//                return [EasyEmptyPart shared].setTitle(@"无法连接到网络").setImageName(@"无网络").setButtonArray(@[@"查看已下载课程"]);
//            } config:^EasyEmptyConfig *{
//                return [EasyEmptyConfig shared].setTitleColor([UIColor colorWithHexString:@"#8A8A8A"]).setTitleFont([UIFont systemFontOfSize:14]).setScrollVerticalEnable(NO).setBgColor(CBackgroundColor).setButtonColor(CNavBgColor).setButtonFont([UIFont systemFontOfSize:14]).setButtonBgColor([UIColor clearColor]);
//            } callback:^(EasyEmptyView *view, UIButton *button, callbackType callbackType) {
//
//                [EasyEmptyView hiddenEmptyInView:[[UIApplication sharedApplication] keyWindow]];
//                if ([[UserDefaultsUtils valueWithKey:@"access_token"] length] !=0 ) {
//                    UIViewController *rootViewController = [[UIApplication sharedApplication] keyWindow].rootViewController;
//                    UIViewController *topViewController = [BaseTools topViewControllerWithRootViewController:rootViewController];
//                    PLVDownloadManagerViewController *vc = [[PLVDownloadManagerViewController alloc]init];
//                    [topViewController.navigationController pushViewController:vc animated:YES];
//                }else{
//                    [BaseTools showErrorMessage:@"请登录后再操作"];
//                    dispatch_async(dispatch_get_main_queue(), ^{
//
//                        [BaseTools alertLoginWithVC:self];
//                    });
//                }
//            }];
//        }
//    }else{
//        [self initDataSource];
//        [EasyEmptyView hiddenEmptyInView:[[UIApplication sharedApplication] keyWindow]];
//    }
//}
@synthesize currentStatus;
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
