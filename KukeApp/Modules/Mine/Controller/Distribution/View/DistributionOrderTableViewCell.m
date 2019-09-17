//
//  DistributionOrderTableViewCell.m
//  KukeApp
//
//  Created by 库课 on 2019/3/19.
//  Copyright © 2019 KukeZangMing. All rights reserved.
//

#import "DistributionOrderTableViewCell.h"

@implementation DistributionOrderTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.goodImage.layer.cornerRadius = 5;
    self.goodImage.layer.masksToBounds = YES;
}
- (void)setModel:(DistributionOrderData *)model{
    self.buyerNameLab.text = [NSString stringWithFormat:@"买家：%@",model.stu_mobile];
    self.orderIdLab.text = [NSString stringWithFormat:@"订单号：%@",model.order_sn];
    self.orderTimeLab.text = [BaseTools getDateStringWithTimeStr:model.create_time];
    [self.goodImage sd_setImageWithURL:[NSURL URLWithString:model.goods_img] placeholderImage:[UIImage imageNamed:@"goodsImage"]];
    self.goodsName.text = model.goods_title;
    self.goodsPrice.text = model.goods_price;
    self.goodsCount.text =[NSString stringWithFormat:@"x%@",model.goods_num];
    self.commissionLab.text = [NSString stringWithFormat:@"佣金：%@",model.bro_money];
    self.payPriceLab.text = [NSString stringWithFormat:@"实付：%@",model.order_money];
    if ([model.status isEqualToString:@"0"]) {
        self.orderTypeLab.text = @"待结算";
        self.orderTypeLab.textColor = [UIColor blackColor];
    }else if ([model.status isEqualToString:@"1"]){
        self.orderTypeLab.text = @"已结算";
         self.orderTypeLab.textColor = [UIColor colorWithHexString:@"2FA582"];
    }else if ([model.status isEqualToString:@"2"]){
        self.orderTypeLab.text = @"买家退款，未结算";
        self.orderTypeLab.textColor = [UIColor blackColor];

    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
