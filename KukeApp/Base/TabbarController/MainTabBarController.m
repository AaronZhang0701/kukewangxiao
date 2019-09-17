//
//  MainTabBarController.m
//  MiAiApp
//
//  Created by 张明 on 2017/5/18.
//  Copyright © 2017年 张明. All rights reserved.
//

#import "MainTabBarController.h"

#import "RootNavigationController.h"
#import "HomePageViewController.h"
#import "MineViewController.h"
#import "NewCourseViewController.h"
#import "UITabBar+CustomBadge.h"
#import "XYTabBar.h"
#import "NewsListViewController.h"
@interface MainTabBarController ()<UITabBarControllerDelegate>{
    
    NSString *ID;
    NSString *name;
}

@property (nonatomic,strong) NSMutableArray * VCS;//tabbar root VC

@end

@implementation MainTabBarController


- (void)viewDidLoad {
    [super viewDidLoad];
    [self configNotifications];
    self.delegate = self;
    //初始化tabbar
    [self setUpTabBar];
    //添加子控制器
    [self setUpAllChildViewController];
  
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

#pragma mark -config
- (void)configNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(switchToCourseViewController:) name:@"SwitchToCourseViewController" object:nil];

}

- (void)switchToCourseViewController:(NSNotification *)noti {

    if ([noti.object[@"ID"] isEqualToString:@"3"]) {

        if ([UserDefaultsUtils boolValueWithKey:KIsAudit]){
            self.selectedIndex = 1;
            [UserDefaultsUtils saveValue:noti.object[@"Name"] forKey:@"CateName"];
            [UserDefaultsUtils saveValue:noti.object[@"ID"] forKey:@"CateID"];
        }else{
            self.selectedIndex = 0;
            UIViewController *rootViewController = [[UIApplication sharedApplication] keyWindow].rootViewController;
            UIViewController *topViewController = [BaseTools topViewControllerWithRootViewController:rootViewController];
            HomePageBannerViewController *vc = [[HomePageBannerViewController alloc]init];
            vc.url = @"https://m.kuke99.com/special/jszp_special";
            vc.title = @"教师招聘";
            [topViewController.navigationController pushViewController:vc animated:YES];
        }
    }else{
        self.selectedIndex = 1;
        [UserDefaultsUtils saveValue:noti.object[@"Name"] forKey:@"CateName"];
        [UserDefaultsUtils saveValue:noti.object[@"ID"] forKey:@"CateID"];
    }
}
#pragma mark ————— 初始化TabBar —————
-(void)setUpTabBar{
    //设置背景色 去掉分割线
    [self setValue:[XYTabBar new] forKey:@"tabBar"];
    [self.tabBar setBackgroundColor:[UIColor whiteColor]];
    [self.tabBar setBackgroundImage:[UIImage new]];
    //通过这两个参数来调整badge位置
    //    [self.tabBar setTabIconWidth:29];
    //    [self.tabBar setBadgeTop:9];
}

#pragma mark - ——————— 初始化VC ————————
-(void)setUpAllChildViewController{
    _VCS = @[].mutableCopy;

    HomePageViewController *homeVC = [[HomePageViewController alloc]init];
    [self setupChildViewController:homeVC title:@"首页" imageName:@"Tab_home" seleceImageName:@"Tab_home_select"];
    

    NewCourseViewController *makeFriendVC = [[NewCourseViewController alloc]init];
    [self setupChildViewController:makeFriendVC title:@"课程" imageName:@"Tab_course" seleceImageName:@"Tab_course_select"];
//    CourseViewController *makeFriendVC = [[CourseViewController alloc]init];
//    [self setupChildViewController:makeFriendVC title:@"课程" imageName:@"Tab_course" seleceImageName:@"Tab_course_select"];
    

    NewsListViewController *msgVC = [NewsListViewController new];
    [self setupChildViewController:msgVC title:@"资讯" imageName:@"Tab_news" seleceImageName:@"Tab_news_select"];
    
    
    MineViewController *mineVC = [[MineViewController alloc]init];
    [self setupChildViewController:mineVC title:@"我的" imageName:@"Tab_mine" seleceImageName:@"Tab_mine_select"];
    
    self.viewControllers = _VCS;
    

//    if (@available(iOS 11.0, *)) {
//        UIBarButtonItem *item = [UIBarButtonItem appearance];
//
//        NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:0.001],
//
//                                     NSForegroundColorAttributeName:[UIColor clearColor]};
//
//        [item setTitleTextAttributes:attributes forState:UIControlStateNormal];
//    }else{
//        [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60)forBarMetrics:UIBarMetricsDefault];
//    }
    
    [[UITabBar appearance] setTranslucent:NO];

}

-(void)setupChildViewController:(UIViewController*)controller title:(NSString *)title imageName:(NSString *)imageName seleceImageName:(NSString *)selectImageName{
    controller.title = title;
    controller.tabBarItem.title = title;//跟上面一样效果
    controller.tabBarItem.image = [[UIImage imageNamed:imageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    controller.tabBarItem.selectedImage = [[UIImage imageNamed:selectImageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    //未选中字体颜色
    [controller.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:KBlackColor,NSFontAttributeName:SYSTEMFONT(10.0f)} forState:UIControlStateNormal];
    
    //选中字体颜色
    [controller.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor redColor],NSFontAttributeName:SYSTEMFONT(10.0f)} forState:UIControlStateSelected];
    //包装导航控制器
    RootNavigationController *nav = [[RootNavigationController alloc]initWithRootViewController:controller];
    
//    [self addChildViewController:nav];
    [_VCS addObject:nav];
    
}


-(void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{
     
    //    NSLog(@"选中 %ld",tabBarController.selectedIndex);
    
}

-(void)setRedDotWithIndex:(NSInteger)index isShow:(BOOL)isShow{
    if (isShow) {
        [self.tabBar setBadgeStyle:kCustomBadgeStyleRedDot value:0 atIndex:index];
    }else{
        [self.tabBar setBadgeStyle:kCustomBadgeStyleNone value:0 atIndex:index];
    }
    
}

- (BOOL)shouldAutorotate {
    return [self.selectedViewController shouldAutorotate];
}
- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return [self.selectedViewController supportedInterfaceOrientations];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
