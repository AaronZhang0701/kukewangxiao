//
//  HomeLiveTableViewCell.m
//  KukeApp
//
//  Created by 库课 on 2019/7/17.
//  Copyright © 2019 KukeZangMing. All rights reserved.
//

#import "HomeLiveTableViewCell.h"
#import "LiveListViewController.h"

@interface HomeLiveTableViewCell (){
    HomeLiveModel *model1;
    HomeLiveModel *model2;
}

@end

@implementation HomeLiveTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.view1.layer.shadowColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:0.25].CGColor;
    self.view1.layer.shadowOffset = CGSizeMake(0,0);
    self.view1.layer.shadowOpacity = 1;
    self.view1.layer.shadowRadius = 4;
    self.view1.layer.cornerRadius = 5;
    
    
    self.view2.layer.shadowColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:0.25].CGColor;
    self.view2.layer.shadowOffset = CGSizeMake(0,0);
    self.view2.layer.shadowOpacity = 1;
    self.view2.layer.shadowRadius = 4;
    self.view2.layer.cornerRadius = 5;
    
    self.header1_1.layer.cornerRadius = 26.5f;
    self.header1_2.layer.cornerRadius = 26.5f;
    self.header1_3.layer.cornerRadius = 26.5f;
    self.header2_1.layer.cornerRadius = 26.5f;
    self.header2_2.layer.cornerRadius = 26.5f;
    self.header2_3.layer.cornerRadius = 26.5f;
    
    
    [self.typeLab1 addRoundedCorners:UIRectCornerTopRight | UIRectCornerBottomLeft withRadii:CGSizeMake(3.0, 3.0)];
    [self.typeLab2 addRoundedCorners:UIRectCornerTopRight | UIRectCornerBottomLeft withRadii:CGSizeMake(3.0, 3.0)];
    
    
    
    // Initialization code
}
- (void)setModelAry:(NSMutableArray *)modelAry{

    if (modelAry.count == 1) {
        model1 = modelAry[0];
        self.view2.hidden = YES;
    }else if (modelAry.count == 2) {
        self.view2.hidden = NO;
        model1 = modelAry[0];
        model2 = modelAry[1];
        if ([model2.live_status isEqualToString:@"0"]) {
            self.typeLab2.backgroundColor = [UIColor colorWithHexString:@"#999999"];
            self.typeLab2.text = @"未开课";
            //        self.typeLab2.textColor = CTitleColor;
        }else if ([model2.live_status isEqualToString:@"1"]){
            self.typeLab2.backgroundColor = [UIColor colorWithHexString:@"#999999"];
            self.typeLab2.text = @"已开课";
        }else if ([model2.live_status isEqualToString:@"2"]){
            self.typeLab2.backgroundColor = CNavBgColor;
            self.typeLab2.text = @"直播中";
        }else if ([model2.live_status isEqualToString:@"3"]){
            self.typeLab2.backgroundColor = [UIColor colorWithHexString:@"#999999"];
            self.typeLab2.text = @"回放";
            //        self.typeLab2.textColor = CTitleColor;
        }
        
        self.timeLab2.text = model2.live_time_text;
        self.titleLab2.text = model2.title;
        if (model2.teachers.count == 1) {
            self.header2_1.hidden = YES;
            self.header2_3.hidden = YES;
            self.header2_2.hidden = NO;
            HomePageLiveTeacherModel *teacher = model2.teachers[0];
            [self.header2_2 sd_setImageWithURL:[NSURL URLWithString: teacher.photo] placeholderImage:nil];
        }else if(model2.teachers.count == 2){
            self.header2_1.hidden = NO;
            self.header2_3.hidden = NO;
            self.header2_2.hidden = YES;
            HomePageLiveTeacherModel *teacher1 = model2.teachers[0];
            HomePageLiveTeacherModel *teacher2 = model2.teachers[1];
            [self.header2_1 sd_setImageWithURL:[NSURL URLWithString: teacher1.photo] placeholderImage:nil];
            [self.header2_3 sd_setImageWithURL:[NSURL URLWithString: teacher2.photo] placeholderImage:nil];
        }
    }

    self.timeLab1.text = model1.live_time_text;
    self.titleLab1.text = model1.title;
    if ([model1.live_status isEqualToString:@"0"]) {
        self.typeLab1.backgroundColor = [UIColor colorWithHexString:@"#999999"];
        self.typeLab1.text = @"未开课";
//        self.typeLab1.textColor = CTitleColor;
    }else if ([model1.live_status isEqualToString:@"1"]){
        self.typeLab1.backgroundColor = [UIColor colorWithHexString:@"#999999"];
        self.typeLab1.text = @"已开课";
    }else if ([model1.live_status isEqualToString:@"2"]){
        self.typeLab1.backgroundColor = CNavBgColor;
        self.typeLab1.text = @"直播中";
    }else if ([model1.live_status isEqualToString:@"3"]){
        self.typeLab1.backgroundColor = [UIColor colorWithHexString:@"#999999"];
        self.typeLab1.text = @"回放";
//         self.typeLab1.textColor = CTitleColor;
    }
    
    if (model1.teachers.count == 1) {
        HomePageLiveTeacherModel *teacher = model1.teachers[0];
        self.header1_1.hidden = YES;
        self.header1_3.hidden = YES;
        self.header1_2.hidden = NO;
        [self.header1_2 sd_setImageWithURL:[NSURL URLWithString: teacher.photo] placeholderImage:nil];
    }else if(model1.teachers.count == 2){
        self.header1_1.hidden = NO;
        self.header1_3.hidden = NO;
        self.header1_2.hidden = YES;
        HomePageLiveTeacherModel *teacher1 = model1.teachers[0];
        HomePageLiveTeacherModel *teacher2 = model1.teachers[1];
        [self.header1_1 sd_setImageWithURL:[NSURL URLWithString: teacher1.photo] placeholderImage:nil];
        [self.header1_3 sd_setImageWithURL:[NSURL URLWithString: teacher2.photo] placeholderImage:nil];
    }
    
}
- (IBAction)moreAction:(id)sender {
    LiveListViewController *vc = [[LiveListViewController alloc]init];
    
    [[[AppDelegate shareAppDelegate] getCurrentUIVC].navigationController pushViewController:vc animated:YES];
}
- (IBAction)live1Action:(id)sender {
    
   
    CourseDetailViewController *vc = [[CourseDetailViewController alloc]init];
    vc.ID = model1.live_id;
    vc.titleIndex = @"6";
    [[[AppDelegate shareAppDelegate] getCurrentUIVC].navigationController pushViewController:vc animated:YES];

}
- (IBAction)live2Action:(id)sender {
    CourseDetailViewController *vc = [[CourseDetailViewController alloc]init];
    vc.ID = model2.live_id;
    vc.titleIndex = @"6";
    [[[AppDelegate shareAppDelegate] getCurrentUIVC].navigationController pushViewController:vc animated:YES];
    
    
//    [PolyvLiveOrVodPlayerManager zm_verifyPermissionWithChannelId:@"351716" vid:@"" playerType:@"Live" ToPlayerFromViewController:[[AppDelegate shareAppDelegate] getCurrentUIVC]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
