//
//  GroupDetailHeaderTableViewCell.m
//  KukeApp
//
//  Created by 库课 on 2019/1/17.
//  Copyright © 2019 zhangming. All rights reserved.
//

#import "GroupDetailHeaderTableViewCell.h"

@implementation GroupDetailHeaderTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.goodsImage.layer.cornerRadius = 5;
    self.goodsImage.layer.masksToBounds = YES;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
