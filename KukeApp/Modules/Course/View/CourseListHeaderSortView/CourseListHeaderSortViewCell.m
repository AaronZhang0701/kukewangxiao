//
//  CourseListHeaderSortViewCell.m
//  YXYC
//
//  Created by ios hzjt on 2018/6/8.
//  Copyright © 2018年 hzjt. All rights reserved.
//

#import "CourseListHeaderSortViewCell.h"

@interface CourseListHeaderSortViewCell()

@property (nonatomic, strong) UILabel *cellLabel;

@end

@implementation CourseListHeaderSortViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self configSelf];
        
    }
    return self;
}

- (void)configSelf {
    
//    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    _cellLabel = [[UILabel alloc] init];
    _cellLabel.font = [UIFont systemFontOfSize:13];
    _cellLabel.textAlignment = NSTextAlignmentLeft;
    
    [self.contentView addSubview:_cellLabel];
}

- (void)configWithText:(NSString *)text Selected:(BOOL)isSelected {
    self.cellLabel.text = text;
    self.cellLabel.textColor = isSelected? CNavBgColor: [UIColor blackColor];
    self.accessoryType = (isSelected? UITableViewCellAccessoryCheckmark: UITableViewCellAccessoryNone);
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.cellLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@100);
        make.height.equalTo(@44);
        make.left.equalTo(self.contentView.mas_left).offset(20);
        make.centerX.equalTo(self.contentView.mas_centerX);
    }];
}
















- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
