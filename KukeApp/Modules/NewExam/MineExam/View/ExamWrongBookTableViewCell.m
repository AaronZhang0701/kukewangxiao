//
//  ExamWrongBookTableViewCell.m
//  KukeApp
//
//  Created by 库课 on 2019/8/9.
//  Copyright © 2019 KukeZangMing. All rights reserved.
//

#import "ExamWrongBookTableViewCell.h"
#import "ExamWebViewController.h"

@interface ExamWrongBookTableViewCell (){
    NSDictionary *model;
}

@end

@implementation ExamWrongBookTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.lookBtn.layer.cornerRadius = 3;
    self.lookBtn.layer.borderColor = [CTitleColor CGColor];
    self.lookBtn.layer.borderWidth = 0.5f;
    self.shuatiBtn.layer.cornerRadius = 3;
    self.shuatiBtn.layer.borderColor = [CTitleColor CGColor];
    self.shuatiBtn.layer.borderWidth = 0.5f;
    // Initialization code
}
- (void)configCellWithData:(id)data bookType:(NSString *)type{
    model = data;
    if ([type isEqualToString:@"1"]) {
        self.imageView.image = [UIImage imageNamed:@"错题本"];
    }else{
        self.imageView.image = [UIImage imageNamed:@"收藏本"];
    }
//    self.title.text = @"asdfasdfas";
    self.title.text = model[@"subject_name"];
    self.number.text = [NSString stringWithFormat:@"共计%@道题目",data[@"question_count"]];
}
- (IBAction)lookAction:(id)sender {
    ExamWebViewController *vc = [[ExamWebViewController alloc]init];
    vc.url =[NSString stringWithFormat:@"%@%@",SERVER_HOSTM,model[@"look_url"]];
    [[[AppDelegate shareAppDelegate] getCurrentUIVC].navigationController pushViewController:vc animated:YES];
}
- (IBAction)shuatiAction:(id)sender {
    ExamWebViewController *vc = [[ExamWebViewController alloc]init];
    vc.url =[NSString stringWithFormat:@"%@%@",SERVER_HOSTM,model[@"do_url"]];
    [[[AppDelegate shareAppDelegate] getCurrentUIVC].navigationController pushViewController:vc animated:YES];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
