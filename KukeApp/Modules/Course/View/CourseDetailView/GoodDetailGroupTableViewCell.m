//
//  GoodDetailGroupTableViewCell.m
//  KukeApp
//
//  Created by 库课 on 2019/7/15.
//  Copyright © 2019 KukeZangMing. All rights reserved.
//

#import "GoodDetailGroupTableViewCell.h"
#import "JoinGroupListViewController.h"
@interface GoodDetailGroupTableViewCell (){
    CourseDetailGroupRecommendModel *model;
    NSTimer   *_timer;
    NSInteger _second;
}

@end

@implementation GoodDetailGroupTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerRun:) userInfo:nil repeats:YES];
    //将定时器加入NSRunLoop，保证滑动表时，UI依然刷新
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    self.jionGroupBtn.layer.cornerRadius = 2.5f;
    self.jionGroupBtn.layer.masksToBounds = YES;
    self.headerImage.layer.cornerRadius = 18.5f;
    self.headerImage.layer.masksToBounds = YES;
    
    // Initialization code
}

- (void)setDict:(CourseDetailGroupRecommendModel *)dict{
    model = dict;
    [self.headerImage sd_setImageWithURL:[NSURL URLWithString:dict.photo] placeholderImage:[UIImage imageNamed:@"个人中心未登录头像"]];
    self.nameLab.text = dict.stu_name;
    self.groupMsgLab.text = [NSString stringWithFormat:@"还差%@人    还剩21:00:00",dict.rest_num];
    
}
- (IBAction)jionGroupAction:(id)sender {
//    JoinGroupListViewController *vc = [[JoinGroupListViewController alloc]init];
//    vc.group_buy_goods_id = model.group_buy_goods_rule_id;
//    [[[AppDelegate shareAppDelegate] getCurrentUIVC].navigationController pushViewController:vc animated:YES];
    
    
    if (_myBlock) {
        self.myBlock();
    }
    
}
- (void)setConfigWithSecond:(NSInteger)second {
    _second = second;
    if (_second > 0) {
        self.groupMsgLab.text = [NSString stringWithFormat:@"还差%@人    还剩%@",model.rest_num,[self ll_timeWithSecond:_second]];
//        NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"剩余时间:%@",[self ll_timeWithSecond:_second]]];
//        [attributeStr addAttribute:NSForegroundColorAttributeName value:CNavBgColor range:NSMakeRange(5,attributeStr.length-5)];
//        self.restTime.attributedText = attributeStr;
    }
    else {
        
        self.groupMsgLab.text = [NSString stringWithFormat:@"还差%@人    已结束",model.rest_num];
        self.jionGroupBtn.enabled = NO;
        self.jionGroupBtn.backgroundColor = CBackgroundColor;
        [self.jionGroupBtn setTitleColor:CTitleColor forState:(UIControlStateNormal)];
//        self.restTime.hidden  = YES;
    }
}

- (void)timerRun:(NSTimer *)timer {
    if (_second > 0) {
//        NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"剩余时间:%@",[self ll_timeWithSecond:_second]]];
//        [attributeStr addAttribute:NSForegroundColorAttributeName value:CNavBgColor range:NSMakeRange(5,attributeStr.length-5)];
//        self.restTime.attributedText = attributeStr;
        self.groupMsgLab.text = [NSString stringWithFormat:@"还差%@人    还剩%@",model.rest_num,[self ll_timeWithSecond:_second]];
        
        _second -= 1;
    }
    else {
        self.groupMsgLab.text = [NSString stringWithFormat:@"还差%@人    已结束",model.rest_num];
        self.jionGroupBtn.enabled = NO;
        self.jionGroupBtn.backgroundColor = CBackgroundColor;
        [self.jionGroupBtn setTitleColor:CTitleColor forState:(UIControlStateNormal)];
//        self.restTime.hidden  = YES;
    }
}

//重写父类方法，保证定时器被销毁
- (void)removeFromSuperview {
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
    [super removeFromSuperview];
}

//将秒数转换为字符串格式
- (NSString *)ll_timeWithSecond:(NSInteger)second
{
    NSString *time;
    if (second < 60) {
        time = [NSString stringWithFormat:@"00:00:%02ld",(long)second];
    }
    else {
        if (second < 3600) {
            time = [NSString stringWithFormat:@"00:%02ld:%02ld",second/60,second%60];
        }
        else {
            time = [NSString stringWithFormat:@"%02ld:%02ld:%02ld",second/3600,(second-second/3600*3600)/60,second%60];
        }
    }
    return time;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
