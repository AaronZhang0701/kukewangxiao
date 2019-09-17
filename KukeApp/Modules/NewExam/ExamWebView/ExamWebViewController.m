//
//  ExamWebViewController.m
//  KukeApp
//
//  Created by 库课 on 2019/7/29.
//  Copyright © 2019 KukeZangMing. All rights reserved.
//

#import "ExamWebViewController.h"
#import "BAKit_WebView.h"
#import "BAAlertController.h"
#import <GGWkCookie/GGWkCookie.h>
#import "PLVDownloadManagerViewController.h"
@interface ExamWebViewController ()<WKUIDelegate,WKNavigationDelegate,GGWkWebViewDelegate,WKScriptMessageHandler,NoDataTipsDelegate,UIScrollViewDelegate>{
    NSMutableDictionary *_cookieDic;
}
@property(nonatomic, strong) WKWebView *webView;
@property(nonatomic, strong) WKWebViewConfiguration *webConfig;
@property(nonatomic, strong) UIProgressView *progressView;
@property (nonatomic, strong) NoDataTipsView *loadNetView;
@property(nonatomic, strong) NSURL *ba_web_currentUrl;

@end

@implementation ExamWebViewController
- (void) viewWillAppear:(BOOL)animated{
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [_webConfig.userContentController addScriptMessageHandler:self name:@"goBack"];
    [_webConfig.userContentController addScriptMessageHandler:self name:@"gohome"];
    [_webConfig.userContentController addScriptMessageHandler:self name:@"goLogin"];
    [_webConfig.userContentController addScriptMessageHandler:self name:@"goShare"];

}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [_webConfig.userContentController removeScriptMessageHandlerForName:@"goBack"];
    [_webConfig.userContentController removeScriptMessageHandlerForName:@"gohome"];
    [_webConfig.userContentController removeScriptMessageHandlerForName:@"goLogin"];
    [_webConfig.userContentController removeScriptMessageHandlerForName:@"goShare"];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // 设置一个测试cookie的字典
    
  [self setAutomaticallyAdjustsScrollViewInsets:NO];
    [self setupUI];
}
- (void)setupUI
{
    self.view.backgroundColor = BAKit_Color_White_pod;
    self.webView.hidden = NO;

    [self.view addSubview:self.webView];
//    [self configBackItem];
//    [self configMenuItem];
    NSString *token = nil;
    if ([[UserDefaultsUtils valueWithKey:@"access_token"] length]>0) {
        token =[UserDefaultsUtils valueWithKey:@"access_token"];
    }else{
        token = @"";
    }
    _cookieDic = [NSMutableDictionary dictionaryWithDictionary:@{
                                                                 @"app_mark":@"ios",
                                                                 @"accessToken":token,
                                                                 @"kuke": @"1",
                                                                 }];
    // 开启自定义cookie
    [_webView startCustomCookie];

   /*   加载本地html
    NSString *path = [[NSBundle mainBundle] bundlePath];
    NSURL *baseURL = [NSURL fileURLWithPath:path];
    NSString * htmlPath = [[NSBundle mainBundle] pathForResource:@"index"
                                                          ofType:@"html"];
    NSString * htmlCont = [NSString stringWithContentsOfFile:htmlPath
                                                    encoding:NSUTF8StringEncoding
                                                       error:nil];
    [self.webView loadHTMLString:htmlCont baseURL:baseURL];*/
    
    if (![CoreStatus isNetworkEnable]) {
        [self.view addSubview:self.loadNetView];
    }else{
        [self.webView ba_web_loadURLString:self.url];
    }
    BAKit_WeakSelf;
    self.webView.ba_web_didStartBlock = ^(WKWebView *webView, WKNavigation *navigation) {
        
        //        BAKit_StrongSelf
        NSLog(@"开始加载网页");
    };
    
    self.webView.ba_web_didFinishBlock = ^(WKWebView *webView, WKNavigation *navigation) {
        NSLog(@"加载网页结束");
        
        // WKWebview 禁止长按(超链接、图片、文本...)弹出效果
        [webView ba_web_stringByEvaluateJavaScript:@"document.documentElement.style.webkitTouchCallout='none'" completionHandler:nil];
    };
    
    self.webView.ba_web_isLoadingBlock = ^(BOOL isLoading, CGFloat progress) {
        
        BAKit_StrongSelf
        [self ba_web_progressShow];
        self.progressView.progress = progress;
        if (self.progressView.progress == 1.0f)
        {
            [self ba_web_progressHidden];
        }
    };
    
    self.webView.ba_web_getTitleBlock = ^(NSString *title) {
        
        BAKit_StrongSelf
        // 获取当前网页的 title
        self.title = title;
    };
    
    self.webView.ba_web_getCurrentUrlBlock = ^(NSURL * _Nonnull currentUrl) {
        BAKit_StrongSelf
        self.ba_web_currentUrl = currentUrl;
    };
    
    // 必须要先设定 要拦截的 urlScheme，然后再处理 回调
    self.webView.ba_web_urlScheme = @"basharefunction";
    self.webView.ba_web_decidePolicyForNavigationActionBlock = ^(NSURL *currentUrl) {
        NSLog(@"%@",currentUrl);
    };
}


