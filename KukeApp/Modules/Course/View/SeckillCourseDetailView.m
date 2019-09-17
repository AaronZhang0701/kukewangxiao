//
//  SeckillCourseDetailView.m
//  KukeApp
//
//  Created by 库课 on 2019/2/25.
//  Copyright © 2019 KukeZangMing. All rights reserved.
//

#import "SeckillCourseDetailView.h"

@implementation SeckillCourseDetailView

- (instancetype)initWithFrame:(CGRect)frame dict:(NSDictionary *)data
{
    self = [super initWithFrame:frame];
    if (self) {

        self.backView = [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass([self class]) owner:self options:nil] firstObject];//(owner:self ，firstObject必要)
        self.backView.frame = self.bounds;
        [self addSubview:self.backView];

        NSString *price = data[@"seckill_goods"][@"seckill_price"];
        NSString *market_price = data[@"price"];
        
        NSMutableAttributedString * ma_price = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@   %@",price,market_price]];
        [ma_price addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:23] range:NSMakeRange(0, price.length)];
        [ma_price addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0,  price.length)];
        
        [ma_price addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange( price.length+3,  market_price.length)];
        [ma_price addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange( price.length+3,  market_price.length)];
        
        [ma_price addAttributes:@{NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle], NSBaselineOffsetAttributeName : @(NSUnderlineStyleSingle)} range:NSMakeRange( price.length+3,  market_price.length)];
        
        
        self.seckillPrice.attributedText = ma_price;

        
        NSString *proStr =(NSString *)data[@"seckill_goods"][@"stock_occupied_ratio"];
        self.progress.progress = [proStr floatValue]/100;
        if ([data[@"seckill_goods"][@"seckill_status"] isEqualToString:@"1"]) {//进行中
            self.startPay.hidden = YES;
            self.progressNumber.text = [NSString stringWithFormat:@"已抢%@%%",data[@"seckill_goods"][@"stock_occupied_ratio"]];
            [self beginCountDown: ^(id receiver, NSInteger leftTime, BOOL *isStop) {
                if (leftTime > 0) {
                    NSInteger hours   = (NSInteger)((leftTime)/3600);
                    NSInteger minute  = (NSInteger)(leftTime- hours*3600)/60;
                    NSInteger second  = (NSInteger)leftTime- hours*3600 - minute*60;
                    self.timeLab.text =[NSString stringWithFormat:@"距离结束仅剩 %02ld:%02ld:%02ld",(long)hours,(long)minute,(long)second];
                } else {
                   self.backView.hidden = YES;
                }
            } WithStartTimeStamp:[[BaseTools currentTimeStr] longLongValue] endTimeStamp:[data[@"seckill_goods"][@"end_time"] longLongValue]*1000];
            
        }else{
            self.startPay.hidden = NO;
            self.timeLab.hidden  = YES;
            self.progressNumber.hidden = YES;
            self.progress.hidden = YES;
            self.backView.backgroundColor = [UIColor colorWithRed:243/255.0 green:144/255.0 blue:148/255.0 alpha:1];
            [self beginCountDown: ^(id receiver, NSInteger leftTime, BOOL *isStop) {
                if (leftTime > 0) {
                    NSInteger hours   = (NSInteger)((leftTime)/3600);
                    NSInteger minute  = (NSInteger)(leftTime- hours*3600)/60;
                    NSInteger second  = (NSInteger)leftTime- hours*3600 - minute*60;
                    self.startPay.text =[NSString stringWithFormat:@"即将开抢 %02ld:%02ld:%02ld",(long)hours,(long)minute,(long)second];
                } else {
                    self.startPay.hidden = YES;
                    self.timeLab.hidden  = NO;
                    self.progressNumber.hidden = NO;
                    self.progress.hidden = NO;
                    self.backView.backgroundColor = CNavBgColor;
                    self.progressNumber.text = [NSString stringWithFormat:@"已抢%@%%",data[@"seckill_goods"][@"stock_occupied_ratio"]];
                    [[ZMTimeCountDown ShareManager] zj_timeCountDownWithStartTimeStamp:[[BaseTools currentTimeStr] longLongValue] endTimeStamp:[data[@"seckill_goods"][@"end_time"] longLongValue]*1000 completeBlock:^(NSInteger day, NSInteger hour, NSInteger minute, NSInteger second) {
                        if (hour == 0  && minute == 0 && second == 0) {
                            self.backView.hidden = YES;
                        }else{
                            
                            self.timeLab.text =[NSString stringWithFormat:@"距离结束仅剩 %02ld:%02ld:%02ld",(long)hour,(long)minute,(long)second];
                        }
                    }];
                }
            } WithStartTimeStamp:[[BaseTools currentTimeStr] longLongValue] endTimeStamp:[data[@"seckill_goods"][@"start_time"] longLongValue]*1000];

          
        }
    }
    return self;
}
- (void)layoutSubviews{
    
    [super layoutSubviews];
    self.progress.transform = CGAffineTransformMakeScale(1.0f, 2.0f);
    self.progress.progressTintColor=[UIColor whiteColor];
    self.progress.trackTintColor=[UIColor colorWithRed:243/255.0 green:144/255.0 blue:148/255.0 alpha:1];
}
- (void)dealloc{
    [[ZMTimeCountDown ShareManager] zj_timeDestoryTimer];
}

@end
