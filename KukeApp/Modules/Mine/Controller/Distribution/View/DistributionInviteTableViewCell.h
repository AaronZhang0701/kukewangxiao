//
//  DistributionInviteTableViewCell.h
//  KukeApp
//
//  Created by 库课 on 2019/3/20.
//  Copyright © 2019 KukeZangMing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DistributionInviteModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface DistributionInviteTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *accountLab;
@property (weak, nonatomic) IBOutlet UILabel *spreadMoney;
@property (weak, nonatomic) IBOutlet UILabel *commissionLab;
@property (nonatomic, strong) DistributionInviteData *model;

@end

NS_ASSUME_NONNULL_END
