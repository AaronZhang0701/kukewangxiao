//
//  CourseListModel.m
//  KukeApp
//
//  Created by iOSDeveloper on 2018/9/30.
//  Copyright © 2018年 zhangming. All rights reserved.
//

#import "CourseListModel.h"
@implementation CourseDataAryModel

+ (JSONKeyMapper *)keyMapper{
    // 属性名作为key ,字典中的key名 作为 value
    return [[JSONKeyMapper alloc]initWithModelToJSONDictionary:@{@"ID":@"id"}];
}



@end
@implementation CourseListModel

@end
