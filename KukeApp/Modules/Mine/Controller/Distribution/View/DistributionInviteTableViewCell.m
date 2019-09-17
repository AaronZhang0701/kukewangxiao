//
//  DistributionInviteTableViewCell.m
//  KukeApp
//
//  Created by 库课 on 2019/3/20.
//  Copyright © 2019 KukeZangMing. All rights reserved.
//

#import "DistributionInviteTableViewCell.h"

@implementation DistributionInviteTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)setModel:(DistributionInviteData *)model{
    self.nameLab.text = model.truename;
    self.accountLab.text = model.mobile;
    self.spreadMoney.text = [NSString stringWithFormat:@"%@",model.money];
    self.commissionLab.text = [NSString stringWithFormat:@"%@",model.bro_money];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
