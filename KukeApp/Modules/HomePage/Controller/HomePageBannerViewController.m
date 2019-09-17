//
//  HomePageBannerViewController.m
//  KukeApp
//
//  Created by iOSDeveloper on 2018/10/8.
//  Copyright © 2018年 zhangming. All rights reserved.
//

#import "HomePageBannerViewController.h"
#import "NJKWebViewProgress.h"
#import "NJKWebViewProgressView.h"
#import "RegisterDistributionViewController.h"
#import "DistributionBottomShareView.h"
#import "DistributionGoodsShareView.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import "PLVDownloadManagerViewController.h"
@interface HomePageBannerViewController ()<UIWebViewDelegate,NSURLConnectionDataDelegate,NJKWebViewProgressDelegate,NoDataTipsDelegate>{
    NSURLRequest *_originRequest;
    
    NSURLConnection *_urlConnection;
    
    BOOL _authenticated;
    
    NJKWebViewProgressView *_progressView;
    
    NJKWebViewProgress *_progressProxy;
    NSMutableURLRequest * request;
}
@property (strong, nonatomic) DistributionBottomShareView *shareView;
@property (nonatomic, strong) NoDataTipsView *loadNetView;
@end

@implementation HomePageBannerViewController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    [self.navigationController.navigationBar removeAllSubviews];
    [self.navigationController setNavigationBarHidden:NO];
    
//    UIButton *titleBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
//    titleBtn.frame = CGRectMake(midX(self.view)-60,8, 120, 30);
//    [titleBtn setTitle:self.title forState:(UIControlStateNormal)];
//    titleBtn.backgroundColor =CNavBgColor;
//    [self.navigationController.navigationBar addSubview:titleBtn];
    //    [AppUtiles setTabBarHidden:YES];
    [self.navigationController.navigationBar addSubview:_progressView];
    
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    // Remove progress view
    // because UINavigationBar is shared with other ViewControllers
    [_progressView removeFromSuperview];
}

