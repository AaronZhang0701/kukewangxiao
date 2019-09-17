//

//  PingAnXiaoYuan-Parent
//
//  Created by zkr01 on 16/12/20.
//  Copyright © 2016年 张明. All rights reserved.
//

#import "BaseTools.h"
#import "MBProgressHUD+MJ.h"
//#import <SVProgressHUD.h>
//#import <MJPhoto.h>
//#import <MJPhotoBrowser.h>
#import "LoginViewController.h"
@implementation BaseTools

+ (UIViewController*)topViewControllerWithRootViewController:(UIViewController*)rootViewController
{
    if ([rootViewController isKindOfClass:[UITabBarController class]]) {
        UITabBarController *tabBarController = (UITabBarController *)rootViewController;
        return [self topViewControllerWithRootViewController:tabBarController.selectedViewController];
    } else if ([rootViewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController* navigationController = (UINavigationController*)rootViewController;
        return [self topViewControllerWithRootViewController:navigationController.visibleViewController];
    } else if (rootViewController.presentedViewController) {
        UIViewController* presentedViewController = rootViewController.presentedViewController;
        return [self topViewControllerWithRootViewController:presentedViewController];
    } else {
        return rootViewController;
    }
}
+(void)showMessage:(NSString *)message
{
    [MBProgressHUD showMessage:message];
    
}
+(void)showMessage:(NSString *)message toView:(UIView *)toView
{
    [MBProgressHUD showMessage:message toView:toView];
}
+(void)hide
{
    [MBProgressHUD hideHUD];
}
+(void)hideFormView:(UIView *)forView
{
    [MBProgressHUD hideHUDForView:forView];
}

+(void)showError:(NSString *)error
{
    [MBProgressHUD showError:error];
}
+(void)showError:(NSString *)error toView:(UIView *)toView
{
    [MBProgressHUD showError:error toView:toView];
}
+(void)showSuccess:(NSString *)success
{
    [MBProgressHUD showSuccess:success];
}
+(void)showSuccess:(NSString *)success toView:(UIView *)toView
{
    [MBProgressHUD showSuccess:success toView:toView];
}


+ (void)showSuccessMessage:(NSString *)message{

    [MBProgressHUD showSuccessMessage:message];
}
+ (void)showErrorMessage:(NSString *)message{
    
    dispatch_async(dispatch_get_main_queue(), ^{

        [MBProgressHUD showErrorMessage:message];
    });
    

}
///********************* SVProgressHUD **********************/
//
//+ (void)showSuccessMessage:(NSString *)message
//{
//    [SVProgressHUD showSuccessWithStatus:message];
//}
//
//+ (void)showErrorMessage:(NSString *)message
//{
//    [SVProgressHUD showErrorWithStatus:message];
//}
//
+ (void)showProgressMessage:(NSString *) message
{
    
    [SVProgressHUD setBackgroundColor:[UIColor colorWithRed:0.00f green:0.00f blue:0.00f alpha:0.75f]];
    [SVProgressHUD setForegroundColor:[UIColor whiteColor]];
    [SVProgressHUD setDefaultStyle:(SVProgressHUDStyleCustom)];
    [SVProgressHUD showWithStatus:message];
}

+ (void)dismissHUD
{
    [SVProgressHUD dismiss];
}

+ (void)showAlertMessage:(NSString *)msg
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:msg delegate:self cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
    [alertView show];
}

+(CGSize) getLabelSize :(CGFloat)contentWidth fontType:(CGFloat )size  label:(NSString *)textLabel hight:(CGFloat)hight{
    UIFont *font = [UIFont systemFontOfSize:size];
    NSDictionary * tdic = [NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName,nil];
    CGSize strSize = [textLabel boundingRectWithSize:CGSizeMake(contentWidth,hight) options:NSStringDrawingUsesLineFragmentOrigin attributes:tdic context:nil].size;
    return strSize;
}
+(NSString *)getNowTimeTimestamp{
    
    
    
    NSDate *dat = [NSDate dateWithTimeIntervalSinceNow:0];
    
    NSTimeInterval a=[dat timeIntervalSince1970];
    
    NSString *timeString = [NSString stringWithFormat:@"%0.f", a];//转为字符型

    
    return timeString;
    
}
//获取当前的时间

