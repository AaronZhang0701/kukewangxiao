//
//  DistributionCommissionTableViewCell.h
//  KukeApp
//
//  Created by 库课 on 2019/3/18.
//  Copyright © 2019 KukeZangMing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DistributionBillModel.h"
#import "DistributionOrderModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface DistributionCommissionTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *orderType;
@property (weak, nonatomic) IBOutlet UILabel *orderState;
@property (weak, nonatomic) IBOutlet UIImageView *oederImage;
@property (weak, nonatomic) IBOutlet UILabel *orderMoney;
@property (weak, nonatomic) IBOutlet UILabel *orderTime;
@property (nonatomic, strong) DistributionBillData *model;
@property (nonatomic, strong) DistributionOrderData *data;
@end

NS_ASSUME_NONNULL_END
