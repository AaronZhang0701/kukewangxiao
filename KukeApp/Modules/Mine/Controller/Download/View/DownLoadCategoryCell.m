//
//  DownLoadCategoryCell.m
//  KukeApp
//
//  Created by iOSDeveloper on 2018/12/7.
//  Copyright © 2018年 zhangming. All rights reserved.
//

#import "DownLoadCategoryCell.h"

@implementation DownLoadCategoryCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.pic.clipsToBounds = YES;
    self.pic.layer.cornerRadius = 5.0;
    UIColor *color = [UIColor blackColor];
    self.isLook.backgroundColor = [color colorWithAlphaComponent:0.5];
    self.isLook.layer.masksToBounds = YES;
    
}
- (void)upDataWithCategoryID:(NSString *)categoryID{
    
    DownLoadDataBaseModel *model = [DownLoadVideoDataBaseTool selectWithCategoryID:categoryID];
    
    
    self.courseCount.text = [NSString stringWithFormat:@"总课时:%@",model.videoCount];
    self.categoryName.text = model.categoryName;
    [self.pic sd_setImageWithURL:[NSURL URLWithString:model.videoImage] placeholderImage:[UIImage imageNamed:@"goodsImage"]];
    NSMutableArray *ary = [DownLoadVideoDataBaseTool selectVideoCountWithCategoryID:categoryID andVideoType:@"1"];
    self.downLoadCount.text  = [NSString stringWithFormat:@"已下载:%ld",ary.count];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
