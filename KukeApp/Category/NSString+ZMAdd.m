//
//  NSString+ZMAdd.m
//  KukeApp
//
//  Created by iOSDeveloper on 2018/8/15.
//  Copyright © 2018年 zhangming. All rights reserved.
//

#import "NSString+ZMAdd.h"
#include <CommonCrypto/CommonCrypto.h>


@implementation NSString (ZMAdd)

#pragma mark - 判断是否是有效的(非空/非空白)字符串
// @"(null)", @"null", nil, @"", @"  ", @"\n" will Returns NO; otherwise Returns YES.
- (BOOL)zm_isValidString {
    // 1. 判断是否是 非空字符串
    if (self == nil ||
        [self isEqual:[NSNull null]] ||
        [self isEqual:@"(null)"] ||
        [self isEqual:@"null"]) {
        return NO;
    }
    // 2. 判断是否是 非空白字符串
    if ([[self zm_stringByTrim] length] == 0) {
        return NO;
    }
    return YES;
}

#pragma mark - 判断是否包含指定字符串
- (BOOL)zm_containsString:(NSString *)string {
    if (string == nil) return NO;
    return [self rangeOfString:string].location != NSNotFound;
}

#pragma mark - 修剪字符串（去掉头尾两边的空格和换行符）
- (NSString *)zm_stringByTrim {
    NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    return [self stringByTrimmingCharactersInSet:set];
}

#pragma mark - md5加密（32位小写）
- (NSString *)zm_md5String {
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    unsigned char result[CC_MD5_BLOCK_BYTES];
    CC_MD5(data.bytes, (CC_LONG)data.length, result);
    NSString *md5Str = [NSString stringWithFormat:
                        @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
                        result[0], result[1], result[2], result[3],
                        result[4], result[5], result[6], result[7],
                        result[8], result[9], result[10], result[11],
                        result[12], result[13], result[14], result[15]
                        ];
    return [md5Str lowercaseString];
}

#pragma mark - md5加密（16位小写）
- (NSString *)zm_md5String16 {
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(data.bytes, (CC_LONG)data.length, result);
    NSString *md5Str = [NSString stringWithFormat:
                        @"%02x%02x%02x%02x%02x%02x%02x%02x",
                        result[4], result[5], result[6], result[7],
                        result[8], result[9], result[10], result[11]
                        ];
    return [md5Str lowercaseString];
}

