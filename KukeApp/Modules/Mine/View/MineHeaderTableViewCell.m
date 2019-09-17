//
//  MineHeaderTableViewCell.m
//  KukeApp
//
//  Created by iOSDeveloper on 2018/10/2.
//  Copyright © 2018年 zhangming. All rights reserved.
//

#import "MineHeaderTableViewCell.h"
#import <SDWebImage/UIButton+WebCache.h>
#import "MyLearningListViewController.h"
#import "MyAnswerRecordListViewController.h"
#import "NewsNoticeViewController.h"
#import "ExamPageViewController.h"
@implementation MineHeaderTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.signInBtn setTitle:@"签到有礼" forState:(UIControlStateNormal)];
    [self.signInBtn setImage:[UIImage imageNamed:@"个人中心-签到有礼"] forState:(UIControlStateNormal)];
    [self.signInBtn br_layoutButtonWithEdgeInsetsStyle:(BRButtonEdgeInsetsStyleLeft) imageTitleSpace:5];
    self.pic.layer.cornerRadius = 35;
    self.pic.layer.masksToBounds = YES;
    self.messgeUnreadNumberLab.layer.cornerRadius = 7.0f;
    self.messgeUnreadNumberLab.layer.masksToBounds = YES;
    
    //这里设置的是左上和左下角
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.signInBtn.bounds byRoundingCorners:UIRectCornerBottomLeft| UIRectCornerTopLeft cornerRadii:CGSizeMake(20, 20)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.signInBtn.bounds;
    maskLayer.path = maskPath.CGPath;
    self.signInBtn.layer.mask = maskLayer;
    self.pic.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headClick:)];
    tap1.cancelsTouchesInView = NO;
    [self.pic addGestureRecognizer:tap1];
    
    
    self.recordView.layer.cornerRadius = 5;
    self.recordView.layer.masksToBounds = YES;

   
}
- (void)loadView{
    
    [self.recordView LX_SetShadowPathWith:[UIColor blackColor] shadowOpacity:0 shadowRadius:5 shadowSide:LXShadowPathAllSide shadowPathWidth:5];
    CurrentUserInfo *info= nil;
    if ([UserInfoTool persons].count != 0) {
        self.loginBtn.hidden =  YES;
        self.registerBtn.hidden = YES;
        self.headImage.hidden = NO;
        if ([[UserDefaultsUtils valueWithKey:@"IsYouKe"] isEqualToString:@"1"]) {
            [self.pic sd_setImageWithURL:[NSURL URLWithString:info.photo] placeholderImage:[UIImage imageNamed:@"个人中心未登录头像"]];
            [self.headImage setTitle:@"游客(登录)" forState:(UIControlStateNormal)];
        }else{
            info = [UserInfoTool persons][0];
            [self.pic sd_setImageWithURL:[NSURL URLWithString:info.photo] placeholderImage:[UIImage imageNamed:@"个人中心未登录头像"]];
            [self.headImage setTitle:info.NiName forState:(UIControlStateNormal)];
        }
    }else{
        self.loginBtn.hidden =  NO;
        self.registerBtn.hidden = NO;
        self.headImage.hidden = YES;
        [self.pic sd_setImageWithURL:[NSURL URLWithString:info.photo] placeholderImage:[UIImage imageNamed:@"个人中心未登录头像"]];
        [self.headImage setTitle:@"登录" forState:(UIControlStateNormal)];
    }
}
- (void)setImageUrl:(NSString *)imageUrl{
//    NSArray *dirArray = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
//    NSString *path = [dirArray firstObject];
//    path = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"IDCARD%d",0]];
//    if([[NSFileManager defaultManager] fileExistsAtPath:path]){
//        NSData *picData = [NSData dataWithContentsOfFile:path];
//        self.pic.image = [UIImage imageWithData:picData];
//    }

}
- (IBAction)headerAction:(id)sender {
    if (_headerActionBlock) {
        self.headerActionBlock();
    }
    
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    UIView * view = [super hitTest:point withEvent:event];
    if (view != nil) {
        // 转换坐标系
        CGPoint newPoint = [self.courseRecord convertPoint:point fromView:self];
        // 判断触摸点是否在button上
        if (CGRectContainsPoint(self.courseRecord.bounds, newPoint)) {
            view = self.courseRecord;
        }
        
        // 转换坐标系
        CGPoint newPoint1 = [self.testPaperRecord convertPoint:point fromView:self];
        // 判断触摸点是否在button上
        if (CGRectContainsPoint(self.testPaperRecord.bounds, newPoint1)) {
            view = self.testPaperRecord;
        }
    }
    return view;
}

- (IBAction)courseRecordAction:(id)sender {
    MyLearningListViewController *vc = [[MyLearningListViewController alloc]init];
    [[[AppDelegate shareAppDelegate] getCurrentUIVC].navigationController pushViewController:vc animated:YES];
}
- (IBAction)testPaperRecordAction:(id)sender {
//    MyAnswerRecordListViewController *vc = [[MyAnswerRecordListViewController alloc]init];
    ExamPageViewController *vc = [[ExamPageViewController alloc]init];
    [[[AppDelegate shareAppDelegate] getCurrentUIVC].navigationController pushViewController:vc animated:YES];
}
- (IBAction)myNoticeAction:(id)sender {
    
    NewsNoticeViewController *vc = [[NewsNoticeViewController alloc]init];
    [[[AppDelegate shareAppDelegate] getCurrentUIVC].navigationController pushViewController:vc animated:YES];

}
- (IBAction)loginAction:(id)sender {
     [BaseTools alertLoginWithVC:[[AppDelegate shareAppDelegate]getCurrentUIVC]];
}
- (IBAction)registerAction:(id)sender {
  
    [BaseTools alertRegisterWithVC:[[AppDelegate shareAppDelegate]getCurrentUIVC]];
}

- (IBAction)singInAction:(id)sender {
    
    if (_singinActionBlock) {
        self.singinActionBlock();
    }
}
- (void)headClick:(id)sender {
    if (_headerActionBlock) {
        self.headerActionBlock();
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
