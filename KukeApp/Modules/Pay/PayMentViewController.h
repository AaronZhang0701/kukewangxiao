//
//  PayMentViewController.h
//  KukeApp
//
//  Created by iOSDeveloper on 2018/10/24.
//  Copyright © 2018年 zhangming. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PayMentViewController : ZMBaseViewController
@property (weak, nonatomic) IBOutlet UIImageView *pic;
@property (weak, nonatomic) IBOutlet UILabel *goodsName;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UILabel *orderPrice;
@property (weak, nonatomic) IBOutlet UILabel *discountPrice;
@property (weak, nonatomic) IBOutlet UIButton *payPrice;
@property (weak, nonatomic) IBOutlet UIButton *address;
@property (weak, nonatomic) IBOutlet UIView *bigView;
@property (weak, nonatomic) IBOutlet UIButton *payBtn;
@property (nonatomic, strong) NSString *order_sn;
@property (nonatomic, strong) NSString *goodID;
@property (nonatomic, strong) NSString *goodType;
@property (nonatomic, strong) NSString *isOrder;

@property (nonatomic, strong) NSString *group_buy_goods_rule_id;
@property (nonatomic, strong) NSString *token;
@property (nonatomic, strong) NSString *seckill_id;

@property (nonatomic, strong) NSString *dist_id;
@property (weak, nonatomic) IBOutlet UILabel *address_name;
@property (weak, nonatomic) IBOutlet UILabel *address_tel;
@property (weak, nonatomic) IBOutlet UILabel *address_ad;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UILabel *couponText;
@property (weak, nonatomic) IBOutlet UIButton *couponbtn;
@property (weak, nonatomic) IBOutlet UILabel *couponMoney;
@property (weak, nonatomic) IBOutlet UIImageView *couponArrow;
@property (weak, nonatomic) IBOutlet UIView *groupView;
@property (weak, nonatomic) IBOutlet UILabel *groupRestNum;
@property (weak, nonatomic) IBOutlet UIImageView *stuImage1;
@property (weak, nonatomic) IBOutlet UIImageView *stuImage2;
@property (weak, nonatomic) IBOutlet UIImageView *stuImage3;
@property (weak, nonatomic) IBOutlet UILabel *groupPic;
@property (weak, nonatomic) IBOutlet UILabel *sutName1;
@property (weak, nonatomic) IBOutlet UILabel *stuName2;
@property (weak, nonatomic) IBOutlet UILabel *stuName3;

@end
