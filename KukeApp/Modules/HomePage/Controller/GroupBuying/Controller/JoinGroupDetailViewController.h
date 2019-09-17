//
//  JoinGroupDetailViewController.h
//  KukeApp
//
//  Created by 库课 on 2019/1/11.
//  Copyright © 2019 zhangming. All rights reserved.
//

#import "ZMBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface JoinGroupDetailViewController : ZMBaseTableViewController

@property (nonatomic, strong) NSString *token;
@property (nonatomic, strong) NSString *group_buy_goods_rule_id;
@end

NS_ASSUME_NONNULL_END
