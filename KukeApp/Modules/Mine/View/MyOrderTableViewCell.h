//
//  MyOrderTableViewCell.h
//  KukeApp
//
//  Created by iOSDeveloper on 2018/10/22.
//  Copyright © 2018年 zhangming. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyOrderModel.h"
typedef void(^CancelActionBlock)(NSString *order_sn);
typedef void(^DeleteActionBlock)(NSString *order_sn);
typedef void(^ReceiptActionBlock)(NSString *order_sn);
typedef void(^ShareActionBlock)(NSString *url,NSString *goodsName);

@interface MyOrderTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *pic;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UILabel *payPrice;
@property (weak, nonatomic) IBOutlet UIButton *payAction;
@property (weak, nonatomic) IBOutlet UIButton *ohterBtn;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UIButton *orderStatus;
@property (weak, nonatomic) IBOutlet UILabel *endTime;
@property (nonatomic, strong) MyOrderDataModel *model;
@property (nonatomic, strong) MyOrderDataModel *data;
@property (nonatomic ,copy) CancelActionBlock cancelActionBlock;
@property (nonatomic ,copy) DeleteActionBlock deleteActionBlock;
@property (nonatomic ,copy) ReceiptActionBlock receiptActionBlock;
@property (nonatomic ,copy) ShareActionBlock shareBlock;
@property (weak, nonatomic) IBOutlet UIButton *shareBtn;
@property (weak, nonatomic) IBOutlet UIButton *groupStatusLab;

@property (weak, nonatomic) IBOutlet UIButton *afterSaleBtn;
@property (weak, nonatomic) IBOutlet UIButton *receipetBtn;
@property (weak, nonatomic) IBOutlet UIButton *evaluateBtn;
@property (weak, nonatomic) IBOutlet UIButton *seeDetialBtn;
- (void)setConfigWithSecond:(NSInteger)second;
@end
