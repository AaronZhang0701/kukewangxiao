//
//  UserInfoTool.h
//  ParkingLot
//
//  Created by WSF on 2018/7/11.
//  Copyright © 2018年 ZKLJ. All rights reserved.
//

#import <Foundation/Foundation.h>
@class CurrentUserInfo;
@interface UserInfoTool : NSObject
//清空表数据
+ (BOOL)deleteListData;

//获取所有数据
+ (NSArray *)persons;

//添加一条数据
+ (void)addPerson:(CurrentUserInfo *)person;

//根据UserId查询数据
+ (CurrentUserInfo *)selPersonWithUserId:(NSString *)userId;

//根据UserId更新数据
+ (void)updatePersonWithRecommendName:(NSString *)recommendName andCreateDate:(NSString *)createDate withPassportNum:(NSString *)passportNum withWalletListStr:(NSString *)walletListStr;

//更新用户名
+ (void)updatePersonWithUserId:(NSString *)userId withUserName:(NSString *)userName;

//更新头像
+ (void)updatePersonWithUserId:(NSString *)userId withUserIcon:(NSString *)usericon;

//更新性别
+ (void)updatePersonWithUserId:(NSString *)userId withUserSex:(NSString *)sex;

//更新年龄
+ (void)updatePersonWithUserId:(NSString *)userId withUserAge:(NSString *)age;

//根据userid删除一条特定的数据
+ (BOOL)deletePersonWithUserUserId:(NSString *)userID;

@end
