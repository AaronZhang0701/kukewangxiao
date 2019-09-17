//
//  HZNewListHeaderFiltrateHeaderView.m
//  YXYC
//
//  Created by ios hzjt on 2018/6/9.
//  Copyright © 2018年 hzjt. All rights reserved.
//

#import "CourseListHeaderFiltrateHeaderView.h"

@interface CourseListHeaderFiltrateHeaderView()
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UILabel *line;
@end

@implementation CourseListHeaderFiltrateHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self configSelf];
        
    }
    return self;
}
- (void)configSelf {
    self.backgroundColor = [UIColor whiteColor];
    
    _label = [[UILabel alloc] init];
//    _label.font = [UIFont systemFontOfSize:14];
    _label.font = [UIFont boldSystemFontOfSize:14];
    
    _label.textAlignment = NSTextAlignmentLeft;
    
//    _line = [[UILabel alloc]init];
//    _line.backgroundColor = CBackgroundColor;
//    [self addSubview:_line];
    
    [self addSubview:_label];
    
}
- (void)configTitle:(NSString *)title {
    self.label.text = title;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(15);
        make.width.equalTo(@100);
        make.height.equalTo(@30);
        make.top.equalTo(self.mas_top).offset(12.5);
    }];
    
//    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.mas_left);
//        make.right.equalTo(self.mas_right);
//        make.height.equalTo(@1);
//        make.top.equalTo(self.mas_top);
//    }];
}

@end



















