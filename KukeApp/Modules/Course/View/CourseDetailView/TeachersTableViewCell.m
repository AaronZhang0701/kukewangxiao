//
//  TeachersTableViewCell.m
//  
//
//  Created by iOSDeveloper on 2018/10/11.
//

#import "TeachersTableViewCell.h"

@implementation TeachersTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.headerImage.layer.cornerRadius = 45;
    self.headerImage.layer.masksToBounds = YES;
    
}
-(void)setModel:(CourseDetailTeacherModel *)model{
    [self.headerImage sd_setImageWithURL:[NSURL URLWithString:model.photo] placeholderImage:[UIImage imageNamed:@"个人中心未登录头像"]];
    self.teacherName.text = model.teacher_name;
    self.teacherPosition.text = model.title;
    self.teacherDetail.text = model.intro;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
