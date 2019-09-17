//
//  MenuDataTool.h
//  PingAnXiaoYuan-Parent
//
//  Created by zkr01 on 17/3/15.
//  Copyright © 2017年 张明. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HomePageMenuModel.h"
@interface MenuDataTool : NSObject
+ (void)addMenu:(HomePageCategoryModel *)menu;
+ (NSArray *)getAllMenu;
//根据name查询数据
+ (HomePageCategoryModel *)searchMenuidWithMenuname:(NSString *)menuid;
+ (BOOL)deleteListData;
@end
