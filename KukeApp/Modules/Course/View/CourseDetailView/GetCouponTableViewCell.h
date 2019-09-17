//
//  GetCouponTableViewCell.h
//  KukeApp
//
//  Created by iOSDeveloper on 2018/12/11.
//  Copyright © 2018年 zhangming. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GetCouponModel.h"
#import "MyCouponModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface GetCouponTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *bigView;
@property (weak, nonatomic) IBOutlet UILabel *moneyLab;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *conditionLab;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UILabel *getLab;
@property (weak, nonatomic) IBOutlet UIImageView *lineImage;

@property (nonatomic, strong) GetCouponListModel *model;

@property (nonatomic, strong) MyCouponListModel *useModel;
@end

NS_ASSUME_NONNULL_END
