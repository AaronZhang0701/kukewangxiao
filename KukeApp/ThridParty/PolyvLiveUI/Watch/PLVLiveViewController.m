//
//  PLVLiveViewController.m
//  PolyvCloudClassDemo
//
//  Created by zykhbl on 2018/8/8.
//  Copyright © 2018年 polyv. All rights reserved.
//

#import "PLVLiveViewController.h"
#import "objc/runtime.h"
#import <PolyvCloudClassSDK/PolyvCloudClassSDK.h>
#import <PolyvBusinessSDK/PolyvBusinessSDK.h>
#import "PLVNormalLiveMediaViewController.h"
#import "PLVPPTLiveMediaViewController.h"
#import "FTPageController.h"
#import "PLVChatroomManager.h"
#import "PLVChatroomController.h"
#import "PCCUtils.h"
#import "PLVEmojiManager.h"
#import "WechatAlterView.h"
#import <Photos/PHPhotoLibrary.h>
#import <Photos/PHAssetChangeRequest.h>
#import "AdWebViewController.h"
#define PPTPlayerViewScale (3.0 / 4.0)
#define NormalPlayerViewScale (9.0 / 16.0)
//#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
//#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

@interface PLVLiveViewController () <PLVBaseMediaViewControllerDelegate, PLVTriviaCardViewControllerDelegate,  PLVLinkMicControllerDelegate, PLVSocketIODelegate, PLVChatroomDelegate,PLVPlayerSkinViewDelegate>{
    QYSessionViewController *sessionVC;
}

@property (nonatomic, assign) NSUInteger channelId;//当前直播的频道号
@property (nonatomic, strong) PLVSocketIO *socketIO;
@property (nonatomic, strong) PLVBaseMediaViewController<PLVLiveMediaProtocol> *mediaVC;//播放器控件
@property (nonatomic, strong) PLVTriviaCardViewController *triviaCardVC;//答题卡控件
@property (nonatomic, strong) PLVLinkMicController *linkMicVC;//连麦控件
@property (nonatomic, strong) FTPageController *pageController;
@property (nonatomic, strong) PLVChatroomController *publicChatroomController;
@property (nonatomic, strong) PLVChatroomController *privateChatroomController;
@property (nonatomic, assign) BOOL idleTimerDisabled;

@property (nonatomic, strong) NSTimer *pollingTimer;
@property (nonatomic, strong) UIView *kefuView;

@end

@implementation PLVLiveViewController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gongzhonghaoClick) name:@"kukegongzhonghao" object:nil];
    self.idleTimerDisabled = [UIApplication sharedApplication].idleTimerDisabled;
    [UIApplication sharedApplication].idleTimerDisabled = YES;
    
    [self initData];
    
    BOOL watchPermission = [PLVChatroomController havePermissionToWatchLive:self.channelId];
    if (watchPermission) {
        [self setupUI];
        [self loadChannelMenuInfos];
        [self loadChatroomInfos];
    } else {
        __weak typeof(self) weakSelf = self;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf exitCurrentControllerWithAlert:nil message:@"您未被授权观看本直播"];
        });
    }
    
//    [self playerPolling];
}
- (void)createKefuView{
    
    self.kefuView = [[UIView alloc] init];
    self.kefuView.alpha = 0.5;
    self.kefuView.layer.cornerRadius = 22.5f;
    self.kefuView.frame = CGRectMake(screenWidth()-53,screenHeight()-150,45,45);
    self.kefuView.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:1.0];
    [self.view addSubview:self.kefuView];
    
    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake(2.5f,2.5f,40,40);
    label.textAlignment = NSTextAlignmentCenter;
    label.numberOfLines = 0;
    [self.kefuView addSubview:label];
    
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:@"咨询老师" attributes:@{NSFontAttributeName: [UIFont fontWithName:@"PingFang-SC-Medium" size: 12],NSForegroundColorAttributeName: [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0]}];
    label.attributedText = string;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
    [self.kefuView addGestureRecognizer:tap];
    
    
}

