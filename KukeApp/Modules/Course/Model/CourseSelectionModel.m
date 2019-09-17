//
//  CourseSelectionModel.m
//  KukeApp
//
//  Created by iOSDeveloper on 2018/9/30.
//  Copyright © 2018年 zhangming. All rights reserved.
//

#import "CourseSelectionModel.h"

@implementation CourseSubjectModel
+ (JSONKeyMapper *)keyMapper{
    // 属性名作为key ,字典中的key名 作为 value
    return [[JSONKeyMapper alloc]initWithModelToJSONDictionary:@{@"ID":@"id"}];
}
@end


@implementation CourseCateSonModel
+ (JSONKeyMapper *)keyMapper{
    // 属性名作为key ,字典中的key名 作为 value
    return [[JSONKeyMapper alloc]initWithModelToJSONDictionary:@{@"ID":@"id"}];
}
@end



@implementation CourseTopCategoryModel
+ (JSONKeyMapper *)keyMapper{
    // 属性名作为key ,字典中的key名 作为 value
    return [[JSONKeyMapper alloc]initWithModelToJSONDictionary:@{@"ID":@"id"}];
}
@end



@implementation CourseSelectionModel
@end
