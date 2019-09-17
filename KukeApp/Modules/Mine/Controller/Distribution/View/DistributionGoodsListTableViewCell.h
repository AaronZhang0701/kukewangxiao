//
//  DistributionGoodsListTableViewCell.h
//  KukeApp
//
//  Created by 库课 on 2019/3/22.
//  Copyright © 2019 KukeZangMing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DistributionSpreadGoodsListModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface DistributionGoodsListTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *goodsImage;
@property (weak, nonatomic) IBOutlet UILabel *goodsName;
@property (weak, nonatomic) IBOutlet UILabel *goodsPrice;
@property (weak, nonatomic) IBOutlet UILabel *goodsCommission;
@property (nonatomic, strong) DistributionSpreadGoodsListData *model;
@end

NS_ASSUME_NONNULL_END
