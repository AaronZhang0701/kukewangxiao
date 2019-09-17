//
//  AppDelegate+Polyv.m
//  KukeApp
//
//  Created by 库课 on 2019/7/3.
//  Copyright © 2019 KukeZangMing. All rights reserved.
//

#import "AppDelegate+Polyv.h"

@implementation AppDelegate (Polyv)
-(void)setupWithPolyvOption:(NSDictionary *)launchOptions{
    [self initPLVVod];
    [self initPLVLive];
    // 接收远程事件
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    [self becomeFirstResponder];
    
}
#pragma mark ————— 保利威直播 初始化 —————
-(void)initPLVLive{
    
//
    PLVLiveVideoConfig *liveConfig = [PLVLiveVideoConfig sharedInstance];
    //    liveConfig.channelId = @"324016";
    liveConfig.appId = PolyvLiveAppID;
    liveConfig.userId = PolyvLiveUserId;
    liveConfig.appSecret = PolyvLiveAppSecret;

    /// 直播后，在（https://live.polyv.net/#/channel/你的频道号/playback）中可把某段视频转存到回放列表，然后在官网（https://my.polyv.net/secure/video/）上找到回放的 vodId 字符串值
    PLVVodConfig *vodConfig = [PLVVodConfig sharedInstance];
    vodConfig.vodId = @"9b52ce99c45161d5a101794c64a6991e_9";
    /// 以下字符串 configString，key，iv 的值在官网（https://my.polyv.net/secure/setting/api）上已配置好
    NSError *error = nil;
    NSString *configString = @"TD1YSmNwb9igqvbRFuaBtZbrGfnKDTXOXi3quGttQ1yQDj2jeqri2K7QdS5QOAIqXdMhYmsVl/iV0J7rH6UcQu2v4s95/sH2DGR79ksc7gP8MbibWxMWUEB7DjYthJVVBw00jFgEkIAWxCr45Kjcxw==";/// SDK加密串
    NSString *key = @"VXtlHmwfS2oYm0CZ";/// 加密密钥
    NSString *iv = @"2u9gDPKdX6GyQJKU";/// 加密向量
    [PLVVodConfig settingsWithConfigString:configString key:key iv:iv error:&error];
    
    // 配置统计后台参数：用户Id、用户昵称及自定义参数
    [PLVLiveVideoConfig setViewLogParam:nil param2:nil param4:nil param5:nil];
   
    
}
/// 转发远程事件
- (void)remoteControlReceivedWithEvent:(UIEvent *)event {
    [[NSNotificationCenter defaultCenter] postNotificationName:PLVVodRemoteControlEventDidReceiveNotification object:self userInfo:@{PLVVodRemoteControlEventKey: event}];
}
#pragma mark ————— 保利威点播 初始化 —————
-(void)initPLVVod{

    NSError *error = nil;
    PLVVodSettings *settings = [PLVVodSettings settingsWithConfigString:@"w+0QBSlxUNpTUt0zOdo4beLxwaVhdmQOidQiGJL+836mjjDPfF9O1fzeqFEJtX07CL/NKzeHP8Ezmp1MsYJiLe6N6Awy620UzRG/xzm65PJgB+e2txUytrD0Pl6tzc+3+jlstm8WE5v+wdL0aGYorg==" key:@"VXtlHmwfS2oYm0CZ" iv:@"2u9gDPKdX6GyQJKU" error:&error];
    NSLog(@"%@",PLVVodSdkVersion);;
    [IJKFFMoviePlayerController setLogLevel:k_IJK_LOG_INFO];
    
    // PLVVodDownloadManager 下载配置
    {
        PLVVodDownloadManager *downloadManager = [PLVVodDownloadManager sharedManager];
        //downloadManager.autoStart = YES;
        downloadManager.maxRuningCount = 3;
        // 下载错误统一回调
        downloadManager.downloadErrorHandler = ^(PLVVodVideo *video, NSError *error) {
            NSLog(@"download error: %@\n%@", video.vid, error);
        };
    }
    
    //    // 接收远程事件
    //    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    //    [self becomeFirstResponder];
    
}
@end