+(NSString*)getCurrentTimes{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    
    //现在时间,你可以输出来看下是什么格式
    
    NSDate *datenow = [NSDate date];
    
    //----------将nsdate按formatter格式转成nsstring
    
    NSString *currentTimeString = [formatter stringFromDate:datenow];
    
    NSLog(@"currentTimeString =  %@",currentTimeString);
    
    return currentTimeString;
    
}


//获取当前时间
+ (NSString *)currentDateStr{
    NSDate *currentDate = [NSDate date];//获取当前时间，日期
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];// 创建一个时间格式化对象
    [dateFormatter setDateFormat:@"YYYY/MM/dd hh:mm:ss"];//设定时间格式,这里可以设置成自己需要的格式
    NSString *dateString = [dateFormatter stringFromDate:currentDate];//将时间转化成字符串
    return dateString;
}

//获取当前时间戳
+ (NSString *)currentTimeStr{
    NSDate* date = [NSDate dateWithTimeIntervalSinceNow:0];//获取当前时间0秒后的时间
    NSTimeInterval time=[date timeIntervalSince1970]*1000;// *1000 是精确到毫秒，不乘就是精确到秒
    NSString *timeString = [NSString stringWithFormat:@"%.0f", time];
    return timeString;
}


// 时间戳转时间,时间戳为13位是精确到毫秒的，10位精确到秒
+ (NSString *)getLiveDateStringWithTimeStr:(NSString *)str{
    if (str.length <10) {
        return @"0";
    }
    NSTimeInterval time=[str doubleValue];//传入的时间戳str如果是精确到毫秒的记得要/1000
    NSDate *detailDate=[NSDate dateWithTimeIntervalSince1970:time];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init]; //实例化一个NSDateFormatter对象
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"yyyy.MM.dd HH:mm"];
    NSString *currentDateStr = [dateFormatter stringFromDate: detailDate];
    return currentDateStr;
}
// 时间戳转时间,时间戳为13位是精确到毫秒的，10位精确到秒
+ (NSString *)getDateStringWithTimeStr:(NSString *)str{
    if (str.length <10) {
        return @"0";
    }
    NSTimeInterval time=[str doubleValue];//传入的时间戳str如果是精确到毫秒的记得要/1000
    NSDate *detailDate=[NSDate dateWithTimeIntervalSince1970:time];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init]; //实例化一个NSDateFormatter对象
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *currentDateStr = [dateFormatter stringFromDate: detailDate];
    return currentDateStr;
}
+ (NSString *)getDateStringWithTimeMdHm:(NSString *)str{
    NSTimeInterval time=[str doubleValue];//传入的时间戳str如果是精确到毫秒的记得要/1000
    NSDate *detailDate=[NSDate dateWithTimeIntervalSince1970:time];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init]; //实例化一个NSDateFormatter对象
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"MM-dd HH:mm"];
    NSString *currentDateStr = [dateFormatter stringFromDate: detailDate];
    return currentDateStr;
}
+ (NSString *)getDateStringWithTimeHM:(NSString *)str{
    NSTimeInterval time=[str doubleValue];//传入的时间戳str如果是精确到毫秒的记得要/1000
    NSDate *detailDate=[NSDate dateWithTimeIntervalSince1970:time];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init]; //实例化一个NSDateFormatter对象
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"HH:mm"];
    NSString *currentDateStr = [dateFormatter stringFromDate: detailDate];
    return currentDateStr;
}
+ (NSString *)getDateStringWithTimeMdHms:(NSString *)str{
    NSTimeInterval time=[str doubleValue];//传入的时间戳str如果是精确到毫秒的记得要/1000
    NSDate *detailDate=[NSDate dateWithTimeIntervalSince1970:time];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init]; //实例化一个NSDateFormatter对象
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"MM-dd HH:mm:ss"];
    NSString *currentDateStr = [dateFormatter stringFromDate: detailDate];
    return currentDateStr;
}

