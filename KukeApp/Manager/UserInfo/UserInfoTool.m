//
//  UserInfoTool.m
//  ParkingLot
//
//  Created by WSF on 2018/7/11.
//  Copyright © 2018年 ZKLJ. All rights reserved.
//

#import "UserInfoTool.h"
//#import <FMDB.h>
#import "CurrentUserInfo.h"

#define PERSON_PATH  [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject]stringByAppendingPathComponent:@"currentUser.sqlite"]

@implementation UserInfoTool

static FMDatabaseQueue *_userQueue;
//static FMDatabase *_dbase;

+ (void)initialize
{
    // 1.打开数据库
    //    _dbase = [FMDatabase databaseWithPath:PERSON_PATH];
    _userQueue = [FMDatabaseQueue databaseQueueWithPath:PERSON_PATH];
    //    [_dbase open];
    [_userQueue inDatabase:^(FMDatabase *db) {
        // 2.创表
        BOOL ret = [db executeUpdate:@"CREATE TABLE IF NOT EXISTS t_currentUser (Tel text, Name text, token text, NiName text, StudentID text,Photo text);"];
        if (ret) {
            NSLog(@"Person创建表成功");
        }else{
            NSLog(@"Person创建表失败");
        }
    }];
    
    
}


//添加一条数据
+ (void)addPerson:(CurrentUserInfo *)person
{
    [_userQueue inDatabase:^(FMDatabase *db) {
        BOOL ret = [db executeUpdateWithFormat:@"INSERT INTO t_currentUser(Tel,Name,token,NiName,StudentID,Photo) VALUES (%@,%@,%@,%@,%@,%@);",person.Tel, person.Name, person.token, person.NiName, person.StudentID,person.photo];
        if(ret){
            NSLog(@"插入数据成功");
        }else{
            NSLog(@"插入数据失败");
        }
    }];
}

//获取所有数据
+ (NSArray *)persons
{
    NSMutableArray *allPerson = [NSMutableArray array];
    [_userQueue inDatabase:^(FMDatabase *db) {
        // 得到结果集
        FMResultSet *set = [db executeQuery:@"SELECT * FROM t_currentUser;"];
        // 不断往下取数据
        while (set.next) {
            // 获得当前所指向的数据
            CurrentUserInfo *curPerson = [[CurrentUserInfo alloc]init];
            curPerson.Tel = [set stringForColumn:@"Tel"];
            curPerson.token = [set stringForColumn:@"token"];
            curPerson.Name = [set stringForColumn:@"Name"];
            curPerson.NiName = [set stringForColumn:@"NiName"];
            curPerson.StudentID = [set stringForColumn:@"StudentID"];
            curPerson.photo= [set stringForColumn:@"photo"];

            [allPerson addObject:curPerson];
        }
    }];
    return allPerson;
}

//根据UserId查询数据
+ (CurrentUserInfo *)selPersonWithUserId:(NSString *)userId
{
    CurrentUserInfo *curPerson = [[CurrentUserInfo alloc]init];
    [_userQueue inDatabase:^(FMDatabase *db) {
        NSString *sql = [NSString stringWithFormat:@"SELECT * FROM t_currentUser WHERE userid='%@'",userId];
        FMResultSet *set = [db executeQuery:sql];
        
        while (set.next) {
            CurrentUserInfo *curPerson = [[CurrentUserInfo alloc]init];
            curPerson.Tel = [set stringForColumn:@"Tel"];
            curPerson.token = [set stringForColumn:@"token"];
            curPerson.Name = [set stringForColumn:@"Name"];
            curPerson.NiName = [set stringForColumn:@"NiName"];
            curPerson.StudentID = [set stringForColumn:@"StudentID"];
            curPerson.photo= [set stringForColumn:@"photo"];
        }
        
    }];
    return curPerson;
}