- (void)tapAction{
    [(PLVLivePlayerController *)self.mediaVC.player pause];
    if ([[UserDefaultsUtils valueWithKey:@"access_token"] length] !=0 ) {
        
        NSString *urlString = [NSString stringWithFormat:@"%@/live/%@.html", SERVER_HOSTPC,self.data[@"live_id"]];
    
        QYSource *source = [[QYSource alloc] init];
        source.title =  @"库课网校";
        source.urlString = @"https://www.kuke99.com/";
        QYCommodityInfo *commodityInfo = [[QYCommodityInfo alloc] init];
        commodityInfo.title = self.data[@"title"];
        commodityInfo.desc = self.data[@"title"];
        commodityInfo.sendByUser = YES;
        commodityInfo.actionTextColor =CNavBgColor;
        commodityInfo.actionText = @"发送商品";
        commodityInfo.pictureUrlString = self.data[@"img"];
        commodityInfo.urlString = urlString;
        commodityInfo.note =self.data[@"discount_price"];
        commodityInfo.show = YES;
        
        
        QYSessionViewController *sessionViewController = [[QYSDK sharedSDK] sessionViewController];
 
        sessionViewController.sessionTitle = @"库课网校";
        sessionViewController.source = source;
        sessionViewController.commodityInfo = commodityInfo;
        sessionVC = sessionViewController;
        if (IS_PAD) {
            UINavigationController* navi = [[UINavigationController alloc]initWithRootViewController:sessionViewController];
            navi.modalPresentationStyle = UIModalPresentationFormSheet;
            [self presentViewController:navi animated:YES completion:nil];
        }
        else{
            sessionViewController.hidesBottomBarWhenPushed = YES;
             UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"导航栏返回"] style:UIBarButtonItemStylePlain target:self action:@selector(onBack:)];

            sessionViewController.navigationItem.leftBarButtonItem = leftItem;
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:sessionViewController];
            [PCCUtils deviceOnInterfaceOrientationMaskPortrait];
            [self presentViewController:nav animated:YES completion:nil];
        }
        
        [[QYSDK sharedSDK] customUIConfig].bottomMargin = 0;
        [[[QYSDK sharedSDK] customActionConfig] setLinkClickBlock:^(NSString *linkAddress) {
            AdWebViewController *vc = [[AdWebViewController alloc]init];
            vc.url = linkAddress;
            vc.title = @"商品详情";
//            UIBarButtonItem *leftItem1 = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"导航栏返回"] style:UIBarButtonItemStylePlain target:sessionViewController action:@selector(back)];
//
//            vc.navigationItem.leftBarButtonItem = leftItem1;
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
            [sessionViewController presentViewController:nav animated:YES completion:nil];
        }];
    }else{
        [BaseTools showErrorMessage:@"请登录后再操作"];
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [BaseTools alertLoginWithVC:self];
        });
    }
}
- (void)pause:(PLVPlayerSkinView *)skinView {
    [(PLVLivePlayerController *)self.mediaVC.player pause];
}
- (void)back{
    [sessionVC dismissViewControllerAnimated:YES completion:nil];
}
- (void)onBack:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)gongzhonghaoClick{
    WechatAlterView *wechatView = [[WechatAlterView alloc]initWithFrame:CGRectMake(0, 0,293,413)];
    wechatView.layer.cornerRadius = 5;
    wechatView.layer.masksToBounds = YES;
    CGPoint showCenter = CGPointMake(SCREEN_WIDTH/2,SCREEN_HEIGHT-self.view.height/2-50);
    [SGBrowserView showMoveView:wechatView moveToCenter:showCenter];
    wechatView.closeBlock = ^{
        [SGBrowserView hide];
    };
    wechatView.saveBlock = ^(UIImageView *pic) {
        UIImageWriteToSavedPhotosAlbum([UIImage imageNamed:@"公众号二维码"], self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    };
    
}

#pragma mark -- <保存到相册>
-(void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    NSString *msg = nil ;
    if(error){
        msg = @"保存图片失败" ;
        [BaseTools showErrorMessage:msg];
    }else{
        msg = @"保存图片成功" ;
        [BaseTools showErrorMessage:msg];
    }
}

- (void)dealloc {
    NSLog(@"%s", __FUNCTION__);
    [UIApplication sharedApplication].idleTimerDisabled = self.idleTimerDisabled;
}

- (void)playerPolling {
    if (@available(iOS 10.0, *)) {
        self.pollingTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 repeats:YES block:^(NSTimer * _Nonnull timer) {
            NSLog(@"观看时长：%ld，停留时长：%ld", self.mediaVC.player.watchDuration, self.mediaVC.player.stayDuration);
        }];
    }
}