#pragma mark - sha1加密（小写）
- (NSString *)zm_sha1String {
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    unsigned char result[CC_SHA1_DIGEST_LENGTH];
    CC_SHA1(data.bytes, (CC_LONG)data.length, result);
    NSMutableString *sha1Str = [NSMutableString
                                stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    for (int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++) {
        [sha1Str appendFormat:@"%02x", result[i]];
    }
    return sha1Str;
}

#pragma mark - 返回一个新的UUID字符串
+ (NSString *)zm_UUID {
    CFUUIDRef uuid = CFUUIDCreate(NULL);
    CFStringRef string = CFUUIDCreateString(NULL, uuid);
    CFRelease(uuid);
    return (__bridge_transfer NSString *)string;
}

#pragma mark - 转UTF8字符串（UTF-8编码）
- (NSString *)zm_utf8String {
    /**
     AFNetworking/AFURLRequestSerialization.m
     
     Returns a percent-escaped string following RFC 3986 for a query string key or value.
     RFC 3986 states that the following characters are "reserved" characters.
     - 一般的分隔符: ":", "#", "[", "]", "@", "?", "/"
     - 子分隔符: "!", "$", "&", "'", "(", ")", "*", "+", ",", ";", "="
     In RFC 3986 - Section 3.4, it states that the "?" and "/" characters should not be escaped to allow
     query strings to include a URL. Therefore, all "reserved" characters with the exception of "?" and "/"
     should be percent-escaped in the query string.
     - parameter string: The string to be percent-escaped.
     - returns: The percent-escaped string.
     */
    static NSString * const kAFCharactersGeneralDelimitersToEncode = @":#[]@"; // does not include "?" or "/" due to RFC 3986 - Section 3.4
    static NSString * const kAFCharactersSubDelimitersToEncode = @"!$&'()*+,;=";
    
    NSMutableCharacterSet * allowedCharacterSet = [[NSCharacterSet URLQueryAllowedCharacterSet] mutableCopy];
    [allowedCharacterSet removeCharactersInString:[kAFCharactersGeneralDelimitersToEncode stringByAppendingString:kAFCharactersSubDelimitersToEncode]];
    static NSUInteger const batchSize = 50;
    
    NSUInteger index = 0;
    NSMutableString *escaped = @"".mutableCopy;
    
    while (index < self.length) {
        NSUInteger length = MIN(self.length - index, batchSize);
        NSRange range = NSMakeRange(index, length);
        // To avoid breaking up character sequences such as 👴🏻👮🏽
        range = [self rangeOfComposedCharacterSequencesForRange:range];
        NSString *substring = [self substringWithRange:range];
        NSString *encoded = [substring stringByAddingPercentEncodingWithAllowedCharacters:allowedCharacterSet];
        [escaped appendString:encoded];
        
        index += range.length;
    }
    return escaped;
    
    //return [self stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
}

#pragma mark - 获取文本的大小
- (CGSize)zm_getTextSize:(UIFont *)font maxSize:(CGSize)maxSize mode:(NSLineBreakMode)lineBreakMode {
    NSMutableDictionary *attributes = [[NSMutableDictionary alloc]init];
    attributes[NSFontAttributeName] = font;
    if (lineBreakMode != NSLineBreakByWordWrapping) {
        NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
        paragraphStyle.lineBreakMode = lineBreakMode;
        attributes[NSParagraphStyleAttributeName] = paragraphStyle;
    }
    // 计算文本的的rect
    CGRect rect = [self boundingRectWithSize:maxSize
                                     options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                  attributes:attributes
                                     context:nil];
    return rect.size;
}

#pragma mark - 获取文本的宽度
- (CGFloat)zm_getTextWidth:(UIFont *)font height:(CGFloat)height {
    CGSize size = [self zm_getTextSize:font maxSize:CGSizeMake(MAXFLOAT, height) mode:NSLineBreakByWordWrapping];
    return size.width;
}

#pragma mark - 获取文本的高度
- (CGFloat)zm_getTextHeight:(UIFont *)font width:(CGFloat)width {
    CGSize size = [self zm_getTextSize:font maxSize:CGSizeMake(width, MAXFLOAT) mode:NSLineBreakByWordWrapping];
    return size.height;
}

#pragma mark - label富文本: 插入图片
- (NSMutableAttributedString *)zm_setRichTextWithImage:(NSString *)iconName bounds:(CGRect)bounds iconLocation:(NSInteger)location {
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:self];
    // 文本附件
    NSTextAttachment *attch = [[NSTextAttachment alloc] init];
    // 定义图片内容及位置和大小（y为负值可以向上移动图片）
    attch.image = [UIImage imageNamed:iconName];
    attch.bounds = bounds;
    // 创建带有图片的富文本
    NSAttributedString *imageStr = [NSAttributedString attributedStringWithAttachment:attch];
    // 将图片插入指定位置
    [attrString insertAttributedString:imageStr atIndex:location];
    return attrString;
}

#pragma mark - label富文本: 设置不同字体和颜色
- (NSMutableAttributedString *)zm_setChangeText:(NSString *)changeText changeFont:(nullable UIFont *)font changeTextColor:(nullable UIColor *)color {
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:self];
    // 获取要调整文字样式的位置
    NSRange range = [[attrString string]rangeOfString:changeText];
    if (font) {
        // 设置不同字体
        [attrString addAttribute:NSFontAttributeName value:font range:range];
    }
    if (color) {
        // 设置不同颜色
        [attrString addAttribute:NSForegroundColorAttributeName value:color range:range];
    }
    return attrString;
}

