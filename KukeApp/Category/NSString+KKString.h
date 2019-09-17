//
//  NSString+KKString.h
//  kuke
//
//  Created by iOSDeveloper on 2017/10/28.
//  Copyright © 2017年 iOSDeveloper. All rights reserved.
//

#import <Foundation/Foundation.h>
@class UIViewController;

@interface NSString (KKString)

/*!
 移除字符串中的HTML标签
 
 @return NSString 移除HTML标签后的字符串
 */
- (NSString *)stringByRemovingHTMLMark;

/**
 移除字符串中的HTML标签保留image标签

 @return NSString 移除HTML标签后的字符串
 */
- (NSString *)stringByRemovingHTMLMarkWithoutImage;

/*!
 生成一个由大写英文字母组成的随机字符串
 
 @param lenght 字符串长度
 
 @return NSString 生成的相应长度的字符串
 */
+ (NSString *)generatesRandomStringWithLength:(int)lenght;

/*!
 将JSON对象（NSArray、NSDictionary）转换为字符串
 
 @param JSONObject JSON对象（NSArray、NSDictionary）
 
 @return NSString 转换后的字符串
 */
+ (NSString *)stringByJSONObject:(id)JSONObject;

/*!
 * @brief 把格式化的JSON格式的字符串转换成字典
 * @param JSONString JSON格式的字符串
 * @return NSDictionary 返回字典
 */
+ (NSDictionary *)dictionaryByJSONString:(NSString *)JSONString;

/*!
 对字符串进行SHA1计算
 
 @return NSString 计算结果
 */
- (NSString *) sha1;

/*!
 对字符串进行MD5计算
 
 @return NSString 计算结果
 */
- (NSString *) md5;

/**
 手机号码判断
 
 @param mobileNum 手机号
 
 @return 是否为手机号
 */
+ (BOOL)isMobileNumber:(NSString *)mobileNum;

/**
 获取当前时间字符串
 
 @param dateFormat 时间格式
 @return 时间字符串
 */
+ (NSString *)stringDateWithDateFormat:(NSString *)dateFormat;

/**
 将时间戳字符串转换为时间字符串
 
 @param dateFormat 时间格式
 @return 时间字符串
 */
- (NSString *)dateStringForTimeStampWithDateFormat:(NSString *)dateFormat;

/**
 比较时间字符串是否在区间内
 
 @param dateFormat 时间格式
 @param stratDateString 区间开始时间
 @param endDateString 区间结束时间
 @return 是否在时间区间内
 */
- (BOOL)dateStringCompareWithForDateFormat:(NSString *)dateFormat stratDateString:(NSString *)stratDateString endDateString:(NSString *)endDateString;

/**
 对用户名进行加密处理防止泄漏个人信息

 @return 处理后的用户名
 */
- (NSString *)encryptionUserName;

/**
 根据url判断需要加载的控制器类
 
 @param complete 结果回调
 */
- (void)urlStringWithComplete:(void (^)(__kindof UIViewController *viewController))complete;

/**
 比较两个版本号的大小
 
 @param v1 第一个版本号
 @param v2 第二个版本号
 @return 版本号相等,返回0; v1小于v2,返回-1; 否则返回1.
 */
+ (NSInteger)compareVersion:(NSString *)v1 to:(NSString *)v2;

#pragma mark - html处理为图片文本字典
/**
 预处理
 
 @param string 处理的html文本
 @return 返回去掉多余标签的文本
 */
+ (NSString *)stringPretreatmentWithString:(NSString *)string;

/**
 返回成型的视图数组
 
 @param string 处理后的html文本
 @return 返回数组
 */
+ (NSArray *)arrayPretreatmentWithImgString:(NSString *)string;

@end
