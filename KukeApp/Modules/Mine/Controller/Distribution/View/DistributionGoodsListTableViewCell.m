
//
//  DistributionGoodsListTableViewCell.m
//  KukeApp
//
//  Created by 库课 on 2019/3/22.
//  Copyright © 2019 KukeZangMing. All rights reserved.
//

#import "DistributionGoodsListTableViewCell.h"

@implementation DistributionGoodsListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.goodsImage.layer.cornerRadius = 5;
    self.goodsImage.layer.masksToBounds = YES;
    // Initialization code
}
- (void)setModel:(DistributionSpreadGoodsListData *)model{
    
//    if ([model.goods_type isEqualToString:@"4"]) {
//        self.goodsImage.frame = CGRectMake((141-95/3*2)/2, 14, 141/3*2,95);
//    }else{
        self.goodsImage.frame = CGRectMake(15, 14, 141, 94);
//    }
    
    [self.goodsImage sd_setImageWithURL:[NSURL URLWithString:model.goods_img] placeholderImage:[UIImage imageNamed:@"goodsImage"]];
    self.goodsName.text = model.goods_title;
    self.goodsPrice.text = [NSString stringWithFormat:@"%@",model.goods_discount_price];
    self.goodsCommission.text = [NSString stringWithFormat:@"预计可赚%@",model.bro_money];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
