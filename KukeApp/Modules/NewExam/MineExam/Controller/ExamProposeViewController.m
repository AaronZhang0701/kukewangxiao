//
//  ExamProposeViewController.m
//  KukeApp
//
//  Created by 库课 on 2019/8/9.
//  Copyright © 2019 KukeZangMing. All rights reserved.
//

#import "ExamProposeViewController.h"
#import "XLPageViewController.h"
#import "ExamListViewModel.h"
#import "ExamProposeGoodsListViewController.h"
#import "ExamRankingListViewController.h"
@interface ExamProposeViewController ()<XLPageViewControllerDelegate,XLPageViewControllerDataSrouce>

@property (nonatomic, strong) XLPageViewController *pageViewController;
//标题组
@property (nonatomic, strong) NSArray *titles;

@property (nonatomic, strong) NSMutableArray *cateIDs;
//配置信息
@property (nonatomic, strong) XLPageViewControllerConfig *config;

@property (nonatomic, strong) ExamListViewModel *viewModel;
@end

@implementation ExamProposeViewController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO];

}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"排行及提升建议";
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.titles = @[@"总刷题量TOP10",@"总正确率TOP10",@"提升建议"];
    [self initPageViewController];
}

- (void)initPageViewController{
    self.config = [XLPageViewControllerConfig defaultConfig];
    self.config.titleViewHeight = 59;
    self.config.titleSpace = 0;
    self.config.titleWidth = self.view.bounds.size.width/3;
    self.config.shadowLineWidth = self.view.bounds.size.width/3;
    self.config.titleViewInset = UIEdgeInsetsZero;
    self.config.titleNormalFont = [UIFont systemFontOfSize:15];
    self.config.titleSelectedFont = [UIFont systemFontOfSize:15];
    self.config.titleNormalColor = CTitleColor;
    self.config.titleSelectedColor = CNavBgColor;
    self.config.separatorLineHeight = 9;
    self.config.separatorLineColor = CBackgroundColor;
    self.config.shadowLineColor = CNavBgColor;
    self.config.shadowLineHeight = 1;
    self.pageViewController = [[XLPageViewController alloc] initWithConfig:self.config];
    self.pageViewController.view.frame = self.view.bounds;
    self.pageViewController.delegate = self;
    self.pageViewController.dataSource = self;
    [self addChildViewController:self.pageViewController];
    [self.view addSubview:self.pageViewController.view];
}

#pragma mark -
#pragma mark TableViewDelegate&DataSource
- (UIViewController *)pageViewController:(XLPageViewController *)pageViewController viewControllerForIndex:(NSInteger)index {
    if (index == 2) {
        ExamProposeGoodsListViewController *vc = [[ExamProposeGoodsListViewController alloc]init];
        vc.exam_cate_id = self.cate_id;
        return vc;
    }else{
        ExamRankingListViewController *vc = [[ExamRankingListViewController alloc] init];
        vc.exam_cate_id = self.cate_id;
        vc.rinkingType = [NSString stringWithFormat:@"%ld",index + 1];
        return vc;
    }
   
}

- (NSString *)pageViewController:(XLPageViewController *)pageViewController titleForIndex:(NSInteger)index {
    
    return self.titles[index];
}

- (NSInteger)pageViewControllerNumberOfPage {
    return self.titles.count;
}

- (void)pageViewController:(XLPageViewController *)pageViewController didSelectedAtIndex:(NSInteger)index {
    NSLog(@"切换到了：%@",self.titles[index]);
}

@end
