//
//  ReceiveAddressModel.m
//  KukeApp
//
//  Created by 库课 on 2019/2/13.
//  Copyright © 2019 KukeZangMing. All rights reserved.
//

#import "ReceiveAddressModel.h"
@implementation ReceiveAddressDataListModel

+ (JSONKeyMapper *)keyMapper{
    // 属性名作为key ,字典中的key名 作为 value
    return [[JSONKeyMapper alloc]initWithModelToJSONDictionary:@{@"ID":@"id"}];
}



@end
@implementation ReceiveAddressModel

@end