#pragma mark - init
- (void)initData {
    PLVLiveVideoConfig *liveConfig = [PLVLiveVideoConfig sharedInstance];
    self.channelId = liveConfig.channelId.integerValue;
    
    PLVSocketObjectUserType userType = self.liveType==PLVLiveViewControllerTypeLive ? PLVSocketObjectUserTypeStudent : PLVSocketObjectUserTypeSlice;
    
    /* 初始化登录用户
        1. nickName 为nil时，聊天室首次点击输入栏会弹窗提示输入昵称。可通过设置defaultUser属性为NO屏蔽
        2. 抽奖功能必须固定唯一的 nickName 和 userId，如果忘了填写上次的中奖信息，有固定的 userId 还会再次弹出相关填写页面
     */
    PLVSocketObject *loginUser = [PLVSocketObject socketObjectForLoginWithRoomId:self.channelId nickName:self.nickName avatar:self.avatarUrl userId:nil accountId:[PLVLiveVideoConfig sharedInstance].userId authorization:nil userType:userType];
    loginUser.defaultUser = NO; // 屏蔽聊天室点击输入栏弹窗提示输入昵称
    [PLVChatroomManager sharedManager].loginUser = loginUser;
}

- (void)setupUI {
    CGFloat mediaViewControllerHeight = self.view.bounds.size.width * (self.liveType == PLVLiveViewControllerTypeCloudClass ? PPTPlayerViewScale : NormalPlayerViewScale);
    mediaViewControllerHeight += [UIApplication sharedApplication].statusBarFrame.size.height;
    
    [self setupPublicChatroom:mediaViewControllerHeight];
    [self addMediaViewController:mediaViewControllerHeight];
}

- (void)addMediaViewController:(CGFloat)h {
    PLVLiveVideoConfig *liveConfig = [PLVLiveVideoConfig sharedInstance];
    PLVSocketObject *loginUser = [PLVChatroomManager sharedManager].loginUser;
    CGRect originSecondaryFrame = CGRectZero;
    
    if (self.liveType == PLVLiveViewControllerTypeCloudClass) {
        self.mediaVC = [[PLVPPTLiveMediaViewController alloc] init];
        CGFloat w = (int)([UIScreen mainScreen].bounds.size.width / 3.0);
        originSecondaryFrame = CGRectMake(self.view.frame.size.width - w, h + 44.0, w, (int)(w * PPTPlayerViewScale));
    } else {
        self.mediaVC = [[PLVNormalLiveMediaViewController alloc] init];
        CGFloat w = (int)([UIScreen mainScreen].bounds.size.width / 3.0);
        originSecondaryFrame = CGRectMake(self.view.frame.size.width - w, h + 44.0, w, (int)(w * NormalPlayerViewScale));
    }
    
    self.mediaVC.delegate = self;
    self.mediaVC.playAD = self.playAD;
    self.mediaVC.channelId = liveConfig.channelId; //必须，不能为空
    self.mediaVC.userId = liveConfig.userId; //必须，不能为空
    self.mediaVC.nickName = loginUser.nickName;
    self.mediaVC.view.frame = CGRectMake(0.0, 0.0, self.view.bounds.size.width, h);
    self.mediaVC.originFrame = self.mediaVC.view.frame;
    [self.view addSubview:self.mediaVC.view];
    [self createKefuView];
    self.linkMicVC = [[PLVLinkMicController alloc] init];
    self.linkMicVC.delegate = self;
    if (self.liveType == PLVLiveViewControllerTypeLive) {
        self.linkMicVC.linkMicType = PLVLinkMicTypeLive;//开启视频连麦时，普通直播的连麦窗口是音频模式
        self.linkMicVC.originSecondaryFrame = CGRectMake(0.0, originSecondaryFrame.origin.y, 60.0, 60.0);
    } else {
        self.linkMicVC.linkMicType = PLVLinkMicTypeCloudClass;//开启视频连麦时，云课堂的是视频模式
        self.linkMicVC.originSecondaryFrame = originSecondaryFrame;
    }
    self.linkMicVC.view.frame = CGRectMake(0.0, self.linkMicVC.originSecondaryFrame.origin.y, self.view.bounds.size.width, self.linkMicVC.originSecondaryFrame.size.height);
    self.linkMicVC.linkMicBtn = self.mediaVC.skinView.linkMicBtn;
    [self.view insertSubview:self.linkMicVC.view aboveSubview:self.mediaVC.view];
    
    self.linkMicVC.login = loginUser;
    self.mediaVC.linkMicVC = self.linkMicVC;
    if (self.liveType == PLVLiveViewControllerTypeCloudClass) {
        [(PLVPPTLiveMediaViewController *)self.mediaVC loadSecondaryView:originSecondaryFrame];
    }
    
//    // 若需要 [加载静态离线页面]，请解开2处注释代码
//    // 1_[加载静态离线页面]
//      NSString *basePath = [NSString stringWithFormat:@"%@/dist", [[NSBundle mainBundle] bundlePath]];
//      NSURL *baseURL = [NSURL fileURLWithPath:basePath isDirectory:YES];
//      NSString *htmlPath = [NSString stringWithFormat:@"%@/index.html", basePath];
//      NSError * htmlError;
//      NSString *htmlString = [NSString stringWithContentsOfFile:htmlPath encoding:NSUTF8StringEncoding error:&htmlError];
//      if (htmlError) { NSLog(@"[加载静态离线页面] 错误 Error - %@",htmlError); }
    
    self.triviaCardVC = [[PLVTriviaCardViewController alloc] init];
    self.triviaCardVC.delegate = self;
    
//    // 2_[加载静态离线页面]
//     self.triviaCardVC.localHtml = htmlString;
//     self.triviaCardVC.baseURL = baseURL;
    
    self.triviaCardVC.view.frame = self.view.bounds;
    self.triviaCardVC.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:self.triviaCardVC.view];
}

