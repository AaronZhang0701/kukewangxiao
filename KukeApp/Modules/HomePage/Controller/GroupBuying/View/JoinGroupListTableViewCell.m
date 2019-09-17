//
//  JoinGroupListTableViewCell.m
//  KukeApp
//
//  Created by 库课 on 2019/1/11.
//  Copyright © 2019 zhangming. All rights reserved.
//

#import "JoinGroupListTableViewCell.h"
#import "PayMentViewController.h"
@implementation JoinGroupListTableViewCell{
    NSTimer   *_timer;
    NSInteger _second;
    JoinGroupListDataModel *data;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerRun:) userInfo:nil repeats:YES];
    //将定时器加入NSRunLoop，保证滑动表时，UI依然刷新
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    self.pic.layer.cornerRadius = 7;
    self.pic.layer.masksToBounds = YES;
    
    self.groupBtn.layer.cornerRadius = 3;
    self.groupBtn.layer.masksToBounds = YES;

    self.student1.layer.cornerRadius = 25;
    self.student1.layer.masksToBounds = YES;
    
    self.student2.layer.cornerRadius = 25;
    self.student2.layer.masksToBounds = YES;
    
    self.student3.layer.cornerRadius = 25;
    self.student3.layer.masksToBounds = YES;
    // Initialization code
}
-(void)setModel:(JoinGroupListDataModel *)model{
    data = model;
    self.addTime.text = [NSString stringWithFormat:@"开团时间 %@",[BaseTools getDateStringWithTimeMdHms:model.add_time]];
    [self.student1 sd_setImageWithURL:[NSURL URLWithString:model.photo] placeholderImage:[UIImage imageNamed:@"个人中心未登录头像"]];
    self.studentName1.text = model.stu_name;
    if (model.son.count == 1) {
        [self.student2 sd_setImageWithURL:[NSURL URLWithString:[model.son[0] photo]] placeholderImage:[UIImage imageNamed:@"个人中心未登录头像"]];
        self.studentName2.text =[model.son[0] stu_name];
        self.student3.hidden = YES;
        self.studentName3.hidden = YES;
    }else if (model.son.count ==2){
        [self.student2 sd_setImageWithURL:[NSURL URLWithString:[model.son[0] photo]]placeholderImage:[UIImage imageNamed:@"个人中心未登录头像"]];
        [self.student3 sd_setImageWithURL:[NSURL URLWithString:[model.son[1] photo]] placeholderImage:[UIImage imageNamed:@"个人中心未登录头像"]];
        self.studentName2.text =[model.son[0] stu_name];
        self.studentName3.text =[model.son[1] stu_name];
    }
    self.restNumber.text = [NSString stringWithFormat:@"还差%@人拼团成功",model.rest_num];

    
    
    
}
- (IBAction)groupAction:(id)sender {
    if ([[UserDefaultsUtils valueWithKey:@"access_token"] length] !=0 ) {
        if ([data.is_include isEqualToString:@"1"]) {
            [BaseTools showErrorMessage:@"你已经参与过该团了"];
        }else{
            PayMentViewController *vc = [[PayMentViewController alloc]init];
            vc.goodID = data.goods_id;
            vc.goodType = data.goods_type;
            vc.group_buy_goods_rule_id = data.group_buy_goods_rule_id;
            vc.token = data.token;
            
            [[[AppDelegate shareAppDelegate] getCurrentUIVC].navigationController pushViewController:vc animated:YES];
        }
    }else{
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [BaseTools alertLoginWithVC:[[AppDelegate shareAppDelegate] getCurrentUIVC]];
        });
    }
   
}
- (void)setConfigWithSecond:(NSInteger)second {
    _second = second;
    if (_second > 0) {
        
        NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"剩余时间:%@",[self ll_timeWithSecond:_second]]];
        [attributeStr addAttribute:NSForegroundColorAttributeName value:CNavBgColor range:NSMakeRange(5,attributeStr.length-5)];
        self.restTime.attributedText = attributeStr;
    }
    else {
        self.restTime.hidden  = YES;
    }
}

- (void)timerRun:(NSTimer *)timer {
    if (_second > 0) {
        NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"剩余时间:%@",[self ll_timeWithSecond:_second]]];
        [attributeStr addAttribute:NSForegroundColorAttributeName value:CNavBgColor range:NSMakeRange(5,attributeStr.length-5)];
        self.restTime.attributedText = attributeStr;
        
        
        _second -= 1;
    }
    else {
        self.restTime.hidden  = YES;
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

- (void)dealloc {
    NSLog(@"cell释放");
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
