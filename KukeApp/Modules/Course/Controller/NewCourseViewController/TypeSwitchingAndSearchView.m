//
//  TypeSwitchingAndSearchView.m
//  KukeApp
//
//  Created by 库课 on 2019/4/15.
//  Copyright © 2019 KukeZangMing. All rights reserved.
//

#import "TypeSwitchingAndSearchView.h"
#import "PYSearch.h"
#import "SearchResultListViewController.h"
@interface TypeSwitchingAndSearchView ()<PYSearchViewControllerDelegate>{
    NSString *goodsTypeStr;
    NSString *cateIDStr;
}
@property (nonatomic, strong) NSMutableArray *btnArray;
@property (nonatomic,strong) UIButton *myButton;

@end

@implementation TypeSwitchingAndSearchView


- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.btnArray = [NSMutableArray array];
        if ([UserDefaultsUtils valueWithKey:[NSString stringWithFormat:@"course_goods_type_%@",[UserDefaultsUtils valueWithKey:@"CateID"]]] == nil) {
            [UserDefaultsUtils saveValue:@"3" forKey:[NSString stringWithFormat:@"course_goods_type_%@",cateIDStr]];
        }
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(upLoad:) name:@"SwitchGoodsType" object:nil];
        [self initTypeButton];
        [self initSearchBtn];
        UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(0, 40, screenWidth(), 7)];
        line.backgroundColor = CBackgroundColor;
        [self addSubview:line];
    }
    return self;
}
- (void)setPush_cate_id:(NSString *)push_cate_id{
    NSArray *array = [self subviews];//获取button父视图上的所有子控件
    for(int i=0;i<array.count;i++) //遍历数组 找出所有的button
    {
        id view = array[i];
        if([view isKindOfClass:[UIButton class]])
        {
            UIButton *btn = (UIButton*)view;
            if (btn.tag == 80000) {
                
            }else{
                if ([push_cate_id isEqualToString:@"1"]) {
                    if ([btn.currentTitle isEqualToString:@"题库"]){
                        [btn setBackgroundColor:CNavBgColor];//选中button的颜色
                        [btn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
                        btn.layer.borderWidth = 0;
                    }
                }else if ([push_cate_id isEqualToString:@"3"]){
                    if ([btn.currentTitle isEqualToString:@"课程"]){
                        [btn setBackgroundColor:CNavBgColor];//选中button的颜色
                        [btn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
                        btn.layer.borderWidth = 0;
                    }
                }else if ([push_cate_id isEqualToString:@"4"]){
                    if ([btn.currentTitle isEqualToString:@"图书"]) {
                        [btn setBackgroundColor:CNavBgColor];//选中button的颜色
                        [btn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
                        btn.layer.borderWidth = 0;
                    }
                }
                
            }
            
        }
    }
    
}
-(void)setCate_id:(NSString *)cate_id{
    cateIDStr = cate_id;
    
    
    NSArray *array = [self subviews];//获取button父视图上的所有子控件
    for(int i=0;i<array.count;i++) //遍历数组 找出所有的button
    {
        id view = array[i];
        if([view isKindOfClass:[UIButton class]])
        {
            UIButton *btn = (UIButton*)view;
            if (btn.tag == 80000) {
                
            }else{
  
                if ([[UserDefaultsUtils valueWithKey:[NSString stringWithFormat:@"course_goods_type_%@",cateIDStr]] integerValue] == 3 && i==0) {
                    [btn setBackgroundColor:CNavBgColor];//选中button的颜色
                    [btn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
                    btn.layer.borderWidth = 0;
                }else if([[UserDefaultsUtils valueWithKey:[NSString stringWithFormat:@"course_goods_type_%@",cateIDStr]] integerValue] == 1 && i==1){
                    [btn setBackgroundColor:CNavBgColor];//选中button的颜色
                    [btn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
                    btn.layer.borderWidth = 0;
                }else if([[UserDefaultsUtils valueWithKey:[NSString stringWithFormat:@"course_goods_type_%@",cateIDStr]] integerValue] == 4 && i==2){
                    [btn setBackgroundColor:CNavBgColor];//选中button的颜色
                    [btn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
                    btn.layer.borderWidth = 0;
                }else if([UserDefaultsUtils valueWithKey:[NSString stringWithFormat:@"course_goods_type_%@",cateIDStr]] == nil && [[UserDefaultsUtils valueWithKey:[NSString stringWithFormat:@"course_goods_type_%@",cateIDStr]] integerValue] == 0 && i == 0){
                    [btn setBackgroundColor:CNavBgColor];//选中button的颜色
                    [btn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
                    btn.layer.borderWidth = 0;
                }else{
                    [btn setBackgroundColor:[UIColor clearColor]];//选中button的颜色
                    [btn setTitleColor:CTitleColor forState:(UIControlStateNormal)];
                    btn.layer.borderWidth = 0.5f;
                    btn.layer.borderColor = [CTitleColor CGColor];
                }
                
            }
            
        }
    }
  
    
}
//- (void)upLoad:(NSNotification *)noti
//{
//    goodsTypeStr = noti.object;
//
//}
- (void)initTypeButton{
    
    NSArray *ary = @[@"课程",@"题库",@"图书"];
    
    for(NSInteger i = 0; i < ary.count; i++)
        
    {
        UIButton *clickBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        clickBtn.backgroundColor = [UIColor clearColor];
        
        clickBtn.selected = NO;
        
        [clickBtn setTitleColor:CTitleColor forState:(UIControlStateNormal)];
        
        clickBtn.layer.cornerRadius = 11;
        
        clickBtn.layer.borderWidth = 0.5f;
        
        clickBtn.layer.borderColor = [CTitleColor CGColor];
        
        clickBtn.layer.masksToBounds = YES;
        
        clickBtn.frame = CGRectMake(15 + i*(65 + 15), 9, 65, 22);
        
        [clickBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [clickBtn setTag:i];
        
        clickBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        
        [clickBtn setTitle:ary[i] forState:(UIControlStateNormal)];
        
        
//        if ([[UserDefaultsUtils valueWithKey:[NSString stringWithFormat:@"course_goods_type_%@",cateIDStr]] integerValue] == 3 && i==0) {
//            [clickBtn setBackgroundColor:CNavBgColor];//选中button的颜色
//            [clickBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
//            clickBtn.layer.borderWidth = 0;
//        }
        
        [self.btnArray addObject:clickBtn];
        
        
        
        [self addSubview:clickBtn];

    }

}

- (void)btnClick:(UIButton *)sender {
    NSArray *array = [self subviews];//获取button父视图上的所有子控件
    for(int i=0;i<array.count;i++) //遍历数组 找出所有的button
    {
        id view = array[i];
        if([view isKindOfClass:[UIButton class]])
        {
            UIButton *btn = (UIButton*)view;
            if (btn.tag == 80000) {
                
            }else{
                btn.backgroundColor = [UIColor clearColor];
                btn.layer.borderWidth = 0.5f;
                [btn setTitleColor:CTitleColor forState:(UIControlStateNormal)];
                btn.selected = NO;
            }
            
        }
    }
    NSInteger index = [array indexOfObject:sender];
    NSString *goodsType = nil;
    if (index==0) {
        goodsType = @"3";
    }else if (index == 1){
        goodsType = @"1";
    }else{
        goodsType = @"4";
    }
    
    [UserDefaultsUtils saveValue:@"2" forKey:@"SwicthTab"];
    [UserDefaultsUtils saveValue:goodsType forKey:[NSString stringWithFormat:@"course_goods_type_%@",cateIDStr]];

    KPostNotification(@"SwitchGoodsType", [UserDefaultsUtils valueWithKey:@"CateID"]);
    if (_goodsTypeActionBlock) {
        self.goodsTypeActionBlock(goodsTypeStr);
    }
    sender.selected =YES;
    [sender setBackgroundColor:CNavBgColor];//选中button的颜色
    [sender setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    sender.layer.borderWidth = 0;
}
- (void)initSearchBtn{
    
    UIButton *searchBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    searchBtn.frame = CGRectMake(screenWidth()- 32, 12, 17, 17);
    searchBtn.tag = 80000;
    [searchBtn setImage:[UIImage imageNamed:@"sousuo"] forState:(UIControlStateNormal)];
    [searchBtn addTarget:self action:@selector(searchAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [self addSubview:searchBtn];
    
}

- (void)searchAction:(UIButton *)sender {
    
//    NSArray *hotSeaches = @[@"1", @"Python", @"Objective-C", @"Swift", @"C", @"C++", @"PHP", @"C#", @"Perl", @"Go", @"JavaScript", @"R", @"Ruby", @"MATLAB"];
    // 2. Create a search view controller
    PYSearchViewController *searchViewController = [PYSearchViewController searchViewControllerWithHotSearches:nil searchBarPlaceholder:@"请输入您要查找的内容" didSearchBlock:^(PYSearchViewController *searchViewController, UISearchBar *searchBar, NSString *searchText) {
        
        
        [[OpenInstallSDK defaultManager] reportEffectPoint:@"search" effectValue:1];
        
        // Called when search begain.
        // eg：Push to a temp view controller
        searchBar.barTintColor = CBackgroundColor;
   
        searchViewController.searchTextField.backgroundColor = CBackgroundColor;
//        searchBar.backgroundColor = CBackgroundColor;
//        searchViewController.searchBarBackgroundColor =CBackgroundColor;
        SearchResultListViewController *vc = [[SearchResultListViewController alloc] init];
        vc.searchText = searchText;
        vc.cate_id = cateIDStr;
        vc.goodsType = self.goodsType;
        [searchViewController.navigationController pushViewController:vc animated:YES];
    }];
    // 3. Set style for popular search and search history
//    if (0 == indexPath.section) {
//        searchViewController.hotSearchStyle = (NSInteger)indexPath.row;
//        searchViewController.searchHistoryStyle = PYHotSearchStyleDefault;
//    } else {
        searchViewController.hotSearchStyle = PYHotSearchStyleDefault;
        searchViewController.searchHistoryStyle = PYSearchHistoryStyleNormalTag;
//    }
    searchViewController.searchBarCornerRadius = 15;
    searchViewController.searchBar.tintColor=[UIColor grayColor];
    // 4. Set delegate
    searchViewController.delegate = self;
    // 5. Present(Modal) or push search view controller
    // Present(Modal)
    //    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:searchViewController];
    //    [self presentViewController:nav animated:YES completion:nil];
    // Push
    // Set mode of show search view controller, default is `PYSearchViewControllerShowModeModal`
    searchViewController.searchViewControllerShowMode = PYSearchViewControllerShowModePush;
    //    // Push search view controller
    
    
    [[[AppDelegate shareAppDelegate] getCurrentUIVC].navigationController pushViewController:searchViewController animated:YES];
    
    [searchViewController.navigationController setNavigationBarHidden:NO animated:NO];
}
#pragma mark - PYSearchViewControllerDelegate
- (void)searchViewController:(PYSearchViewController *)searchViewController searchTextDidChange:(UISearchBar *)seachBar searchText:(NSString *)searchText
{
    
//    if (searchText.length) {
//        // Simulate a send request to get a search suggestions
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            NSMutableArray *searchSuggestionsM = [NSMutableArray array];
//            for (int i = 0; i < arc4random_uniform(5) + 10; i++) {
//                NSString *searchSuggestion = [NSString stringWithFormat:@"Search suggestion %d", i];
//                [searchSuggestionsM addObject:searchSuggestion];
//            }
//            // Refresh and display the search suggustions
//            searchViewController.searchSuggestions = searchSuggestionsM;
//        });
//    }
}
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
