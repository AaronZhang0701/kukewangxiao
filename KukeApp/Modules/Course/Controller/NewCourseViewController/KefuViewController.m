//
//  KefuViewController.m
//  KukeApp
//
//  Created by iOSDeveloper on 2018/11/5.
//  Copyright © 2018年 zhangming. All rights reserved.
//

#import "KefuViewController.h"
#import "NJKWebViewProgress.h"
#import "NJKWebViewProgressView.h"

@interface KefuViewController ()<UIWebViewDelegate,NSURLConnectionDataDelegate,NJKWebViewProgressDelegate>{
    NSURLRequest *_originRequest;
    
    NSURLConnection *_urlConnection;
    
    BOOL _authenticated;
    
    UIWebView *web;
    NJKWebViewProgressView *_progressView;
    NJKWebViewProgress *_progressProxy;
}

@end

@implementation KefuViewController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [self.navigationController setNavigationBarHidden:NO];

    [self.navigationController.navigationBar addSubview:_progressView];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
 
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
    
    web = [[UIWebView alloc]initWithFrame:CGRectMake(0, -45, screenWidth(), screenHeight()-19)];
    web.delegate = self;
    web.scrollView.bounces=NO;
    NSString *str =[NSString stringWithFormat:@"%@",self.url];
    NSURL *url = [NSURL URLWithString:str];
    
//    NSMutableDictionary *cookieDic = [NSMutableDictionary dictionary];
//    NSMutableString *cookieValue = [NSMutableString stringWithFormat:@"kuke=%@",@"1"];
//    NSHTTPCookieStorage *cookieJar = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:url];
//    [request addValue:cookieValue forHTTPHeaderField:@"Cookie"];
    [web loadRequest:request];
    web.scalesPageToFit = YES;
    //        设置检测网页中的格式类型，all表示检测所有类型包括超链接、电话号码、地址等。
    web.dataDetectorTypes = UIDataDetectorTypeNone;
    [self.view addSubview:web];
    
    _progressProxy = [[NJKWebViewProgress alloc] init];
    web.delegate = _progressProxy;
    _progressProxy.webViewProxyDelegate = self;
    _progressProxy.progressDelegate = self;
    
    CGFloat progressBarHeight = 2.f;
    CGRect navigationBarBounds = self.navigationController.navigationBar.bounds;
    CGRect barFrame = CGRectMake(0, navigationBarBounds.size.height - progressBarHeight, navigationBarBounds.size.width, progressBarHeight);
    _progressView = [[NJKWebViewProgressView alloc] initWithFrame:barFrame];
    _progressView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    
    // Do any additional setup after loading the view.
}
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
//    NSDictionary *dic = @{@"kuke":@"1"};
//    [dic enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
//        // 设定 cookie
//        NSHTTPCookie *cookie = [NSHTTPCookie cookieWithProperties:
//                                [NSDictionary dictionaryWithObjectsAndKeys:
//                                 [request.URL host], NSHTTPCookieDomain,
//                                 [request.URL path], NSHTTPCookiePath,
//                                 key,NSHTTPCookieName,
//                                 obj,NSHTTPCookieValue,
//                                 nil]];
//
//        [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];
//        //        NSLog(@"cookie = %@",cookie);
//
//    }];
    
    
    return YES;
    
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
