//
//  GroupDetailTableViewCell.m
//  KukeApp
//
//  Created by 库课 on 2019/1/17.
//  Copyright © 2019 zhangming. All rights reserved.
//

#import "GroupDetailTableViewCell.h"
#import "CourseDetailViewController.h"
#import "PayMentViewController.h"
@interface GroupDetailTableViewCell (){
    GroupDetailDataModel *data;
}

@end

@implementation GroupDetailTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.joinGroupBtn.layer.cornerRadius = 5;
    self.joinGroupBtn.layer.masksToBounds = YES;
    
    self.stuImage1.layer.masksToBounds = 25;
    self.stuImage1.layer.masksToBounds = YES;
    
    self.stuImage2.layer.masksToBounds = 25;
    self.stuImage2.layer.masksToBounds = YES;
    
    self.stuImage3.layer.masksToBounds = 25;
    self.stuImage3.layer.masksToBounds = YES;
    
    self.pic.layer.cornerRadius = 7;
    self.pic.layer.masksToBounds = YES;
    
    // Initialization code
}
- (void)setModel:(GroupDetailDataModel *)model{
    data = model;
}
- (IBAction)joinGroupAction:(id)sender {
    
    if ([[UserDefaultsUtils valueWithKey:@"access_token"] length] !=0 ) {
        if ([data.goods.is_include isEqualToString:@"1"]) {
            [BaseTools showErrorMessage:@"你已经参与过该团了"];
        }else{
            PayMentViewController *vc = [[PayMentViewController alloc]init];
            vc.goodID = data.goods.goods_id;
            vc.goodType = data.goods.goods_type;
            vc.group_buy_goods_rule_id = data.goods.group_buy_goods_rule_id;
            vc.token = [data.stu[0] token];
            [[[AppDelegate shareAppDelegate] getCurrentUIVC].navigationController pushViewController:vc animated:YES];
        }
    }else{
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [BaseTools alertLoginWithVC:[[AppDelegate shareAppDelegate] getCurrentUIVC]];
        });
    }
    
}
- (IBAction)openGroupAction:(id)sender {
    
    CourseDetailViewController *vc = [[CourseDetailViewController alloc]init];
    vc.ID = data.goods.goods_id;

    vc.titleIndex = data.goods.goods_type;
    vc.coursePrice = data.goods.group_buy_price;
    vc.courseTitle = data.goods.goods_name;
    vc.ac_type = @"3";
    [[[AppDelegate shareAppDelegate] getCurrentUIVC].navigationController pushViewController:vc animated:YES];
}
- (IBAction)groupRuleAction:(id)sender {
    KefuViewController *vc = [[KefuViewController alloc]init];
    vc.url = @"http://m.kukewang.com/group_rule";
    vc.title = @"库拼团玩法";
    [[[AppDelegate shareAppDelegate] getCurrentUIVC].navigationController pushViewController:vc animated:YES];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
