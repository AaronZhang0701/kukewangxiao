//
//  UIView+WKExtension.m
//  Pods-WKChewieRefresh_Example
//
//  Created by 王昆 on 2017/11/16.
//

#import "UIView+WKExtension.h"

@implementation UIView (WKExtension)
- (void)setWk_x:(CGFloat)wk_x
{
    CGRect frame = self.frame;
    frame.origin.x = wk_x;
    self.frame = frame;
}

- (CGFloat)wk_x
{
    return self.frame.origin.x;
}

- (void)setWk_y:(CGFloat)wk_y
{
    CGRect frame = self.frame;
    frame.origin.y = wk_y;
    self.frame = frame;
}

- (CGFloat)wk_y
{
    return self.frame.origin.y;
}

- (void)setWk_w:(CGFloat)wk_w
{
    CGRect frame = self.frame;
    frame.size.width = wk_w;
    self.frame = frame;
}

- (CGFloat)wk_w
{
    return self.frame.size.width;
}

- (void)setWk_h:(CGFloat)wk_h
{
    CGRect frame = self.frame;
    frame.size.height = wk_h;
    self.frame = frame;
}

- (CGFloat)wk_h
{
    return self.frame.size.height;
}

- (void)setWk_size:(CGSize)wk_size
{
    CGRect frame = self.frame;
    frame.size = wk_size;
    self.frame = frame;
}

- (CGSize)wk_size
{
    return self.frame.size;
}

- (void)setWk_origin:(CGPoint)wk_origin
{
    CGRect frame = self.frame;
    frame.origin = wk_origin;
    self.frame = frame;
}

- (CGPoint)wk_origin
{
    return self.frame.origin;
}
@end
