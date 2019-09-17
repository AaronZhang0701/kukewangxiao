//
//  ExamRanKingTableViewCell.m
//  KukeApp
//
//  Created by 库课 on 2019/8/9.
//  Copyright © 2019 KukeZangMing. All rights reserved.
//

#import "ExamRanKingTableViewCell.h"

@implementation ExamRanKingTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.pic.layer.cornerRadius = 22.5f;

    // Initialization code
}
- (void)configCellWithData:(id)data withType:(NSString *)type{
    [self.pic sd_setImageWithURL:[NSURL URLWithString:data[@"photo"]] placeholderImage:[UIImage imageNamed:@"个人中心未登录头像"]];
    self.Tel.text = data[@"mobile"];
    NSString *str;
    if ([type isEqualToString:@"2"]) {
        str= data[@"do_count"];
    }else{
        str = [NSString stringWithFormat:@"%@道",data[@"do_count"]];
    }
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:str attributes:@{NSFontAttributeName: [UIFont fontWithName:@"PingFang-SC-Medium" size: 18],NSForegroundColorAttributeName: [UIColor colorWithRed:230/255.0 green:33/255.0 blue:41/255.0 alpha:1.0]}];
    
    [string addAttributes:@{NSFontAttributeName: [UIFont fontWithName:@"PingFang-SC-Medium" size: 14]} range:NSMakeRange([str length]-1, 1)];
    
    self.number.attributedText = string;
    
    if ([data[@"ranking"] isEqualToString:@"1"]) {
        [self.ranking setTitle:@"" forState:(UIControlStateNormal)];
        [self.ranking setImage:[UIImage imageNamed:@"1图标"] forState:(UIControlStateNormal)];
    }else if ([data[@"ranking"] isEqualToString:@"2"]){
        [self.ranking setTitle:@"" forState:(UIControlStateNormal)];
        [self.ranking setImage:[UIImage imageNamed:@"2图标"] forState:(UIControlStateNormal)];
    }else if ([data[@"ranking"] isEqualToString:@"3"]){
        [self.ranking setTitle:@"" forState:(UIControlStateNormal)];
        [self.ranking setImage:[UIImage imageNamed:@"3图标"] forState:(UIControlStateNormal)];
    }else{
        [self.ranking setTitle:data[@"ranking"] forState:(UIControlStateNormal)];
        [self.ranking setImage:nil forState:(UIControlStateNormal)];
    }
    
    if ([data[@"is_inside"] isEqualToString:@"2"]) {
        [self.ranking setTitleColor:CNavBgColor forState:(UIControlStateNormal)];
        self.Tel.textColor = CNavBgColor;
        self.number.textColor = CNavBgColor;
        self.contentView.backgroundColor = [UIColor whiteColor];
    }else if([data[@"is_inside"] isEqualToString:@"1"]){
        [self.ranking setTitleColor:CTitleColor forState:(UIControlStateNormal)];
        self.Tel.textColor = CTitleColor;
        self.number.textColor = [UIColor blackColor];
        self.contentView.backgroundColor = [UIColor colorWithHexString:@"#FFF2F3"];
    }else{
        [self.ranking setTitleColor:CTitleColor forState:(UIControlStateNormal)];
        self.Tel.textColor = CTitleColor;
        self.number.textColor = [UIColor blackColor];
        self.contentView.backgroundColor = [UIColor whiteColor];
    }
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
