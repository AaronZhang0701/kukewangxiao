//

//  PingAnXiaoYuan-Parent
//
//  Created by zkr01 on 16/12/20.
//  Copyright © 2016年 张明. All rights reserved.
//

#import "UIView+Common.h"

/**
 *  获取视图位置信息的类别
 */
@interface UIView (Postion)
/**
 *  获取屏幕的宽
 *
 *  @return 屏幕的宽
 */
CGFloat screenWidth();

/**
 *  获取屏幕的高
 *
 *  @return 屏幕的高
 */
CGFloat screenHeight();

/**
 *  根据 frame 来返回宽
 *
 *  @param rect 视图的 rect
 *
 *  @return 宽
 */
CGFloat width(CGRect rect);

/**
 *  根据 frame 返回视图的高
 *
 *  @param rect 视图的 frame
 *
 *  @return  高
 */
CGFloat height(CGRect rect);


/**
 *  返回当前视图的宽
 *
 *  @return 返回视图的宽
 */
- (CGFloat)width;

/**
 *  返回当前视图的高
 *
 *  @return 返回视图的高
 */
- (CGFloat)height;
/**
 *  获取视图最大的 X 坐标
 *
 *  @param view
 *
 *  @return x 的坐标
 */
CGFloat maxX(UIView *view);
/**
 *  获取视图居中的 X 坐标
 *
 *  @param view
 *
 *  @return x 的坐标
 */
CGFloat midX(UIView *view);
/**
 *  获取视图最小的 X 坐标
 *
 *  @param view
 *
 *  @return x 的坐标
 */
CGFloat minX(UIView *view);
/**
 *  获取视图最大的 Y 坐标
 *
 *  @param view
 *
 *  @return Y 的坐标
 */
CGFloat maxY(UIView *view);
/**
 *  获取视图中间的 Y 坐标
 *
 *  @param view
 *
 *  @return Y 的坐标
 */
CGFloat midY(UIView *view);
/**
 *  获取视图最小的 Y 坐标
 *
 *  @param view
 *
 *  @return Y 的坐标
 */
CGFloat minY(UIView *view);

@end

@interface UIView (Common)
#pragma mark - 设置部分圆角
/**
 *  设置部分圆角(绝对布局)
 *
 *  @param corners 需要设置为圆角的角 UIRectCornerTopLeft | UIRectCornerTopRight | UIRectCornerBottomLeft | UIRectCornerBottomRight | UIRectCornerAllCorners
 *  @param radii   需要设置的圆角大小 例如 CGSizeMake(20.0f, 20.0f)
 */
- (void)addRoundedCorners:(UIRectCorner)corners
                withRadii:(CGSize)radii;
/**
 *  设置部分圆角(相对布局)
 *
 *  @param corners 需要设置为圆角的角 UIRectCornerTopLeft | UIRectCornerTopRight | UIRectCornerBottomLeft | UIRectCornerBottomRight | UIRectCornerAllCorners
 *  @param radii   需要设置的圆角大小 例如 CGSizeMake(20.0f, 20.0f)
 *  @param rect    需要设置的圆角view的rect
 */
- (void)addRoundedCorners:(UIRectCorner)corners
                withRadii:(CGSize)radii
                 viewRect:(CGRect)rect;
@end