// 时间戳转时间,时间戳为13位是精确到毫秒的，10位精确到秒
+ (NSString *)getDateStringWithTimeStrDay:(NSString *)str{
    NSTimeInterval time=[str doubleValue];//传入的时间戳str如果是精确到毫秒的记得要/1000
    NSDate *detailDate=[NSDate dateWithTimeIntervalSince1970:time];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init]; //实例化一个NSDateFormatter对象
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *currentDateStr = [dateFormatter stringFromDate: detailDate];
    return currentDateStr;
}


//              ：2017-08-01 10:09:03
//字符串转时间戳 如：2017-4-10 17:15:10
+ (NSString *)getTimeStrWithString:(NSString *)str{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];// 创建一个时间格式化对象
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"]; //设定时间的格式
    NSDate *tempDate = [dateFormatter dateFromString:str];//将字符串转换为时间对象
    NSString *timeStr = [NSString stringWithFormat:@"%lld", (long long)[tempDate timeIntervalSince1970]*1000];//字符串转成时间戳,精确到毫秒*1000
    return timeStr;
}
+ (int)getWeekdayNum
{
    NSDateFormatter *dataFormatter = [[NSDateFormatter alloc] init];
    [dataFormatter setDateFormat:@"MM月dd日"];
    NSString *strDate = [dataFormatter stringFromDate:[NSDate date]];
    //获取星期几
    NSDateComponents *componets = [[NSCalendar autoupdatingCurrentCalendar] components:NSWeekdayCalendarUnit fromDate:[NSDate date]];
    int weekday = [componets weekday];//1代表星期日，2代表星期一，后面依次
    return weekday;
}
+ (NSString *)compareCurrentTime:(NSString *)str
{

    // 获取当前时时间戳 1466386762.345715 十位整数 6位小数
    NSTimeInterval currentTime = [[NSDate date] timeIntervalSince1970];
    // 时间戳(后台返回的时间 一般是13位数字)
    NSTimeInterval createTime = [str longLongValue]/1000;
    // 时间差
    NSTimeInterval time = currentTime - createTime;
    NSInteger s = time/60;
    if (s<1) {
        return @"刚刚";
    }
    if (s<60) {
        
        return [NSString stringWithFormat:@"%ld分钟前 ",s];
    }
    // 秒转小时
    NSInteger hours = time/3600;
    if (hours<24) {
        return [NSString stringWithFormat:@"%ld小时前",hours];
    }
    //秒转天数
    NSInteger days = time/3600/24;
    if (days < 30) {
        return [NSString stringWithFormat:@"%ld天前",days];
    }
    //秒转月
    NSInteger months = time/3600/24/30;
    if (months < 12) {
        return [NSString stringWithFormat:@"%ld月前",months];
    }
    //秒转年
    NSInteger years = time/3600/24/30/12;
    return [NSString stringWithFormat:@"%ld年前",years];

}
//根据时间戳获取星期几
+ (NSString *)getWeekDayFordate:(long long)data
{
//    data = 1496990533;
    NSArray *weekday = [NSArray arrayWithObjects: [NSNull null], @"星期日", @"星期一", @"星期二", @"星期三", @"星期四", @"星期五", @"星期六", nil];
    
    NSDate *newDate = [NSDate dateWithTimeIntervalSince1970:data];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [calendar components:NSWeekdayCalendarUnit fromDate:newDate];
    
    NSString *weekStr = [weekday objectAtIndex:components.weekday];
    return weekStr;
}