/**
 *  加载 js 字符串，例如：高度自适应获取代码：
 // webView 高度自适应
 [self ba_web_stringByEvaluateJavaScript:@"document.body.offsetHeight" completionHandler:^(id _Nullable result, NSError * _Nullable error) {
 // 获取页面高度，并重置 webview 的 frame
 self.ba_web_currentHeight = [result doubleValue];
 CGRect frame = webView.frame;
 frame.size.height = self.ba_web_currentHeight;
 webView.frame = frame;
 }];
 *
 *  @param javaScriptString js 字符串
 */
- (void)ba_web_stringByEvaluateJavaScript:(NSString *)javaScriptString completionHandler:(void (^ _Nullable)(_Nullable id, NSError * _Nullable error))completionHandler
{
    [self.webView ba_web_stringByEvaluateJavaScript:javaScriptString completionHandler:completionHandler];
}
#pragma mark - GGWkWebViewDelegate
/// 代理方法中设置 app自定义的cookie
- (NSDictionary *)webviewSetAppCookieKeyAndValue {
    return _cookieDic;
}
#pragma mark - 懒加载失败默认视图
- (NoDataTipsView *)loadNetView {
    if (!_loadNetView) {
        
        _loadNetView = [NoDataTipsView setTipsBackGroupWithframe:CGRectMake(0, 0, screenWidth(), self.view.height) tipsIamgeName:@"无网络" tipsStr:@"无法连接到网络,点击页面刷新"];
        _loadNetView.backgroundColor = CBackgroundColor;
        _loadNetView.noDataBtn.hidden = NO;
        _loadNetView.delegate = self;
    }
    return _loadNetView;
}
#pragma mark - <NoDataTipsDelegate> - 提示按钮点击
- (void)tipsNoDataBtnDid {
    if ([[UserDefaultsUtils valueWithKey:@"access_token"] length] !=0 ) {
        UIViewController *rootViewController = [[UIApplication sharedApplication] keyWindow].rootViewController;
        UIViewController *topViewController = [BaseTools topViewControllerWithRootViewController:rootViewController];
        PLVDownloadManagerViewController *vc = [[PLVDownloadManagerViewController alloc]init];
        [topViewController.navigationController pushViewController:vc animated:YES];
    }else{
        [BaseTools showErrorMessage:@"请登录后再操作"];
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [BaseTools alertLoginWithVC:self];
        });
    }
}
- (void)tipsRefreshBtnClicked{
    [self.webView ba_web_loadURLString:self.url];
}

