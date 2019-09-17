//
//  NewsHeaderCollectionViewCell.m
//  KukeApp
//
//  Created by 库课 on 2019/5/13.
//  Copyright © 2019 KukeZangMing. All rights reserved.
//

#import "NewsHeaderCollectionViewCell.h"

@implementation NewsHeaderCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.titleLab.backgroundColor = [UIColor whiteColor];
    self.titleLab.layer.borderWidth = 0.5f;
    self.titleLab.layer.borderColor = [CTitleColor CGColor];
    self.titleLab.textColor = CTitleColor;
    self.titleLab.layer.cornerRadius = 11;
    self.titleLab.layer.masksToBounds = YES;
    // Initialization code
}
- (void)setSelected:(BOOL)selected{

    if (selected) {
        self.titleLab.backgroundColor = CNavBgColor;
        self.titleLab.layer.borderWidth = 0;
        self.titleLab.layer.cornerRadius = 11;
        self.titleLab.layer.masksToBounds = YES;
        //    cell.layer.borderColor = [CTitleColor CGColor];
        self.titleLab.textColor = [UIColor whiteColor];


    }else{
        self.titleLab.backgroundColor = [UIColor whiteColor];
        self.titleLab.layer.borderWidth = 0.5f;
        self.titleLab.layer.borderColor = [CTitleColor CGColor];
        self.titleLab.textColor = CTitleColor;
        self.titleLab.layer.cornerRadius = 11;
        self.titleLab.layer.masksToBounds = YES;

    }
    [super setSelected:selected];

}
@end