//根据UserId更新数据
+ (void)updatePersonWithRecommendName:(NSString *)recommendName andCreateDate:(NSString *)createDate withPassportNum:(NSString *)passportNum withWalletListStr:(NSString *)walletListStr
{
//    [_userQueue inDatabase:^(FMDatabase *db) {
//
//        NSString *sql = [NSString stringWithFormat:@"UPDATE t_currentUser SET RecommendName='%@' WHERE Tel='%@'",usericon,userId];
//        NSString *sql2 = [NSString stringWithFormat:@"UPDATE t_currentUser SET username='%@' WHERE userid='%@'",userName,userId];
//        NSString *sql3 = [NSString stringWithFormat:@"UPDATE t_currentUser SET age='%@' WHERE userid='%@'",age,userId];
//        NSString *sql4 = [NSString stringWithFormat:@"UPDATE t_currentUser SET sex='%@' WHERE userid='%@'",sex,userId];
//        NSString *sql5 = [NSString stringWithFormat:@"UPDATE t_currentUser SET state='%@' WHERE userid='%@'",state,userId];
//        NSString *sql6 = [NSString stringWithFormat:@"UPDATE t_currentUser SET ctime='%@' WHERE userid='%@'",cTime,userId];
//        BOOL res = [db executeUpdate:sql]&&[db executeUpdate:sql2]&&[db executeUpdate:sql3]&&[db executeUpdate:sql4]&&[db executeUpdate:sql5]&&[db executeUpdate:sql6];
//
//        if (!res) {
//            NSLog(@"更新错误");
//        }else{
//            NSLog(@"更新数据成功");
//        }
//
//    }];
}

//更新用户名
+ (void)updatePersonWithUserId:(NSString *)userId withUserName:(NSString *)userName
{
    [_userQueue inDatabase:^(FMDatabase *db) {
        
        NSString *sql = [NSString stringWithFormat:@"UPDATE t_currentUser SET username='%@' WHERE userid='%@'",userName,userId];
        BOOL res = [db executeUpdate:sql];
        
        if (!res) {
            NSLog(@"更新错误");
        }else{
            NSLog(@"更新数据成功");
        }
        
    }];
}

//更新头像
+ (void)updatePersonWithUserId:(NSString *)userId withUserIcon:(NSString *)usericon
{
    [_userQueue inDatabase:^(FMDatabase *db) {
        
        NSString *sql = [NSString stringWithFormat:@"UPDATE t_currentUser SET usericon='%@' WHERE StudentID='%@'",usericon,userId];
        BOOL res = [db executeUpdate:sql];
        
        if (!res) {
            NSLog(@"更新错误");
        }else{
            NSLog(@"更新数据成功");
        }
        
    }];
}

//更新性别
+ (void)updatePersonWithUserId:(NSString *)userId withUserSex:(NSString *)sex
{
    [_userQueue inDatabase:^(FMDatabase *db) {
        
        NSString *sql = [NSString stringWithFormat:@"UPDATE t_currentUser SET sex='%@' WHERE userid='%@'",sex,userId];
        BOOL res = [db executeUpdate:sql];
        
        if (!res) {
            NSLog(@"更新错误");
        }else{
            NSLog(@"更新数据成功");
        }
        
    }];
}

//更新年龄
+ (void)updatePersonWithUserId:(NSString *)userId withUserAge:(NSString *)age
{
    [_userQueue inDatabase:^(FMDatabase *db) {
        
        NSString *sql = [NSString stringWithFormat:@"UPDATE t_currentUser SET age='%@' WHERE userid='%@'",age,userId];
        BOOL res = [db executeUpdate:sql];
        
        if (!res) {
            NSLog(@"更新错误");
        }else{
            NSLog(@"更新数据成功");
        }
        
    }];
}

//根据userID删除一条特定的数据
+ (BOOL)deletePersonWithUserUserId:(NSString *)userID
{
    __block BOOL ret;
    [_userQueue inDatabase:^(FMDatabase *db) {
        NSString *sql = [NSString stringWithFormat:@"Delete FROM t_currentUser WHERE userid='%@'",userID];
        ret = [db executeUpdate:sql];
    }];
    
    return ret;
}


//清空表数据
+ (BOOL)deleteListData
{
    __block BOOL result;
    [_userQueue inDatabase:^(FMDatabase *db) {
        result = [db executeUpdate:@"DELETE FROM t_currentUser"];
    }];
    return result;
}

@end
