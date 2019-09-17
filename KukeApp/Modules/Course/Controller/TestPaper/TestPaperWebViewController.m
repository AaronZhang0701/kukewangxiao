//
//  TestPaperWebViewController.m
//  KukeApp
//
//  Created by iOSDeveloper on 2018/10/25.
//  Copyright © 2018年 zhangming. All rights reserved.
//

#import "TestPaperWebViewController.h"
#import <WebKit/WebKit.h>
#import "PLVDownloadManagerViewController.h"
@interface TestPaperWebViewController ()<UIWebViewDelegate,WKUIDelegate,WKNavigationDelegate,NoDataTipsDelegate>{
    UIWebView *web;
    NSString *str;
    NSMutableURLRequest * request;
}
@property (nonatomic, strong) NoDataTipsView *loadNetView;
@end

@implementation TestPaperWebViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"开始做题";
    
    UIButton * backButton = [UIButton buttonWithType:UIButtonTypeSystem];
    backButton.frame = CGRectMake(10, 20, 20, 20);
    [backButton setBackgroundImage:[UIImage imageNamed:@"导航栏返回"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backButton];
    
    web = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, screenWidth(), screenHeight()-UI_navBar_Height)];
    web.delegate = self;
    web.scrollView.bounces=NO;
    web.scalesPageToFit = YES;
    web.dataDetectorTypes = UIDataDetectorTypeNone;
    [self.view addSubview:web];
//
    NSString *urlStr = [NSString stringWithFormat:@"%@/do_test/%@/%@.html",SERVER_HOSTM,self.dict[@"exam_id"],self.dict[@"id"]];
    //oc代码
    NSString *token = nil;
    if ([[UserDefaultsUtils valueWithKey:@"access_token"] length]>0) {
        token =[UserDefaultsUtils valueWithKey:@"access_token"];
    }else{
        token = @"";
    }
    NSMutableDictionary *cookieDic = [NSMutableDictionary dictionary];
    NSMutableString *cookieValue = [NSMutableString stringWithFormat:@"accessToken=%@;kuke=1",token];
    NSHTTPCookieStorage *cookieJar = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
    [request addValue:cookieValue forHTTPHeaderField:@"Cookie"];
    if (![CoreStatus isNetworkEnable]) {
        [self.view addSubview:self.loadNetView];
    }else{
        [web loadRequest:request];
    }
    
//    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
//    config.userContentController = [[WKUserContentController alloc] init];
//    config.allowsInlineMediaPlayback = YES;
//    config.preferences.minimumFontSize = 10;
//    config.processPool = [[WKProcessPool alloc]init];
//    config.preferences.javaScriptCanOpenWindowsAutomatically = NO;
//    // web内容处理池
//    config.processPool = [[WKProcessPool alloc] init];
//    // 将所有cookie以document.cookie = 'key=value';形式进行拼接
//    NSString *cookieValue = @"document.cookie = 'fromapp=ios';document.cookie = 'channel=appstore';";
//    // 加cookie给h5识别，表明在ios端打开该地址
//    WKUserContentController* userContentController = WKUserContentController.new;
//    WKUserScript * cookieScript = [[WKUserScript alloc]
//                                   initWithSource: cookieValue
//                                   injectionTime:WKUserScriptInjectionTimeAtDocumentStart forMainFrameOnly:NO];
//    [userContentController addUserScript:cookieScript];
//    config.userContentController = userContentController;
//
//
//    WKWebView *webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, screenWidth(), screenHeight()-64) configuration:config];
//    webView.UIDelegate = self;
//    webView.navigationDelegate = self;
//    webView.allowsBackForwardNavigationGestures = YES;
//    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
//    [request setValue:[self getCookieValue] forHTTPHeaderField:@"Cookie"];
//
//    [webView loadRequest:request];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadDetailData) name:@"RelodaDetailData" object:nil];
    // Do any additional setup after loading the view.
}
- (void)reloadDetailData{
    [web reload];
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
    [web loadRequest:request];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [self.loadNetView removeFromSuperview];
//    //核心方法如下
//    JSContext *content = [self.web valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
//    //此处的getMessage和JS方法中的getMessage名称一致.
//    content[@"shareAction"] = ^() {
//        NSArray *arguments = [JSContext currentArguments];
//        [self shareAction:arguments];
//
//    };
}
//用苹果自带的返回键按钮处理如下(自定义的返回按钮)
- (void)back:(UIBarButtonItem *)btn
{
//    if ([web canGoBack]) {
//
//        [web goBack];
//
//    }else{
        NSString *type = [web stringByEvaluatingJavaScriptFromString:@"is_autosave()"];
        if ([type isEqualToString:@"1"]) {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"正在做题中，确定要退出吗？" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *actionOne = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [web stringByEvaluatingJavaScriptFromString:@"autosave()"];
                [self.view resignFirstResponder];
                [self.navigationController popViewControllerAnimated:YES];
            }];
            UIAlertAction *actionTwo = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
            
            [alertController addAction:actionOne];
            [alertController addAction:actionTwo];
            
            [self presentViewController:alertController animated:YES completion:nil];
        }else{
 
            [self.view resignFirstResponder];
            [self.navigationController popViewControllerAnimated:YES];
        }
        

        