#pragma mark - NJKWebViewProgressDelegate
-(void)webViewProgress:(NJKWebViewProgress *)webViewProgress updateProgress:(float)progress
{
    [_progressView setProgress:progress animated:YES];
//    self.title = [web stringByEvaluatingJavaScriptFromString:@"document.title"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if ([UserDefaultsUtils boolValueWithKey:KIsAudit]){
        self.web.userInteractionEnabled = YES;
    }else{
        self.web.userInteractionEnabled = NO;
    }
    UIButton * backButton = [UIButton buttonWithType:UIButtonTypeSystem];
    backButton.frame = CGRectMake(10, 20, 20, 20);
    [backButton setBackgroundImage:[UIImage imageNamed:@"导航栏返回"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backButton];
    
    
    self.web = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, screenWidth(), screenHeight()-UI_navBar_Height)];
    self.web.delegate = self;
    self.web.scrollView.bounces=NO;
    NSString *str =[NSString stringWithFormat:@"%@",self.url];
    NSURL *url = [NSURL URLWithString:str];
    if (@available(iOS 11.0, *)) {
        self.web.scrollView.contentInsetAdjustmentBehavior =UIScrollViewContentInsetAdjustmentNever;
    } else {
        // Fallback on earlier versions
    }
    NSMutableDictionary *cookieDic = [NSMutableDictionary dictionary];
    NSString *token = nil;
    if ([[UserDefaultsUtils valueWithKey:@"access_token"] length]>0) {
        token =[UserDefaultsUtils valueWithKey:@"access_token"];
    }else{
        token = @"";
    }
   
   
    NSMutableString *cookieValue = [NSMutableString stringWithFormat:@"accessToken=%@;kuke=1",token];
    NSHTTPCookieStorage *cookieJar = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    
    
    
    request = [NSMutableURLRequest requestWithURL:url];
    [request addValue:cookieValue forHTTPHeaderField:@"Cookie"];
    self.web.scalesPageToFit = YES;
    
    //        设置检测网页中的格式类型，all表示检测所有类型包括超链接、电话号码、地址等。
    self.web.dataDetectorTypes = UIDataDetectorTypeNone;
    [self.view addSubview:self.web];
    
    _progressProxy = [[NJKWebViewProgress alloc] init];
    self.web.delegate = _progressProxy;
    _progressProxy.webViewProxyDelegate = self;
    _progressProxy.progressDelegate = self;
    
    CGFloat progressBarHeight = 1.f;
    CGRect navigationBarBounds = self.navigationController.navigationBar.bounds;
    CGRect barFrame = CGRectMake(0, navigationBarBounds.size.height - progressBarHeight, navigationBarBounds.size.width, progressBarHeight);
    _progressView = [[NJKWebViewProgressView alloc] initWithFrame:barFrame];
    _progressView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    
    self.web.mediaPlaybackRequiresUserAction = NO; // 允许自动播放
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadDetailData) name:@"RelodaDetailData" object:nil];
    if (![CoreStatus isNetworkEnable]) {
        [self.view addSubview:self.loadNetView];
        _progressView.hidden = YES;
    }else{
        [self.web loadRequest:request];
    }
    
    
    // Do any additional setup after loading the view.
}
- (void)reloadDetailData{
    [self.web reload];
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
    [self.web loadRequest:request];
}
//用苹果自带的返回键按钮处理如下(自定义的返回按钮)
- (void)back:(UIBarButtonItem *)btn
{
    if ([self.web canGoBack]) {
        [self.web goBack];
        
    }else{

        [self.view resignFirstResponder];
        [self.navigationController popViewControllerAnimated:YES];
    }
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [self.loadNetView removeFromSuperview];
    //核心方法如下
    JSContext *content = [self.web valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    //此处的getMessage和JS方法中的getMessage名称一致.
    content[@"shareAction"] = ^() {
        NSArray *arguments = [JSContext currentArguments];
        [self shareAction:arguments];
        
    };
}
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    if (![CoreStatus isNetworkEnable]) {
        [BaseTools showErrorMessage:@"无法连接到网络"];
        return YES;
    }else{
        NSString *token = nil;
        if ([[UserDefaultsUtils valueWithKey:@"access_token"] length]>0) {
            token =[UserDefaultsUtils valueWithKey:@"access_token"];
        }else{
            token = @"";
        }
        
        NSDictionary *dic = @{@"kuke":@"1",@"accessToken":token,@"app_mark":@"ios"};
        [dic enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            // 设定 cookie
            NSHTTPCookie *cookie = [NSHTTPCookie cookieWithProperties:
                                    [NSDictionary dictionaryWithObjectsAndKeys:
                                     [request.URL host], NSHTTPCookieDomain,
                                     [request.URL path], NSHTTPCookiePath,
                                     key,NSHTTPCookieName,
                                     obj,NSHTTPCookieValue,
                                     nil]];
            [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];
        }];
        
        NSString *url = request.URL.absoluteString;
        if ([url rangeOfString:[NSString stringWithFormat:@"%@/distribution/distributor_register",SERVER_HOSTM]].location != NSNotFound) {
            //跳转原生界面
            RegisterDistributionViewController *vc  = [[RegisterDistributionViewController alloc]init];
            vc.rootVC = self.rootVC;
            [self.navigationController pushViewController:vc animated:YES];
            
            return NO;
        }
        if ([url rangeOfString:[NSString stringWithFormat:@"%@/uesr/register",SERVER_HOSTM]].location != NSNotFound) {
            //跳转原生界面
            [BaseTools showErrorMessage:@"请登录后再操作"];
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [BaseTools alertRegisterWithVC:self];
            });
            
            return NO;
        }
        if ([url rangeOfString:[NSString stringWithFormat:@"%@/user/login",SERVER_HOSTM]].location != NSNotFound) {
            //跳转原生界面
            [BaseTools showErrorMessage:@"请登录后再操作"];
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [BaseTools alertLoginWithVC:self];
            });
            
            return NO;
        }
        
        return YES;
    }
    
    
}
-(void)dealloc{
//    [self cleanCacheAndCookie];
    [self.web removeAllSubviews];
}

