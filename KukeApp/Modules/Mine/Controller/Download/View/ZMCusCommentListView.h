//
//  ZMCusCommentListView.h
//  ZMZX
//
//  Created by Kennith.Zeng on 2018/8/29.
//  Copyright © 2018年 齐家网. All rights reserved.
//

#import <UIKit/UIKit.h>
#define ZMCusCommentViewTopHeight SCREEN_WIDTH/16*9

@interface ZMCusCommentListView : UIView
@property (nonatomic, copy) void(^closeBtnBlock)(void);
@property (nonatomic, copy) void(^tapBtnBlock)(void);
@property (nonatomic, strong) NSDictionary *videoInfo;
@end
