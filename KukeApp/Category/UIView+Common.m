//

//  PingAnXiaoYuan-Parent
//
//  Created by zkr01 on 16/12/20.
//  Copyright © 2016年 张明. All rights reserved.
//

#import <UIKit/UIKit.h>

@implementation UIView (Postion)
/**
 *  获取屏幕的宽
 *
 *  @return 屏幕的宽
 */
CGFloat screenWidth() {
    return [[UIScreen mainScreen] bounds].size.width;
}
/**
 *  获取屏幕的高
 *
 *  @return 屏幕的高
 */
CGFloat screenHeight() {
    return [[UIScreen mainScreen] bounds].size.height;
}
/**
 *  根据 frame 来返回宽
 *
 *  @param rect 视图的 rect
 *
 *  @return 宽
 */
CGFloat width(CGRect rect) {
    return CGRectGetWidth(rect);
}
/**
 *  根据 frame 返回视图的高
 *
 *  @param rect 视图的 frame
 *
 *  @return  高
 */
CGFloat height(CGRect rect) {
    return CGRectGetHeight(rect);
}

/**
 *  返回当前视图的宽
 *
 *  @return 返回视图的宽
 */
- (CGFloat)width {
    return self.frame.size.width;
}
/**
 *  返回当前视图的高
 *
 *  @return 返回视图的高
 */
- (CGFloat)height {
    return self.frame.size.height;
}


CGFloat maxX(UIView *view) {
    return CGRectGetMaxX(view.frame);
}

CGFloat midX(UIView *view) {
    return CGRectGetMidX(view.frame);
}

CGFloat minX(UIView *view) {
    return CGRectGetMinX(view.frame);
}

CGFloat maxY(UIView *view) {
    return CGRectGetMaxY(view.frame);
}

CGFloat midY(UIView *view) {
    return CGRectGetMidY(view.frame);
}

CGFloat minY(UIView *view) {
    return CGRectGetMinY(view.frame);
}

@end

@implementation UIView (Common)
/**
 *  设置部分圆角(绝对布局)
 *
 *  @param corners 需要设置为圆角的角 UIRectCornerTopLeft | UIRectCornerTopRight | UIRectCornerBottomLeft | UIRectCornerBottomRight | UIRectCornerAllCorners
 *  @param radii   需要设置的圆角大小 例如 CGSizeMake(20.0f, 20.0f)
 */
- (void)addRoundedCorners:(UIRectCorner)corners
                withRadii:(CGSize)radii {
    
    UIBezierPath* rounded = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:corners cornerRadii:radii];
    CAShapeLayer* shape = [[CAShapeLayer alloc] init];
    [shape setPath:rounded.CGPath];
    
    self.layer.mask = shape;
}

/**
 *  设置部分圆角(相对布局)
 *
 *  @param corners 需要设置为圆角的角 UIRectCornerTopLeft | UIRectCornerTopRight | UIRectCornerBottomLeft | UIRectCornerBottomRight | UIRectCornerAllCorners
 *  @param radii   需要设置的圆角大小 例如 CGSizeMake(20.0f, 20.0f)
 *  @param rect    需要设置的圆角view的rect
 */
- (void)addRoundedCorners:(UIRectCorner)corners
                withRadii:(CGSize)radii
                 viewRect:(CGRect)rect {
    
    UIBezierPath* rounded = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:corners cornerRadii:radii];
    CAShapeLayer* shape = [[CAShapeLayer alloc] init];
    [shape setPath:rounded.CGPath];
    
    self.layer.mask = shape;
}
@end

