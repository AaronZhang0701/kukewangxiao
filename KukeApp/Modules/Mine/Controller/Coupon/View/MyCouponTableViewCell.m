//
//  MyCouponTableViewCell.m
//  KukeApp
//
//  Created by iOSDeveloper on 2018/12/11.
//  Copyright © 2018年 zhangming. All rights reserved.
//

#import "MyCouponTableViewCell.h"

@implementation MyCouponTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.bigView.layer.cornerRadius = 5.0f;
    self.bigView.layer.masksToBounds = YES;
    // Initialization code
}
- (void)setModel:(MyCouponListModel *)model{
    
    if ([model.status isEqualToString:@"0"]) {
        
    }else if ([model.status isEqualToString:@"1"]){
        self.bigView.backgroundColor = [UIColor colorWithRed:204/255.0 green:204/255.0 blue:204/255.0 alpha:1];
        self.pic.image = [UIImage imageNamed:@"已使用图章"];
        self.lineImage.image = [UIImage imageNamed:@"优惠券背景切图已使用已失效"];
    }else{
        self.bigView.backgroundColor = [UIColor colorWithRed:204/255.0 green:204/255.0 blue:204/255.0 alpha:1];
        self.pic.image = [UIImage imageNamed:@"已失效图章"];
        self.lineImage.image = [UIImage imageNamed:@"优惠券背景切图已使用已失效"];
    }
    
    
    if ([model.coupon.coupon_type isEqualToString:@"1"]) {
        
        NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@",model.coupon.coupon_value]];
        [attributeStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15.0f] range:NSMakeRange(0,1)];
        self.moneyLab.attributedText =attributeStr ;
        
    }else{
        NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@折",model.coupon.coupon_value]];
        [attributeStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15.0f] range:NSMakeRange(model.coupon.coupon_value.length,1)];
        self.moneyLab.attributedText =attributeStr ;
        
    }
    self.nameLab.text =model.coupon.discount_note;
    self.conditionLab.text = model.coupon.direction;
    NSString *startTime = [BaseTools getDateStringWithTimeStr:model.coupon.valid_start_time];
    NSString *endTime = [BaseTools getDateStringWithTimeStr:model.coupon.valid_end_time];
    self.timeLab.text = [NSString stringWithFormat:@"%@-%@",startTime,endTime];
//    self.timeLab.text = model.coupon.valid_text;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
