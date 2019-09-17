//
//  RechargeRecordTableViewCell.h
//  KukeApp
//
//  Created by iOSDeveloper on 2018/10/29.
//  Copyright © 2018年 zhangming. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RechargeRecordModel.h"
@interface RechargeRecordTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *type;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *money;
@property (nonatomic, strong) MyRechargeRecordeDataListModel *model;
@end
