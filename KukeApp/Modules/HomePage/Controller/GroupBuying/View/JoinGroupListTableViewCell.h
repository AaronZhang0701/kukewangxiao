//
//  JoinGroupListTableViewCell.h
//  KukeApp
//
//  Created by 库课 on 2019/1/11.
//  Copyright © 2019 zhangming. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JoinGroupListModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface JoinGroupListTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *addTime;
@property (weak, nonatomic) IBOutlet UILabel *restTime;
@property (weak, nonatomic) IBOutlet UIImageView *student1;
@property (weak, nonatomic) IBOutlet UIImageView *student2;
@property (weak, nonatomic) IBOutlet UIImageView *student3;
@property (weak, nonatomic) IBOutlet UILabel *studentName1;
@property (weak, nonatomic) IBOutlet UILabel *studentName2;
@property (weak, nonatomic) IBOutlet UILabel *studentName3;
@property (weak, nonatomic) IBOutlet UILabel *restNumber;
@property (weak, nonatomic) IBOutlet UIButton *groupBtn;
@property (nonatomic, strong) JoinGroupListDataModel *model;
- (void)setConfigWithSecond:(NSInteger)second;
@property (weak, nonatomic) IBOutlet UILabel *pic;
@end

NS_ASSUME_NONNULL_END