- (void)setupPublicChatroom:(CGFloat)top {
    CGRect pageCtrlFrame = CGRectMake(0, top, SCREEN_WIDTH, SCREEN_HEIGHT - top);
    CGRect chatroomFrame = CGRectMake(0, 0, CGRectGetWidth(pageCtrlFrame), CGRectGetHeight(pageCtrlFrame)-PageControllerTopBarHeight);
    
    PLVTextInputViewType type = self.liveType == PLVLiveViewControllerTypeLive ? PLVTextInputViewTypeNormalPublic : PLVTextInputViewTypeCloudClassPublic;
    self.publicChatroomController = [PLVChatroomController chatroomWithType:type roomId:self.channelId frame:chatroomFrame];
    self.publicChatroomController.delegate = self;
//    self.publicChatroomController.allowToSpeakInTeacherMode = NO;
    [self.publicChatroomController loadSubViews:self.view];
    
    self.pageController = [[FTPageController alloc] initWithTitles:@[@"互动聊天"] controllers:@[self.publicChatroomController]];
    self.pageController.view.backgroundColor = [UIColor colorWithWhite:236/255.0 alpha:1];
    self.pageController.view.frame = pageCtrlFrame;
    [self.view addSubview:self.pageController.view];
    [self addChildViewController:self.pageController];
}

- (void)addPrivateChatroom {
    self.privateChatroomController = [PLVChatroomController chatroomWithType:PLVTextInputViewTypePrivate roomId:self.channelId frame:self.publicChatroomController.view.frame];
    self.privateChatroomController.delegate = self;
    [self.privateChatroomController loadSubViews:self.view];
    
    [self.pageController addPageWithTitle:@"提问" controller:self.privateChatroomController];
}

#pragma mark - view controls
- (BOOL)shouldAutorotate {
    return self.mediaVC != nil && self.mediaVC.canAutorotate && ![PLVLiveVideoConfig sharedInstance].unableRotate && ![PLVLiveVideoConfig sharedInstance].triviaCardUnableRotate;
}

- (BOOL)prefersStatusBarHidden {
    if (self.mediaVC.skinView.fullscreen) {//横屏时，隐藏Status Bar
        [self.view bringSubviewToFront:self.kefuView];
        self.kefuView.frame = CGRectMake(self.view.frame.size.width-53, self.view.frame.size.height-150, 45, 45);
        return YES;
    } else {
        [self.view bringSubviewToFront:self.kefuView];
        self.kefuView.frame = CGRectMake(screenWidth()-53,screenHeight()-150,45,45);
        return NO;
    }
}

- (UIStatusBarStyle)preferredStatusBarStyle {//Status Bar颜色随底色高亮变化
    return UIStatusBarStyleLightContent;
}

#pragma mark - network request
- (void)loadChannelMenuInfos {
    __weak typeof(self)weakSelf = self;
    [PLVLiveVideoAPI getChannelMenuInfos:self.channelId completion:^(PLVLiveVideoChannelMenuInfo *channelMenuInfo) {
        for (PLVLiveVideoChannelMenu *menu in channelMenuInfo.channelMenus) {
            if ([menu.menuType isEqualToString:@"quiz"]) {
                [weakSelf addPrivateChatroom];
                break;
            }
        }
    } failure:^(NSError *error) {
        NSLog(@"频道菜单获取失败！%@",error);
    }];
}

