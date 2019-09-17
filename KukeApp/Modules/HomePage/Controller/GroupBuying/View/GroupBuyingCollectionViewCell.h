//
//  GroupBuyingCollectionViewCell.h
//  KukeApp
//
//  Created by 库课 on 2019/1/9.
//  Copyright © 2019 zhangming. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomePageMenuModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface GroupBuyingCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIButton *peopleNumberBtn;
@property (weak, nonatomic) IBOutlet UIImageView *goodsImage;
@property (weak, nonatomic) IBOutlet UILabel *goodsTitle;
@property (weak, nonatomic) IBOutlet UILabel *goodsPrice;
@property (weak, nonatomic) IBOutlet UILabel *goodsDiscountPrice;
@property (weak, nonatomic) IBOutlet UILabel *groupNumber;
@property (nonatomic, strong) HomeGroupBuyingModel *model;
@end

NS_ASSUME_NONNULL_END
