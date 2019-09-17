//
//  IBWebViewController.m
//  O2
//
//  Created by qilongTan on 15/10/31.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "XLWebViewController.h"
#import "XLJSHandler.h"
//#import "HeaderModel.h"
//#import "AESCipher.h"
//#impor"YYKit.h"YYKit.h>

@interface XLWebViewController () <WKNavigationDelegate>
@property (nonatomic,strong) XLJSHandler * jsHandler;
@property (nonatomic,assign) double lastProgress;//上次进度条位置
@end

@implementation XLWebViewController

-(instancetype)initWithUrl:(NSString *)url {
    self = [super init];
    if (self) {
        self.url = url;
        _progressViewColor = [UIColor colorWithHexString:@"0485d1"];
    }
    return self;
}

-(void)setUrl:(NSString *)url
{
    if (_url != url) {
        _url = url;
//        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:_url]];
//        //加密header部分
//        NSString *headerContentStr = [[HeaderModel new] modelToJSONString];
//        NSString *headerAESStr = aesEncrypt(headerContentStr);
//        [request setValue:headerAESStr forHTTPHeaderField:@"header-encrypt-code"];
//        [self.webView loadRequest:request];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initWKWebView];
    //适配iOS11
    if (@available(iOS 11.0, *)){
        self.webView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    else{
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
}

#pragma mark 初始化webview
-(void)initWKWebView
{
//    WKWebViewConfiguration * configuration = [[WKWebViewConfiguration alloc]init];
//    configuration.preferences.javaScriptEnabled = YES;//打开js交互
//    _webConfiguration = configuration;
//    _jsHandler = [[XLJSHandler alloc]initWithViewController:self configuration:configuration];
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    config.userContentController = [[WKUserContentController alloc] init];
    config.allowsInlineMediaPlayback = YES;
    config.preferences.minimumFontSize = 10;
    config.processPool = [[WKProcessPool alloc]init];
    config.preferences.javaScriptCanOpenWindowsAutomatically = NO;
    // web内容处理池
    config.processPool = [[WKProcessPool alloc] init];
    // 将所有cookie以document.cookie = 'key=value';形式进行拼接
    NSString *cookieValue = @"document.cookie = 'fromapp=ios';document.cookie = 'channel=appstore';";
    // 加cookie给h5识别，表明在ios端打开该地址
    WKUserContentController* userContentController = WKUserContentController.new;
    WKUserScript * cookieScript = [[WKUserScript alloc]
                                   initWithSource: cookieValue
                                   injectionTime:WKUserScriptInjectionTimeAtDocumentStart forMainFrameOnly:NO];
    [userContentController addUserScript:cookieScript];
    config.userContentController = userContentController;
    CGRect f = self.view.bounds;
    if (self.navigationController && self.isHidenNaviBar == NO) {
        f = CGRectMake(0, 0, self.view.bounds.size.width, kScreenHeight - kTopHeight);
    }
    
    self.webView = [[WKWebView alloc]initWithFrame:f configuration:config];
    _webView.navigationDelegate = self;
    _webView.backgroundColor = [UIColor clearColor];
    _webView.allowsBackForwardNavigationGestures =YES;//打开网页间的 滑动返回
    _webView.scrollView.decelerationRate = UIScrollViewDecelerationRateNormal;
    //监控进度
    [_webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    [self.view addSubview:_webView];
    //进度条
    _progressView = [[UIProgressView alloc]initWithProgressViewStyle:UIProgressViewStyleDefault];
    _progressView.tintColor = _progressViewColor;
    _progressView.trackTintColor = [UIColor clearColor];
    _progressView.frame = CGRectMake(0, 0, self.view.bounds.size.width, 3.0);
    [_webView addSubview:_progressView];
    
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:_url]];
    
    [request setValue:[self getCookieValue] forHTTPHeaderField:@"Cookie"];
//    //加密header部分
//    NSString *headerContentStr = [[HeaderModel new] modelToJSONString];
//    NSString *headerAESStr = aesEncrypt(headerContentStr);
//    [request setValue:headerAESStr forHTTPHeaderField:@"header-encrypt-code"];
    [_webView loadRequest:request];
}
- (NSMutableString*)getCookieValue{
    // 在此处获取返回的cookie
    NSMutableDictionary *cookieDic = [NSMutableDictionary dictionary];
    NSMutableString *cookieValue = [NSMutableString stringWithFormat:@""];
    
    NSHTTPCookieStorage *cookieJar = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (NSHTTPCookie *cookie in [cookieJar cookies]) {
        [cookieDic setObject:cookie.value forKey:cookie.name];
    }
    // cookie重复，先放到字典进行去重，再进行拼接
    //    for (NSString *key in cookieDic) {
    NSString *token = nil;
    if ([[UserDefaultsUtils valueWithKey:@"access_token"] length]>0) {
        token =[UserDefaultsUtils valueWithKey:@"access_token"];
    }else{
        token = @"";
    }
    NSString *appendString =  [NSMutableString stringWithFormat:@"accessToken=%@;kuke=1",token];

    [cookieValue appendString:appendString];

    //    }
    return cookieValue;
}


-(void)backButtonClicked
{
    if ([self.webView canGoBack]) {
        [self.webView goBack];
    }
    else {
        [super backBtnClicked];
    }
}

#pragma mark --进度条
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    
    [self updateProgress:_webView.estimatedProgress];
}

#pragma mark -  更新进度条
-(void)updateProgress:(double)progress{
    self.progressView.alpha = 1;
    if(progress > _lastProgress){
        [self.progressView setProgress:self.webView.estimatedProgress animated:YES];
    }else{
        [self.progressView setProgress:self.webView.estimatedProgress];
    }
    _lastProgress = progress;
    
    if (progress >= 1) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.progressView.alpha = 0;
            [self.progressView setProgress:0];
            _lastProgress = 0;
        });
    }
}

