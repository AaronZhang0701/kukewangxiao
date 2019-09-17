
//
//  GetCouponModel.m
//  KukeApp
//
//  Created by iOSDeveloper on 2018/12/12.
//  Copyright © 2018年 zhangming. All rights reserved.
//

#import "GetCouponModel.h"

@implementation GetCouponListModel
+ (JSONKeyMapper *)keyMapper{
    // 属性名作为key ,字典中的key名 作为 value
    return [[JSONKeyMapper alloc]initWithModelToJSONDictionary:@{@"coupon_id":@"id"}];
}
@end

@implementation GetCouponModel

@end
