//
//  CourseTitleTableViewCell.m
//  KukeApp
//
//  Created by iOSDeveloper on 2018/10/11.
//  Copyright © 2018年 zhangming. All rights reserved.
//

#import "CourseTitleTableViewCell.h"

@interface CourseTitleTableViewCell (){

}

@end

@implementation CourseTitleTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];

}

- (void)setModel:(CourseDetailModel *)model{
    
    self.titleLab.text = model.title;
    self.descriptionLab.text = model.subtitle;

    NSString *price = model.discount_price;
    NSString *market_price = model.price;
    
    NSMutableAttributedString * ma_price = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@   %@",price,market_price]];
    [ma_price addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:23] range:NSMakeRange(0, price.length)];
    [ma_price addAttribute:NSForegroundColorAttributeName value:CNavBgColor range:NSMakeRange(0,  price.length)];
    
    [ma_price addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange( price.length+3,  market_price.length)];
    [ma_price addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#8A8A8A"] range:NSMakeRange( price.length+3,  market_price.length)];
    
    [ma_price addAttributes:@{NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle], NSBaselineOffsetAttributeName : @(NSUnderlineStyleSingle)} range:NSMakeRange( price.length+3,  market_price.length)];
    
    
    self.priceLab.attributedText = ma_price;

    
    NSMutableArray *ary = [NSMutableArray array];
    NSMutableArray *imageAry = [NSMutableArray array];
    if (model.testpaper_num.length != 0) {
        [imageAry addObject:@"详情页试卷"];
        [ary addObject:[NSString stringWithFormat:@" %@套试卷",model.testpaper_num]];
    }
    if ([model.lesson_num integerValue]>0) {
        [imageAry addObject:@"详情页课时"];
        [ary addObject:[NSString stringWithFormat:@" %@个课时",model.lesson_num]];
    }
    if ([model.live_num integerValue]>0) {
        [imageAry addObject:@"详情页直播"];
        [ary addObject:[NSString stringWithFormat:@" %@个直播",model.live_num]];
    }
    if ([model.course_num integerValue]>0) {
        [imageAry addObject:@"详情页课时"];
        [ary addObject:[NSString stringWithFormat:@" %@个课程",model.course_num]];
    }
    if ([model.exam_num integerValue]>0) {
     
        [imageAry addObject:@"详情页试卷"];
        [ary addObject:[NSString stringWithFormat:@" %@套题库",model.exam_num]];
    }
    if ([model.book_num integerValue]>0) {
        [imageAry addObject:@"详情页-tushu"];
        [ary addObject:[NSString stringWithFormat:@" %@本图书",model.book_num] ];
    }
    if (ary.count == 0) {
        self.classHourLab.hidden = YES;
    }else{
        [self.classHourLab removeAllSubviews];
        self.classHourLab.hidden = NO;
        
        for (int i = 0; i<ary.count; i++) {
            UIButton *btn = [UIButton buttonWithType:(UIButtonTypeCustom)];
            [btn setTitleColor:[UIColor colorWithHexString:@"#8A8A8A"] forState:(UIControlStateNormal)];
            btn.titleLabel.font = [UIFont systemFontOfSize:12];
            btn.frame = CGRectMake(i*70, 0, 70, 16);
            [self.classHourLab addSubview:btn];
            [btn setImage:[UIImage imageNamed:imageAry[i]] forState:(UIControlStateNormal)];
            [btn setTitle:ary[i] forState:(UIControlStateNormal)];
        }

    }
 
    if (model.live_time_text.length != 0) {
        self.liveTime.hidden = NO;
        self.classHourLab.width = 100;
        self.liveTime.x = 150;
        self.liveTime.width = screenWidth()- 160;
        [self.liveTime setTitle:[NSString stringWithFormat:@"开课时间:%@",model.live_time_text] forState:(UIControlStateNormal)];
    }else{
        self.liveTime.hidden = YES;
    }
    
    if ([model.group_sign isEqualToString:@"1"]) {
     
        self.groupBuyNum.hidden = NO;
        self.groupPeopleNum.hidden  = NO;
        self.groupBuyNum.text = [NSString stringWithFormat:@"已拼%@份",model.group.pre_num];
        self.priceLab.text = model.group.group_buy_price;
        [self.groupPeopleNum setTitle:[NSString stringWithFormat:@"%@人团",model.group.group_base_num] forState:(UIControlStateNormal)];
    }
    if ([model.seckill_flag isEqualToString:@"1"]) {
        self.priceLab.hidden = YES;
        self.groupBuyNum.hidden = YES;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
