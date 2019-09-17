//
//  CourseTitleTableViewCell.h
//  KukeApp
//
//  Created by iOSDeveloper on 2018/10/11.
//  Copyright © 2018年 zhangming. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CourseDetailModel.h"
@interface CourseTitleTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLab;
@property (weak, nonatomic) IBOutlet UIButton *classHourLab;
@property (weak, nonatomic) IBOutlet UILabel *priceLab;
@property (weak, nonatomic) IBOutlet UIButton *groupPeopleNum;
@property (weak, nonatomic) IBOutlet UILabel *groupBuyNum;
@property (weak, nonatomic) IBOutlet UIButton *scrollBottomBtn;
@property (weak, nonatomic) IBOutlet UIButton *liveTime;
@property (nonatomic, strong) CourseDetailModel *model;
@property (nonatomic, strong) NSString *cateID;
@end
