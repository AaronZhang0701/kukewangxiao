//
//  DistributionCentreHeaderView.h
//  KukeApp
//
//  Created by 库课 on 2019/3/14.
//  Copyright © 2019 KukeZangMing. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DistributionCentreHeaderView : UIView
@property (weak, nonatomic) IBOutlet UIImageView *headerImage;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *positionLab;
@property (weak, nonatomic) IBOutlet UIImageView *ranksImage;
@property (weak, nonatomic) IBOutlet UILabel *ranksLab;
@property (weak, nonatomic) IBOutlet UILabel *availableMoney;
@property (weak, nonatomic) IBOutlet UIButton *totalMoney;
@property (weak, nonatomic) IBOutlet UIButton *waitMoney;
@property (weak, nonatomic) IBOutlet UILabel *spreadLab;
@property (weak, nonatomic) IBOutlet UILabel *totalRequest;
@property (nonatomic, assign) BOOL isEnable;
@end

NS_ASSUME_NONNULL_END
