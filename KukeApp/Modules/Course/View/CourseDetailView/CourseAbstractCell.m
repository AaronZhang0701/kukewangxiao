////
////  CourseAbstractCell.m
////  KukeApp
////
////  Created by iOSDeveloper on 2018/10/11.
////  Copyright © 2018年 zhangming. All rights reserved.
////
//
//#import "CourseAbstractCell.h"
////#import "BAKit_WebView.h"
//@interface CourseAbstractCell ()<UIWebViewDelegate,WKNavigationDelegate>{
//
//    NSString *str;
//    UITableView *tabView;
//}
////@property (nonatomic, strong) UIWebView *webView;
////@property (nonatomic, strong) WKWebView *newsWebView;
//
//@property(nonatomic, strong) WKWebViewConfiguration *webConfig;
//@end
//@implementation CourseAbstractCell
//
//
////- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
////{
////    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
////    if (self) {
////        // 初始化子视图
////        str = @"";
////       [self addSubview:self.webView];
////    }
////    return self;
////}
////- (void)setContent:(NSString *)content{
//////    if (str.length == 0) {
//////        NSString *htmlString = [NSString stringWithFormat:@"<html> \n"
//////                                "<head> \n"
//////                                "<style type=\"text/css\"> \n"
//////                                "body {font-size:15px;}\n"
//////                                "</style> \n"
//////                                "</head> \n"
//////                                "<body>"
//////                                "<script type='text/javascript'>"
//////                                "window.onload = function(){\n"
//////                                "var $img = document.getElementsByTagName('img');\n"
//////                                "for(var p in  $img){\n"
//////                                " $img[p].style.width = '100%%';\n"
//////                                "$img[p].style.height ='auto'\n"
//////                                "}\n"
//////                                "}"
//////                                "</script>%@"
//////                                "</body>"
//////                                "</html>",content];
//////        [_webView sizeToFit];
//////        [_webView loadHTMLString:htmlString baseURL:nil];
//////        str = content;
//////    }
////
////    NSURLRequest *request=[NSURLRequest requestWithURL:[NSURL URLWithString:content]];
////    [self.webView loadRequest:request];
////    //    [_webView.scrollView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
////}
////- (UIWebView *)webView{
////    if (!_webView) {
////        _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0,self.frame.size.width, 100)];
////        _webView.delegate = self;
////        _webView.scrollView.bounces=NO;
////        _webView.scrollView.scrollEnabled = NO;
////        //监听webview
////    }
////    return _webView;
////
////}
////
////- (void)webViewDidFinishLoad:(UIWebView *)webView
////{
////
////    //方法2
////    CGRect frame = webView.frame;
////    frame.size.width = screenWidth();
////    frame.size.height = 1;
////    //    webView.scrollView.scrollEnabled = NO;
////    webView.frame = frame;
////    frame.size.height = webView.scrollView.contentSize.height;
////    NSLog(@"frame = %@", [NSValue valueWithCGRect:frame]);
////    webView.frame = frame;
//////    float contengOffsetY = 0;
//////    if (webView.height >3000) {
//////        contengOffsetY = webView.height/2-200;
//////    }
////
////    NSDictionary *dict =[[NSDictionary alloc]initWithObjectsAndKeys:[NSString stringWithFormat:@"%f",webView.height],@"WebViewHight1", nil];
////    KPostNotification(@"ContentHeight", dict);
////}
//////在这个方法中捕获到图片的点击事件和被点击图片的url
////- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
////
////    //预览图片
////    if ([request.URL.scheme isEqualToString:@"image-preview"]) {
////        NSString* path = [request.URL.absoluteString substringFromIndex:[@"image-preview:" length]];
////        path = [path stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
////        //path 就是被点击图片的url
//////        [BaseTools showImageWithIamgeArray:mUrlArray andIndex:[mUrlArray indexOfObject:path]];
////        return NO;
////    }
////    return YES;
////}
//
//- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
//    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
//    if (self) {
//        str = @"";
//        // 初始化子视图
//        [self.contentView addSubview:self.webView];
//    }
//    return self;
//}
//#pragma mark - setter / getter
//
//- (WKWebView *)webView
//{
//    if (!_webView)
//    {
//
//        _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0,screenWidth(), 100) configuration:self.webConfig];
//
//        _webView.navigationDelegate = self;
////        _webView.UIDelegate = self;
//
//        //设置cookie代理
////        [self.webView ba_web_initWithDelegate:self.webView uIDelegate:self.webView];
////        _webView.ba_web_isAutoHeight = NO;
//        // 是否允许手势左滑返回上一级, 类似导航控制的左滑返回
//        _webView.allowsBackForwardNavigationGestures = YES;
//        self.webView.multipleTouchEnabled = YES;
//        self.webView.autoresizesSubviews = YES;
//        self.webView.scrollView.bounces=NO;
//        self.webView.scrollView.scrollEnabled = NO;
//
//    }
//    return _webView;
//}
//
//- (WKWebViewConfiguration *)webConfig
//{
//    if (!_webConfig) {
//        //以下代码适配大小
//        NSString *jScript = @"var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width'); document.getElementsByTagName('head')[0].appendChild(meta);";
//
//        WKUserScript *wkUScript = [[WKUserScript alloc] initWithSource:jScript injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
//
//        _webConfig = [[WKWebViewConfiguration alloc] init];
//        _webConfig.allowsInlineMediaPlayback = YES;
//        if (@available(iOS 9.0, *)) {
//            _webConfig.allowsAirPlayForMediaPlayback = YES;
//        } else {
//            // Fallback on earlier versions
//        }
//        if (@available(iOS 9.0, *)) {
//            _webConfig.allowsPictureInPictureMediaPlayback = YES;
//        } else {
//            // Fallback on earlier versions
//        }
//        if (@available(iOS 10.0, *)) {
//
//            _webConfig.mediaTypesRequiringUserActionForPlayback = NO;
//
//        }
//        WKUserContentController *wkUController = [[WKUserContentController alloc] init];
//        [wkUController addUserScript:wkUScript];
//        _webConfig.userContentController = wkUController;
//        //初始化偏好设置属性：preferences
//        _webConfig.preferences = [WKPreferences new];
//        // The minimum font size in points default is 0;
//        //        _webConfig.preferences.minimumFontSize = 40;
//        // 是否支持 JavaScript
//        _webConfig.preferences.javaScriptEnabled = YES;
//        // 不通过用户交互，是否可以打开窗口
//        _webConfig.preferences.javaScriptCanOpenWindowsAutomatically = NO;
//
//
//
//
//    }
//    return _webConfig;
//}
////- (WKWebView *)newsWebView{
////    if (!_newsWebView) {
////        _newsWebView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0,self.frame.size.width, 100)];
////        _newsWebView.navigationDelegate = self;
////        _newsWebView.scrollView.bounces=NO;
////        _newsWebView.scrollView.scrollEnabled = NO;
////        //监听webview
////    }
////    return _newsWebView;
////
////}
//
//- (void)setContent:(NSString *)content{
//    if (str.length == 0) {
//
////        [self.webView ba_web_loadURLString:content];
//        [self.webView sizeToFit];
//        NSURLRequest *request=[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://m.kuke99.com/classroom/353.html"]];
//        [self.webView loadRequest:request];
//        str = content;
//    }
//}
//
//- (void)setTab:(UITableView *)tab
//{
//    tabView = tab;
//}
//- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation*)navigation{
//}
//#pragma mark - 滑动代理
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView
//{
//    if (scrollView == tabView) {
//        [self.webView setNeedsLayout];
//    }
//
//}
//- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation*)navigation{
//
//    [webView evaluateJavaScript:@"document.body.scrollHeight"completionHandler:^(id _Nullable result,NSError * _Nullable error){
//        CGFloat height = [result floatValue];
//
//        self.webView.frame = CGRectMake(0, 0, self.contentView.frame.size.width, height);
//
//        NSDictionary *dict =[[NSDictionary alloc]initWithObjectsAndKeys:[NSString stringWithFormat:@"%f",height],@"WebViewHight1", nil];
//        KPostNotification(@"ContentHeight", dict);
//    }];
//
//}
//
//@end
#import "CourseAbstractCell.h"
@interface CourseAbstractCell ()<UIWebViewDelegate,WKNavigationDelegate>{
    
