//
//  TYTabTitleViewCell.m
//  TYPagerControllerDemo
//
//  Created by tany on 16/5/4.
//  Copyright © 2016年 tanyang. All rights reserved.
//

#import "TYTabPagerBarCell.h"

@interface TYTabPagerBarCell ()
@property (nonatomic, weak) UILabel *titleLabel;
@property (nonatomic, weak) UILabel *titleLabel1;
@end

@implementation TYTabPagerBarCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self addTabTitleLabel];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self addTabTitleLabel];
    }
    return self;
}

- (void)addTabTitleLabel
{
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.font = [UIFont systemFontOfSize:15];
    titleLabel.textColor = [UIColor darkTextColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:titleLabel];
    _titleLabel = titleLabel;
    UILabel *titleLabel1 = [[UILabel alloc]init];
    titleLabel1.font = [UIFont systemFontOfSize:12];
    titleLabel1.textColor = [UIColor lightGrayColor];
    titleLabel1.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:titleLabel1];
    _titleLabel1 = titleLabel1;
}

+ (NSString *)cellIdentifier {
    return @"TYTabPagerBarCell";
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _titleLabel.frame = CGRectMake(0, 0, self.contentView.frame.size.width, self.contentView.frame.size.height/2);
    _titleLabel1.frame = CGRectMake(0, self.contentView.frame.size.height/2, self.contentView.frame.size.width, self.contentView.frame.size.height/2);
}

@end
