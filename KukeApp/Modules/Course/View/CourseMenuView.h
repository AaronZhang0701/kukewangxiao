//
//  CourseMenuView.h
//  KukeApp
//
//  Created by iOSDeveloper on 2018/9/29.
//  Copyright © 2018年 zhangming. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^CourseMenuActionBlock)(NSInteger cateID);

@interface CourseMenuView : UIView
- (instancetype)initWithFrame:(CGRect)frame menuCount:(NSInteger)number;
@property (nonatomic ,copy) CourseMenuActionBlock myBlock;
@end