- (void)loadChatroomInfos {
    __weak typeof(self) weakSelf = self;
    [PLVLiveVideoAPI loadChatroomFunctionSwitchWithRoomId:self.channelId completion:^(NSDictionary *switchInfo) {
        PLVLiveVideoConfig *liveConfig = [PLVLiveVideoConfig sharedInstance];
        [PLVLiveVideoAPI requestAuthorizationForLinkingSocketWithChannelId:weakSelf.channelId Appld:liveConfig.appId appSecret:liveConfig.appSecret success:^(NSDictionary *responseDict) {
            weakSelf.mediaVC.linkMicVC.linkMicParams = responseDict;
            [weakSelf initSocketIOWithTokenInfo:responseDict];
        } failure:^(NSError *error) {
            [PCCUtils showHUDWithTitle:@"聊天室Token获取失败！" detail:error.localizedDescription view:weakSelf.view];
        }];
        [weakSelf.publicChatroomController setSwitchInfo:switchInfo];
    } failure:^(NSError *error) {
        [PCCUtils showHUDWithTitle:@"聊天室状态获取失败！" detail:error.localizedDescription view:weakSelf.view];
    }];
}

#pragma mark - exit
- (void)exitCurrentController {//退出前释放播放器，连麦，socket资源
    [PCCUtils deviceOnInterfaceOrientationMaskPortrait];
    [self.mediaVC clearResource];
    [self.linkMicVC clearResource];
    [self.publicChatroomController clearResource];
    [self.privateChatroomController clearResource];
    [self clearSocketIO];
    if (self.pollingTimer) {
        [self.pollingTimer invalidate];
        self.pollingTimer = nil;
    }
    KPostNotification(@"CloseLive", nil);
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)exitCurrentControllerWithAlert:(NSString *)title message:(NSString *)message {
    __weak typeof(self) weakSelf = self;
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf exitCurrentController];
    }]];
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - SocketIO init / clear
- (void)initSocketIOWithTokenInfo:(NSDictionary *)responseDict {
    self.socketIO = [[PLVSocketIO alloc] initSocketIOWithConnectToken:responseDict[@"chat_token"] enableLog:NO];//初始化 socketIO 连接对象
    self.socketIO.delegate = self;
    [self.socketIO connect];
    //self.socketIO.debugMode = YES;
}

- (void)clearSocketIO {
    if (self.socketIO) {
        [self.socketIO disconnect];
        [self.socketIO removeAllHandlers];
        self.socketIO = nil;
    }
}

#pragma mark - PLVSocketIODelegate
// 此方法可能多次调用，如锁屏后返回会重连聊天室
- (void)socketIO:(PLVSocketIO *)socketIO didConnectWithInfo:(NSString *)info {
    NSLog(@"%@--%@", NSStringFromSelector(_cmd), info);
    [socketIO emitMessageWithSocketObject:[PLVChatroomManager sharedManager].loginUser];//登录聊天室
}

- (void)socketIO:(PLVSocketIO *)socketIO didUserStateChange:(PLVSocketUserState)userState {
    NSLog(@"%@--userState:%ld", NSStringFromSelector(_cmd), (long)userState);
    [PCCUtils showChatroomMessage:PLVNameStringWithSocketUserState(userState) addedToView:self.pageController.view];
    if (userState == PLVSocketUserStateLogined) {
        PLVSocketObject *socketObject = socketIO.user;
        socketObject.accountId = [PLVLiveVideoConfig sharedInstance].userId; // 当前需要
        [PLVChatroomManager sharedManager].socketUser = socketObject;
    }
}

#pragma mark Socket message
- (void)socketIO:(PLVSocketIO *)socketIO didReceivePublicChatMessage:(PLVSocketChatRoomObject *)chatObject {
//    NSLog(@"%@--type:%lu, event:%@", NSStringFromSelector(_cmd), (unsigned long)chatObject.eventType, chatObject.event);
    [self.publicChatroomController addNewChatroomObject:chatObject];
}

- (void)socketIO:(PLVSocketIO *)socketIO didReceivePrivateChatMessage:(PLVSocketChatRoomObject *)chatObject {
//    NSLog(@"%@--type:%lu, event:%@", NSStringFromSelector(_cmd), (unsigned long)chatObject.eventType, chatObject.event);
    if (self.privateChatroomController) {
        [self.privateChatroomController addNewChatroomObject:chatObject];
    }
}

- (void)socketIO:(PLVSocketIO *)socketIO didReceiveLinkMicMessage:(PLVSocketLinkMicObject *)linkMicObject {
    NSLog(@"%@--type:%lu, event:%@", NSStringFromSelector(_cmd), (unsigned long)linkMicObject.eventType, linkMicObject.event);
    [self.mediaVC.linkMicVC handleLinkMicObject:linkMicObject];
}

