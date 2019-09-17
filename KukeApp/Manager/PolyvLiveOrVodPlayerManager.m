//
//  PolyvLiveOrVodPlayerManager.m
//  KukeApp
//
//  Created by 库课 on 2019/7/10.
//  Copyright © 2019 KukeZangMing. All rights reserved.
//

#import "PolyvLiveOrVodPlayerManager.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import <PolyvCloudClassSDK/PLVLiveVideoAPI.h>
#import <PolyvCloudClassSDK/PLVLiveVideoConfig.h>
#import <PolyvBusinessSDK/PLVVodConfig.h>
#import "PLVLiveViewController.h"
#import "PLVVodViewController.h"
#import "PCCUtils.h"
@implementation PolyvLiveOrVodPlayerManager
+ (void)zm_verifyPermissionWithChannelId:(NSString *)channelId vid:(NSString *)vid playerType:(NSString *)playerType  ToPlayerFromViewController:(UIViewController *)vc dataSource:(id)data{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].delegate.window animated:YES];
    [hud.label setText:@"加载中..."];
    __weak typeof(self) weakSelf = self;
    if ([playerType isEqualToString:@"Live"]) {
  
        [PLVLiveVideoAPI verifyPermissionWithChannelId:channelId.integerValue vid:vid appId:PolyvLiveAppID userId:PolyvLiveUserId appSecret:PolyvLiveAppSecret completion:^{
            [PLVLiveVideoAPI liveStatus:channelId completion:^(BOOL liveing, NSString *liveType) {
                [hud hideAnimated:YES];
                
                PLVLiveVideoConfig *liveConfig = [PLVLiveVideoConfig sharedInstance];
                liveConfig.channelId = channelId;
                liveConfig.appId = PolyvLiveAppID;
                liveConfig.userId = PolyvLiveUserId;
                liveConfig.appSecret = PolyvLiveAppSecret;
                
                PLVLiveViewController *liveVC = [[PLVLiveViewController alloc]init];
                CurrentUserInfo *info= nil;
                if ([UserInfoTool persons].count != 0) {
                    info = [UserInfoTool persons][0];
                    if (info.Tel.length == 11) {
                        NSString *numberString = [info.Tel encryptionUserName];
                        liveVC.nickName = numberString;
                    }else{
                        liveVC.nickName = @"游客";
                    }
                    liveVC.avatarUrl = info.photo;
                }
                liveVC.liveType = [@"ppt" isEqualToString:liveType] ? PLVLiveViewControllerTypeCloudClass : PLVLiveViewControllerTypeLive;
                liveVC.playAD = !liveing;
 
                liveVC.data = data;
                [vc presentViewController:liveVC animated:YES completion:nil];

            } failure:^(NSError *error) {
                [hud hideAnimated:YES];
//                [PCCUtils presentAlertViewController:nil message:error.localizedDescription inViewController:vc];
            }];
        } failure:^(NSError *error) {
            [hud hideAnimated:YES];
//            [weakSelf presentToAlertViewControllerWithError:error inViewController:vc];
        }];
    } else {
       
        
        [PLVLiveVideoAPI verifyPermissionWithChannelId:channelId.integerValue vid:vid appId:PolyvLiveAppID userId:PolyvLiveUserId appSecret:nil completion:^{
            [PLVLiveVideoAPI getVodType:vid completion:^(BOOL vodType) {
                [hud hideAnimated:YES];
                //必需先设置 PLVVodConfig 单例里需要的信息，因为在后面的加载中需要使用
                PLVVodConfig *vodConfig = [PLVVodConfig sharedInstance];
                PLVLiveVideoConfig *liveConfig = [PLVLiveVideoConfig sharedInstance];
                vodConfig.vodId = vid;
                liveConfig.appId = PolyvLiveAppID;
                // 用于回放跑马灯显示
                liveConfig.channelId = channelId ;
                liveConfig.userId = PolyvLiveUserId;
                
                PLVVodViewController *vodVC = [PLVVodViewController new];
                vodVC.vodType = vodType ? PLVVodViewControllerTypeCloudClass : PLVVodViewControllerTypeLive;
                [vc presentViewController:vodVC animated:YES completion:nil];
            } failure:^(NSError *error) {
                [hud hideAnimated:YES];
                [weakSelf presentToAlertViewControllerWithError:error inViewController:vc];
            }];
        } failure:^(NSError *error) {
            [hud hideAnimated:YES];
            [weakSelf presentToAlertViewControllerWithError:error inViewController:vc];
        }];
    }
}



- (void)presentToAlertViewControllerWithError:(NSError *)error inViewController:(UIViewController *)vc {
    [PCCUtils presentAlertViewController:nil message:error.localizedDescription inViewController:vc];
}

@end
