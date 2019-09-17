//
//  UIButton+AICategory.h
//
//  Created by iOSDeveloper on 2018/8/9.
//  Copyright © 2018年 zhangming. All rights reserved.
//

#import <UIKit/UIKit.h>



typedef NS_ENUM(NSUInteger, BRButtonEdgeInsetsStyle) {
    /** image在上，label在下 */
    BRButtonEdgeInsetsStyleTop,
    /** image在左，label在右 */
    BRButtonEdgeInsetsStyleLeft,
    /** image在下，label在上 */
    BRButtonEdgeInsetsStyleBottom,
    /** image在右，label在左 */
    BRButtonEdgeInsetsStyleRight
};

@interface UIButton (AICategory)

/**
 *  设置button的文字和图片的布局样式，及间距
 *
 *  @param style 文字和图片的布局样式
 *  @param space 文字和图片的间距
 */
- (void)br_layoutButtonWithEdgeInsetsStyle:(BRButtonEdgeInsetsStyle)style
                           imageTitleSpace:(CGFloat)space;

/*
 *    倒计时按钮
 *
 *    @param seconds          要倒计时的总秒数
 *    @param color            还没倒计时的颜色
 *    @param countDownColor   倒计时的颜色
 */
- (void)br_startWithTime:(NSInteger)seconds color:(UIColor *)color countDownColor:(UIColor *)countDownColor;



@end
