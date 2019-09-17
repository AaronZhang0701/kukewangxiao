//
//  HomePageMessageTableViewCell.m
//  KukeApp
//
//  Created by 库课 on 2019/5/22.
//  Copyright © 2019 KukeZangMing. All rights reserved.
//

#import "HomePageMessageTableViewCell.h"

@implementation HomePageMessageTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setModel:(HomeNewsModel *)model{
    self.timeLab.text = model.add_time;
    self.titleLab.text = model.title;
    self.titleLab.textColor = CTitleColor;
    self.descripLab.text = model.label_name;
    [self.img sd_setImageWithURL:[NSURL URLWithString:model.picture] placeholderImage:[UIImage imageNamed:@"资讯图片"]];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
