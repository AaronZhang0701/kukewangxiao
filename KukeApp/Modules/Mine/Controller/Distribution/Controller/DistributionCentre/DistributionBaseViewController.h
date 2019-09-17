//
//  DistributionBaseViewController.h
//  KukeApp
//
//  Created by 库课 on 2019/3/18.
//  Copyright © 2019 KukeZangMing. All rights reserved.
//

#import "ZMBaseViewController.h"
#define PageMenuH 50
#define NaviH 64
#define HeaderViewH 487

#define isIPhoneX screenHeight()==812
#define insert (isIPhoneX ? (84+PageMenuH) : 0)
NS_ASSUME_NONNULL_BEGIN

@interface DistributionBaseViewController : ZMBaseTableViewController
@property (nonatomic, strong) NSString *tab;
@property (nonatomic, assign) BOOL isEnable;
@end

NS_ASSUME_NONNULL_END
