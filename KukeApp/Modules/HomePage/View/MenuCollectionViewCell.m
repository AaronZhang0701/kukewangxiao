//
//  MenuCollectionViewCell.m
//  KukeApp
//
//  Created by iOSDeveloper on 2018/9/25.
//  Copyright © 2018年 zhangming. All rights reserved.
//

#import "MenuCollectionViewCell.h"

@implementation MenuCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)setModel:(HomePageCategoryModel *)model{
    [self.menuImage sd_setImageWithURL:[NSURL URLWithString:model.icon] placeholderImage:nil];
    self.menuTitle.text = model.name;
}
@end
