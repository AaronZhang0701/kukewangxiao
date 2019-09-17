//
//  CourseCommentModel.m
//  KukeApp
//
//  Created by iOSDeveloper on 2018/10/14.
//  Copyright © 2018年 zhangming. All rights reserved.
//

#import "CourseCommentModel.h"
@implementation CourseCommentListModel
+ (JSONKeyMapper *)keyMapper{
    // 属性名作为key ,字典中的key名 作为 value
    return [[JSONKeyMapper alloc]initWithModelToJSONDictionary:@{@"ID":@"id"}];
}
@end
@implementation CourseCommentDataListModel

@end


@implementation CourseCommentModel

@end
