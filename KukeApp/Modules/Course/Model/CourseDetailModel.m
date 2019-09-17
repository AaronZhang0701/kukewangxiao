//
//  CourseDetailModel.m
//  KukeApp
//
//  Created by iOSDeveloper on 2018/10/12.
//  Copyright © 2018年 zhangming. All rights reserved.
//

#import "CourseDetailModel.h"
@implementation CourseDetailGroupModel


@end

@implementation CourseDetailTeacherModel

@end
@implementation CourseDetailModel
+ (JSONKeyMapper *)keyMapper{
    // 属性名作为key ,字典中的key名 作为 value
    return [[JSONKeyMapper alloc]initWithModelToJSONDictionary:@{@"ID":@"id"}];
}
@end
@implementation CourseDetailSeckillModel

@end
@implementation CourseDetailGroupRecommendModel

@end
@implementation CourseDistributionModel

@end

