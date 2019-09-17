//
//  GroupBuyingListTableViewCell.m
//  KukeApp
//
//  Created by 库课 on 2019/1/11.
//  Copyright © 2019 zhangming. All rights reserved.
//

#import "GroupBuyingListTableViewCell.h"
#import "CourseDetailViewController.h"

@interface GroupBuyingListTableViewCell (){
    HomeGroupBuyingModel *data;
}

@end

@implementation GroupBuyingListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.goodsImage.layer.cornerRadius = 5;
    self.goodsImage.layer.masksToBounds = YES;
    self.joinGroupBtn.layer.cornerRadius = 3;
    self.joinGroupBtn.layer.masksToBounds = YES;
    
}
-(void)setModel:(HomeGroupBuyingModel *)model{
    data = model;
    
//    if ([model.goods_type isEqualToString:@"4"]) {
//        self.goodsImage.frame = CGRectMake((141-94/3*2)/2,14, 141/3*2,94);
//    }else{
        self.goodsImage.frame = CGRectMake(15, 14, 141, 94);
//    }
    [self.goodsImage sd_setImageWithURL:[NSURL URLWithString:model.goods_img] placeholderImage:[UIImage imageNamed:@"goodsImage"]];
    self.goodsTitle.text = model.goods_name;
    self.goodsPrice.text = model.group_buy_price;
    self.goodsDiscountPrice.text = model.goods_price;
    self.groupNum.text = [NSString stringWithFormat:@"已拼%@份",model.pre_num];
    [self.peopleNumBtn setTitle:[NSString stringWithFormat:@"%@人团",model.group_base_num] forState:(UIControlStateNormal)];
    
}
- (IBAction)joinGroupAction:(id)sender {
    CourseDetailViewController *vc = [[CourseDetailViewController alloc]init];
    vc.ac_type = @"3";
    vc.ID = data.goods_id;
    vc.titleIndex = data.goods_type;
    vc.coursePrice = data.group_buy_price;
    vc.courseTitle = data.goods_name;
    [[[AppDelegate shareAppDelegate] getCurrentUIVC].navigationController pushViewController:vc animated:YES];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