- (void)socketIO:(PLVSocketIO *)socketIO didReceivePPTMessage:(NSString *)json {
    if ([self.mediaVC isKindOfClass:PLVPPTLiveMediaViewController.class]) {
        [(PLVPPTLiveMediaViewController *)self.mediaVC refreshPPT:json];
    }
}

#pragma mark Interactive message
- (void)socketIO:(PLVSocketIO *)socketIO didReceiveBulletinMessage:(NSString *)json result:(int)result {
    if (result == 0) {
        [self.triviaCardVC openBulletin:json];
    }else if(result == 1){
        [self.triviaCardVC removeBulletin];
    }
}

- (void)socketIO:(PLVSocketIO *)socketIO didReceiveQuestionMessage:(NSString *)json result:(int)result {
    __weak typeof(self) weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (result == 0) {
            [weakSelf.triviaCardVC openQuestionContent:json];
        } else if (result == 1) {
            [weakSelf.triviaCardVC openQuestionResult:json];
        } else if (result == 2) {
            [weakSelf.triviaCardVC testQuestion:json];
        }
    });
}

- (void)socketIO:(PLVSocketIO *)socketIO didReceiveLotteryMessage:(NSString *)json result:(int)result {
    if (result == 0 || result == 2) {
        [self.triviaCardVC startLottery:json];
    } else if (result == 1 || result == 3) {
        [self.triviaCardVC stopLottery:json socketIO:socketIO];
    }
}

- (void)socketIO:(PLVSocketIO *)socketIO didReceiveQuestionnaireMessage:(NSString *)json result:(int)result {
    if (result == 0) {
        [self.triviaCardVC openQuestionnaireContent:json]; // 打开问卷
    } else if (result == 1) {
        [self.triviaCardVC stopQuestionNaire:json];    // 关闭问卷
    }
}

- (void)socketIO:(PLVSocketIO *)socketIO didReceiveSignInMessage:(NSString *)json result:(int)result {
    if (result == 0) {
        [self.triviaCardVC startSign:json];
    } else if (result == 1) {
        [self.triviaCardVC stopSign:json];
    }
}

#pragma mark Custom message
- (void)socketIO:(PLVSocketIO *)socketIO didReceiveCustomMessage:(NSDictionary *)customMessage {
    NSLog(@"%@--%@",NSStringFromSelector(_cmd),customMessage[@"EVENT"]);
    [self.publicChatroomController addCustomMessage:customMessage mine:NO];
}

#pragma mark Connect state
- (void)socketIO:(PLVSocketIO *)socketIO didDisconnectWithInfo:(NSString *)info {
    NSLog(@"%@--%@",NSStringFromSelector(_cmd),info);
    [PCCUtils showChatroomMessage:@"聊天室失去连接" addedToView:self.pageController.view];
}

- (void)socketIO:(PLVSocketIO *)socketIO connectOnErrorWithInfo:(NSString *)info {
    NSLog(@"%@--%@",NSStringFromSelector(_cmd),info);
    [PCCUtils showChatroomMessage:@"聊天室连接失败" addedToView:self.pageController.view];
    if (self.publicChatroomController) {
        [self.publicChatroomController recoverChatroomStatus];
    }
}

- (void)socketIO:(PLVSocketIO *)socketIO reconnectWithInfo:(NSString *)info {
    NSLog(@"%@--%@",NSStringFromSelector(_cmd),info);
    [PCCUtils showChatroomMessage:@"聊天室重连中..." addedToView:self.pageController.view];
}

#pragma mark Error
- (void)socketIO:(PLVSocketIO *)socketIO localError:(NSString *)description {
    NSLog(@"%@--%@",NSStringFromSelector(_cmd),description);
}

#pragma mark - PLVChatroomDelegate
- (void)chatroom:(PLVChatroomController *)chatroom didOpenError:(PLVChatroomErrorCode)code {
    if (code == PLVChatroomErrorCodeBeKicked) {
        [self exitCurrentControllerWithAlert:nil message:@"您未被授权观看本直播"];
    }
}

- (void)chatroom:(PLVChatroomController *)chatroom emitSocketObject:(PLVSocketChatRoomObject *)object {
    if (self.socketIO.socketIOState == PLVSocketIOStateConnected) {
        [self.socketIO emitMessageWithSocketObject:object];
    } else {
        [PCCUtils showChatroomMessage:@"聊天室未连接！" addedToView:self.pageController.view];
    }
}