#pragma mark --navigation delegate
//加载完毕
-(void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    self.title = webView.title;
    [self updateProgress:webView.estimatedProgress];
    
    [self updateNavigationItems];
}

-(void)updateNavigationItems{
    
}

-(void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
//    if(webView != self.webView) {
//        decisionHandler(WKNavigationActionPolicyAllow);
//        return;
//    }
//    //更新返回按钮
//    [self updateNavigationItems];
//
//    NSURL * url = webView.URL;
//    //打开wkwebview禁用了电话和跳转appstore 通过这个方法打开
//    UIApplication *app = [UIApplication sharedApplication];
//    if ([url.scheme isEqualToString:@"tel"])
//    {
//        if ([app canOpenURL:url])
//        {
//            [app openURL:url];
//            decisionHandler(WKNavigationActionPolicyCancel);
//            return;
//        }
//    }
//    if ([url.absoluteString containsString:@"itunes.apple.com"])
//    {
//        if ([app canOpenURL:url])
//        {
//            [app openURL:url];
//            decisionHandler(WKNavigationActionPolicyCancel);
//            return;
//        }
//    }
//    decisionHandler(WKNavigationActionPolicyAllow);
    // 你所保存的cookie
    NSString *token = nil;
    if ([[UserDefaultsUtils valueWithKey:@"access_token"] length]>0) {
        token =[UserDefaultsUtils valueWithKey:@"access_token"];
    }else{
        token = @"";
    }
    NSString *cookie = [NSMutableString stringWithFormat:@"accessToken=%@;kuke=1",token];
    // 如果请求头部不包含cookie值则需要我们去传cookie
    if ([navigationAction.request allHTTPHeaderFields][@"Cookie"] && [[navigationAction.request allHTTPHeaderFields][@"Cookie"] rangeOfString:cookie].length > 0) {
        decisionHandler(WKNavigationActionPolicyAllow);
    } else {
        NSMutableURLRequest *request= [NSMutableURLRequest requestWithURL:navigationAction.request.URL];
        [request setValue:cookie forHTTPHeaderField:@"Cookie"];
        [webView loadRequest:request];
        decisionHandler(WKNavigationActionPolicyCancel);
    }
}

-(void)backBtnClicked{
    [self.webView stopLoading];
    if ([self.webView canGoBack]) {
        [self.webView goBack];
    }else{
        [super backBtnClicked];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc {
    [_jsHandler cancelHandler];
    self.webView.navigationDelegate = nil;
    [_webView removeObserver:self forKeyPath:@"estimatedProgress"];
}

@end
