//
//  SeckillListTableViewCell.m
//  KukeApp
//
//  Created by 库课 on 2019/2/22.
//  Copyright © 2019 KukeZangMing. All rights reserved.
//

#import "SeckillListTableViewCell.h"
#import "CourseDetailViewController.h"

@interface SeckillListTableViewCell ()
@property (nonatomic, strong) SeckillListDataModel *data;
@end

@implementation SeckillListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.goodsImage.layer.cornerRadius = 5;
    self.goodsImage.layer.masksToBounds = YES;
    
    self.goodsFinish.layer.cornerRadius = 5;
    self.goodsFinish.layer.masksToBounds = YES;
    self.goodsFinish.backgroundColor =  [[UIColor darkTextColor] colorWithAlphaComponent:0.55];
    self.payBtn.layer.cornerRadius = 3;
    self.payBtn.layer.masksToBounds = YES;
    self.seckillProgress.transform = CGAffineTransformMakeScale(1.0f, 2.0f);
    self.seckillProgress.progressTintColor=CNavBgColor;
    self.seckillProgress.trackTintColor=CBackgroundColor;
    
}
- (void)setModel:(SeckillListDataModel *)model{
    
    self.data = model;
    if ([model.seckill_status isEqualToString:@"0"]) {
        self.payBtn.backgroundColor = [UIColor colorWithRed:232/255.0 green:232/255.0  blue:232/255.0  alpha:1];
        [self.payBtn setTitleColor:[UIColor colorWithRed:138/255.0 green:138/255.0 blue:138/255.0 alpha:1] forState:(UIControlStateNormal)];
        [self.payBtn setTitle:@"即将开抢" forState:(UIControlStateNormal)];
//        self.payBtn.userInteractionEnabled = NO;
    }else if ([model.seckill_status isEqualToString:@"1"]){
        
    }else if ([model.seckill_status isEqualToString:@"2"]){
        self.payBtn.backgroundColor = [UIColor colorWithRed:232/255.0 green:232/255.0  blue:232/255.0  alpha:1];
        [self.payBtn setTitleColor:[UIColor colorWithRed:138/255.0 green:138/255.0 blue:138/255.0 alpha:1] forState:(UIControlStateNormal)];
//        self.payBtn.userInteractionEnabled = NO;
        [self.payBtn setTitle:@"已结束" forState:(UIControlStateNormal)];
        
    }
    [self.goodsImage sd_setImageWithURL:[NSURL URLWithString:model.goods_img] placeholderImage:[UIImage imageNamed:@"goodsImage"]];
    self.goodsName.text = model.goods_title;
//    self.goodsSeckillPrice.text = model.seckill_price;
//    self.goodsDisPrice.text = model.goods_price;
    self.seckillProgress.progress = [model.stock_occupied_ratio floatValue]/100;
    
    NSString *price = model.seckill_price;
    NSString *market_price = model.goods_price;
    
    NSMutableAttributedString * ma_price = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@   %@",price,market_price]];
    [ma_price addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(0, price.length)];
    [ma_price addAttribute:NSForegroundColorAttributeName value:CNavBgColor range:NSMakeRange(0,  price.length)];
    
    [ma_price addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange( price.length+3,  market_price.length)];
    [ma_price addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#8A8A8A"] range:NSMakeRange( price.length+3,  market_price.length)];
    
    [ma_price addAttributes:@{NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle], NSBaselineOffsetAttributeName : @(NSUnderlineStyleSingle)} range:NSMakeRange( price.length+3,  market_price.length)];
    
    
    self.goodsSeckillPrice.attributedText = ma_price;
    
    
    if ([model.seckill_status isEqualToString:@"0"]) {
        self.goodsNumber.text = [NSString stringWithFormat:@"限量%@份",model.stock_total];
        self.goodsFinish.hidden = YES;
    }else{
        if ([model.stock_occupied_ratio isEqualToString:@"100"]) {
            self.goodsFinish.hidden = NO;
            self.goodsNumber.text = @"已抢完";
            [self.payBtn setTitle:@"已抢完" forState:(UIControlStateNormal)];
        }else{
            self.goodsFinish.hidden = YES;
            self.goodsNumber.text = [NSString stringWithFormat:@"已抢%@%%",model.stock_occupied_ratio];
            [self.payBtn setTitle:@"立即抢购" forState:(UIControlStateNormal)];
        }
    }
}
- (IBAction)payAction:(id)sender {
    CourseDetailViewController *vc = [[CourseDetailViewController alloc]init];
    vc.ID = self.data.goods_id;
    vc.titleIndex = self.data.goods_type;
    vc.coursePrice = self.data.seckill_price;
    vc.courseTitle = self.data.goods_title;
    vc.ac_type = @"2";
    [[[AppDelegate shareAppDelegate] getCurrentUIVC].navigationController pushViewController:vc animated:YES];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
