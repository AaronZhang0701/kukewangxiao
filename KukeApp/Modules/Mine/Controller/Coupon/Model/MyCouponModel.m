//
//  MyCouponModel.m
//  KukeApp
//
//  Created by iOSDeveloper on 2018/12/11.
//  Copyright © 2018年 zhangming. All rights reserved.
//

#import "MyCouponModel.h"
@implementation MyCouponDataModel

@end
@implementation MyCouponListModel
+ (JSONKeyMapper *)keyMapper{
    // 属性名作为key ,字典中的key名 作为 value
    return [[JSONKeyMapper alloc]initWithModelToJSONDictionary:@{@"coupon_id":@"id"}];
}
@end

@implementation MyCouponModel

@end

