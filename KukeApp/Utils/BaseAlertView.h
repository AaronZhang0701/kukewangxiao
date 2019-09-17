//
//  BaseAlertView.h
//  KukeApp
//
//  Created by iOSDeveloper on 2018/10/23.
//  Copyright © 2018年 zhangming. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseAlertView : UIView

- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)titleStr leftBtn:(NSString *)leftStr rightBtn:(NSString *)rightStr;
@property (weak, nonatomic) IBOutlet UIButton *NOBtn;
@property (weak, nonatomic) IBOutlet UIButton *YesBtn;
@property (weak, nonatomic) IBOutlet UILabel *title;

@end
