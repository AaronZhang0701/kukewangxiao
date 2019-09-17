//
//  HomePageRecommendTableViewCell.m
//  KukeApp
//
//  Created by iOSDeveloper on 2018/9/25.
//  Copyright © 2018年 zhangming. All rights reserved.
//

#import "HomePageRecommendTableViewCell.h"

@implementation HomePageRecommendTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
   
    self.picView.layer.cornerRadius = 5;
    self.picView.layer.masksToBounds = YES;
    // Initialization code
}
- (void)setModel:(CourseDataAryModel *)model{
    
    [self.picView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",model.img]] placeholderImage:[UIImage imageNamed:@"123"]];
    
    self.titleLab.text = model.title;
//    if ([model.goods_type isEqualToString:@"4"]) {
//        self.picView.frame = CGRectMake((138-95/3*2)/2, 14, 138/3*2,95);
//    }else{
        self.picView.frame = CGRectMake(8, 14, 138, 95);
//    }
//    self.originalPriceLab.text = [NSString stringWithFormat:@"%@",model.price];
//    self.moneyLab.text = [NSString stringWithFormat:@"%@",model.discount_price];
//    self.originalPriceLab.text = [NSString stringWithFormat:@"%@",model.price];
//    self.moneyLab.text = [NSString stringWithFormat:@"%@",model.discount_price];
    
    
    NSString *price = model.discount_price;
    NSString *market_price = model.price;
    
    NSMutableAttributedString * ma_price = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@   %@",price,market_price]];
    [ma_price addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(0, price.length)];
    [ma_price addAttribute:NSForegroundColorAttributeName value:CNavBgColor range:NSMakeRange(0,  price.length)];
    
    [ma_price addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange( price.length+3,  market_price.length)];
    [ma_price addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#8A8A8A"] range:NSMakeRange( price.length+3,  market_price.length)];
    
    [ma_price addAttributes:@{NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle], NSBaselineOffsetAttributeName : @(NSUnderlineStyleSingle)} range:NSMakeRange( price.length+3,  market_price.length)];
    
    
    self.moneyLab.attributedText = ma_price;
    
    if ([model.goods_type isEqualToString:@"1"]) {
        self.introduceLab.text = [NSString stringWithFormat:@"%@套试卷    随到随学",model.testpaper_num];
    }else if ([model.goods_type isEqualToString:@"3"]){
        self.introduceLab.text = [NSString stringWithFormat:@"%@个课时    随到随学",model.lesson_num];
    }else if ([model.goods_type isEqualToString:@"4"]){
        self.introduceLab.text =@"";
    }else if ([model.goods_type isEqualToString:@"5"]){
        self.introduceLab.text = [NSString stringWithFormat:@"%@个课程    %@套试卷",model.course_num,model.exam_num];
        
        
        NSMutableArray *ary = [NSMutableArray array];
        if ([model.live_num integerValue]>0) {
            [ary addObject:[NSString stringWithFormat:@"%@个直播",model.live_num]];
        }
        if ([model.course_num integerValue]>0) {
            [ary addObject:[NSString stringWithFormat:@"%@个课程",model.course_num]];
        }
        if ([model.exam_num integerValue]>0) {
            [ary addObject:[NSString stringWithFormat:@"%@套题库",model.exam_num]];
        }
        if ([model.book_num integerValue]>0) {
            [ary addObject:[NSString stringWithFormat:@"%@本图书",model.book_num] ];
            
        }
        if (ary.count == 0) {
            self.introduceLab.hidden = YES;
        }else{
            self.introduceLab.hidden = NO;
            NSString *text = [ary componentsJoinedByString:@"  "];
            self.introduceLab.text = text;
        }
    }
    
}
- (void)setIsCollection:(BOOL)isCollection{
    if (isCollection) {
        self.introduceLab.hidden = YES;
    }else{
        self.introduceLab.hidden = NO;
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
