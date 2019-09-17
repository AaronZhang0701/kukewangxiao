//
//  MenuDataTool.m
//  PingAnXiaoYuan-Parent
//
//  Created by zkr01 on 17/3/15.
//  Copyright © 2017年 张明. All rights reserved.
//

#import "MenuDataTool.h"

#define PERSON_PATH  [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject]stringByAppendingPathComponent:@"Menu.sqlite"]

@implementation MenuDataTool


static FMDatabase *_dbase;

+ (void)initialize
{
    // 1.打开数据库
    _dbase = [FMDatabase databaseWithPath:PERSON_PATH];
    NSLog(@"%@",PERSON_PATH);
    [_dbase open];
    // 2.创表
    [_dbase executeUpdate:@"CREATE TABLE IF NOT EXISTS t_menu (ID text, icon text, name text);"];
}
+ (void)addMenu:(HomePageCategoryModel *)menu
{
     FMDatabaseQueue *queue = [[FMDatabaseQueue alloc] initWithPath:PERSON_PATH];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [queue inDatabase:^(FMDatabase *db) {
            BOOL ret = [_dbase executeUpdateWithFormat:@"INSERT INTO t_menu(icon,name,ID) VALUES (%@, %@, %@);", menu.icon,menu.name,menu.ID];
            if(ret){
                NSLog(@"插入菜单数据成功");
            }else{
                NSLog(@"插入数据失败");
            }
        }];
    });
    
}
+ (NSArray *)getAllMenu
{// 得到结果集
    FMResultSet *set = [_dbase executeQuery:@"SELECT * FROM t_menu;"];
    
    // 不断往下取数据
    NSMutableArray *shops = [NSMutableArray array];
    while (set.next) {
        // 获得当前所指向的数据
        HomePageCategoryModel *menu = [[HomePageCategoryModel alloc]init];
        menu.icon = [set stringForColumn:@"icon"];
        menu.ID = [set stringForColumn:@"ID"];
        menu.name = [set stringForColumn:@"name"];
        [shops addObject:menu];
    }
    return shops;
}
//根据name查询数据
+ (HomePageCategoryModel *)searchMenuidWithMenuname:(NSString *)menuid
{
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM t_menu WHERE menuname='%@'",menuid];
    FMResultSet *set = [_dbase executeQuery:sql];
    
    HomePageCategoryModel *menu = [[HomePageCategoryModel alloc]init];
    while (set.next) {
        menu.name = [set stringForColumn:@"name"];
        menu.ID = [set stringForColumn:@"ID"];
        menu.icon = [set stringForColumn:@"icon"];
    }
    return menu;
    
}
+ (BOOL)deleteListData
{
    
    BOOL result = [_dbase executeUpdate:@"DELETE FROM t_menu"];
    return result;
}

@end
