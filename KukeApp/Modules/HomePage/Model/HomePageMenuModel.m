//
//  HomePageMenuModel.m
//  KukeApp
//
//  Created by iOSDeveloper on 2018/10/8.
//  Copyright © 2018年 zhangming. All rights reserved.
//

#import "HomePageMenuModel.h"


@implementation HomePageAdModel

@end

@implementation HomePageCategoryModel
+ (JSONKeyMapper *)keyMapper{
    // 属性名作为key ,字典中的key名 作为 value
    return [[JSONKeyMapper alloc]initWithModelToJSONDictionary:@{@"ID":@"id"}];
}
@end

@implementation HomePageBannerModel

@end

@implementation HomePageDataModel

@end

@implementation HomePageMenuModel

@end
@implementation HomePagePlayModel

@end


@implementation HomeGroupBuyingModel

@end
@implementation HomePagePlaySeckillListModel

@end
@implementation HomeNewsModel

@end
@implementation HomeLiveModel

@end
@implementation HomePageLiveTeacherModel

@end


@implementation HomePagePlaySeckillModel

@end
