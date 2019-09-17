//
//  MyCourseListTableViewCell.m
//  KukeApp
//
//  Created by iOSDeveloper on 2018/10/18.
//  Copyright © 2018年 zhangming. All rights reserved.
//

#import "MyCourseListTableViewCell.h"

@interface MyCourseListTableViewCell (){
    NSString *cate_id;
}

@end

@implementation MyCourseListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.pic.layer.cornerRadius = 5;
    self.pic.layer.masksToBounds = YES;
    self.startBtn.layer.borderWidth = 1;
    self.startBtn.layer.borderColor = [[UIColor colorWithRed:230/255.0 green:33/255.0 blue:41/255.0 alpha:1] CGColor];
    self.startBtn.layer.cornerRadius = 3;
    self.startBtn.layer.masksToBounds = YES;
    UIColor *color = [UIColor blackColor];
    self.isFailureImage.backgroundColor = [color colorWithAlphaComponent:0.5];
    self.isFailureImage.layer.masksToBounds = YES;
    self.isFailureImage.layer.cornerRadius = 5;
    self.liveTypeView.backgroundColor = [color colorWithAlphaComponent:0.6];
    [self.liveTypeView addRoundedCorners:(UIRectCornerBottomLeft | UIRectCornerBottomRight) withRadii:CGSizeMake(5.0, 5.0)];
//    self.isFailureImage.alpha = 0.5;
    // Initialization code
}
- (void)setCateID:(NSString *)cateID{
    cate_id = cateID;
}

- (void)setModel:(CourseDataAryModel *)model{
    self.liveTypeView.hidden = YES;
    [self.pic sd_setImageWithURL:[NSURL URLWithString:model.img] placeholderImage:[UIImage imageNamed:@""]];
    self.titleLab.text = model.title;
    self.timeLab.text = [NSString stringWithFormat:@"共%@套试卷",model.testpaper_num];
    if ([UserDefaultsUtils boolValueWithKey:KIsAudit]){
        self.isFailureImage.hidden = YES;
    }else{
        if ([model.is_expired isEqualToString:@"1"]) {
            self.isFailureImage.hidden = NO;
        }else{
            self.isFailureImage.hidden = YES;
        }
        
    }
    
    
    if (![model.ave_score isEqualToString:@"0"]) {
        self.averageLab.text = [NSString stringWithFormat:@"平均分%@",model.ave_score];
    }else{
        self.averageLab.hidden = YES;
    }
    
    if ([model.over_num integerValue]==0) {//未作
        [self.propressLab setTitle:@"未开始做题" forState:(UIControlStateNormal)];
        [self.propressLab setImage:nil forState:(UIControlStateNormal)];
        [self.startBtn setTitle:@"开始做题" forState:(UIControlStateNormal)];
    }else if (0<[model.over_num integerValue]<[model.testpaper_num integerValue]){//做了一部分但是没做完
        [self.propressLab setTitle:[NSString stringWithFormat:@"已做%@套",model.over_num] forState:(UIControlStateNormal)];
        [self.propressLab setImage:nil forState:(UIControlStateNormal)];
        [self.startBtn setTitle:@"继续做题" forState:(UIControlStateNormal)];
        self.averageLab.textColor = [UIColor colorWithRed:138/255.0 green:138/255.0 blue:138/255.0 alpha:1];
    }else if ([model.over_num integerValue]==[model.testpaper_num integerValue]){// 已经做完了
        [self.propressLab setTitle:@"  已做完全部试卷" forState:(UIControlStateNormal)];
        [self.propressLab setImage:[UIImage imageNamed:@"学完绿色对勾图标"] forState:(UIControlStateNormal)];
        [self.startBtn setTitle:@"重新做题" forState:(UIControlStateNormal)];
        self.averageLab.textColor = [UIColor colorWithRed:65/255.0 green:164/255.0 blue:95/255.0 alpha:1];
    }
}
- (void)configCellData:(NewExamListData *)model{
    self.liveTypeView.hidden = YES;
    self.startBtn.hidden = YES;
    [self.pic sd_setImageWithURL:[NSURL URLWithString:model.img] placeholderImage:[UIImage imageNamed:@""]];
    self.titleLab.text = model.title;
    self.timeLab.text = [NSString stringWithFormat:@"共%@套试卷",model.testpaper_num];

    
    

    

    
//    if ([model.over_num integerValue]==0) {//未作
//        [self.propressLab setTitle:@"未开始做题" forState:(UIControlStateNormal)];
//        [self.propressLab setImage:nil forState:(UIControlStateNormal)];
//        [self.startBtn setTitle:@"开始做题" forState:(UIControlStateNormal)];
//    }else if (0<[model.over_num integerValue]<[model.testpaper_num integerValue]){//做了一部分但是没做完
//        [self.propressLab setTitle:[NSString stringWithFormat:@"已做%@套",model.over_num] forState:(UIControlStateNormal)];
//        [self.propressLab setImage:nil forState:(UIControlStateNormal)];
//        [self.startBtn setTitle:@"继续做题" forState:(UIControlStateNormal)];
//        self.averageLab.textColor = [UIColor colorWithRed:138/255.0 green:138/255.0 blue:138/255.0 alpha:1];
//    }else if ([model.over_num integerValue]==[model.testpaper_num integerValue]){// 已经做完了
//        [self.propressLab setTitle:@"  已做完全部试卷" forState:(UIControlStateNormal)];
//        [self.startBtn setTitle:@"重新做题" forState:(UIControlStateNormal)];
//        self.averageLab.textColor = [UIColor colorWithRed:65/255.0 green:164/255.0 blue:95/255.0 alpha:1];
//    }
    if ([model.study_status integerValue]==0) {//未作
        [self.propressLab setTitle:@"未开始做题" forState:(UIControlStateNormal)];
        [self.propressLab setImage:nil forState:(UIControlStateNormal)];
        [self.startBtn setTitle:@"开始做题" forState:(UIControlStateNormal)];
        self.averageLab.hidden = YES;
    }else if ([model.study_status integerValue]==1){//做了一部分但是没做完
        //        [self.propressLab setTitle:[NSString stringWithFormat:@"学至 %@",models.last_node_title] forState:(UIControlStateNormal)];
        
        [self.propressLab setTitle:[NSString stringWithFormat:@"已做%@套",model.over_num] forState:(UIControlStateNormal)];
        [self.propressLab setImage:nil forState:(UIControlStateNormal)];
        self.averageLab.hidden = NO;
        
        [self.propressLab setImage:nil forState:(UIControlStateNormal)];
        [self.startBtn setTitle:@"继续做题" forState:(UIControlStateNormal)];
        self.averageLab.text = [NSString stringWithFormat:@"平均分%@",model.ave_score];
        self.averageLab.textColor = CNavBgColor;
    }else if ([model.study_status integerValue]==2){// 已经做完了
        self.averageLab.hidden = NO;
        [self.propressLab setTitle:@"  已做完全部试卷" forState:(UIControlStateNormal)];
        [self.startBtn setTitle:@"重新做题" forState:(UIControlStateNormal)];
        self.averageLab.text = [NSString stringWithFormat:@"平均分%@",model.ave_score];
        self.averageLab.textColor = [UIColor colorWithRed:65/255.0 green:164/255.0 blue:95/255.0 alpha:1];
    }
    
    if ([UserDefaultsUtils boolValueWithKey:KIsAudit]){
        self.isFailureImage.hidden = YES;
    }else{
        if ([model.is_expired isEqualToString:@"1"]) {
            self.isFailureImage.hidden = NO;
        }else{
            self.isFailureImage.hidden = YES;
        }

    }

}

