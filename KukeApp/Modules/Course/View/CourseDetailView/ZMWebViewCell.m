//
//  BACell.m
//  BAWKWebView
//
//  Created by boai on 2017/6/30.
//  Copyright © 2017年 boai. All rights reserved.
//

#import "ZMWebViewCell.h"
#import "WebVIewModel.h"

static NSString * const kCellID = @"BACell_id";

@interface ZMWebViewCell (){
    UITableView *tabView;
    CGFloat tempOffset;
}

//@property(nonatomic, strong) WKWebViewConfiguration *webConfig;

@end

@implementation ZMWebViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
        tempOffset = 0;
    }
    return self;
}

+ (id)ba_creatCellWithTableView:(UITableView *)tableView
{
    ZMWebViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellID];
    
    if (!cell)
    {
        cell = [[self alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:kCellID];
    }
    
    return cell;
}

- (void)setupUI
{
//    self.webView.hidden = NO;
    
}

- (void)setModel:(WebVIewModel *)model
{
    _model = model;
    
    if (self.model.height == 100)
    {
        [self.webView ba_web_loadURLString:self.model.contentHtml];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.webView.frame = self.bounds;
//    self.webView.scrollView.contentInset = UIEdgeInsetsMake(self.webView.scrollView.contentInset.top, 0, 0, 0);
//    self.webView.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height - self.webView.scrollView.contentInset.top);
}

- (WKWebView *)webView
{
    if (!_webView)
    {
//        _webView = [[WKWebView alloc] initWithFrame:CGRectZero configuration:self.webConfig];
        _webView = [WKWebView new];
        
        _webView.ba_web_isAutoHeight = YES;
        //  添加 WKWebView 的代理，注意：用此方法添加代理
        BAKit_WeakSelf
        [_webView ba_web_initWithDelegate:weak_self.webView uIDelegate:weak_self.webView];
        
//        _webView.backgroundColor = BAKit_Color_Yellow_pod;
        _webView.userInteractionEnabled = false;
        
        self.webView.ba_web_getCurrentHeightBlock = ^(CGFloat currentHeight) {

            BAKit_StrongSelf
            self.cell_height = currentHeight;
            NSLog(@"html 高度2：%f", currentHeight);

            if (self.WebLoadFinish)
            {
                self.WebLoadFinish(self.cell_height);
            };
        };


        
        [self.contentView addSubview:_webView];
    }
    return _webView;
}
- (void)setTab:(UITableView *)tab
{
    tabView = tab;
}
#pragma mark - 滑动代理
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (!tempOffset || ABS(scrollView.contentOffset.y - tempOffset) > screenHeight()/2)
    {
        [self.webView setNeedsLayout];
        tempOffset = scrollView.contentOffset.y;
    }

}


@end
