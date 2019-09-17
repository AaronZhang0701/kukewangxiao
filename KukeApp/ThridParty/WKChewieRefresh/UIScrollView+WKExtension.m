//
//  UIScrollView+WKExtension.m
//  Pods-WKChewieRefresh_Example
//
//  Created by 王昆 on 2017/11/16.
//

#import "UIScrollView+WKExtension.h"
#import <objc/runtime.h>

//#define WK_SYSTEM_VERSION_GREATER_NOT_LESS_THAN(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunguarded-availability-new"
@implementation UIScrollView (WKExtension)
static BOOL wkgt_ios_11_;
+ (void)load {
    // 缓存判断值
    wkgt_ios_11_ = [[[UIDevice currentDevice] systemVersion] compare:@"11.0" options:NSNumericSearch] != NSOrderedAscending;
}

- (UIEdgeInsets)wk_inset
{
#ifdef __IPHONE_11_0
    if (wkgt_ios_11_) {
        return self.adjustedContentInset;
    }
#endif
    return self.contentInset;
}

- (void)setWk_insetT:(CGFloat)wk_insetT
{
    UIEdgeInsets inset = self.contentInset;
    inset.top = wk_insetT;
#ifdef __IPHONE_11_0
    if (wkgt_ios_11_) {
        inset.top -= (self.adjustedContentInset.top - self.contentInset.top);
    }
#endif
    self.contentInset = inset;
}

- (CGFloat)wk_insetT
{
    return self.wk_inset.top;
}

- (void)setWk_insetB:(CGFloat)wk_insetB
{
    UIEdgeInsets inset = self.contentInset;
    inset.bottom = wk_insetB;
#ifdef __IPHONE_11_0
    if (wkgt_ios_11_) {
        inset.bottom -= (self.adjustedContentInset.bottom - self.contentInset.bottom);
    }
#endif
    self.contentInset = inset;
}

- (CGFloat)wk_insetB
{
    return self.wk_inset.bottom;
}

- (void)setWk_insetL:(CGFloat)wk_insetL
{
    UIEdgeInsets inset = self.contentInset;
    inset.left = wk_insetL;
#ifdef __IPHONE_11_0
    if (wkgt_ios_11_) {
        inset.left -= (self.adjustedContentInset.left - self.contentInset.left);
    }
#endif
    self.contentInset = inset;
}

- (CGFloat)wk_insetL
{
    return self.wk_inset.left;
}

- (void)setWk_insetR:(CGFloat)wk_insetR
{
    UIEdgeInsets inset = self.contentInset;
    inset.right = wk_insetR;
#ifdef __IPHONE_11_0
    if (wkgt_ios_11_) {
        inset.right -= (self.adjustedContentInset.right - self.contentInset.right);
    }
#endif
    self.contentInset = inset;
}

- (CGFloat)wk_insetR
{
    return self.wk_inset.right;
}

- (void)setWk_offsetX:(CGFloat)wk_offsetX
{
    CGPoint offset = self.contentOffset;
    offset.x = wk_offsetX;
    self.contentOffset = offset;
}

- (CGFloat)wk_offsetX
{
    return self.contentOffset.x;
}

- (void)setWk_offsetY:(CGFloat)wk_offsetY
{
    CGPoint offset = self.contentOffset;
    offset.y = wk_offsetY;
    self.contentOffset = offset;
}

- (CGFloat)wk_offsetY
{
    return self.contentOffset.y;
}

- (void)setWk_contentW:(CGFloat)wk_contentW
{
    CGSize size = self.contentSize;
    size.width = wk_contentW;
    self.contentSize = size;
}

- (CGFloat)wk_contentW
{
    return self.contentSize.width;
}

- (void)setWk_contentH:(CGFloat)wk_contentH
{
    CGSize size = self.contentSize;
    size.height = wk_contentH;
    self.contentSize = size;
}

- (CGFloat)wk_contentH
{
    return self.contentSize.height;
}
@end
#pragma clang diagnostic pop

