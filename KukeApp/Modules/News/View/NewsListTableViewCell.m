//
//  NewsListTableViewCell.m
//  KukeApp
//
//  Created by iOSDeveloper on 2018/10/1.
//  Copyright © 2018年 zhangming. All rights reserved.
//

#import "NewsListTableViewCell.h"

@implementation NewsListTableViewCell


-(void)setModel:(CourseDataAryModel *)model{
    self.timeLab.text = [BaseTools getDateStringWithTimeStrDay:model.add_time];
    self.titleLab.text = model.title;
    self.descriptionLab.text = model.label_name;
    [_pic sd_setImageWithURL:[NSURL URLWithString:model.picture] placeholderImage:[UIImage imageNamed:@"资讯图片"]];
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
