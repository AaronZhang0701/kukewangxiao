//
//  MineListTableViewCell.m
//  KukeApp
//
//  Created by iOSDeveloper on 2018/10/2.
//  Copyright © 2018年 zhangming. All rights reserved.
//

#import "MineListTableViewCell.h"

@implementation MineListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)configWithDic:(NSDictionary *)dic{
    self.title.text = [dic valueForKey:@"title"];
    self.titleImage.image = [UIImage imageNamed:[dic valueForKey:@"image"]];

    self.titleImage.contentMode=UIViewContentModeScaleAspectFit;
    self.titleImage.clipsToBounds=YES;//  是否剪切掉超出 UIImageView 范围的图片
    [self.titleImage setContentScaleFactor:[[UIScreen mainScreen] scale]];

    
    self.numBer.text = dic[@"content"];
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
