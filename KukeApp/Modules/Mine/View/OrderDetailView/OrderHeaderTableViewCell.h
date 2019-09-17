//
//  OrderHeaderTableViewCell.h
//  KukeApp
//
//  Created by 库课 on 2019/1/3.
//  Copyright © 2019 zhangming. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyOrderModel.h"
NS_ASSUME_NONNULL_BEGIN
typedef void(^ShareActionBlock)(NSString *url,NSString *goodsName);
@interface OrderHeaderTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *statusLab;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (weak, nonatomic) IBOutlet UIButton *payBtn;
@property (weak, nonatomic) IBOutlet UIButton *ReceivingBtn;
@property (weak, nonatomic) IBOutlet UIButton *evaluationBtn;
@property (weak, nonatomic) IBOutlet UIButton *afterSaleBtn;
@property (weak, nonatomic) IBOutlet UIButton *afterSale_right;
@property (weak, nonatomic) IBOutlet UIButton *shareBtn;
@property (nonatomic, strong) NSDictionary *model;
@property (nonatomic, strong) NSDictionary *data;
@property (nonatomic ,copy) ShareActionBlock shareBlock;
@end

NS_ASSUME_NONNULL_END
