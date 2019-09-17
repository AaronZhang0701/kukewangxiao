//
//  TeachersTableViewCell.h
//  
//
//  Created by iOSDeveloper on 2018/10/11.
//

#import <UIKit/UIKit.h>
#import "CourseDetailModel.h"
@interface TeachersTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headerImage;
@property (weak, nonatomic) IBOutlet UILabel *teacherName;
@property (weak, nonatomic) IBOutlet UILabel *teacherPosition;
@property (weak, nonatomic) IBOutlet UILabel *teacherDetail;
@property (nonatomic,strong) CourseDetailTeacherModel *model;
@end