- (void)setModels:(MyLearningListDataModel *)models{
    
    self.startBtn.hidden = YES;
    self.timeLab.hidden = NO;;
    self.averageLab.hidden = YES;
    self.liveTypeView.hidden = YES;
    [self.pic sd_setImageWithURL:[NSURL URLWithString:models.course_img] placeholderImage:[UIImage imageNamed:@""]];
    self.titleLab.text = models.course_title;
//    self.timeLab.text = [NSString stringWithFormat:@"共%@课时  已学习%@课时",models.course_lesson_num,models.learned_lesson_num];
    self.timeLab.text = [NSString stringWithFormat:@"已学 %@/%@ 课时",models.learned_lesson_num,models.course_lesson_num];
    
    if ([models.learn_status integerValue]==0) {//未作
        [self.propressLab setTitle:@"未开始学习" forState:(UIControlStateNormal)];
        [self.propressLab setImage:nil forState:(UIControlStateNormal)];
        [self.startBtn setTitle:@"开始学习" forState:(UIControlStateNormal)];
    }else if ([models.learn_status integerValue]==1){//做了一部分但是没做完
//        [self.propressLab setTitle:[NSString stringWithFormat:@"学至 %@",models.last_node_title] forState:(UIControlStateNormal)];
        
        NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"学至 课时%@  %@",models.last_node_number,models.last_node_title]];
        [attributeStr addAttribute:NSForegroundColorAttributeName value:CNavBgColor range:NSMakeRange(2,attributeStr.length-2)];
        
        [self.propressLab setAttributedTitle:attributeStr forState:(UIControlStateNormal)];
        
        [self.propressLab setImage:nil forState:(UIControlStateNormal)];
        [self.startBtn setTitle:@"继续学习" forState:(UIControlStateNormal)];
//        self.averageLab.textColor = [UIColor colorWithRed:138/255.0 green:138/255.0 blue:138/255.0 alpha:1];
    }else if ([models.learn_status integerValue]==2){// 已经做完了
        [self.propressLab setTitle:@"  已做完全部试卷" forState:(UIControlStateNormal)];
        [self.startBtn setTitle:@"重新学习" forState:(UIControlStateNormal)];
//        self.averageLab.textColor = [UIColor colorWithRed:65/255.0 green:164/255.0 blue:95/255.0 alpha:1];
    }
    
    if ([UserDefaultsUtils boolValueWithKey:KIsAudit]){
        self.isFailureImage.hidden = YES;
    }else{
        if ([models.is_expired isEqualToString:@"1"]) {
            self.isFailureImage.hidden = NO;
        }else{
            self.isFailureImage.hidden = YES;
        }
        
    }

}