#pragma mark 导航栏的返回按钮
- (void)configBackItem
{
    UIImage *backImage = [UIImage imageNamed:@"导航栏返回"];
//    backImage = [backImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    UIButton *backBtn = [[UIButton alloc] init];
    backBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    if (kIsiPhoneX) {
        backBtn.frame = CGRectMake(10, 44, 44, 44);
    }else{
        backBtn.frame = CGRectMake(10, 20, 44, 44);
    }
    
    [backBtn setImage:backImage forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];

    [self.webView addSubview:backBtn];
//    UIBarButtonItem *colseItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
//    self.navigationItem.leftBarButtonItem = colseItem;
}



- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    self.webView.frame = CGRectMake(0, PLV_StatusBarHeight, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-PLV_StatusBarHeight);
    self.progressView.frame = CGRectMake(0, UI_navBar_Height, BAKit_SCREEN_WIDTH, 20);
}
#pragma mark - setter / getter

- (WKWebView *)webView
{
    if (!_webView)
    {
        _webView = [[WKWebView alloc] initWithFrame:CGRectZero configuration:self.webConfig];
        //设置cookie代理
        _webView.UIDelegate = self;
        _webView.navigationDelegate = self;
        _webView.scrollView.delegate = self;
        [_webView ba_web_initWithDelegate:self uIDelegate:self];
        _webView.cookieDelegate = self;
        _webView.ba_web_isAutoHeight = NO;
        // 是否允许手势左滑返回上一级, 类似导航控制的左滑返回
        _webView.allowsBackForwardNavigationGestures = YES;
        self.webView.multipleTouchEnabled = YES;
        self.webView.autoresizesSubviews = YES;
    }
    return _webView;
}
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation {
    self.title = @"";
    [webView evaluateJavaScript:@"document.cookie" completionHandler:^(NSString *result, NSError * _Nullable error) {
        NSLog(@"网页中的cookie为：\n%@",[result componentsSeparatedByString:@"; "]);
    }];
}
- (WKWebViewConfiguration *)webConfig
{
    if (!_webConfig) {
        //以下代码适配大小
        NSString *jScript = @"var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width'); document.getElementsByTagName('head')[0].appendChild(meta);";
        
        WKUserScript *wkUScript = [[WKUserScript alloc] initWithSource:jScript injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
        
        _webConfig = [[WKWebViewConfiguration alloc] init];
        _webConfig.allowsInlineMediaPlayback = YES;
        if (@available(iOS 9.0, *)) {
            _webConfig.allowsAirPlayForMediaPlayback = YES;
        } else {
            // Fallback on earlier versions
        }
        if (@available(iOS 9.0, *)) {
            _webConfig.allowsPictureInPictureMediaPlayback = YES;
        } else {
            // Fallback on earlier versions
        }
        if (@available(iOS 10.0, *)) {
            
            _webConfig.mediaTypesRequiringUserActionForPlayback = NO;
            
        }
        WKUserContentController *wkUController = [[WKUserContentController alloc] init];
        [wkUController addUserScript:wkUScript];
        _webConfig.userContentController = wkUController;
        //初始化偏好设置属性：preferences
        _webConfig.preferences = [WKPreferences new];
        // The minimum font size in points default is 0;
        //        _webConfig.preferences.minimumFontSize = 40;
        // 是否支持 JavaScript
        _webConfig.preferences.javaScriptEnabled = YES;
        // 不通过用户交互，是否可以打开窗口
        _webConfig.preferences.javaScriptCanOpenWindowsAutomatically = NO;

    }
    return _webConfig;
}

#pragma mark - WKScriptMessageHandler
//当js 通过 注入的方法 @“messageSend” 时会调用代理回调。 原生收到的所有信息都通过此方法接收。
-(void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message
{
    NSLog(@"原生收到了js发送过来的消息 message.body = %@",message.body);
    if ([message.name isEqualToString:@"goBack"]) {
        [self.view resignFirstResponder];
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    if ([message.name isEqualToString:@"goLogin"]) {

        [BaseTools showErrorMessage:@"请登录后再操作"];
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [BaseTools alertLoginWithVC:self];
        });
    }
    if ([message.name isEqualToString:@"gohome"]) {
        // 这是从一个模态出来的页面跳到tabbar的某一个页面
        [[[AppDelegate shareAppDelegate] getCurrentUIVC].navigationController popToRootViewControllerAnimated:NO];
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        
        UITabBarController *tabViewController = (UITabBarController *) appDelegate.window.rootViewController;
        
        [tabViewController setSelectedIndex:0];

    }
    if ([message.name isEqualToString:@"goShare"]) {
        NSDictionary *dict = [self dictionaryWithJsonString:message.body];
        [self shareAction:dict];
    }
    
}
-(void)shareAction:(NSDictionary *)dict {
    

    
    [UMSocialShareUIConfig shareInstance].sharePageGroupViewConfig.sharePageGroupViewPostionType = UMSocialSharePageGroupViewPositionType_Bottom;
    [UMSocialShareUIConfig shareInstance].sharePageScrollViewConfig.shareScrollViewPageItemStyleType = UMSocialPlatformItemViewBackgroudType_None;
    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
        if (platformType == UMSocialPlatformType_UserDefine_Begin+2) {
            //自定义图标的点击事件
        }
        else{
            [self shareWebPageToPlatformType:platformType shareURLString:dict[@"url"] title:dict[@"title"] descr:@"库课网校"];
        }
    }];
}
//网页分享
- (void)shareWebPageToPlatformType:(UMSocialPlatformType)platformType shareURLString:(NSString *)string title:(NSString *)title descr:(NSString *)descr{
    /*
     创建网页内容对象
     根据不同需求设置不同分享内容，一般为图片，标题，描述，url
     */
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:title descr:descr thumImage:[UIImage imageNamed:@"1024"]];
    
    //设置网页地址
    shareObject.webpageUrl = string;
    
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
        if (error) {
            UMSocialLogInfo(@"************Share fail with error %@*********",error);
        }else{
            [[OpenInstallSDK defaultManager] reportEffectPoint:@"goodshare" effectValue:1];
            if ([data isKindOfClass:[UMSocialShareResponse class]]) {
                UMSocialShareResponse *resp = data;
                //分享结果消息
                UMSocialLogInfo(@"response message is %@",resp.message);
                //第三方原始返回的数据
                UMSocialLogInfo(@"response originalResponse data is %@",resp.originalResponse);
            }else{
                UMSocialLogInfo(@"response data is %@",data);
            }
        }
    }];
}
- (void)ba_web_progressShow
{
    // 开始加载网页时展示出progressView
    self.progressView.hidden = NO;
    // 开始加载网页的时候将progressView的Height恢复为1.5倍
    self.progressView.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
    // 防止progressView被网页挡住
    [self.navigationController.view bringSubviewToFront:self.progressView];
}