//    }
}

//- (NSMutableString*)getCookieValue{
//    // 在此处获取返回的cookie
//    NSMutableDictionary *cookieDic = [NSMutableDictionary dictionary];
//    NSMutableString *cookieValue = [NSMutableString stringWithFormat:@""];
//    NSHTTPCookieStorage *cookieJar = [NSHTTPCookieStorage sharedHTTPCookieStorage];
//    for (NSHTTPCookie *cookie in [cookieJar cookies]) {
//        [cookieDic setObject:cookie.value forKey:cookie.name];
//    }
//    // cookie重复，先放到字典进行去重，再进行拼接
////    for (NSString *key in cookieDic) {
//
//
//
//
//        NSString *appendString = [NSMutableString stringWithFormat:@"accessToken=%@",[UserDefaultsUtils valueWithKey:@"access_token"]];
//        [cookieValue appendString:appendString];
////    }
//    return cookieValue;
//}
//// API是根据WebView对于即将跳转的HTTP请求头信息和相关信息来决定是否跳转
//- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
//{
//    // 你所保存的cookie
//
//    NSString *cookie = [NSMutableString stringWithFormat:@"accessToken=%@",[UserDefaultsUtils valueWithKey:@"access_token"]];
//    // 如果请求头部不包含cookie值则需要我们去传cookie
//    if ([navigationAction.request allHTTPHeaderFields][@"Cookie"] && [[navigationAction.request allHTTPHeaderFields][@"Cookie"] rangeOfString:cookie].length > 0) {
//        decisionHandler(WKNavigationActionPolicyAllow);
//    } else {
//        NSMutableURLRequest *request= [NSMutableURLRequest requestWithURL:navigationAction.request.URL];
//        [request setValue:cookie forHTTPHeaderField:@"Cookie"];
//        [webView loadRequest:request];
//        decisionHandler(WKNavigationActionPolicyCancel);
//    }
//}

//- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
//{
//    BOOL isNavigator = YES;
//
//    NSDictionary *headerFields = request.allHTTPHeaderFields;
//    NSString *cookie = headerFields[@"Cookie"];
//    if (cookie == nil) {
//        NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] initWithURL:request.URL];
//        urlRequest.allHTTPHeaderFields = headerFields;
//        [urlRequest setValue:[self getCookieValue] forHTTPHeaderField:@"Cookie"];
//        [webView loadRequest:request];
//        isNavigator = NO;
//    }else{
//        isNavigator = YES;
//    }
//
//    if (!isNavigator) {
//        decisionHandler(WKNavigationActionPolicyCancel);
//    }else{
//        decisionHandler(WKNavigationActionPolicyAllow);
//    }
//}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    NSString *token = nil;
    if ([[UserDefaultsUtils valueWithKey:@"access_token"] length]>0) {
        token =[UserDefaultsUtils valueWithKey:@"access_token"];
    }else{
        token = @"";
    }
    
    
    NSDictionary *dic = @{@"kuke":@"1",@"accessToken":token};
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
        //        NSLog(@"cookie = %@",cookie);

    }];
    NSString *url = request.URL.absoluteString;
    
    str = url;
    if ([url rangeOfString:[NSString stringWithFormat:@"%@/user/login",SERVER_HOSTM]].location != NSNotFound) {
        //跳转原生界面
        [BaseTools showErrorMessage:@"请登录后再操作"];
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [BaseTools alertLoginWithVC:self];
        });
        
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
    
    return YES;
    
}
//-(void) webViewDidFinishLoad:(UIWebView *)webView {
////    [UIApplicationsharedApplication].networkActivityIndicatorVisible =NO;
//    self.title = [web stringByEvaluatingJavaScriptFromString:@"document.title"];
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
