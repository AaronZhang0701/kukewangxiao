//
//  DistributionOrderTableViewCell.h
//  KukeApp
//
//  Created by 库课 on 2019/3/19.
//  Copyright © 2019 KukeZangMing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DistributionOrderModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface DistributionOrderTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *buyerNameLab;
@property (weak, nonatomic) IBOutlet UILabel *orderTypeLab;
@property (weak, nonatomic) IBOutlet UILabel *orderIdLab;
@property (weak, nonatomic) IBOutlet UILabel *orderTimeLab;
@property (weak, nonatomic) IBOutlet UIImageView *goodImage;
@property (weak, nonatomic) IBOutlet UILabel *goodsName;
@property (weak, nonatomic) IBOutlet UILabel *goodsPrice;
@property (weak, nonatomic) IBOutlet UILabel *goodsCount;
@property (weak, nonatomic) IBOutlet UILabel *commissionLab;
@property (weak, nonatomic) IBOutlet UILabel *payPriceLab;
@property (nonatomic, strong) DistributionOrderData *model;
@end

NS_ASSUME_NONNULL_END