- (void)chatroom:(PLVChatroomController *)chatroom followKeyboardAnimation:(BOOL)flag {
    if (!self.mediaVC.skinView.fullscreen) {
        if (flag) {
            CGFloat safeAreaY = 20.0;
            if (@available(iOS 11.0, *)) {
                safeAreaY = self.view.safeAreaLayoutGuide.layoutFrame.origin.y;
            }
            CGRect linkMicRect = self.linkMicVC.view.frame;
            linkMicRect = CGRectMake(0.0, safeAreaY, linkMicRect.size.width, linkMicRect.size.height);
            self.linkMicVC.view.frame = linkMicRect;
            [self.mediaVC.view insertSubview:self.linkMicVC.view belowSubview:self.mediaVC.skinView];
        } else {
            self.linkMicVC.view.frame = CGRectMake(0.0, self.linkMicVC.originSecondaryFrame.origin.y, self.view.bounds.size.width, self.linkMicVC.originSecondaryFrame.size.height);
            [self.view insertSubview:self.linkMicVC.view aboveSubview:self.mediaVC.view];
        }
        
        if ([self.mediaVC isKindOfClass:PLVPPTLiveMediaViewController.class]) {
            [(PLVPPTLiveMediaViewController *)self.mediaVC secondaryViewFollowKeyboardAnimation:flag];
        }
    }
}

- (NSString *)currentChannelSessionId:(PLVChatroomController *)chatroom {
    return [self.mediaVC currentChannelSessionId];
}

- (void)chatroom:(PLVChatroomController *)chatroom didSendSpeakContent:(NSString *)content {
    NSMutableAttributedString *attributedStr = [[PLVEmojiManager sharedManager] convertTextEmotionToAttachment:content font:[UIFont systemFontOfSize:14]];
    [self.mediaVC danmu:attributedStr];
}

- (void)chatroom:(PLVChatroomController *)chatroom emitCustomEvent:(NSString *)event emitMode:(int)emitMode data:(NSDictionary *)data tip:(NSString *)tip {
    if (self.socketIO.socketIOState == PLVSocketIOStateConnected) {
        [self.socketIO emitCustomEvent:event roomId:self.channelId emitMode:emitMode data:data tip:tip];
    } else {
        [PCCUtils showChatroomMessage:@"聊天室未连接！" addedToView:self.pageController.view];
    }
}

- (void)chatroom:(PLVChatroomController *)chatroom showMessage:(NSString *)message {
    [PCCUtils showChatroomMessage:message addedToView:self.pageController.view];
}

- (void)readBulletin:(PLVChatroomController *)chatroom{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.33 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.triviaCardVC openLastBulletin];
    });
}

#pragma mark - PLVBaseMediaViewControllerDelegate
- (void)quit:(PLVBaseMediaViewController *)mediaVC error:(NSError *)error {
    if (error) {
        if (error.code == PLVBaseMediaErrorCodeMarqueeFailed) {
            [self exitCurrentControllerWithAlert:@"自定义跑马灯校验失败" message:error.localizedDescription];
        }
    } else {
        [self exitCurrentController];
    }
}

- (void)statusBarAppearanceNeedsUpdate:(PLVBaseMediaViewController *)mediaVC {
    [self setNeedsStatusBarAppearanceUpdate];//横竖屏切换前，更新Status Bar的状态
    
    [self.triviaCardVC layout:self.mediaVC.skinView.fullscreen];
    if (self.mediaVC.skinView.fullscreen) {
        [self.publicChatroomController tapChatInputView];
        [self.privateChatroomController tapChatInputView];
    }
}

- (void)sendText:(PLVBaseMediaViewController *)mediaVC text:(NSString *)text{
    [self.publicChatroomController sendTextMessage:text];
}

#pragma mark - PLVTriviaCardViewControllerDelegate
- (void)triviaCardViewController:(PLVTriviaCardViewController *)triviaCardVC chooseAnswer:(NSDictionary *)dict {
    [self.socketIO emitMessageWithSocketObject:[self createCardSocketObjectWithEvent:@"ANSWER_TEST_QUESTION" dict:dict]];
}

- (void)triviaCardViewController:(PLVTriviaCardViewController *)triviaCardVC questionnaireAnswer:(NSDictionary *)dict {
    [self.socketIO emitMessageWithSocketObject:[self createCardSocketObjectWithEvent:@"ANSWER_QUESTIONNAIRE" dict:dict]];
}