- (void)ba_web_progressHidden
{
    /*
     *添加一个简单的动画，将progressView的Height变为1.4倍，在开始加载网页的代理中会恢复为1.5倍
     *动画时长0.25s，延时0.3s后开始动画
     *动画结束后将progressView隐藏
     */
    [UIView animateWithDuration:0.25f delay:0.3f options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.progressView.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
    } completion:^(BOOL finished) {
        self.progressView.hidden = YES;
        
    }];
}
#pragma mark - WKNavigationDelegate

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    self.title = @"加载中...";
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    // 禁止放大缩小
    NSString *injectionJSString = @"var script = document.createElement('meta');"
    "script.name = 'viewport';"
    "script.content=\"width=device-width, initial-scale=1.0,maximum-scale=1.0, minimum-scale=1.0, user-scalable=no\";"
    "document.getElementsByTagName('head')[0].appendChild(script);";
    [webView evaluateJavaScript:injectionJSString completionHandler:nil];
    [self.loadNetView removeFromSuperview];
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    self.title = @"";
    NSLog(@"%@", error);
}

- (UIProgressView *)progressView
{
    if (!_progressView)
    {
        _progressView = [UIProgressView new];
        _progressView.tintColor = CNavBgColor;
        _progressView.trackTintColor = BAKit_Color_Gray_8_pod;
        
        self.progressView.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
        
        [self.view addSubview:_progressView];
    }
    return _progressView;
}

