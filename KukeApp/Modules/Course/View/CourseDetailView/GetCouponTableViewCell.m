//
//  GetCouponTableViewCell.m
//  KukeApp
//
//  Created by iOSDeveloper on 2018/12/11.
//  Copyright © 2018年 zhangming. All rights reserved.
//

#import "GetCouponTableViewCell.h"

@implementation GetCouponTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.bigView.layer.cornerRadius = 5.0f;
    self.bigView.layer.masksToBounds = YES;
}
- (void)setModel:(GetCouponListModel *)model{
    if ([model.coupon_type isEqualToString:@"1"]) {
        
        NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@",model.coupon_value]];
        [attributeStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15.0f] range:NSMakeRange(0,1)];
        self.moneyLab.attributedText =attributeStr ;
        
    }else{
        NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@折",model.coupon_value]];
        [attributeStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15.0f] range:NSMakeRange(model.coupon_value.length,1)];
        self.moneyLab.attributedText =attributeStr ;
        
    }
    self.nameLab.text =model.discount_note;
    self.conditionLab.text = model.direction;
    self.timeLab.text = model.valid_text;
//    NSString *startTime = [BaseTools getDateStringWithTimeStr:model.v alid_start_time];
//    NSString *endTime = [BaseTools getDateStringWithTimeStr:model.valid_end_time];
//    self.timeLab.text = [NSString stringWithFormat:@"%@-%@",startTime,endTime];
}
- (void)setUseModel:(MyCouponListModel *)useModel{
    
    
    
    if ([useModel.coupon.coupon_type isEqualToString:@"1"]) {
        
        NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@",useModel.coupon.coupon_value]];
        [attributeStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15.0f] range:NSMakeRange(0,1)];
        self.moneyLab.attributedText =attributeStr ;
        
    }else{
        NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@折",useModel.coupon.coupon_value]];
        [attributeStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15.0f] range:NSMakeRange(useModel.coupon.coupon_value.length,1)];
        self.moneyLab.attributedText =attributeStr ;
        
    }
    self.nameLab.text =useModel.coupon.discount_note;
    self.conditionLab.text = useModel.coupon.direction;
    NSString *startTime = [BaseTools getDateStringWithTimeStr:useModel.coupon.valid_start_time];
    NSString *endTime = [BaseTools getDateStringWithTimeStr:useModel.coupon.valid_end_time];
    self.timeLab.text = [NSString stringWithFormat:@"%@-%@",startTime,endTime];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
