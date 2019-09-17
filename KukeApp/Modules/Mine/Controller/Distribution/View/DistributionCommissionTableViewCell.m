//
//  DistributionCommissionTableViewCell.m
//  KukeApp
//
//  Created by 库课 on 2019/3/18.
//  Copyright © 2019 KukeZangMing. All rights reserved.
//

#import "DistributionCommissionTableViewCell.h"

@implementation DistributionCommissionTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setModel:(DistributionBillData *)model{
//    if ([model.trans_type isEqualToString:@"1"] || [model.trans_type isEqualToString:@"2"] ) {
//        self.orderType.text = @"下级分佣";
//    }else if ([model.trans_type isEqualToString:@"3"] ){
//        self.orderType.text = @"推广订单";
//    }else if ([model.trans_type isEqualToString:@"4"] ){
//        self.orderType.text = @"自购订单";
//    }else if ([model.trans_type isEqualToString:@"10"] || [model.trans_type isEqualToString:@"11"]){
//        self.orderType.text = @"提现 ";
//    }
    self.orderType.text = model.trans_type_text;
    self.orderTime.text = [BaseTools getDateStringWithTimeStr:model.create_time];
    if ([model.trans_flag isEqualToString:@"1"]) {
        self.orderMoney.text = [NSString stringWithFormat:@"+%@",model.trans_money];
    }else{
        self.orderMoney.text = [NSString stringWithFormat:@"-%@",model.trans_money];
    }
    if ([model.trans_status isEqualToString:@"0"]) {
        self.oederImage.image = [UIImage imageNamed:@"待打款-未完成图标"];
        self.orderState.text = @"审核中";

    }else if ([model.trans_status isEqualToString:@"1"]) {
        self.oederImage.image = [UIImage imageNamed:@"待打款-未完成图标"];
        self.orderState.text = @"待打款";

    }else if ([model.trans_status isEqualToString:@"2"]) {
        self.oederImage.image = [UIImage imageNamed:@"已结算图标（已完成）"];
        self.orderState.text = @"已打款";

    }else if ([model.trans_status isEqualToString:@"3"]) {
        self.oederImage.image = [UIImage imageNamed:@"已驳回 图标 拷贝"];
        self.orderState.text = @"已驳回";

    }else if ([model.trans_status isEqualToString:@"4"]) {
        self.oederImage.image = [UIImage imageNamed:@"已结算图标（已完成）"];
        self.orderState.text = @"已退回";

    }else if ([model.trans_status isEqualToString:@"5"]) {
        self.oederImage.image = [UIImage imageNamed:@"已结算图标（已完成）"];
        self.orderState.text = @"已结算";

    }
}
-(void)setData:(DistributionOrderData *)data{
//    if ([data.trans_type isEqualToString:@"1"] || [data.trans_type isEqualToString:@"2"] ) {
//        self.orderType.text = @"下级分佣";
//    }else if ([data.trans_type isEqualToString:@"3"] ){
//        self.orderType.text = @"推广订单";
//    }else if ([data.trans_type isEqualToString:@"4"] ){
//        self.orderType.text = @"自购订单";
//    }else if ([data.trans_type isEqualToString:@"10"] || [data.trans_type isEqualToString:@"11"]){
//        self.orderType.text = @"提现 ";
//    }
    self.orderType.text = data.trans_type_text;
    self.orderTime.text = [BaseTools getDateStringWithTimeStr:data.create_time];
    if ([data.trans_flag isEqualToString:@"1"]) {
        self.orderMoney.text = [NSString stringWithFormat:@"+%@",data.trans_money];
    }else{
        self.orderMoney.text = [NSString stringWithFormat:@"-%@",data.trans_money];
    }
    
    
    if ([data.trans_status isEqualToString:@"0"]) {
        self.oederImage.image = [UIImage imageNamed:@"待打款-未完成图标"];
        self.orderState.text = @"审核中";
        
    }else if ([data.trans_status isEqualToString:@"1"]) {
        self.oederImage.image = [UIImage imageNamed:@"待打款-未完成图标"];
        self.orderState.text = @"待打款";
        
    }else if ([data.trans_status isEqualToString:@"2"]) {
        self.oederImage.image = [UIImage imageNamed:@"已结算图标（已完成）"];
        self.orderState.text = @"已打款";
        
    }else if ([data.trans_status isEqualToString:@"3"]) {
        self.oederImage.image = [UIImage imageNamed:@"已驳回 图标 拷贝"];
        self.orderState.text = @"已驳回";
        
    }else if ([data.trans_status isEqualToString:@"4"]) {
        self.oederImage.image = [UIImage imageNamed:@"已结算图标（已完成）"];
        self.orderState.text = @"已退回";
        
    }else if ([data.trans_status isEqualToString:@"5"]) {
        self.oederImage.image = [UIImage imageNamed:@"已结算图标（已完成）"];
        self.orderState.text = @"已结算";
        
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