- (void)setBa_web_progressTintColor:(UIColor *)ba_web_progressTintColor
{
    _ba_web_progressTintColor = ba_web_progressTintColor;
    
    self.progressView.progressTintColor = ba_web_progressTintColor;
}

- (void)setBa_web_progressTrackTintColor:(UIColor *)ba_web_progressTrackTintColor
{
    _ba_web_progressTrackTintColor = ba_web_progressTrackTintColor;
    
    self.progressView.trackTintColor = ba_web_progressTrackTintColor;
}
- (void)cleanCacheAndCookie
{
    //清除cookies
    NSHTTPCookie *cookie;
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (cookie in [storage cookies])
    {
        [storage deleteCookie:cookie];
    }
    
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    NSURLCache * cache = [NSURLCache sharedURLCache];
    [cache removeAllCachedResponses];
    [cache setDiskCapacity:0];
    [cache setMemoryCapacity:0];
    
    if (@available(iOS 9.0, *)) {
        WKWebsiteDataStore *dateStore = [WKWebsiteDataStore defaultDataStore];
        [dateStore fetchDataRecordsOfTypes:[WKWebsiteDataStore allWebsiteDataTypes]
                         completionHandler:^(NSArray<WKWebsiteDataRecord *> * __nonnull records)
         {
             for (WKWebsiteDataRecord *record  in records)
             {
                 
                 [[WKWebsiteDataStore defaultDataStore] removeDataOfTypes:record.dataTypes
                                                           forDataRecords:@[record]
                                                        completionHandler:^
                  {
                      NSLog(@"Cookies for %@ deleted successfully",record.displayName);
                  }];
             }
         }];
    } else {
        // Fallback on earlier versions
    }
}
- (void)dealloc
{
    [self.webView removeFromSuperview];
    [self.progressView removeFromSuperview];
    
    self.webView = nil;
    self.webConfig = nil;
    self.progressView = nil;
    self.ba_web_currentUrl = nil;
}

