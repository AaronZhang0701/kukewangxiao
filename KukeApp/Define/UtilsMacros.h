//
//  define.h
//  MiAiApp
//
//  Created by 张明 on 2017/5/18.
//  Copyright © 2017年 张明. All rights reserved.
//

// 全局工具类宏定义

#ifndef define_h
#define define_h

#define kIsiPhoneX \
({BOOL isPhoneX = NO;\
if (@available(iOS 11.0, *)) {\
isPhoneX = [[UIApplication sharedApplication] delegate].window.safeAreaInsets.bottom > 0.0;\
}\
(isPhoneX);})

#define GF_SCREEN_WIDTH ([[UIScreen mainScreen]bounds].size.width)
#define GF_SCREEN_HEIGHT ([[UIScreen mainScreen]bounds].size.height)

#define gfWeakSelf(weakSelf)  __weak __typeof(&*self)weakSelf = self

// 判断是否是iPhoneX
//#define kIsiPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)
//获取系统对象
#define kApplication        [UIApplication sharedApplication]
#define kAppWindow          [UIApplication sharedApplication].delegate.window
#define kAppDelegate        [AppDelegate shareAppDelegate]
#define kRootViewController [UIApplication sharedApplication].delegate.window.rootViewController
#define kUserDefaults       [NSUserDefaults standardUserDefaults]
#define kNotificationCenter [NSNotificationCenter defaultCenter]

#define kStatusBarHeight [[UIApplication sharedApplication] statusBarFrame].size.height
#define kNavBarHeight 44.0
#define kTabBarHeight ([[UIApplication sharedApplication] statusBarFrame].size.height>20?83:49)
#define kTopHeight (kStatusBarHeight + kNavBarHeight)
#define IS_IOS11_LATER ([[UIDevice currentDevice] systemVersion] >= 11)
// 导航条高度
#define UI_navBar_Height  (kIsiPhoneX? 88.0 : 64.0)
// 底部tabbar高度
#define UI_tabBar_Height (kIsiPhoneX? 83.0 : 49.0)
// 导航坐标
#define kScreenNavigationBarHeight (kIsiPhoneX?88:64)
//获取屏幕宽高
#define KScreenWidth ([[UIScreen mainScreen] bounds].size.width)
#define KScreenHeight [[UIScreen mainScreen] bounds].size.height
#define kScreen_Bounds [UIScreen mainScreen].bounds

#define Iphone6ScaleWidth KScreenWidth/375.0
#define Iphone6ScaleHeight KScreenHeight/667.0
//根据ip6的屏幕来拉伸
#define kRealValue(with) ((with)*(KScreenWidth/375.0f))

//强弱引用
#define kWeakSelf(type)  __weak typeof(type) weak##type = type;
#define kStrongSelf(type) __strong typeof(type) type = weak##type;

//View 圆角和加边框
#define ViewBorderRadius(View, Radius, Width, Color)\
\
[View.layer setCornerRadius:(Radius)];\
[View.layer setMasksToBounds:YES];\
[View.layer setBorderWidth:(Width)];\
[View.layer setBorderColor:[Color CGColor]]

// View 圆角
#define ViewRadius(View, Radius)\
\
[View.layer setCornerRadius:(Radius)];\
[View.layer setMasksToBounds:YES]

//property 属性快速声明 别用宏定义了，使用代码块+快捷键实现吧

// 当前系统版本
#define CurrentSystemVersion [[UIDevice currentDevice].systemVersion doubleValue]
//当前语言
#define CurrentLanguage (［NSLocale preferredLanguages] objectAtIndex:0])
#define IS_PAD (UI_USER_INTERFACE_IDIOM()== UIUserInterfaceIdiomPad)

// UIScreen width.
#define PLV_ScreenWidth   [UIScreen mainScreen].bounds.size.width
// UIScreen height.
#define PLV_ScreenHeight  [UIScreen mainScreen].bounds.size.height
// iPhone X
#define PLV_iPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)
#define PLV_iPhoneXR ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(828, 1792), [[UIScreen mainScreen] currentMode].size) : NO)
// 横屏时左右安全区域
#define PLV_Landscape_Left_And_Right_Safe_Side_Margin  44
// 横屏时底部安全区域
#define PLV_Landscape_Left_And_Right_Safe_Bottom_Margin  21
// 状态栏高度
#define PLV_StatusBarHeight ((PLV_iPhoneX || PLV_iPhoneXR) ? 44.f: 20.f)
// 状态栏+导航栏高度
#define PLV_StatusAndNaviBarHeight ((PLV_iPhoneX || PLV_iPhoneXR) ? 88.f: 64.f)
// 各个机型最小逻辑分辨率宽度
#define PLV_Min_ScreenWidth 320
#define PLV_Max_ScreenWidth 414



//Polyv直播appId
#define PolyvLiveAppID @"f3uddp9gat"
//Polyv直播userId
#define PolyvLiveUserId @"9b52ce99c4"
//Polyv直播appSecret
#define PolyvLiveAppSecret @"a23dac18943c4840b04867f71d69562a"




