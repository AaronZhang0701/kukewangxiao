//
//  UIViewController+ActionSheet.h
//  蓝媒智能家居系统
//
//  Created by 英赛智能 on 16/6/9.
//  Copyright © 2016年 BlueMedia. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^takePhoto)(void);
typedef void(^pickPhoto)(void);
@interface UIViewController (ActionSheet)

//- (void)actionSheet:(takePhoto)tpBlock ppBlock:(pickPhoto)pkBlock;
- (void)actionSheet:(takePhoto)tpBlock ppBlock:(pickPhoto)pkBlock with:(UIView *)view;
@end