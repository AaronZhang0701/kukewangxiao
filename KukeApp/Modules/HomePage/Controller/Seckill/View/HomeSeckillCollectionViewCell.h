//
//  HomeSeckillCollectionViewCell.h
//  KukeApp
//
//  Created by 库课 on 2019/2/18.
//  Copyright © 2019 KukeZangMing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomePageMenuModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface HomeSeckillCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *goodsImage;
@property (weak, nonatomic) IBOutlet UILabel *goodsName;
@property (weak, nonatomic) IBOutlet UILabel *goodsPrice;
@property (weak, nonatomic) IBOutlet UILabel *goodsDisPrice;
@property (weak, nonatomic) IBOutlet UIProgressView *goodsProgress;
@property (weak, nonatomic) IBOutlet UILabel *seckillNumber;
@property (weak, nonatomic) IBOutlet UIImageView *goodsFinish;
@property (nonatomic, strong) HomePagePlaySeckillListModel *model;
@end

NS_ASSUME_NONNULL_END
