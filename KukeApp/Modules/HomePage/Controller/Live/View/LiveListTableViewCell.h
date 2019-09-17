//
//  LiveListTableViewCell.h
//  KukeApp
//
//  Created by 库课 on 2019/7/18.
//  Copyright © 2019 KukeZangMing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LiveListModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface LiveListTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *goodsPic;
@property (weak, nonatomic) IBOutlet UIImageView *LiveTypePic;
@property (weak, nonatomic) IBOutlet UILabel *liveTypeLab;
@property (weak, nonatomic) IBOutlet UILabel *goodsName;
@property (weak, nonatomic) IBOutlet UIImageView *goodsTimePic;
@property (weak, nonatomic) IBOutlet UILabel *goodsTimeLab;
@property (weak, nonatomic) IBOutlet UILabel *studentNum;
@property (weak, nonatomic) IBOutlet UILabel *goodsPriceLab;
@property (weak, nonatomic) IBOutlet UIButton *joinBtn;

@property (weak, nonatomic) IBOutlet UIView *liveTypeView;

@property (nonatomic,strong) LiveListDataModel *model;
@end

NS_ASSUME_NONNULL_END
