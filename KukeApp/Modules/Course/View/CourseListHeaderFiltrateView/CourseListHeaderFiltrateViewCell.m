//
//  CourseListHeaderFiltrateViewCell.m
//  YXYC
//
//  Created by ios hzjt on 2018/6/9.
//  Copyright © 2018年 hzjt. All rights reserved.
//

#import "CourseListHeaderFiltrateViewCell.h"

@interface CourseListHeaderFiltrateViewCell()

@property (nonatomic, strong) UILabel *cellLabel;

@end

@implementation CourseListHeaderFiltrateViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self configSelf];
        
    }
    return self;
}
- (void)configSelf {
    self.contentView.backgroundColor = CBackgroundColor;
    self.contentView.layer.masksToBounds = YES;
    self.contentView.layer.cornerRadius = 16;
    
    _cellLabel = [[UILabel alloc] init];
    _cellLabel.textAlignment = NSTextAlignmentCenter;
    _cellLabel.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:_cellLabel];
    
}
- (void)configWithTitle:(NSString *)title selected:(BOOL)selected {
    _cellLabel.text = title;
    _cellLabel.textColor = selected? [UIColor whiteColor]: [UIColor blackColor];
    self.contentView.backgroundColor = selected? CNavBgColor: CBackgroundColor;
}


- (void)layoutSubviews {
    [super layoutSubviews];
    [self.cellLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(0);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-0);
        make.left.equalTo(self.contentView.mas_left).offset(0);
        make.right.equalTo(self.contentView.mas_right).offset(-0);
    }];
    
    
}

@end