///**
// *  获取未来某个日期是星期几
// *  注意：featureDate 传递过来的格式 必须 和 formatter.dateFormat 一致，否则endDate可能为nil
// *
// */
//+ (NSString *)featureWeekdayWithDate:(NSString *)featureDate{
//    // 创建 格式 对象
//    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//    // 设置 日期 格式 可以根据自己的需求 随时调整， 否则计算的结果可能为 nil
//    formatter.dateFormat = @"yyyy-MM-dd";
//    // 将字符串日期 转换为 NSDate 类型
//    NSDate *endDate = [formatter dateFromString:featureDate];
//    // 判断当前日期 和 未来某个时刻日期 相差的天数
//    long days = [self daysFromDate:[NSDate date] toDate:endDate];
//    // 将总天数 换算为 以 周 计算（假如 相差10天，其实就是等于 相差 1周零3天，只需要取3天，更加方便计算）
//    long day = days >= 7 ? days % 7 : days;
//    long week = [self getNowWeekday] + day;
//    switch (week) {
//        case 1:
//            return @"星期天";
//            break;
//        case 2:
//            return @"星期一";
//            break;
//        case 3:
//            return @"星期二";
//            break;
//        case 4:
//            return @"星期三";
//            break;
//        case 5:
//            return @"星期四";
//            break;
//        case 6:
//            return @"星期五";
//            break;
//        case 7:
//            return @"星期六";
//            break;
//            
//        default:
//            break;
//    }
//    return nil;
//}

// 获取当前是星期几
+ (NSInteger)getNowWeekday {
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit |
    NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDate *now = [NSDate date];
    // 话说在真机上需要设置区域，才能正确获取本地日期，天朝代码:zh_CN
    calendar.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    comps = [calendar components:unitFlags fromDate:now];
    return [comps weekday];
}

+ (void)showImageWithIamgeArray:(NSArray *)images andIndex:(NSUInteger)index
{
    NSMutableArray *kjPhtotos = [NSMutableArray array];
    MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
    for (int i = 0; i < images.count; i++) {
        MJPhoto *photo = [[MJPhoto alloc]init];
        if ([images[i] isKindOfClass:[UIImage class]]) {
            photo.image = images[i];
        }else if ([images[i] isKindOfClass:[NSString class]]){
            photo.url = [NSURL URLWithString:images[i]];
        }else if ([images[i] isKindOfClass:[NSURL class]] ){
            photo.url = images[i];
        }
        
        [kjPhtotos addObject:photo];
    }
    browser.photos = kjPhtotos;
    browser.currentPhotoIndex = index;
    [browser show];
}
+(UIView *)showNoDataImage:(UITableView *)tabView
{
////
//    UIImage  *image=[UIImage sd_animatedGIFNamed:@"nodata"];
//
//    UIImageView  *gifview=[[UIImageView alloc]initWithFrame:CGRectMake(midX(tabView)-100, midY(tabView)-150, 200, 200)];
//
//    gifview.image=image;
////    [tabView addSubview]
//    return gifview;
    return nil;

}
+ (NSString*)dictionaryToJson:(NSDictionary *)dic
{
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}


+ (NSString*)arrToJson:(NSArray *)arr
{
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:arr options:NSJSONWritingPrettyPrinted error:&parseError];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

+ (NSArray *)arrayWithJsonString:(NSString *)jsonString
{
    if (jsonString == nil) {
        return nil;
    }
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSArray *jsonArr = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&err];
    if(err) {
        //        DDLogError(@"json解析失败：%@",err);
        return nil;
    }
    return jsonArr;
}