- (void)triviaCardViewController:(PLVTriviaCardViewController *)triviaCardVC checkIn:(NSDictionary *)dict {
    NSString *nickName = self.socketIO.user.nickName;
    NSDictionary *user = @{@"nick" : nickName, @"userId" : self.socketIO.userId};
    NSDictionary *baseJSON = @{@"EVENT" : @"TO_SIGN_IN", @"roomId" : [NSString stringWithFormat:@"%lu", (unsigned long)self.socketIO.roomId], @"user" : user};
    NSMutableDictionary *json = [[NSMutableDictionary alloc] init];
    [json addEntriesFromDictionary:baseJSON];
    [json addEntriesFromDictionary:dict];
    PLVSocketTriviaCardObject *checkin = [PLVSocketTriviaCardObject socketObjectWithJsonDict:json];
    [self.socketIO emitMessageWithSocketObject:checkin];
}

- (void)triviaCardViewController:(PLVTriviaCardViewController *)triviaCardVC lottery:(NSDictionary *)dict {
    NSMutableDictionary *data = [[NSMutableDictionary alloc] init];
    [data addEntriesFromDictionary:@{@"channelId" : [NSString stringWithFormat:@"%lu", (unsigned long)self.socketIO.roomId]}];
    [data addEntriesFromDictionary:dict];
    [PLVLiveVideoAPI postLotteryWithData:data completion:nil failure:^(NSError *error) {
        NSLog(@"抽奖信息提交失败: %@", error.description);
    }];
}

- (PLVSocketTriviaCardObject *)createCardSocketObjectWithEvent:(NSString *)event dict:(NSDictionary *)dict{
    NSString *nickName = self.socketIO.user.nickName;
    NSDictionary *baseJSON = @{@"EVENT" : event, @"roomId" : [NSString stringWithFormat:@"%lu", (unsigned long)self.socketIO.roomId], @"nick" : nickName, @"userId" : self.socketIO.userId};
    NSMutableDictionary *json = [[NSMutableDictionary alloc] init];
    [json addEntriesFromDictionary:baseJSON];
    [json addEntriesFromDictionary:dict];
    PLVSocketTriviaCardObject *triviaCard = [PLVSocketTriviaCardObject socketObjectWithJsonDict:json];
    return triviaCard;
}

#pragma mark - PLVLinkMicControllerDelegate
- (void)linkMicController:(PLVLinkMicController *)lickMic toastTitle:(NSString *)title detail:(NSString *)detail {
    [PCCUtils showHUDWithTitle:title detail:detail view:[UIApplication sharedApplication].delegate.window];
}

- (void)linkMicController:(PLVLinkMicController *)lickMic linkMicStatus:(BOOL)select {
    [self.mediaVC.skinView linkMicStatus:select];
}

- (void)linkMicController:(PLVLinkMicController *)lickMic emitLinkMicObject:(PLVSocketLinkMicEventType)eventType {
    PLVSocketObject *loginUser = [PLVChatroomManager sharedManager].loginUser;
    PLVSocketLinkMicObject *linkMicObject = [PLVSocketLinkMicObject linkMicObjectWithEventType:eventType roomId:self.channelId userNick:loginUser.nickName userPic:loginUser.avatar userId:(NSUInteger)loginUser.userId.longLongValue userType:loginUser.userType];
    [self.socketIO emitMessageWithSocketObject:linkMicObject];
}

- (void)linkMicController:(PLVLinkMicController *)lickMic emitAck:(PLVSocketLinkMicEventType)eventType after:(double)after callback:(void (^)(NSArray * _Nonnull))callback {
    PLVSocketObject *loginUser = [PLVChatroomManager sharedManager].loginUser;
    PLVSocketLinkMicObject *linkMicObject = [PLVSocketLinkMicObject linkMicObjectWithEventType:eventType roomId:self.channelId userNick:loginUser.nickName userPic:loginUser.avatar userId:(NSUInteger)loginUser.userId.longLongValue userType:loginUser.userType];
    [self.socketIO emitACKWithSocketObject:linkMicObject after:after callback:callback];
}

- (void)linkMicSuccess:(PLVLinkMicController *)lickMic {
    [self.mediaVC linkMicSuccess];
}

- (void)cancelLinkMic:(PLVLinkMicController *)lickMic {
    [self.mediaVC cancelLinkMic];
}

- (void)linkMicSwitchViewAction:(PLVLinkMicController *)lickMic {
    if ([self.mediaVC isKindOfClass:PLVPPTLiveMediaViewController.class]) {
        [(PLVPPTLiveMediaViewController *)self.mediaVC linkMicSwitchViewAction];
    }
}

@end
