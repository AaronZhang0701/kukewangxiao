//
//  MyCourseListTableViewCell.h
//  KukeApp
//
//  Created by iOSDeveloper on 2018/10/18.
//  Copyright © 2018年 zhangming. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CourseListModel.h"
#import "MylearningRecordListModel.h"
#import "MineExamListModel.h"
@interface MyCourseListTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *pic;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UIButton *startBtn;
@property (weak, nonatomic) IBOutlet UILabel *averageLab;
@property (weak, nonatomic) IBOutlet UIButton *propressLab;
@property (nonatomic, strong) CourseDataAryModel *model;
@property (weak, nonatomic) IBOutlet UIImageView *isFailureImage;
@property (weak, nonatomic) IBOutlet UIView *liveTypeView;
@property (weak, nonatomic) IBOutlet UILabel *liveTypeLab;
@property (weak, nonatomic) IBOutlet UIImageView *liveTypePic;
@property (weak, nonatomic) IBOutlet UIButton *liveTimeBtn;
@property (nonatomic, strong) MyLearningListDataModel *models;

@property (nonatomic, strong) MyLearningListDataModel *liveModel;
@property (nonatomic, strong) NSString *cateID;

- (void)configCellData:(NewExamListData *)model;

@end
