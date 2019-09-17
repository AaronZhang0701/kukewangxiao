//
//  SeckillListTableViewCell.h
//  KukeApp
//
//  Created by 库课 on 2019/2/22.
//  Copyright © 2019 KukeZangMing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SeckillListModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface SeckillListTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *goodsImage;
@property (weak, nonatomic) IBOutlet UILabel *goodsName;
@property (weak, nonatomic) IBOutlet UILabel *goodsSeckillPrice;
@property (weak, nonatomic) IBOutlet UILabel *goodsDisPrice;
@property (weak, nonatomic) IBOutlet UIProgressView *seckillProgress;
@property (weak, nonatomic) IBOutlet UILabel *goodsNumber;
@property (weak, nonatomic) IBOutlet UIButton *payBtn;
@property (weak, nonatomic) IBOutlet UIImageView *goodsFinish;
@property (nonatomic, strong) SeckillListDataModel *model;
@end

NS_ASSUME_NONNULL_END
