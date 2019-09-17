//
//  UIScrollView+WKExtension.h
//  Pods-WKChewieRefresh_Example
//
//  Created by 王昆 on 2017/11/16.
//

#import <UIKit/UIKit.h>

@interface UIScrollView (WKExtension)
@property (readonly, nonatomic) UIEdgeInsets wk_inset;

@property (assign, nonatomic) CGFloat wk_insetT;
@property (assign, nonatomic) CGFloat wk_insetB;
@property (assign, nonatomic) CGFloat wk_insetL;
@property (assign, nonatomic) CGFloat wk_insetR;

@property (assign, nonatomic) CGFloat wk_offsetX;
@property (assign, nonatomic) CGFloat wk_offsetY;

@property (assign, nonatomic) CGFloat wk_contentW;
@property (assign, nonatomic) CGFloat wk_contentH;
@end
