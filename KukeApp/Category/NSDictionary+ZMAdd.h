//
//  NSDictionary+ZMAdd.h
//  KukeApp
//
//  Created by iOSDeveloper on 2018/8/15.
//  Copyright © 2018年 zhangming. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef NS_ENUM(NSInteger, ZMDictionarySortType) {
    /** 升序 */
    ZMDictionarySortTypeAsc = 0,
    /** 降序 */
    ZMDictionarySortTypeDesc
};

@interface NSDictionary (ZMAdd)
/** 字典 转 json字符串（一整行输出，没有空格和换行符）*/
- (nullable NSString *)br_toJsonStringNoFormat;
/** 字典 转 json字符串 */
- (nullable NSString *)br_toJsonString;
/** 把字典拼成url字符串 */
- (nullable NSString *)br_toURLString;
/** 把排序后的字典拼成url字符串（根据key升序/降序排列） */
- (nullable NSString *)br_toURLStringWithSortedDictionary:(ZMDictionarySortType)type;
@end
