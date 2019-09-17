//
//  GroupDetailTableViewCell.h
//  KukeApp
//
//  Created by 库课 on 2019/1/17.
//  Copyright © 2019 zhangming. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GroupDetailModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface GroupDetailTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *numLab;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UIImageView *stuImage1;
@property (weak, nonatomic) IBOutlet UIImageView *stuImage2;
@property (weak, nonatomic) IBOutlet UIImageView *stuImage3;
@property (weak, nonatomic) IBOutlet UILabel *stuName1;
@property (weak, nonatomic) IBOutlet UILabel *stuName2;
@property (weak, nonatomic) IBOutlet UILabel *stuName3;
@property (weak, nonatomic) IBOutlet UIButton *joinGroupBtn;
@property (weak, nonatomic) IBOutlet UILabel *pic;
@property (nonatomic, strong) GroupDetailDataModel *model;

@end

NS_ASSUME_NONNULL_END
