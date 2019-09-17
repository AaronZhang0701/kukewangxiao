//
//  AfterSaleTableViewCell.m
//  KukeApp
//
//  Created by iOSDeveloper on 2018/10/23.
//  Copyright © 2018年 zhangming. All rights reserved.
//

#import "AfterSaleTableViewCell.h"

@implementation AfterSaleTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)setModel:(MyOrderDataModel *)model{
    self.data = model;
    self.orderID.text = [NSString stringWithFormat:@"订单号:%@",model.order_sn];
    self.time.text = [NSString stringWithFormat:@"下单时间:%@",[BaseTools getDateStringWithTimeStr:model.order_time]];
    self.title.text = [model.goods valueForKey:@"goods_name"];
    [self.pic sd_setImageWithURL:[NSURL URLWithString:[model.goods valueForKey:@"goods_image"]] placeholderImage:[UIImage imageNamed:@"goodsImage"]];
    self.price.text = model.order_price;
    if([model.order_status isEqualToString:@"4"]){
        self.type.text = @"交易成功";
        self.type.textColor = [UIColor colorWithHexString:@"41a45f"];
        [self.btn setTitle:@"申请退款" forState:(UIControlStateNormal)];
        self.btn.layer.borderWidth = 0.5f;
        self.btn.layer.borderColor = [CNavBgColor CGColor];
        self.btn.layer.cornerRadius = 5;
        self.btn.layer.masksToBounds = YES;
        [self.btn addTarget:self action:@selector(btnAction) forControlEvents:(UIControlEventTouchUpInside)];
    }else if ([model.order_status isEqualToString:@"5"]){
        self.type.hidden = YES;
        [self.btn setTitle:@"退款中" forState:(UIControlStateNormal)];

    }else if ([model.order_status isEqualToString:@"6"]){
        self.type.hidden = YES;
        [self.btn setTitle:@"已退款" forState:(UIControlStateNormal)];

    }else if ([model.order_status isEqualToString:@"7"]){
        self.type.hidden =YES;
        [self.btn setTitle:@"退款失败" forState:(UIControlStateNormal)];

    }
    
}
- (void)btnAction{
    NSDictionary *dict =[[NSDictionary alloc]initWithObjectsAndKeys:self.data.order_sn,@"Order_sn", nil];
    KPostNotification(@"AfterSale",dict);
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
