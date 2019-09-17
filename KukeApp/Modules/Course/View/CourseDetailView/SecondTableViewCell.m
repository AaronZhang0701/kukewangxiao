//
//  SecondTableViewCell.m
//  cellWebView
//
//  Created by abc on 2018/5/28.
//  Copyright © 2018年 mike. All rights reserved.
//

#import "SecondTableViewCell.h"
#import <WebKit/WebKit.h>

@interface SecondTableViewCell()<WKNavigationDelegate>

@property (nonatomic, strong) WKWebView *newsWebView;
@property (nonatomic, strong) UIView *line;

@end

@implementation SecondTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createView];
    }
    return self;
}
- (void)createView{
    self.newsWebView = [[WKWebView alloc] init];
    self.newsWebView.frame = CGRectMake(0, 0, self.contentView.frame.size.width, 0);
    self.newsWebView.navigationDelegate = self;
    self.newsWebView.scrollView.scrollEnabled = NO;
    [self.newsWebView sizeToFit];
    [self.contentView addSubview:self.newsWebView];
    //
    self.line = [[UIView alloc] init];
    [self.contentView addSubview:self.line];
    self.line.backgroundColor = [UIColor lightGrayColor];
}
- (void)refreshWebView:(NSString *)url indexPath:(NSInteger)index{
    self.indexPath = index;
//    NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:url]];
//    [self.newsWebView loadRequest:request];
//    NSString *headerString = @"<header><meta name='viewport' content='width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no'></header>";
    [self.newsWebView loadHTMLString:url baseURL:nil];
}
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation*)navigation{
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation*)navigation{
    
    [webView evaluateJavaScript:@"document.body.scrollHeight"completionHandler:^(id _Nullable result,NSError * _Nullable error){
        CGFloat height = [result floatValue];
        self.newsWebView.frame = CGRectMake(0, 0, self.contentView.frame.size.width, height);
//        [self.delegate webViewDidFinishLoad:height];
        self.line.frame = CGRectMake(0, height-0.5, self.contentView.frame.size.width, 0.5);
    }];
    
}
- (void)layoutSubviews{
    [super layoutSubviews];
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
