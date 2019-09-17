//
//  CourseCommentView.h
//  KukeApp
//
//  Created by iOSDeveloper on 2018/10/1.
//  Copyright © 2018年 zhangming. All rights reserved.
//

#import "CourseDetailListBaseView.h"
#import "CourseCommentModel.h"
#import "CourseCommentTableCell.h"
@interface CourseCommentView : CourseDetailListBaseView
- (void)getCourseID:(NSString *)ID withClass:(NSInteger)classID;
@end