- (BOOL)willDealloc
{
    return NO;
}
#pragma mark 导航栏的菜单按钮
- (void)configMenuItem
{
    UIImage *menuImage = [UIImage imageNamed:@"BAKit_WebView.bundle/navigationbar_more"];
    menuImage = [menuImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    UIButton *menuBtn = [[UIButton alloc] init];
    //    [menuBtn setTintColor:BAKit_ColorOrange];
    [menuBtn setImage:menuImage forState:UIControlStateNormal];
    [menuBtn addTarget:self action:@selector(menuBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [menuBtn sizeToFit];
    
    UIBarButtonItem *menuItem = [[UIBarButtonItem alloc] initWithCustomView:menuBtn];
    self.navigationItem.rightBarButtonItem = menuItem;
}

#pragma mark 导航栏的关闭按钮
- (void)configColseItem
{
    UIButton *colseBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 44, 44)];
    [colseBtn setTitle:@"关闭" forState:UIControlStateNormal];
    [colseBtn setTitleColor:BAKit_Color_Black_pod forState:UIControlStateNormal];
    [colseBtn addTarget:self action:@selector(colseBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [colseBtn sizeToFit];
    
    UIBarButtonItem *colseItem = [[UIBarButtonItem alloc] initWithCustomView:colseBtn];
    
    NSMutableArray *newArr = [NSMutableArray arrayWithObjects:self.navigationItem.leftBarButtonItem,colseItem, nil];
    self.navigationItem.leftBarButtonItems = newArr;
}

#pragma mark - 按钮点击事件
#pragma mark 返回按钮点击
- (void)goBack
{
    
//    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"正在做题中，确定要退出吗？" preferredStyle:UIAlertControllerStyleAlert];
//    UIAlertAction *actionOne = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        [self.webView ba_web_stringByEvaluateJavaScript:@"autosave()" completionHandler:^(id  _Nullable result, NSError * _Nullable error) {
//            NSLog(@"%@",error);
//        }];
        [self.view resignFirstResponder];
        [self.navigationController popViewControllerAnimated:YES];
//    }];
//    UIAlertAction *actionTwo = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
//    [alertController addAction:actionOne];
//    [alertController addAction:actionTwo];
//
//    [self presentViewController:alertController animated:YES completion:nil];
    //    if (self.webView.ba_web_canGoBack)
    //    {
    //        [self.webView ba_web_goBack];
    //        if (self.navigationItem.leftBarButtonItems.count == 1)
    //        {
    //            [self configColseItem];
    //        }
    //    }
    //    else
    //    {
    //        [self.navigationController popViewControllerAnimated:YES];
    //    }
}

#pragma mark 菜单按钮点击
- (void)menuBtnAction:(UIButton *)sender
{
    BAKit_WeakSelf
    
    NSArray *buttonTitleArray = @[@"safari打开", @"复制链接", @"分享", @"刷新"];
    NSArray *buttonTitleColorArray = @[BAKit_Color_Red_pod, BAKit_Color_Green_pod, BAKit_Color_Yellow_pod, BAKit_Color_Orange_pod];
    
    [UIAlertController ba_actionSheetShowInViewController:self title:@"更多" message:nil buttonTitleArray:buttonTitleArray buttonTitleColorArray:buttonTitleColorArray popoverPresentationControllerBlock:^(UIPopoverPresentationController * _Nonnull popover) {
        
    } block:^(UIAlertController * _Nonnull alertController, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
        BAKit_StrongSelf
        
        NSString *urlStr = self.ba_web_currentUrl.absoluteString;
        
        if (buttonIndex == 0)
        {
            if (urlStr.length > 0)
            {
                /*! safari打开 */
                BAKit_OpenUrl(urlStr);
                return;
            }
            else
            {
                BAKit_ShowAlertWithMsg_ios8(@"无法获取到当前 URL！");
            }
        }
        else if (buttonIndex == 1)
        {
            /*! 复制链接 */
            if (urlStr.length > 0)
            {
                BAKit_CopyContent(urlStr);
                BAKit_ShowAlertWithMsg_ios8(@"亲爱的，已复制URL到黏贴板中！");
                return;
            }
            else
            {
                BAKit_ShowAlertWithMsg_ios8(@"无法获取到当前 URL！");
            }
        }
        else if (buttonIndex == 2)
        {
            
        }
        else if (buttonIndex == 3)
        {
            /*! 刷新 */
            [self.webView ba_web_reload];
        }
        
    }];
}
- (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString
{
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err)
    {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}
#pragma mark 关闭按钮点击
- (void)colseBtnAction:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    
    return nil;
    
}
/////处理alert事件
//- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler{
//    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:message?:@"" preferredStyle:UIAlertControllerStyleAlert];
//    [alertController addAction:([UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        completionHandler();
//    }])];
//    [self presentViewController:alertController animated:YES completion:nil];
//}
//
//- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL))completionHandler{
//    //    DLOG(@"msg = %@ frmae = %@",message,frame);
//    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:message?:@"" preferredStyle:UIAlertControllerStyleAlert];
//    [alertController addAction:([UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//        completionHandler(NO);
//    }])];
//    [alertController addAction:([UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        completionHandler(YES);
//    }])];
//    [self presentViewController:alertController animated:YES completion:nil];
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
