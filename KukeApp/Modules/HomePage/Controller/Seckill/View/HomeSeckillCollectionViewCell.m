//
//  HomeSeckillCollectionViewCell.m
//  KukeApp
//
//  Created by 库课 on 2019/2/18.
//  Copyright © 2019 KukeZangMing. All rights reserved.
//

#import "HomeSeckillCollectionViewCell.h"

@implementation HomeSeckillCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];

    self.goodsImage.layer.cornerRadius = 5;
    self.goodsImage.layer.masksToBounds = YES;
    self.goodsFinish.layer.cornerRadius = 5;
    self.goodsFinish.layer.masksToBounds = YES;
    self.goodsFinish.backgroundColor =  [[UIColor darkTextColor] colorWithAlphaComponent:0.55];
    self.goodsProgress.transform = CGAffineTransformMakeScale(1.0f, 2.0f);
    self.goodsProgress.progressTintColor=CNavBgColor;
    self.goodsProgress.trackTintColor=CBackgroundColor;
    

    
    // Initialization code
}
- (void)setModel:(HomePagePlaySeckillListModel *)model{
    
//    if ([model.goods_type isEqualToString:@"4"]) {
//        self.goodsImage.frame = CGRectMake((self.frame.size.width - self.frame.size.width/3*2)/2,15, self.frame.size.width/3*2,104);
//    }else{
    self.goodsImage.frame = CGRectMake(0, 15,self.frame.size.width, 104);
    self.goodsFinish.frame = CGRectMake(0, 15,self.frame.size.width, 104);
//    }
    
    [self.goodsImage sd_setImageWithURL:[NSURL URLWithString:model.goods_img] placeholderImage:[UIImage imageNamed:@"goodsImage"]];
    self.goodsName.text = model.goods_title;
    self.goodsPrice.text = model.seckill_price;
    self.goodsDisPrice.text = model.goods_price;
    self.goodsProgress.progress = [model.stock_occupied_ratio floatValue]/100;
    if ([model.seckill_status isEqualToString:@"0"]) {
        self.seckillNumber.text = [NSString stringWithFormat:@"限量%@份",model.stock_total];
        self.goodsFinish.hidden = YES;
        
    }else{
        if ([model.stock_occupied_ratio isEqualToString:@"100"]) {
            self.goodsFinish.hidden = NO;
            
            self.seckillNumber.text = @"已抢完";
        }else{
            self.goodsFinish.hidden = YES;
            self.seckillNumber.text = [NSString stringWithFormat:@"已抢%@%%",model.stock_occupied_ratio];
        }
    }
    
   
    
    
}
@end
