//
//  PLVSimpleDetailController.m
//  PolyvVodSDKDemo
//
//  Created by Bq Lin on 2018/3/26.
//  Copyright © 2018年 POLYV. All rights reserved.
//

#import "PLVSimpleDetailController.h"
#import <PLVVodSDK/PLVVodSDK.h>
#import "PLVVodSkinPlayerController.h"

@interface PLVSimpleDetailController ()<CoreStatusProtocol>

@property (weak, nonatomic) IBOutlet UIView *playerPlaceholder;
@property (nonatomic, strong) PLVVodSkinPlayerController *player;

@end

@implementation PLVSimpleDetailController

- (void)dealloc {
	//NSLog(@"%s", __FUNCTION__);
}
-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    //禁止返回
    id traget = self.navigationController.interactivePopGestureRecognizer.delegate;
    UIPanGestureRecognizer * pan = [[UIPanGestureRecognizer alloc]initWithTarget:traget action:nil];
    [self.view addGestureRecognizer:pan];
//    [self.navigationController setNavigationBarHidden:NO];
//    if([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
//        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
//    }
}
-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    };
}
- (void)network{
    [CoreStatus endNotiNetwork:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.title = self.player.video.title;
	[self setupPlayer];
}

- (void)setupPlayer {
	// 初始化播放器
	PLVVodSkinPlayerController *player = [[PLVVodSkinPlayerController alloc] initWithNibName:nil bundle:nil];
    player.is_hideNav = @"0";
	[player addPlayerOnPlaceholderView:self.playerPlaceholder rootViewController:self];
	self.player = player;
    player.rememberLastPosition = YES;
    player.enableBackgroundPlayback = YES;
	NSString *vid = self.vid;
    if (self.localVideo){
        // 本地播放
        self.player.video = self.localVideo;
    }
    else{

        // 无网络情况下，优先检测本地视频文件
        PLVVodLocalVideo *local = [PLVVodLocalVideo localVideoWithVid:self.vid dir:[PLVVodDownloadManager sharedManager].downloadDir];
        if (local && local.path){
            self.player.video = local;
        }
        else
        {
            // 有网情况下，也可以调用此接口，只要存在本地视频，都会优先播放本地视频
            __weak typeof(self) weakSelf = self;
            [PLVVodVideo requestVideoWithVid:vid completion:^(PLVVodVideo *video, NSError *error) {
                if (!video.available) return;
                weakSelf.player.video = video;
                dispatch_async(dispatch_get_main_queue(), ^{
                    weakSelf.title = video.title;
                });
            }];
        }
    }
}

#pragma mark - 转屏设置相关
- (BOOL)shouldAutorotate {
    return YES;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskAllButUpsideDown;
}

//#pragma mark - 转屏逻辑处理
//- (void)onDeviceOrientationChange {
//    UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
//    UIInterfaceOrientation interfaceOrientation = (UIInterfaceOrientation)orientation;
//    switch (interfaceOrientation) {
//        case UIInterfaceOrientationUnknown:{
//            NSLog(@"旋转方向未知");
//            if (self.player.fullscreen) {
//                self.scrollView.hidden = YES;
//                self.introduceButton.hidden = YES;
//                self.commentListButton.hidden = YES;
//                self.catalogueButton.hidden = YES;
//            }else{
//                self.scrollView.hidden = NO;
//                self.introduceButton.hidden = NO;
//                self.commentListButton.hidden = NO;
//                self.catalogueButton.hidden = NO;
//            }
//            //            [self SmallScreenFrameChanges];
//        }
//            break;
//        case UIInterfaceOrientationPortrait:{
//            NSLog(@"第0个旋转方向---电池栏在上");
//            if (self.player.fullscreen) {
//                self.scrollView.hidden = YES;
//                self.introduceButton.hidden = YES;
//                self.commentListButton.hidden = YES;
//                self.catalogueButton.hidden = YES;
//            }else{
//                self.scrollView.hidden = NO;
//                self.introduceButton.hidden = NO;
//                self.commentListButton.hidden = NO;
//                self.catalogueButton.hidden = NO;
//            }
//            
//            //            [self SmallScreenFrameChanges];
//        }
//            break;
//        case UIInterfaceOrientationLandscapeLeft:{
//            
//            if (self.player.fullscreen) {
//                self.scrollView.hidden = YES;
//                self.introduceButton.hidden = YES;
//                self.commentListButton.hidden = YES;
//                self.catalogueButton.hidden = YES;
//            }else{
//                self.scrollView.hidden = NO;
//                self.introduceButton.hidden = NO;
//                self.commentListButton.hidden = NO;
//                self.catalogueButton.hidden = NO;
//            }
//            NSLog(@"第2个旋转方向---电池栏在左");
//            //            if (self.playerSuperView.isFullScreen == NO) {
//            //                [self toFullScreenWithInterfaceOrientation:interfaceOrientation];
//            //            }
//            
//        }
//            break;
//        case UIInterfaceOrientationLandscapeRight:{
//            NSLog(@"第1个旋转方向---电池栏在右");
//            if (self.player.fullscreen) {
//                self.scrollView.hidden = YES;
//                self.introduceButton.hidden = YES;
//                self.commentListButton.hidden = YES;
//                self.catalogueButton.hidden = YES;
//            }else{
//                self.scrollView.hidden = NO;
//                self.introduceButton.hidden = NO;
//                self.commentListButton.hidden = NO;
//                self.catalogueButton.hidden = NO;
//            }
//            //            if (self.playerSuperView.isFullScreen == NO) {
//            //                [self toFullScreenWithInterfaceOrientation:interfaceOrientation];
//            //            }
//            
//        }
//            break;
//        default:
//            if (self.player.fullscreen) {
//                self.scrollView.hidden = YES;
//                self.introduceButton.hidden = YES;
//                self.commentListButton.hidden = YES;
//                self.catalogueButton.hidden = YES;
//            }else{
//                self.scrollView.hidden = NO;
//                self.introduceButton.hidden = NO;
//                self.commentListButton.hidden = NO;
//                self.catalogueButton.hidden = NO;
//            }
//            //            //设备平躺条件下进入播放界面
//            //            if (self.playerSuperView.isFullScreen == NO) {
//            //                [self SmallScreenFrameChanges];
//            //            }
//            break;
//    }
//}
- (BOOL)prefersStatusBarHidden {
	return self.player.prefersStatusBarHidden;
}
- (UIStatusBarStyle)preferredStatusBarStyle {
	return self.player.preferredStatusBarStyle;
}

@synthesize currentStatus;

@end
