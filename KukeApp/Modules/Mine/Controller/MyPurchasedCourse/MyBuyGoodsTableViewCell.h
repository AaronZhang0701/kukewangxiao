//
//  MyBuyGoodsTableViewCell.h
//  KukeApp
//
//  Created by 库课 on 2019/8/2.
//  Copyright © 2019 KukeZangMing. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CourseListModel.h"
@interface MyBuyGoodsTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *pic;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UIImageView *isFailureImage;
@property (nonatomic, strong) CourseDataAryModel *model;
@property (weak, nonatomic) IBOutlet UIButton *livetime;
@property (weak, nonatomic) IBOutlet UILabel *liveTypeLab;
@property (weak, nonatomic) IBOutlet UIImageView *liveTypeImage;
@property (weak, nonatomic) IBOutlet UIView *liveTypeView;
@property (nonatomic, strong) NSString *cateID;
@end