#pragma mark - label富文本: HTML标签文本（HTMLString 转化为NSAttributedString）
- (NSMutableAttributedString *)zm_setTextHTMLString {
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *options = @{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType, NSCharacterEncodingDocumentAttribute: @(NSUTF8StringEncoding)};
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc]initWithData:data options:options documentAttributes:nil error:nil];
    
    return attributedStr;
}

#pragma mark - label富文本: 添加中划线
- (NSMutableAttributedString *)zm_setTextLineThrough {
    // 中划线
    NSDictionary *attribtDic = @{NSStrikethroughStyleAttributeName:[NSNumber numberWithInteger:NSUnderlineStyleSingle]};
    NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString:self attributes:attribtDic];
    return attribtStr;
}

#pragma mark - 设置文本关键词红色显示
// 美国<em>苹果</em> <em>科技</em>有限公司
- (NSAttributedString *)zm_setTextKeywords:(UIColor *)keywordColor {
    NSArray <NSString *>* textArr = [self componentsSeparatedByString:@"<em>"];
    NSString *formatText = [[self stringByReplacingOccurrencesOfString:@"<em>" withString:@""] stringByReplacingOccurrencesOfString:@"</em>" withString:@""];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:formatText];
    for (NSInteger i = 0; i < textArr.count; i++) {
        if ([textArr[i] containsString:@"</em>"]) {
            NSString *keyword = [[textArr[i] componentsSeparatedByString:@"</em>"] firstObject];
            NSRange range = [formatText rangeOfString:keyword];
            [attributedString addAttribute:NSForegroundColorAttributeName value:keywordColor range:range];
        }
    }
    return [attributedString copy];
}

///==================================================
///             正则表达式
///==================================================
#pragma mark - 判断是否是有效的手机号
- (BOOL)zm_isValidPhoneNumber {
    NSString *telNumber = [self stringByReplacingOccurrencesOfString:@" " withString:@""];
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     * 联通：130,131,132,152,155,156,185,186
     * 电信：133,1349,153,180,189,181(增加)
     */
    if (telNumber.length == 11) {
        // 移动号段正则表达式
        NSString *CM_NUM = @"^((13[4-9])|(147)|(15[0-2,7-9])|(178)|(18[2-4,7-8]))\\d{8}|(1705)\\d{7}$";
        // 联通号段正则表达式
        NSString *CU_NUM = @"^((13[0-2])|(145)|(15[5-6])|(176)|(18[5,6]))\\d{8}|(1709)\\d{7}$";
        // 电信号段正则表达式
        NSString *CT_NUM = @"^((133)|(153)|(177)|(18[0,1,9]))\\d{8}$";
        if ([self zm_isValidateByRegex:CM_NUM] || [self zm_isValidateByRegex:CU_NUM] || [self zm_isValidateByRegex:CT_NUM]) {
            return YES;
        } else {
            return NO;
        }
    } else {
        return NO;
    }
}

#pragma mark - 判断是否是有效的用户密码
- (BOOL)zm_isValidPassword {
    // 以字母开头，只能包含“字母”，“数字”，“下划线”，长度6~18
    NSString *regex = @"^([a-zA-Z]|[a-zA-Z0-9_]|[0-9]){6,18}$";
    return [self zm_isValidateByRegex:regex];
}

#pragma mark - 判断是否是有效的用户名（20位的中文或英文）
- (BOOL)zm_isValidUserName {
    NSString *regex = @"^[a-zA-Z一-龥]{1,20}";
    return [self zm_isValidateByRegex:regex];
}

#pragma mark - 判断是否是有效的邮箱
- (BOOL)zm_isValidEmail {
    NSString *regex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    return [self zm_isValidateByRegex:regex];
}

#pragma mark - 判断是否是有效的URL
- (BOOL)isValidUrl {
    NSString *regex = @"(http|https)://((\\w)*|([0-9]*)|([-|_])*)+([\\.|/]((\\w)*|([0-9]*)|([-|_])*))+";
    return [self zm_isValidateByRegex:regex];
}

#pragma mark - 判断是否是有效的银行卡号
- (BOOL)zm_isValidBankNumber {
    NSString *regex =@"^\\d{16,19}$|^\\d{6}[- ]\\d{10,13}$|^\\d{4}[- ]\\d{4}[- ]\\d{4}[- ]\\d{4,7}$";
    return [self zm_isValidateByRegex:regex];
}