/**清除缓存和cookie*/
- (void)cleanCacheAndCookie{
    //清除cookies
    NSHTTPCookie *cookie;
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (cookie in [storage cookies]){
        [storage deleteCookie:cookie];
    }
    //清除UIWebView的缓存
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    NSURLCache * cache = [NSURLCache sharedURLCache];
    [cache removeAllCachedResponses];
    [cache setDiskCapacity:0];
    [cache setMemoryCapacity:0];
}

-(void)shareAction:(NSArray *)ary {
    
    self.shareView = [[DistributionBottomShareView alloc]initWithFrame:CGRectMake(0, screenHeight()-150, screenWidth(), 150)];
    self.shareView.titleLab.text = @"立即分享";

    self.shareView.wbImage.image = [UIImage imageNamed:@"复制链接"];
    self.shareView.threeLab.text = @"复制链接";

    self.shareView.pyqImage.image = [UIImage imageNamed:@"图文二维码"];
    self.shareView.fourLab.text = @"图文二维码";
    

   
    CGPoint showCenter = CGPointMake(SCREEN_WIDTH/2,SCREEN_HEIGHT-self.shareView.height/2);
    [SGBrowserView showMoveView:self.shareView moveToCenter:showCenter];

     __weak typeof(self) weakSelf = self;
    self.shareView.myCloseBlock = ^{
        [SGBrowserView hide];
    };
    self.shareView.myWXShareBlock = ^{
        [weakSelf shareWebPageToPlatformType:UMSocialPlatformType_WechatSession shareURLString:[ary[0] toString] title:[ary[1] toString] descr:@"库课网校"];
    };
    self.shareView.myQQShareBlock = ^{
        [weakSelf shareWebPageToPlatformType:UMSocialPlatformType_QQ shareURLString:[ary[0] toString] title:[ary[1] toString] descr:@"库课网校"];
    };
    self.shareView.myCopyBlock = ^{
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = [ary[0] toString];
        [BaseTools showErrorMessage:@"分销链接已复制到您的粘贴板"];
    };
    self.shareView.myPicBlock = ^{
        [SGBrowserView hide];
        [weakSelf showShareImageView:[ary[0] toString] coalition_id:[ary[2] toString]];
    };
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

- (void)showShareImageView:(NSString *)url coalition_id:(NSString *)coalition_id{
    NSMutableDictionary *parmDic = [NSMutableDictionary dictionary];
    [parmDic setObject:coalition_id forKey:@"coalition_id"];
    [ZMNetworkHelper POST:@"/distribution/draw_goods_poster" parameters:parmDic cache:YES responseCache:^(id responseCache) {

    } success:^(id responseObject) {
        if (responseObject == nil) {

        }else{
            if ([responseObject[@"code"] isEqualToString:@"0"]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    DistributionGoodsShareView *shareview = [[DistributionGoodsShareView alloc]initWithFrame:self.view.bounds];
                    UIColor *color = [UIColor blackColor];
                    shareview.url = responseObject[@"data"];
                    shareview.backgroundColor = [color colorWithAlphaComponent:0.8];
                    CGPoint showCenter = CGPointMake(SCREEN_WIDTH/2,SCREEN_HEIGHT-shareview.height/2);
                    [SGBrowserView showMoveView:shareview moveToCenter:showCenter];
                    [shareview.shareImage sd_setImageWithURL:[NSURL URLWithString:responseObject[@"data"]]];
                    shareview.myCloseBlock = ^{
                        [SGBrowserView hide];
                    };

                });
            }else if ([responseObject[@"code"] isEqualToString:@"-10000"]){
                [BaseTools showErrorMessage:@"请登录后再操作"];
                dispatch_async(dispatch_get_main_queue(), ^{

                    [BaseTools alertLoginWithVC:self];
                });
            }else{
                [BaseTools showErrorMessage:responseObject[@"msg"]];
            }
        }

    } failure:^(NSError *error) {

    }];


}
//#pragma mark - UIWebViewDelegate
//
//- (BOOL)webView:(UIWebView*)webView shouldStartLoadWithRequest:(NSURLRequest*)request navigationType:(UIWebViewNavigationType)navigationType
//
//{
//
//    NSLog(@"Did start loading: %@ auth:%d", [[request URL] absoluteString],_authenticated);
//
//    if(!_authenticated) {
//
//        _authenticated=NO;
//
//        _urlConnection= [[NSURLConnection alloc]initWithRequest:_originRequest delegate:self];
//
//        [_urlConnection start];
//
//        return NO;
//
//    }
//
//    return YES;
//
//}
//
//-(void)webView:(UIWebView*)webView didFailLoadWithError:(NSError*)error
//
//{
//
//    // 102 == WebKitErrorFrameLoadInterruptedByPolicyChange
//
//    NSLog(@"***********error:%@,errorcode=%ld,errormessage:%@",error.domain,(long)error.code,error.description);
//
//    if(!([error.domain isEqualToString:@"WebKitErrorDomain"] && error.code==102)) {
//
//        //当请求出错了会做什么事情
//
//    }
//
//}
//
//#pragma mark-NURLConnectiondelegate
//
//-(void)connection:(NSURLConnection*)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge*)challenge
//
//{
//
//    NSLog(@"WebController Got auth challange via NSURLConnection");
//
//    if([challenge previousFailureCount]==0)
//
//    {
//
//        _authenticated=YES;
//
//          NSURLCredential *credential = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
//
//         [challenge.sender useCredential:credential forAuthenticationChallenge:challenge];
//
//    }else{
//
//        [[challenge sender]cancelAuthenticationChallenge:challenge];
//
//    }
//
//}
//
//
//-(void)connection:(NSURLConnection*)connection didReceiveResponse:(NSURLResponse*)response
//
//{
//
//    NSLog(@"WebController received response via NSURLConnection");
//
//    // remake a webview call now that authentication has passed ok.
//
//    _authenticated=YES;
//
//    //    NSString *body = [NSString stringWithFormat:@"msg=%@",self.baseStr];
//
//    [_originRequest setHTTPMethod:@"POST"];
//
//    [_originRequest setHTTPBody:[self.baseStr dataUsingEncoding:NSUTF8StringEncoding]];
//
//    [web loadRequest:_originRequest];
//
//    // Cancel the URL connection otherwise we double up (webview + url connection, same url = no good!)
//
//    [_urlConnection cancel];
//
//}
//
//- (void)URLSession:(NSURLSession*)session didReceiveChallenge:(NSURLAuthenticationChallenge*)challenge completionHandler:(void(^)(NSURLSessionAuthChallengeDispositiondisposition,NSURLCredential*__nullablecredential))completionHandler{
//
//    NSLog(@"didReceiveChallenge");
//
//    //    if([challenge.protectionSpace.host isEqualToString:@"api.lz517.me"] /*check if this is host you trust: */ ){
//
//    completionHandler(NSURLSessionAuthChallengeUseCredential, [NSURLCredentialcredentialForTrust:challenge.protectionSpace.serverTrust]);
//
//    //    }
//
//}
//
//// We use this method is to accept an untrusted site which unfortunately we need to do, as our PVM servers are self signed.
//
//- (BOOL)connection:(NSURLConnection*)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace*)protectionSpace
//
//{
//
//    return[protectionSpace.authenticationMethodisEqualToString:NSURLAuthenticationMethodServerTrust];
//
//}

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
