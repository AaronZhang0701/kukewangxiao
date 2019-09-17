//
//  RechargeRecordTableViewCell.m
//  KukeApp
//
//  Created by iOSDeveloper on 2018/10/29.
//  Copyright © 2018年 zhangming. All rights reserved.
//

#import "RechargeRecordTableViewCell.h"

@implementation RechargeRecordTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)setModel:(MyRechargeRecordeDataListModel *)model{
    self.type.text = model.content;
    self.time.text = [BaseTools getDateStringWithTimeStr:model.add_time];
    NSString *str;
    if ([model.status isEqualToString:@"1"]) {
        str = @"+";
    }else{
        str = @"-";
    }
    self.money.text = [NSString stringWithFormat:@"%@%@",str,model.affect_amount];
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