    NSString *str;
}
@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) WKWebView *newsWebView;
@end
@implementation CourseAbstractCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // 初始化子视图
        str = @"";
        [self addSubview:self.webView];
    }
    return self;
}
- (void)setContent:(NSString *)content{
    //    if (str.length == 0) {
    //        NSString *htmlString = [NSString stringWithFormat:@"<html> \n"
    //                                "<head> \n"
    //                                "<style type=\"text/css\"> \n"
    //                                "body {font-size:15px;}\n"
    //                                "</style> \n"
    //                                "</head> \n"
    //                                "<body>"
    //                                "<script type='text/javascript'>"
    //                                "window.onload = function(){\n"
    //                                "var $img = document.getElementsByTagName('img');\n"
    //                                "for(var p in  $img){\n"
    //                                " $img[p].style.width = '100%%';\n"
    //                                "$img[p].style.height ='auto'\n"
    //                                "}\n"
    //                                "}"
    //                                "</script>%@"
    //                                "</body>"
    //                                "</html>",content];
    //        [_webView sizeToFit];
    //        [_webView loadHTMLString:htmlString baseURL:nil];
    //        str = content;
    //    }
    
    NSURLRequest *request=[NSURLRequest requestWithURL:[NSURL URLWithString:content]];
    [self.webView loadRequest:request];
    //    [_webView.scrollView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
}
- (UIWebView *)webView{
    if (!_webView) {
        _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0,screenWidth(), 100)];
        _webView.delegate = self;
        _webView.scrollView.bounces=NO;
        _webView.scrollView.scrollEnabled = NO;
        //监听webview
    }
    return _webView;
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    
    //方法2
    CGRect frame = webView.frame;
    frame.size.width = screenWidth();
    frame.size.height = 1;
    //    webView.scrollView.scrollEnabled = NO;
    webView.frame = frame;
    frame.size.height = webView.scrollView.contentSize.height;
    NSLog(@"frame = %@", [NSValue valueWithCGRect:frame]);
    webView.frame = frame;
    //    float contengOffsetY = 0;
    //    if (webView.height >3000) {
    //        contengOffsetY = webView.height/2-200;
    //    }
    
    NSDictionary *dict =[[NSDictionary alloc]initWithObjectsAndKeys:[NSString stringWithFormat:@"%f",webView.height],@"WebViewHight1", nil];
    KPostNotification(@"ContentHeight", dict);
}
//在这个方法中捕获到图片的点击事件和被点击图片的url
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    //预览图片
    if ([request.URL.scheme isEqualToString:@"image-preview"]) {
        NSString* path = [request.URL.absoluteString substringFromIndex:[@"image-preview:" length]];
        path = [path stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        //path 就是被点击图片的url
        //        [BaseTools showImageWithIamgeArray:mUrlArray andIndex:[mUrlArray indexOfObject:path]];
        return NO;
    }
    return YES;
}

//- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
//    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
//    if (self) {
//        str = @"";
//        // 初始化子视图
//        [self.contentView addSubview:self.newsWebView];
//    }
//    return self;
//}
//
//- (WKWebView *)newsWebView{
//    if (!_newsWebView) {
//        _newsWebView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0,self.frame.size.width, 100)];
//        _newsWebView.navigationDelegate = self;
//        _newsWebView.scrollView.bounces=NO;
//        _newsWebView.scrollView.scrollEnabled = NO;
//        //监听webview
//    }
//    return _newsWebView;
//
//}
//
//- (void)setContent:(NSString *)content{
//    if (str.length == 0) {
//
//        [self.newsWebView sizeToFit];
//        NSURLRequest *request=[NSURLRequest requestWithURL:[NSURL URLWithString:content]];
//        [self.newsWebView loadRequest:request];
//        str = content;
//    }
//}
//- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation*)navigation{
//}
//
//- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation*)navigation{
//
//    [webView evaluateJavaScript:@"document.body.scrollHeight"completionHandler:^(id _Nullable result,NSError * _Nullable error){
//        CGFloat height = [result floatValue];
//
//        self.newsWebView.frame = CGRectMake(0, 0, self.contentView.frame.size.width, height);
//
//        NSDictionary *dict =[[NSDictionary alloc]initWithObjectsAndKeys:[NSString stringWithFormat:@"%f",height],@"WebViewHight1", nil];
//        KPostNotification(@"ContentHeight", dict);
//    }];
//
//}

@end
