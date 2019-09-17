//
//  MyBuyGoodsTableViewCell.m
//  KukeApp
//
//  Created by 库课 on 2019/8/2.
//  Copyright © 2019 KukeZangMing. All rights reserved.
//

#import "MyBuyGoodsTableViewCell.h"

@interface MyBuyGoodsTableViewCell (){
    NSString *cate_id;
}

@end

@implementation MyBuyGoodsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.pic.layer.cornerRadius = 5;
    self.pic.layer.masksToBounds = YES;
    UIColor *color = [UIColor blackColor];
    self.isFailureImage.backgroundColor = [color colorWithAlphaComponent:0.5];
    self.isFailureImage.layer.masksToBounds = YES;
    self.isFailureImage.layer.cornerRadius = 5;
    self.liveTypeView.backgroundColor = [color colorWithAlphaComponent:0.6];
    [self.liveTypeView addRoundedCorners:(UIRectCornerBottomLeft | UIRectCornerBottomRight) withRadii:CGSizeMake(5.0, 5.0)];
    
}
- (void)setCateID:(NSString *)cateID{
    cate_id = cateID;
}
-(void)setModel:(CourseDataAryModel *)model{
    [self.pic sd_setImageWithURL:[NSURL URLWithString:model.img] placeholderImage:[UIImage imageNamed:@""]];
    self.titleLab.text = model.title;

    if ([UserDefaultsUtils boolValueWithKey:KIsAudit]){
        self.isFailureImage.hidden = YES;
    }else{
        if ([model.is_expired isEqualToString:@"1"]) {
            self.isFailureImage.hidden = NO;
        }else{
            self.isFailureImage.hidden = YES;
        }
        
    }
    if ([cate_id isEqualToString:@"1"]) {
        self.liveTypeView.hidden = NO;
        

        self.timeLab.text = [NSString stringWithFormat:@"共%@课时",model.node];
        self.livetime.hidden = NO;
        [self.livetime setTitleColor:[UIColor colorWithHexString:@"#8A8A8A"] forState:(UIControlStateNormal)];
        [self.livetime setTitle:[NSString stringWithFormat:@"开课时间:%@",model.live_time_text] forState:(UIControlStateNormal)];
        if ([model.live_status isEqualToString:@"0"]) {
            self.liveTypeImage.image = [UIImage imageNamed:@"直播列表-未开课"];
            self.liveTypeLab.text = @"未开课";
        }else if ([model.live_status isEqualToString:@"1"]){
            self.liveTypeImage.image = [UIImage imageNamed:@"直播列表-已开课"];
            self.liveTypeLab.text = @"已开课";
        }else if ([model.live_status isEqualToString:@"2"]){
            self.liveTypeImage.image = [UIImage imageNamed:@"直播列表-直播中"];
            self.liveTypeLab.text = @"直播中";
        }else if ([model.live_status isEqualToString:@"3"]){
            self.liveTypeImage.image = [UIImage imageNamed:@"直播列表-回放"];
            self.liveTypeLab.text = @"回放";
        }
        
        
    }else{
        self.liveTypeView.hidden = YES;

        self.livetime.hidden = YES;
        self.timeLab.hidden = NO;
        //        self.timeLab.text = [NSString stringWithFormat:@"共%@课时",model.node];
        if (model.node.length == 0) {
            self.timeLab.text  = [NSString stringWithFormat:@"共%@套试卷",model.testpaper_num];
        }else{
            self.timeLab.text  = [NSString stringWithFormat:@"共%@个课时",model.node];
        }
        
    }
    
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