#pragma mark - 判断是否是有效的身份证号
- (BOOL)zm_isValidIDCardNumber {
    NSString *value = self;
    value = [value stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSInteger length = 0;
    if (!value) {
        return NO;
    } else {
        length = value.length;
        if (length !=15 && length !=18) {
            return NO;
        }
    }
    // 省份代码
    NSArray *areasArray = @[@"11",@"12", @"13",@"14", @"15",@"21", @"22",@"23", @"31",@"32", @"33",@"34", @"35",@"36", @"37",@"41", @"42",@"43", @"44",@"45", @"46",@"50", @"51",@"52", @"53",@"54", @"61",@"62", @"63",@"64", @"65",@"71", @"81",@"82", @"91"];
    
    NSString *valueStart2 = [value substringToIndex:2];
    BOOL areaFlag = NO;
    for (NSString *areaCode in areasArray) {
        if ([areaCode isEqualToString:valueStart2]) {
            areaFlag =YES;
            break;
        }
    }
    
    if (!areaFlag) {
        return false;
    }
    
    NSRegularExpression *regularExpression;
    NSUInteger numberofMatch;
    
    int year =0;
    switch (length) {
        case 15:
            year = [value substringWithRange:NSMakeRange(6,2)].intValue + 1900;
            if (year % 4 == 0 || (year % 100 == 0 && year % 4 == 0)) {
                
                regularExpression = [[NSRegularExpression alloc]initWithPattern:@"^[1-9][0-9]{5}[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|[1-2][0-9]))[0-9]{3}$" options:NSRegularExpressionCaseInsensitive error:nil];//测试出生日期的合法性
            } else {
                regularExpression = [[NSRegularExpression alloc]initWithPattern:@"^[1-9][0-9]{5}[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|1[0-9]|2[0-8]))[0-9]{3}$" options:NSRegularExpressionCaseInsensitive error:nil];//测试出生日期的合法性
            }
            numberofMatch = [regularExpression numberOfMatchesInString:value
                                                               options:NSMatchingReportProgress
                                                                 range:NSMakeRange(0, value.length)];
            
            if(numberofMatch >0) {
                return YES;
            } else {
                return NO;
            }
        case 18:
            year = [value substringWithRange:NSMakeRange(6,4)].intValue;
            if (year % 4 == 0 || (year % 100 == 0 && year % 4 == 0)) {
                regularExpression = [[NSRegularExpression alloc]initWithPattern:@"^[1-9][0-9]{5}(19|20)[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|[1-2][0-9]))[0-9]{3}[0-9Xx]$" options:NSRegularExpressionCaseInsensitive error:nil];//测试出生日期的合法性
            } else {
                regularExpression = [[NSRegularExpression alloc]initWithPattern:@"^[1-9][0-9]{5}(19|20)[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|1[0-9]|2[0-8]))[0-9]{3}[0-9Xx]$" options:NSRegularExpressionCaseInsensitive error:nil];//测试出生日期的合法性
            }
            numberofMatch = [regularExpression numberOfMatchesInString:value
                                                               options:NSMatchingReportProgress
                                                                 range:NSMakeRange(0, value.length)];
            if(numberofMatch > 0) {
                int S = ([value substringWithRange:NSMakeRange(0,1)].intValue + [value substringWithRange:NSMakeRange(10,1)].intValue) *7 + ([value substringWithRange:NSMakeRange(1,1)].intValue + [value substringWithRange:NSMakeRange(11,1)].intValue) *9 + ([value substringWithRange:NSMakeRange(2,1)].intValue + [value substringWithRange:NSMakeRange(12,1)].intValue) *10 + ([value substringWithRange:NSMakeRange(3,1)].intValue + [value substringWithRange:NSMakeRange(13,1)].intValue) *5 + ([value substringWithRange:NSMakeRange(4,1)].intValue + [value substringWithRange:NSMakeRange(14,1)].intValue) *8 + ([value substringWithRange:NSMakeRange(5,1)].intValue + [value substringWithRange:NSMakeRange(15,1)].intValue) *4 + ([value substringWithRange:NSMakeRange(6,1)].intValue + [value substringWithRange:NSMakeRange(16,1)].intValue) *2 + [value substringWithRange:NSMakeRange(7,1)].intValue *1 + [value substringWithRange:NSMakeRange(8,1)].intValue *6 + [value substringWithRange:NSMakeRange(9,1)].intValue *3;
                int Y = S %11;
                NSString *M = @"F";
                NSString *JYM = @"10X98765432";
                M = [JYM substringWithRange:NSMakeRange(Y,1)];// 判断校验位
                NSString *validateData = [value substringWithRange:NSMakeRange(17,1)];
                validateData = [validateData uppercaseString];
                if ([M isEqualToString:validateData]) {
                    return YES;// 检测ID的校验位
                } else {
                    return NO;
                }
            } else {
                return NO;
            }
        default:
            return false;
    }
}

#pragma mark - 判断是否是有效的IP地址
- (BOOL)zm_isValidIPAddress {
    NSString *regex = [NSString stringWithFormat:@"^(\\\\d{1,3})\\\\.(\\\\d{1,3})\\\\.(\\\\d{1,3})\\\\.(\\\\d{1,3})$"];
    BOOL rc = [self zm_isValidateByRegex:regex];
    if (rc) {
        NSArray *componds = [self componentsSeparatedByString:@","];
        BOOL v = YES;
        for (NSString *s in componds) {
            if (s.integerValue > 255) {
                v = NO;
                break;
            }
        }
        return v;
    }
    return NO;
}

#pragma mark - 判断是否是纯汉字
- (BOOL)zm_isValidChinese {
    NSString *regex = @"^[\\u4e00-\\u9fa5]+$";
    return [self zm_isValidateByRegex:regex];
}

#pragma mark - 判断是否是邮政编码
- (BOOL)zm_isValidPostalcode {
    NSString *regex = @"^[0-8]\\\\d{5}(?!\\\\d)$";
    return [self zm_isValidateByRegex:regex];
}

#pragma mark - 判断是否是工商税号
- (BOOL)zm_isValidTaxNo {
    NSString *regex = @"[0-9]\\\\d{13}([0-9]|X)$";
    return [self zm_isValidateByRegex:regex];
}

#pragma mark - 判断是否是车牌号
- (BOOL)zm_isCarNumber {
    // 车牌号:湘K-DE829 香港车牌号码:粤Z-J499港
    // 其中\\u4e00-\\u9fa5表示unicode编码中汉字已编码部分，\\u9fa5-\\u9fff是保留部分，将来可能会添加
    NSString *regex = @"^[\\u4e00-\\u9fff]{1}[a-zA-Z]{1}[-][a-zA-Z_0-9]{4}[a-zA-Z_0-9_\\u4e00-\\u9fff]$";
    return [self zm_isValidateByRegex:regex];
}

#pragma mark - 匹配正则表达式的一些简单封装
- (BOOL)zm_isValidateByRegex:(NSString *)regex {
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [pre evaluateWithObject:self];
}

#pragma mark - 通过身份证获取性别
- (NSNumber *)zm_getGenderFromIDCard {
    if (self.length < 16) return nil;
    NSUInteger lenght = self.length;
    NSString *sex = [self substringWithRange:NSMakeRange(lenght - 2, 1)];
    if ([sex intValue] % 2 == 1) {
        return @1;
    }
    return @2;
}

#pragma mark - 隐藏证件号指定位数字
- (NSString *)zm_hideCharacters:(NSUInteger)location length:(NSUInteger)length {
    if (self.length > length && length > 0) {
        NSMutableString *str = [[NSMutableString alloc]init];
        for (NSInteger i = 0; i < length; i++) {
            [str appendString:@"*"];
        }
        return [self stringByReplacingCharactersInRange:NSMakeRange(location, length) withString:[str copy]];
    }
    return self;
}

@end
