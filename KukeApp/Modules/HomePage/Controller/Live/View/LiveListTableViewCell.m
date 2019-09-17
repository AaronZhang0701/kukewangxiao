//
//  LiveListTableViewCell.m
//  KukeApp
//
//  Created by 库课 on 2019/7/18.
//  Copyright © 2019 KukeZangMing. All rights reserved.
//

#import "LiveListTableViewCell.h"

@implementation LiveListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.liveTypeView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6f];
//    self.liveTypeView.layer.cornerRadius = 5; 
    self.goodsPic.layer.cornerRadius = 5;
//    self.goodsPic.layer.masksToBounds = YES;
    self.joinBtn.layer.cornerRadius = 3;
    
//
////    self.liveTypeView.width = self.goodsPic.frame.size.width;
    [self.liveTypeView addRoundedCorners:(UIRectCornerBottomLeft | UIRectCornerBottomRight) withRadii:CGSizeMake(5.0, 5.0) viewRect:CGRectMake(0, 0, screenWidth()-30, 30)];
    self.goodsPic.frame = CGRectMake(15, 15,screenWidth()-30 , (screenWidth()-30)/3*2);
//    self.goodsPic.width = 230*3/2;
    self.liveTypeView.layer.masksToBounds = NO;
    // Initialization code
}
- (void)setModel:(LiveListDataModel *)model{
    [self.goodsPic sd_setImageWithURL:[NSURL URLWithString:model.img] placeholderImage:[UIImage imageNamed:@"goodsImage"]];
  
    self.goodsName.text = model.title;
    NSString *price = model.discount_price;
    NSString *market_price = model.price;
    
    
    NSMutableAttributedString * ma_price = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@   %@",price,market_price]];
    [ma_price addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(0, price.length)];
    [ma_price addAttribute:NSForegroundColorAttributeName value:CNavBgColor range:NSMakeRange(0,  price.length)];
    
    [ma_price addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:10] range:NSMakeRange( price.length+3,  market_price.length)];
    [ma_price addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#8A8A8A"] range:NSMakeRange( price.length+3,  market_price.length)];
    
    [ma_price addAttributes:@{NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle], NSBaselineOffsetAttributeName : @(NSUnderlineStyleSingle)} range:NSMakeRange( price.length+3,  market_price.length)];
    
    
    self.goodsPriceLab.attributedText = ma_price;
    
    
    if ([model.live_status isEqualToString:@"0"]) {
    
        self.LiveTypePic.image = [UIImage imageNamed:@"直播列表-未开课"];
        self.liveTypeLab.text = @"未开课";
        self.goodsTimePic.image = [UIImage imageNamed:@"时间icon"];
        self.goodsTimeLab.text = model.live_time_text;
        self.goodsTimeLab.textColor = CTitleColor;
    }else if ([model.live_status isEqualToString:@"1"]){
        self.LiveTypePic.image = [UIImage imageNamed:@"直播列表-已开课"];
        self.liveTypeLab.text = @"已开课";
        self.goodsTimePic.image = [UIImage imageNamed:@"时间icon"];
        self.goodsTimeLab.text = model.live_time_text;
        self.goodsTimeLab.textColor = CTitleColor;
    }else if ([model.live_status isEqualToString:@"2"]){

        self.LiveTypePic.image = [UIImage imageNamed:@"直播列表-直播中"];
        self.liveTypeLab.text = @"直播中";
        self.goodsTimePic.image = [UIImage imageNamed:@"直播列表时间-红"];
        self.goodsTimeLab.text = model.live_time_text;
        self.goodsTimeLab.textColor = CNavBgColor;
    }else if ([model.live_status isEqualToString:@"3"]){

        self.LiveTypePic.image = [UIImage imageNamed:@"直播列表-回放"];
        self.liveTypeLab.text = @"回放";
        self.goodsTimePic.image = [UIImage imageNamed:@"时间icon"];
        self.goodsTimeLab.text = model.live_time_text;
        self.goodsTimeLab.textColor = CTitleColor;
    }
    self.studentNum.text = [NSString stringWithFormat:@"%@人报名",model.student_num];
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
