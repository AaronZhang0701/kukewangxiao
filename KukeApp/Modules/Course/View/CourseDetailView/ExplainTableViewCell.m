//
//  ExplainTableViewCell.m
//  KukeApp
//
//  Created by 库课 on 2019/3/21.
//  Copyright © 2019 KukeZangMing. All rights reserved.
//

#import "ExplainTableViewCell.h"
@interface ExplainTableViewCell ()<UIWebViewDelegate>{
    float contengOffsetY;
}
@property (nonatomic, strong) UIWebView *webView;
@end
@implementation ExplainTableViewCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // 初始化子视图
        contengOffsetY = 0;
        [self addSubview:self.webView];
    }
    return self;
}
- (void)setContent:(NSString *)content{
    
    
//    NSString *htmlString = [NSString stringWithFormat:@"<html> \n"
//                            "<head> \n"
//                            "<style type=\"text/css\"> \n"
//                            "body {font-size:15px;}\n"
//                            "</style> \n"
//                            "</head> \n"
//                            "<body>"
//                            "<script type='text/javascript'>"
//                            "window.onload = function(){\n"
//                            "var $img = document.getElementsByTagName('img');\n"
//                            "for(var p in  $img){\n"
//                            " $img[p].style.width = '100%%';\n"
//                            "$img[p].style.height ='auto'\n"
//                            "}\n"
//                            "}"
//                            "</script>%@"
//                            "</body>"
//                            "</html>",content];
    [_webView sizeToFit];
    NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/app/goods_buy_explain",SERVER_HOSTM]]];
    [_webView loadRequest:request];
//    [_webView loadHTMLString:htmlString baseURL:nil];
    //    [_webView.scrollView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
}
- (UIWebView *)webView{
    if (!_webView) {
        _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0,self.frame.size.width, 200)];
        _webView.delegate = self;
        _webView.scrollView.bounces=NO;
        
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
    if (contengOffsetY == 0) {
        contengOffsetY = webView.height;
        NSDictionary *dict =[[NSDictionary alloc]initWithObjectsAndKeys:[NSString stringWithFormat:@"%f",webView.height],@"WebViewHight", nil];
        KPostNotification(@"ExplainHeight", dict);
    }
   
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

@end
