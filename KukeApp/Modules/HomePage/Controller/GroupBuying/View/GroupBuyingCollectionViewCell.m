//
//  GroupBuyingCollectionViewCell.m
//  KukeApp
//
//  Created by 库课 on 2019/1/9.
//  Copyright © 2019 zhangming. All rights reserved.
//

#import "GroupBuyingCollectionViewCell.h"

@implementation GroupBuyingCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.goodsImage.layer.cornerRadius = 5;
    self.goodsImage.layer.masksToBounds = YES;
    // Initialization code
}
- (void)setModel:(HomeGroupBuyingModel *)model{
    
//    if ([model.goods_type isEqualToString:@"4"]) {
//        self.goodsImage.frame = CGRectMake((self.frame.size.width - self.frame.size.width/3*2)/2,15, self.frame.size.width/3*2,104);
//    }else{
        self.goodsImage.frame = CGRectMake(0, 15,self.frame.size.width, 104);
//    }

    [self.goodsImage sd_setImageWithURL:[NSURL URLWithString:model.goods_img] placeholderImage:[UIImage imageNamed:@"goodsImage"]];
    self.goodsTitle.text = model.goods_name;
    self.goodsPrice.text = [NSString stringWithFormat:@"%@",model.group_buy_price];
    self.goodsDiscountPrice.text = [NSString stringWithFormat:@"%@",model.goods_price];
    self.groupNumber.text = [NSString stringWithFormat:@"已拼%@份",model.pre_num];
    [self.peopleNumberBtn setTitle:[NSString stringWithFormat:@"%@人团",model.group_base_num] forState:(UIControlStateNormal)];
}
@end
