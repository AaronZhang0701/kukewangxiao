//
//  SettingViewController.m
//  KukeApp
//
//  Created by iOSDeveloper on 2018/10/3.
//  Copyright © 2018年 zhangming. All rights reserved.
//

#import "SettingViewController.h"
#import "MyInformationViewController.h"
#import "DownLoadVideoDataBaseTool.h"
#import "ChangePasswordViewController.h"
@interface SettingViewController ()

@end

@implementation SettingViewController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO];
    //    [AppUtiles setTabBarHidden:YES];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"设置";
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:self.navigationItem.backBarButtonItem.style target:nil action:nil];

    CurrentUserInfo *info= nil;
    if ([UserInfoTool persons].count != 0) {
        info = [UserInfoTool persons][0];
        self.phone.text = info.Tel;
    }else{
        self.phone.text = @"";
    }
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)outLoginAction:(id)sender {
    PLVVodDownloadManager *downloadManager = [PLVVodDownloadManager sharedManager];

    [downloadManager requestDownloadInfosWithCompletion:^(NSArray<PLVVodDownloadInfo *> *downloadInfos) {


        if (downloadInfos.count!=0) {
            dispatch_async(dispatch_get_main_queue(), ^{

                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"您有已下载视频，如果继续退出当前账号将清空已下载视频，请您谨慎选择" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *actionOne = [UIAlertAction actionWithTitle:@"继续退出" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    for (PLVVodDownloadInfo *info in downloadInfos) {

                        [downloadManager removeDownloadWithVid:info.vid error:nil];

                    }
                    [DownLoadVideoDataBaseTool deleteListData];
                    [UserInfoTool deleteListData];
                    [UserDefaultsUtils saveValue:@"" forKey:@"access_token"];
                    [UserDefaultsUtils saveValue:@"0"  forKey:@"IsYouKe"];
                    KPostNotification(@"OutLogin", nil);
                    [self.navigationController popViewControllerAnimated:YES];
                    [[QYSDK sharedSDK] logout:^(BOOL success) {}];

                }];
                UIAlertAction *actionTwo = [UIAlertAction actionWithTitle:@"取消退出" style:UIAlertActionStyleCancel handler:nil];
                [alertController addAction:actionOne];
                [alertController addAction:actionTwo];
 
                [self presentViewController:alertController animated:YES completion:nil];

            });
        }else{
    
            dispatch_async(dispatch_get_main_queue(), ^{
                
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"您确定要退出吗？" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *actionOne = [UIAlertAction actionWithTitle:@"继续退出" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [UserInfoTool deleteListData];
                    [UserDefaultsUtils saveValue:@"" forKey:@"access_token"];
                    [UserDefaultsUtils saveValue:@"0"  forKey:@"IsYouKe"];
                    [self.navigationController popViewControllerAnimated:YES];
                    KPostNotification(@"OutLogin", nil);
                    [JPUSHService setAlias:@"00000000000" completion:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
                        NSLog(@"iResCode = %ld, iTags = %ld, iAlias = %@",iResCode,seq,iAlias);
                    } seq:1];
                    [[QYSDK sharedSDK] logout:^(BOOL success) {}];
                }];
                UIAlertAction *actionTwo = [UIAlertAction actionWithTitle:@"取消退出" style:UIAlertActionStyleCancel handler:nil];
                
                [alertController addAction:actionOne];
                [alertController addAction:actionTwo];
                
                [self presentViewController:alertController animated:YES completion:nil];

            });
 
        }

    }];
    
    
}
- (IBAction)MyInfoAction:(id)sender {
    MyInformationViewController *vc = [[MyInformationViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)changePasswordAction:(id)sender {
    ChangePasswordViewController *vc = [[ChangePasswordViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

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
