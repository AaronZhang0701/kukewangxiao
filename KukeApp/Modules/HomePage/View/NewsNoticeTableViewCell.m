//
//  NewsNoticeTableViewCell.m
//  KukeApp
//
//  Created by iOSDeveloper on 2018/11/5.
//  Copyright © 2018年 zhangming. All rights reserved.
//

#import "NewsNoticeTableViewCell.h"

@implementation NewsNoticeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.bigView.layer.cornerRadius = 5;
    self.bigView.layer.masksToBounds = YES;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
