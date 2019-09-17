//
//  CourseCommentTableCell.h
//  KukeApp
//
//  Created by iOSDeveloper on 2018/10/15.
//  Copyright © 2018年 zhangming. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CourseCommentModel.h"
@interface CourseCommentTableCell : UITableViewCell
@property (nonatomic, strong) UIImageView *headerImage;
@property (nonatomic, strong) UILabel *nameLab;
@property (nonatomic, strong) UILabel *timeLab;
@property (nonatomic, strong) UILabel *contentLab;
@property (nonatomic, strong) UILabel *replyNameLab;
@property (nonatomic, strong) UILabel *replyContentLab;
@property (nonatomic, strong) UILabel *replyTimeLab;
@property (nonatomic, strong) UIView *replyView;
@property (nonatomic, strong) CourseCommentListModel *model;
@end