+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        //        DDLogError(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}
+ (BOOL)valiMobile:(NSString *)mobile{
    
    if (mobile.length != 11)
    
    {
        return NO;
        
    }else{
        return  YES;
    }
    
//    /**
//
//     * 手机号码:
//
//     * 13[0-9], 14[5,7], 15[0, 1, 2, 3, 5, 6, 7, 8, 9], 17[0, 1, 6, 7, 8], 18[0-9]
//
//     * 移动号段: 134,135,136,137,138,139,147,150,151,152,157,158,159,170,178,182,183,184,187,188
//
//     * 联通号段: 130,131,132,145,155,156,170,171,175,176,185,186
//
//     * 电信号段: 133,149,153,170,173,177,180,181,189
//
//     */
//
//    NSString *MOBILE = @"^1(3[0-9]|4[57]|5[0-35-9]|7[0135678]|8[0-9])\\d{8}$";
//
//    /**
//
//     * 中国移动：China Mobile
//
//     * 134,135,136,137,138,139,147,150,151,152,157,158,159,170,178,182,183,184,187,188
//
//     */
//
//    NSString *CM = @"^1(3[4-9]|4[7]|5[0-27-9]|7[08]|8[2-478])\\d{8}$";
//
//    /**
//
//     * 中国联通：China Unicom
//
//     * 130,131,132,145,155,156,170,171,175,176,185,186
//
//     */
//
//    NSString *CU = @"^1(3[0-2]|4[5]|5[56]|7[0156]|8[56])\\d{8}$";
//
//    /**
//
//     * 中国电信：China Telecom
//
//     * 133,149,153,170,173,177,180,181,189
//
//     */
//
//    NSString *CT = @"^1(3[3]|4[9]|53|7[037]|8[019])\\d{8}$";
//
//    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
//
//    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
//
//    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
//
//    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
//
//    if (([regextestmobile evaluateWithObject:mobile] == YES)
//
//        || ([regextestcm evaluateWithObject:mobile] == YES)
//
//        || ([regextestct evaluateWithObject:mobile] == YES)
//
//        || ([regextestcu evaluateWithObject:mobile] == YES))
//
//    {
//
//        return YES;
//
//    }
//
//    else
//
//    {
//
//        return NO;
//
//    }
    
}


#pragma mark - 把大长串的数字做单位处理

+ (NSString *)changeAsset:(NSString *)amountStr

{
    
    if (amountStr && ![amountStr isEqualToString:@""])
        
    {
        
        NSInteger num = [amountStr integerValue];
        
        if (num<10000)
            
        {
            
            return amountStr;
            
        }
        
        else
            
        {
            
            NSString *str = [NSString stringWithFormat:@"%f",num/10000.0];
            
            NSRange range = [str rangeOfString:@"."];
            
            str = [str substringToIndex:range.location+2];
            
            if ([str hasSuffix:@".0"])
                
            {
                
                return [NSString stringWithFormat:@"%@万",[str substringToIndex:str.length-2]];
                
            }
            
            else
                
                return [NSString stringWithFormat:@"%@万",str];
            
        }
        
    }
    
    else
        
        return @"0";
    
}
+(void)alertLoginWithVC:(UIViewController *)viewController {

    [UserInfoTool deleteListData];
    [UserDefaultsUtils saveValue:@"" forKey:@"access_token"];
    KPostNotification(@"OutLogin", nil);
    LoginViewController *vc = [[LoginViewController alloc]init];
    vc.isRegister = @"0";
//    [viewController presentViewController:vc animated:YES completion:^{
//
//    }];
    [viewController.navigationController pushViewController:vc animated:YES];
    

}

+(void)alertRegisterWithVC:(UIViewController *)viewController {
    
    [UserInfoTool deleteListData];
    [UserDefaultsUtils saveValue:@"" forKey:@"access_token"];
    KPostNotification(@"OutLogin", nil);
    LoginViewController *vc = [[LoginViewController alloc]init];
    vc.isRegister = @"1";
    //    [viewController presentViewController:vc animated:YES completion:^{
    //
    //    }];
    [viewController.navigationController pushViewController:vc animated:YES];
    
    
}
#pragma mark - 获取当前网络状态

