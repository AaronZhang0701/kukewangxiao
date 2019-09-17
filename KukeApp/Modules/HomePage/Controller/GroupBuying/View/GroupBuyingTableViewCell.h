//
//  GroupBuyingTableViewCell.h
//  KukeApp
//
//  Created by 库课 on 2019/1/9.
//  Copyright © 2019 zhangming. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomePageMenuModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface GroupBuyingTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *groupBuyingListBtn;
@property (nonatomic, strong) NSMutableArray *ary;
@end

NS_ASSUME_NONNULL_END
