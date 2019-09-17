//
//  BaseAlertView.m
//  KukeApp
//
//  Created by iOSDeveloper on 2018/10/23.
//  Copyright © 2018年 zhangming. All rights reserved.
//

#import "BaseAlertView.h"

@interface BaseAlertView()
@property (strong, nonatomic) IBOutlet UIView *contentView;

@end
@implementation BaseAlertView

- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)titleStr leftBtn:(NSString *)leftStr rightBtn:(NSString *)rightStr
{
    
    
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView = [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass([self class]) owner:self options:nil] firstObject];//(owner:self ，firstObject必要)
        self.contentView.frame = self.bounds;
        self.contentView.layer.cornerRadius = 5;
        self.contentView.layer.masksToBounds = YES;
        [self addSubview:self.contentView];
        
        self.title.text = titleStr;
        [self.NOBtn setTitle:leftStr forState:(UIControlStateNormal)];
        [self.YesBtn setTitle:rightStr forState:(UIControlStateNormal)];
        
        self.NOBtn.layer.cornerRadius = 5;
        self.NOBtn.layer.masksToBounds =YES;
        self.YesBtn.layer.cornerRadius = 5;
        self.YesBtn.layer.masksToBounds = YES;
        self.NOBtn.layer.borderWidth = 1;
        self.NOBtn.layer.borderColor = [CNavBgColor CGColor];

    }
    return self;
}


@end
