//
//  NSString+ZMAdd.h
//  KukeApp
//
//  Created by iOSDeveloper on 2018/8/15.
//  Copyright © 2018年 zhangming. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

//NS_ASSUME_NONNULL_BEGIN

@interface NSString (ZMAdd)

/** 判断是否是有效的(非空/非空白)字符串 */
- (BOOL)zm_isValidString;

/** 判断是否包含指定字符串 */
- (BOOL)zm_containsString:(NSString *_Nullable)string;

/* 修剪字符串（去掉头尾两边的空格和换行符）*/
- (NSString *_Nullable)zm_stringByTrim;

/** md5加密（32位小写） */
- (nullable NSString *)zm_md5String;

/** md5加密（16位小写） */
- (nullable NSString *)zm_md5String16;

/** sha1加密（小写） */
- (NSString *_Nullable)zm_sha1String;

/**
 *  返回一个新的UUID字符串（随机字符串，每次获取都不一样）
 *  如："3FE15217-D71E-4B4F-9919-B388A8D13914"
 */
+ (NSString *_Nullable)zm_UUID;

/** 转UTF8字符串（UTF-8编码）*/
- (NSString *_Nullable)zm_utf8String;

/**
 *  获取文本的大小
 *
 *  @param  font           文本字体
 *  @param  maxSize        文本区域的最大范围大小
 *  @param  lineBreakMode  字符截断类型
 *
 *  @return 文本大小
 */
- (CGSize)zm_getTextSize:(UIFont *_Nullable)font maxSize:(CGSize)maxSize mode:(NSLineBreakMode)lineBreakMode;

/**
 *  获取文本的宽度
 *
 *  @param  font    文本字体
 *  @param  height  文本高度
 *
 *  @return 文本宽度
 */
- (CGFloat)zm_getTextWidth:(UIFont *_Nullable)font height:(CGFloat)height;

/**
 *  获取文本的高度
 *
 *  @param  font   文本字体
 *  @param  width  文本宽度
 *
 *  @return 文本高度
 */
- (CGFloat)zm_getTextHeight:(UIFont *_Nullable)font width:(CGFloat)width;

/** label富文本: 插入图片 */
- (NSMutableAttributedString *_Nullable)zm_setRichTextWithImage:(NSString *_Nullable)iconName bounds:(CGRect)bounds iconLocation:(NSInteger)location;

/** label富文本: 设置不同字体和颜色 */
- (NSMutableAttributedString *_Nullable)zm_setChangeText:(NSString *_Nullable)changeText changeFont:(nullable UIFont *)font changeTextColor:(nullable UIColor *)color;

/** label富文本: HTML标签文本 */
- (NSMutableAttributedString *_Nullable)zm_setTextHTMLString;

/** label富文本: 添加中划线 */
- (NSMutableAttributedString *_Nullable)zm_setTextLineThrough;

/** 设置文本关键词红色显示 */
// <em>苹果</em><em>科技</em>股份有限公司
- (NSAttributedString *)zm_setTextKeywords:(UIColor *_Nullable)keywordColor;

///==================================================
///             正则表达式
///==================================================
/** 判断是否是有效的手机号 */
- (BOOL)zm_isValidPhoneNumber;

/** 判断是否是有效的用户密码 */
- (BOOL)zm_isValidPassword;

/** 判断是否是有效的用户名（20位的中文或英文）*/
- (BOOL)zm_isValidUserName;

/** 判断是否是有效的邮箱 */
- (BOOL)zm_isValidEmail;

/** 判断是否是有效的URL */
- (BOOL)isValidUrl;

/** 判断是否是有效的银行卡号 */
- (BOOL)zm_isValidBankNumber;

/** 判断是否是有效的身份证号 */
- (BOOL)zm_isValidIDCardNumber;

/** 判断是否是有效的IP地址 */
- (BOOL)zm_isValidIPAddress;

/** 判断是否是纯汉字 */
- (BOOL)zm_isValidChinese;

/** 判断是否是邮政编码 */
- (BOOL)zm_isValidPostalcode;

/** 判断是否是工商税号 */
- (BOOL)zm_isValidTaxNo;

/** 判断是否是车牌号 */
- (BOOL)zm_isCarNumber;

/** 通过身份证获取性别（1:男, 2:女） */
- (nullable NSNumber *)zm_getGenderFromIDCard;

/** 隐藏证件号指定位数字（如：360723********6341） */
- (nullable NSString *)zm_hideCharacters:(NSUInteger)location length:(NSUInteger)length;

@end


