//
//  CurrentUserInfo.h
//  ParkingLot
//
//  Created by WSF on 2018/7/11.
//  Copyright © 2018年 ZKLJ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CurrentUserInfo : NSObject

//用户手机号
@property (nonatomic, copy) NSString *Tel;

//用户账号
@property (nonatomic, copy) NSString *Name;

//用户id
@property (nonatomic, copy) NSString *StudentID;

//用户token
@property (nonatomic, copy) NSString *token;

//用户名
@property (nonatomic, copy) NSString *NiName;
//用头像
@property (nonatomic, copy) NSString *photo;

@end
