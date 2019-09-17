//
//  CourseIntroduceView.h
//  KukeApp
//
//  Created by iOSDeveloper on 2018/10/1.
//  Copyright © 2018年 zhangming. All rights reserved.
//

#import "CourseDetailListBaseView.h"
#import "CourseDetailModel.h"
typedef void(^CourseFristIdActionBlock)(NSString *ID);
@interface CourseIntroduceView : CourseDetailListBaseView
@property (nonatomic ,copy) CourseFristIdActionBlock myBlock;
- (void)dataAnalysis:(CourseDetailModel *)data;
- (void)getCourseType:(NSString *)goodsType withDistribute:(NSString *)isDistribute;
@end
