//
//  GroupBuyingListTableViewCell.h
//  KukeApp
//
//  Created by 库课 on 2019/1/11.
//  Copyright © 2019 zhangming. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomePageMenuModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface GroupBuyingListTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *peopleNumBtn;
@property (weak, nonatomic) IBOutlet UIImageView *goodsImage;
@property (weak, nonatomic) IBOutlet UILabel *goodsTitle;
@property (weak, nonatomic) IBOutlet UILabel *goodsPrice;
@property (weak, nonatomic) IBOutlet UILabel *goodsDiscountPrice;
@property (weak, nonatomic) IBOutlet UILabel *groupNum;
@property (weak, nonatomic) IBOutlet UIButton *joinGroupBtn;
@property (nonatomic, strong) HomeGroupBuyingModel *model;
@end

NS_ASSUME_NONNULL_END