- (void)setLiveModel:(MyLearningListDataModel *)liveModel{
    self.liveTypeView.hidden = NO;
    self.liveTimeBtn.hidden = NO;
    self.startBtn.hidden = YES;
    self.timeLab.hidden = YES;
    [self.pic sd_setImageWithURL:[NSURL URLWithString:liveModel.img] placeholderImage:[UIImage imageNamed:@""]];
    self.titleLab.text = liveModel.title;
    self.averageLab.text = [NSString stringWithFormat:@"已学 %@/%@ 课时",liveModel.learned_lesson_num,liveModel.lesson_num];
   
    if ([liveModel.learn_status integerValue]==0) {//未作
        [self.propressLab setTitle:@"未开始学习" forState:(UIControlStateNormal)];
        [self.propressLab setImage:nil forState:(UIControlStateNormal)];
        [self.startBtn setTitle:@"开始学习" forState:(UIControlStateNormal)];
        
    }else if ([liveModel.learn_status integerValue]==1){//做了一部分但是没做完
      
        NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"学至 课时%@  %@",liveModel.last_node_number,liveModel.last_node_title]];
        [attributeStr addAttribute:NSForegroundColorAttributeName value:CNavBgColor range:NSMakeRange(2,attributeStr.length-2)];
        
        [self.propressLab setAttributedTitle:attributeStr forState:(UIControlStateNormal)];
        
        [self.propressLab setImage:nil forState:(UIControlStateNormal)];
     

        [self.startBtn setTitle:@"继续学习" forState:(UIControlStateNormal)];
//        self.averageLab.textColor = [UIColor colorWithRed:138/255.0 green:138/255.0 blue:138/255.0 alpha:1];
    }else if ([liveModel.learn_status integerValue]==2){// 已经做完了
        [self.propressLab setTitle:@"  已做完全部试卷" forState:(UIControlStateNormal)];
        [self.startBtn setTitle:@"重新学习" forState:(UIControlStateNormal)];
//        self.averageLab.textColor = [UIColor colorWithRed:65/255.0 green:164/255.0 blue:95/255.0 alpha:1];
    }
    if ([liveModel.live_status isEqualToString:@"1"]){
        self.liveTypePic.image = [UIImage imageNamed:@"直播列表-已开课"];
        self.liveTypeLab.text = @"已开课";
        [self.liveTimeBtn setImage:[UIImage imageNamed:@"时间icon"] forState:(UIControlStateNormal)];
        [self.liveTimeBtn setTitle:[NSString stringWithFormat:@"开课时间:%@",liveModel.live_time_text] forState:(UIControlStateNormal)];
        [self.liveTimeBtn setTitleColor:[UIColor colorWithHexString:@"#8A8A8A"] forState:(UIControlStateNormal)];
    }else if ([liveModel.live_status isEqualToString:@"2"]){
        [self.liveTimeBtn setTitle:[NSString stringWithFormat:@"直播时间:%@",liveModel.node_time_text] forState:(UIControlStateNormal)];
        [self.liveTimeBtn setTitleColor:CNavBgColor forState:(UIControlStateNormal)];
        [self.liveTimeBtn setImage:[UIImage imageNamed:@"听课记录直播时间红"] forState:(UIControlStateNormal)];
        self.liveTypePic.image = [UIImage imageNamed:@"直播列表-直播中"];
        self.liveTypeLab.text = @"直播中";
       
    }else if ([liveModel.live_status isEqualToString:@"3"]){
         [self.liveTimeBtn setImage:[UIImage imageNamed:@"时间icon"] forState:(UIControlStateNormal)];
        self.liveTypePic.image = [UIImage imageNamed:@"直播列表-回放"];
        self.liveTypeLab.text = @"回放";
        [self.liveTimeBtn setTitleColor:[UIColor colorWithHexString:@"#8A8A8A"] forState:(UIControlStateNormal)];
         [self.liveTimeBtn setTitle:[NSString stringWithFormat:@"开课时间:%@",liveModel.live_time_text] forState:(UIControlStateNormal)];
    }else if ([liveModel.live_status isEqualToString:@"0"]){
         [self.liveTimeBtn setImage:[UIImage imageNamed:@"时间icon"] forState:(UIControlStateNormal)];
         [self.liveTimeBtn setTitle:[NSString stringWithFormat:@"开课时间:%@",liveModel.live_time_text] forState:(UIControlStateNormal)];
        self.liveTypePic.image = [UIImage imageNamed:@"直播列表-未开课"];
        self.liveTypeLab.text = @"未开课";
        [self.liveTimeBtn setTitleColor:[UIColor colorWithHexString:@"#8A8A8A"] forState:(UIControlStateNormal)];
        
    }
    if ([UserDefaultsUtils boolValueWithKey:KIsAudit]){
        self.isFailureImage.hidden = YES;
    }else{
        if ([liveModel.is_expired isEqualToString:@"1"]) {
            self.isFailureImage.hidden = NO;
        }else{
            self.isFailureImage.hidden = YES;
        }
        
    }
    
    
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
