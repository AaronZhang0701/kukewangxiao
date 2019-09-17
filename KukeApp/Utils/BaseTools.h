//

//  PingAnXiaoYuan-Parent
//
//  Created by zkr01 on 16/12/20.
//  Copyright © 2016年 张明. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseTools : NSObject
+ (UIViewController*)topViewControllerWithRootViewController:(UIViewController*)rootViewController;
/********************* SVProgressHUD **********************/
//弹出操作错误信息提示框
+ (void)showErrorMessage:(NSString *)message;
//弹出操作成功信息提示框
+ (void)showSuccessMessage:(NSString *)message;
//弹出加载提示框
+ (void)showProgressMessage:(NSString *) message;
//取消弹出框
+ (void)dismissHUD;
+(NSString *)getNowTimeTimestamp;
+(NSString*)getCurrentTimes;
//获取当前时间
+ (NSString *)currentDateSt;
//获取当前时间戳
+ (NSString *)currentTimeStr;
+ (BOOL)valiMobile:(NSString *)mobile;
// 时间戳转时间,时间戳为13位是精确到毫秒的，10位精确到秒
+ (NSString *)getDateStringWithTimeStr:(NSString *)str;
//字符串转时间戳 如：2017-4-10 17:15:10
+ (NSString *)getTimeStrWithString:(NSString *)str;
+ (NSString *)getLiveDateStringWithTimeStr:(NSString *)str;
+ (void)openKefuWithObj:(id)obj;
/**
 *  @author WSF, 15-07-21 09:07:59
 *
 *  弹出UIAlertView
 *
 *  @param msg 需要显示的信息
 */
+ (void)showAlertMessage:(NSString *)msg;

//显示信息
+(void)showMessage:(NSString*)message;
+(void)showMessage:(NSString*)message toView:(UIView*)toView;
+(void)hideFormView:(UIView*)forView;
+(void)hide;
//显示正确错误
+(void)showError:(NSString*)error;
+(void)showError:(NSString*)error toView:(UIView*)toView;
+(void)showSuccess:(NSString*)success;
+(void)showSuccess:(NSString*)success toView:(UIView*)toView;

+(CGSize) getLabelSize :(CGFloat)contentWidth fontType:(CGFloat )size  label:(NSString *)textLabel hight:(CGFloat)hight;

+ (NSString *) compareCurrentTime:(NSString *)str;
+ (NSString *)getWeekDayFordate:(long long)data;
+ (NSString *)featureWeekdayWithDate:(NSString *)featureDate;
+ (NSString *)getDateStringWithTimeStrDay:(NSString *)str;
+ (NSString *)getDateStringWithTimeHM:(NSString *)str;
+ (void)showImageWithIamgeArray:(NSArray *)images andIndex:(NSUInteger)index;
+(UIView *)showNoDataImage:(UITableView *)tabView;
+ (int)getWeekdayNum;
+ (NSString*)arrToJson:(NSArray *)arr;
+ (NSArray *)arrayWithJsonString:(NSString *)jsonString;
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;
+ (NSString *)changeAsset:(NSString *)amountStr;
+(void)alertLoginWithVC:(UIViewController *)viewController ;

+ (NSString *)getDateStringWithTimeMdHm:(NSString *)str;
+ (NSString *)getDateStringWithTimeMdHms:(NSString *)str;
+ (NSInteger)getCurrentNetworkState;
+(void)alertRegisterWithVC:(UIViewController *)viewController;
@end
