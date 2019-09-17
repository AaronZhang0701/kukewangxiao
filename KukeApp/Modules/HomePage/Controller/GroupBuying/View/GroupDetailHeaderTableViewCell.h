//
//  GroupDetailHeaderTableViewCell.h
//  KukeApp
//
//  Created by 库课 on 2019/1/17.
//  Copyright © 2019 zhangming. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GroupDetailModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface GroupDetailHeaderTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *numBtn;
@property (weak, nonatomic) IBOutlet UILabel *goodsName;
@property (weak, nonatomic) IBOutlet UILabel *priceLab;
@property (weak, nonatomic) IBOutlet UILabel *discountPriceLab;
@property (weak, nonatomic) IBOutlet UIImageView *goodsImage;

@end

NS_ASSUME_NONNULL_END
