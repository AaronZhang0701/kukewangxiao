//
//  ExamProgoseCollectionCell.m
//  KukeApp
//
//  Created by 库课 on 2019/8/9.
//  Copyright © 2019 KukeZangMing. All rights reserved.
//

#import "ExamProgoseCollectionCell.h"

@implementation ExamProgoseCollectionCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self configureUI];
        
    }
    return self;
}
- (void)configData:(id)data{
    [self.imageV sd_setImageWithURL:[NSURL URLWithString:data[@"img"]] placeholderImage:[UIImage imageNamed:@"goodsImage"]];
    self.titleLabel.text = data[@"title"];
}
- (void)configureUI
{
    self.imageV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.width/3*2)];
    self.imageV.layer.cornerRadius = 5;
    self.imageV.layer.masksToBounds = YES;
    self.imageV.image = [UIImage imageNamed:@"1图标"];
    [self.contentView addSubview:self.imageV];
    
    
    self.titleLabel = [[UILabel alloc]init];
    self.titleLabel.frame = CGRectMake(10, maxY(self.imageV)+10,self.contentView.width-20 , 33);
    self.titleLabel.numberOfLines = 0;
    self.titleLabel.font = [UIFont systemFontOfSize:12];
    self.titleLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    [self.contentView addSubview:self.titleLabel];
    
    
//    self.imageV = [[UIImageView alloc]init];
//    self.imageV.layer.cornerRadius = 5;
//    self.imageV.layer.masksToBounds = YES;
//    [self.contentView addSubview:self.imageV];
//
//
//    self.titleLabel = [[UILabel alloc]init];
//    self.titleLabel.numberOfLines = 0;
//    self.titleLabel.font = [UIFont systemFontOfSize:12];
//    self.titleLabel.textColor = [UIColor colorWithHexString:@"#333333"];
//    [self.contentView addSubview:self.titleLabel];
//
//
//    [self.imageV mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.and.right.and.top.mas_equalTo(0);
//        make.height.mas_equalTo(self.imageV.mas_width).multipliedBy(2/3);
//
//    }];
//
//
//    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.and.left.and.right.mas_equalTo(10);
//        make.height.mas_equalTo(33);
//    }];
//
}
@end