/**
 
 *  获取当前网络状态
 
 *
 
 *  0:无网络 & 1:2G & 2:3G & 3:4G & 5:WIFI
 
 */

+ (NSInteger)getCurrentNetworkState {
    
    NSString *netWorkState = [[AFNetworkReachabilityManager sharedManager] localizedNetworkReachabilityStatusString];
    
    /*
     
     AFNetworkReachabilityStatusUnknown          = -1,
     
     AFNetworkReachabilityStatusNotReachable     = 0,
     
     AFNetworkReachabilityStatusReachableViaWWAN = 1,
     
     AFNetworkReachabilityStatusReachableViaWiFi = 2,
     
     */
    
    NSLog(@"NewWorkState --- %@", netWorkState);
    
    
    
    if ([netWorkState isEqualToString:@"Unknown"] || [netWorkState isEqualToString:@"Not Reachable"]) {// 未知 或 无网络
        
        return 0;
        
    }
    
    else if ([netWorkState isEqualToString:@"Reachable via WWAN"]) {// 蜂窝数据
        
        return 1;
        
    }
    
    else {// WiFi
        
        return 2;
        
    }
    
}
+ (void)openKefuWithObj:(id)obj{
    
    
    
//    
////    ZCKitInfo *kinfo = [ZCKitInfo alloc];
////    kinfo.isShowTansfer = YES;
//    
//    //  初始化配置信息
//    ZCLibInitInfo *initInfo = [ZCLibClient getZCLibClient].libInitInfo;
//    //    initInfo.appKey = @"1ff3e4ff91314f5ca308e19570ba24bb";
//    
//    
////    initInfo.serviceMode = 4;
//    CurrentUserInfo *info = nil;
//    if ([UserInfoTool persons].count !=0 ) {
//        info = [UserInfoTool persons][0];
//        initInfo.userId = [UserDefaultsUtils valueWithKey:@"user_id"];
//        initInfo.nickName = info.NiName;
//        initInfo.phone = info.Tel;
//    }else{
//        
//    }
//    
//    //自定义用户参数
//    //    [self customUserInformationWith:initInfo];
//    
//    ZCKitInfo *uiInfo=[ZCKitInfo new];
////    uiInfo.isShowTansfer = NO;
//    uiInfo.customBannerColor = CNavBgColor;
//    // 聊天气泡中的文字
//    //    uiInfo.chatFont  = [UIFont systemFontOfSize:22];
//    
//    // 聊天的背景颜色
//    //    uiInfo.backgroundColor = [UIColor redColor];
//    
//    
//    // 之定义商品和留言页面的相关UI
////        [self customerGoodAndLeavePageWithParameter:uiInfo];
//    
//    // 未读消息
////        [self customUnReadNumber:uiInfo];
//    
//    // ZCLibInitInfo 和 ZCKitInfo 的更多属性配置请在当前类中查看或者查看说明文档
////    NSMutableArray *arr = [[NSMutableArray alloc] init];
////
////    ZCLibCusMenu *menu1 = [[ZCLibCusMenu alloc] init];
////    menu1.title = [NSString stringWithFormat:@"订单"];
////    menu1.url = [NSString stringWithFormat:@"sobot://sendOrderMsg"];;
////    menu1.imgName = @"zcicon_sendpictures";
////    [arr addObject:menu1];
////
////    uiInfo.cusMoreArray = arr;
//    [[ZCLibClient getZCLibClient] setLibInitInfo:initInfo];
//    
//    // 智齿SDK初始化启动事例
//    [ZCSobot startZCChatVC:uiInfo with:obj target:nil pageBlock:^(id object, ZCPageBlockType type) {
//        
//    } messageLinkClick:^BOOL(NSString *link) {
//        
////        if( [link hasPrefix:@"sobot://sendOrderMsg"]){
////            // 发送位置信息
////            [ZCSobot sendeOrderMsg:@"订单号：123456789012\n商品1：瓜子200g*1\n商品链接：www.sobot.com商品描述：恰恰瓜子恰恰瓜子恰恰瓜子\n恰恰瓜子恰恰瓜子恰恰瓜子恰恰瓜子...\n商品2：矿泉水500ml*12\n商品链接：www.sobot.com商品描述:..."];
////            return YES;
////        }
//        //        if( [link hasPrefix:@"sobot://sendlocation"]){
//        //
//        //            // 发送位置信息
//        //            [ZCSobot sendLocation:@{
//        //                                    @"lat":@"40.001693",
//        //                                    @"lng":@"116.353276",
//        //                                    @"localLabel":@"北京市海淀区学清路38号金码大厦A座23层金码大酒店",
//        //                                    @"localName":@"金码大厦",
//        //                                    @"file":fullPath}];
//        //            return YES;
//        //        }else if([link hasPrefix:@"sobot://openlocation"]){
//        //            // 解析经度、纬度、地址：latitude=xx&longitude=xxx&address=xxx
//        //            // 跳转到地图的位置
//        //            NSLog(link);
//        //            // 打开地图
//        //            return YES;
//        //        }
//        return NO;
//    }];
}

