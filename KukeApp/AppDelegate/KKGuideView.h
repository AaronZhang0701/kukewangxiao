//
//  KKGuideView.h
//  kuke
//
//  Created by iOSDeveloper on 2017/10/28.
//  Copyright © 2017年 iOSDeveloper. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KKGuideView : UIView

@property (nonatomic, strong) UIScrollView *imageScrollView;

@property (nonatomic, strong) UIButton *closeButton;

/*
 设置图片
 */
- (void)setGuideImages:(NSArray *)images;

@end
