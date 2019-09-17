//
//  OrderDetailTableViewCell.h
//  KukeApp
//
//  Created by 库课 on 2019/1/3.
//  Copyright © 2019 zhangming. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^SeeDetailActionBlock)();
NS_ASSUME_NONNULL_BEGIN

@interface OrderDetailTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *pic;
@property (weak, nonatomic) IBOutlet UILabel *goods_nameLab;
@property (weak, nonatomic) IBOutlet UILabel *moneyLab;
@property (weak, nonatomic) IBOutlet UILabel *goodsMoney;
@property (weak, nonatomic) IBOutlet UILabel *distributionFeeLab;
@property (weak, nonatomic) IBOutlet UILabel *actualCostLab;
@property (weak, nonatomic) IBOutlet UILabel *totalMoney;
@property (nonatomic ,copy) SeeDetailActionBlock seeBlock;
@end

NS_ASSUME_NONNULL_END