//// 自定义参数 商品信息相关
//- (void)customerGoodAndLeavePageWithParameter:(ZCKitInfo *)uiInfo{
//
//// 商品信息自定义
//    if (_isShowGoodsSwitch.on) {
//        ZCProductInfo *productInfo = [ZCProductInfo new];
//        productInfo.thumbUrl = _goodsImgTF.text;
//        productInfo.title = _goodsTitleTF.text;
//        productInfo.desc = _goodsSummaryTF.text;
//        productInfo.label = _goodTagTF.text;
//        productInfo.link = _goodsSendTF.text;
//
//        [[NSUserDefaults standardUserDefaults] setObject:productInfo.thumbUrl forKey:@"goods_IMG"];
//        [[NSUserDefaults standardUserDefaults] setObject:productInfo.title forKey:@"goods_Title"];
//        [[NSUserDefaults standardUserDefaults] setObject:productInfo.desc forKey:@"goods_SENDMGS"];
//        [[NSUserDefaults standardUserDefaults] setObject:productInfo.label forKey:@"glabel_Text"];
//        [[NSUserDefaults standardUserDefaults] setObject:productInfo.link forKey:@"gPageUrl_Text"];
//        uiInfo.productInfo = productInfo;
//    }
//
//    // 设置电话号和昵称（留言界面的显示）
//    uiInfo.isAddNickName = _isAddNickSwitch.on;
//    uiInfo.isShowNickName = _isShowNickSwitch.on;
//
//}
@end
//Student *s1 = [[Student alloc] init];
//s1.name = @"zzz";
//s1.age = 18;
//
//NSString *path = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
//// 这个文件后缀可以是任意的，只要不与常用文件的后缀重复即可，我喜欢用data
//NSString *filePath = [path stringByAppendingPathComponent:@"student.data"];
//// 归档
//[NSKeyedArchiver archiveRootObject:s1 toFile:filePath];
//
//解档
//
//NSString *path = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
//NSString *filePath = [path stringByAppendingPathComponent:@"student.data"];
//// 解档
//Student *s = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
//NSLog(@"%@----%ld", s.name, s.age);
////  UIDragButton.h//  JXHDemo////  Created by Xinhou Jiang on 6/14/16.//  Copyright © 2016 Jiangxh. All rights reserved.//#import <UIKit/UIKit.h>/** *  代理按钮的点击事件 */@protocol UIDragButtonDelegate <NSObject>- (void)dragButtonClicked:(UIButton *)sender;@end@interface UIDragButton : UIButton/** *  悬浮窗所依赖的根视图 */@property (nonatomic, strong)UIView *rootView;/** *  UIDragButton的点击事件代理 */@property (nonatomic, weak)id<UIDragButtonDelegate>btnDelegate;@end