// 状态栏高度
#define ZM_StatusBarHeight (kIsiPhoneX ? 30.f: 0.0f)

//-------------------打印日志-------------------------
//DEBUG  模式下打印日志,当前行
#ifdef DEBUG
#define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#define DLog(...)
#endif

#define TITLES @[@"首页", @"课程", @"资讯",@"个人中心"]
#define ICONS  @[@"Tab_home",@"Tab_course",@"Tab_news",@"Tab_mine"]

//拼接字符串
#define NSStringFormat(format,...) [NSString stringWithFormat:format,##__VA_ARGS__]

//颜色

//主题颜色
#define CNavBgColor  [UIColor colorWithHexString:@"e62129"]
//字体颜色
#define CTitleColor [UIColor colorWithHexString:@"#494949"]
//灰白色 CBackgroundColor
#define CBackgroundColor  [UIColor colorWithHexString:@"#F3F1F1"]
#define CNavBgFontColor  [UIColor colorWithHexString:@"ffffff"]

#define KClearColor [UIColor clearColor]
#define KWhiteColor [UIColor whiteColor]
#define KBlackColor [UIColor blackColor]
#define KGrayColor [UIColor grayColor]
#define KGray2Color [UIColor lightGrayColor]
#define KBlueColor [UIColor blueColor]
#define KRedColor [UIColor redColor]
#define kRandomColor    KRGBColor(arc4random_uniform(256)/255.0,arc4random_uniform(256)/255.0,arc4random_uniform(256)/255.0)        //随机色生成

//字体
#define BOLDSYSTEMFONT(FONTSIZE)[UIFont boldSystemFontOfSize:FONTSIZE]
#define SYSTEMFONT(FONTSIZE)    [UIFont systemFontOfSize:FONTSIZE]
#define FONT(NAME, FONTSIZE)    [UIFont fontWithName:(NAME) size:(FONTSIZE)]


//定义UIImage对象
#define ImageWithFile(_pointer) [UIImage imageWithContentsOfFile:([[NSBundle mainBundle] pathForResource:[NSString stringWi thFormat:@"%@@%dx", _pointer, (int)[UIScreen mainScreen].nativeScale] ofType:@"png"])]
#define IMAGE_NAMED(name) [UIImage imageNamed:name]

//数据验证
#define StrValid(f) (f!=nil && [f isKindOfClass:[NSString class]] && ![f isEqualToString:@""])
#define SafeStr(f) (StrValid(f) ? f:@"")
#define HasString(str,key) ([str rangeOfString:key].location!=NSNotFound)

#define ValidStr(f) StrValid(f)
#define ValidDict(f) (f!=nil && [f isKindOfClass:[NSDictionary class]])
#define ValidArray(f) (f!=nil && [f isKindOfClass:[NSArray class]] && [f count]>0)
#define ValidNum(f) (f!=nil && [f isKindOfClass:[NSNumber class]])
#define ValidClass(f,cls) (f!=nil && [f isKindOfClass:[cls class]])
#define ValidData(f) (f!=nil && [f isKindOfClass:[NSData class]])

//获取一段时间间隔
#define kStartTime CFAbsoluteTime start = CFAbsoluteTimeGetCurrent();
#define kEndTime  NSLog(@"Time: %f", CFAbsoluteTimeGetCurrent() - start)
//打印当前方法名
#define ITTDPRINTMETHODNAME() ITTDPRINT(@"%s", __PRETTY_FUNCTION__)

#pragma mark - ——————— 用户相关 ————————

//是否是审核状态
#define KIsAudit @"IsAudit"
//审核值
#define KAuditNumnber @"29"
//登录成功刷新上一级页面数据
#define KNotificationLoginUpdata @"KNotificationLoginUpdata"
//登录状态改变通知
#define KNotificationLoginStateChange @"loginStateChange"

//自动登录成功
#define KNotificationAutoLoginSuccess @"KNotificationAutoLoginSuccess"

//被踢下线
#define KNotificationOnKick @"KNotificationOnKick"

//用户信息缓存 名称
#define KUserCacheName @"KUserCacheName"

//用户model缓存
#define KUserModelCache @"KUserModelCache"
//发送通知
#define KPostNotification(name,obj) [[NSNotificationCenter defaultCenter] postNotificationName:name object:obj];


#define KNotificationPayResultStatus @"PayResultStatus"

#define KPayFail @"PayFail"

//网络状态变化
#define KNotificationNetWorkStateChange @"KNotificationNetWorkStateChange"
//单例化一个类
#define SINGLETON_FOR_HEADER(className) \
\
+ (className *)shared##className;

#define SINGLETON_FOR_CLASS(className) \
\
+ (className *)shared##className { \
static className *shared##className = nil; \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
shared##className = [[self alloc] init]; \
}); \
return shared##className; \
}

#endif /* define_h */
