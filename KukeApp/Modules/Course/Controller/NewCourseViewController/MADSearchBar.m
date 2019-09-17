//
//  MADSearchBar.m
//  MADCompatNavBarForIOS11
//
//  Created by 梁宪松 on 2018/1/14.
//  Copyright © 2018年 madao. All rights reserved.
//

#import "MADSearchBar.h"
#import "YBPopupMenu.h"
#undef macroIOS11_ORLATER
#define IOS11_ORLATER ([[[UIDevice currentDevice] systemVersion] compare:@"11.0" options:NSNumericSearch] != NSOrderedAscending )



@interface MADSearchBar ()<YBPopupMenuDelegate>
@property (nonatomic, strong) YBPopupMenu *popupMenu;
@end

@implementation MADSearchBar
{
    NSString *_cancelTitle;
    UIEdgeInsets _insets;
    UITextField *_searchField;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self _setUpView];
    }
    return self;
}

#pragma mark - Private
- (void)_setUpView
{
    // 设置搜索图标
     [self setImage: [UIImage imageNamed:@"search"] forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];
    // iOS11版本以后 高度限制为44
    if (IOS11_ORLATER) {
        [self.heightAnchor constraintEqualToConstant:44].active = YES;
        self.searchTextPositionAdjustment = (UIOffset){10, 0}; // 光标偏移量
    }
    // 设置边距
    CGFloat top = 5;
    CGFloat bottom = top;
    CGFloat left = 30;
    CGFloat right = 60;
    _insets = UIEdgeInsetsMake(top, left, bottom, right);
    
    
}

- (void)_hookSearchBar
{
    // 遍历子视图，获取输入UITextFiled
    if (!_searchField) {
        NSArray *subviewArr = self.subviews;
        for(int i = 0; i < subviewArr.count ; i++) {
            UIView *viewSub = [subviewArr objectAtIndex:i];
            NSArray *arrSub = viewSub.subviews;
            for (int j = 0; j < arrSub.count ; j ++) {
                id tempId = [arrSub objectAtIndex:j];
                if([tempId isKindOfClass:[UITextField class]]) {
                    _searchField = (UITextField *)tempId;
                }
            }
        }
    }
    
    if (_searchField) {
        //自定义UISearchBar
        UITextField *searchField = _searchField;
        if (IOS11_ORLATER) {
            // iOS11版本以后进行适配
            CGRect frame = searchField.frame;
            CGFloat offsetX = frame.origin.x - _insets.left;
            CGFloat offsetY = frame.origin.y - _insets.top;
            frame.origin.x = _insets.left;
            frame.origin.y = _insets.top;
            frame.size.height += offsetY * 2;
            frame.size.width = screenWidth()-90;
            searchField.frame = frame;
        }
        // 自定义样式
        searchField.placeholder = @"请输入关键字";
        searchField.font = [UIFont systemFontOfSize:14];
        searchField.backgroundColor = CBackgroundColor;
        [searchField setBorderStyle:UITextBorderStyleNone];
        [searchField setTextAlignment:NSTextAlignmentLeft];
        [searchField setTextColor:[UIColor grayColor]];
        // 设置圆角
        searchField.layer.masksToBounds = YES;
        searchField.layer.cornerRadius = 14.0f;
        // 设置placeholder是否居中显示
        SEL centerSelector = NSSelectorFromString([NSString stringWithFormat:@"%@%@", @"setCenter", @"Placeholder:"]);
        if ([self respondsToSelector:centerSelector])
        {
            BOOL hasCentredPlaceholder = NO;
            NSMethodSignature *signature = [[UISearchBar class] instanceMethodSignatureForSelector:centerSelector];
            NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
            [invocation setTarget:self];
            [invocation setSelector:centerSelector];
            [invocation setArgument:&hasCentredPlaceholder atIndex:2];
            [invocation invoke];
        }
    }
    
    UIButton *button = [UIButton buttonWithType:(UIButtonTypeCustom)];
    button.frame = CGRectMake(screenWidth()-45, 5, 30, 30);
    [button setImage:[UIImage imageNamed:@"caidan-hei"] forState:(UIControlStateNormal)];
    [button addTarget:self action:@selector(menuAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [self addSubview:button];
    
//    //显示右侧取消按钮
//    self.showsCancelButton = YES;
//    //拿到取消按钮
//    UIButton *cancleBtn = [self valueForKey:@"cancelButton"];
//    //设置按钮上的文字
//    [cancleBtn setTitle:@"取消" forState:UIControlStateNormal];
//    //设置按钮上文字的颜色
//    [cancleBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

}
- (void)menuAction:(UIButton *)sender{
    [YBPopupMenu showRelyOnView:sender titles:TITLES icons:ICONS menuWidth:120 otherSettings:^(YBPopupMenu *popupMenu) {
        popupMenu.fontSize = 13;
        popupMenu.textColor = CTitleColor;
        popupMenu.delegate = self;
    }];
}
#pragma mark - YBPopupMenuDelegate
- (void)ybPopupMenu:(YBPopupMenu *)ybPopupMenu didSelectedAtIndex:(NSInteger)index
{
    if (index == 1) {
    
       [[[AppDelegate shareAppDelegate] getCurrentUIVC].navigationController popToRootViewControllerAnimated:YES];
    }else{
        // 这是从一个模态出来的页面跳到tabbar的某一个页面
        [[[AppDelegate shareAppDelegate] getCurrentUIVC].navigationController popToRootViewControllerAnimated:NO];
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        
        UITabBarController *tabViewController = (UITabBarController *) appDelegate.window.rootViewController;
        
        [tabViewController setSelectedIndex:index];
        
    }
    

}

#pragma mark - Layout
-(void) layoutSubviews
{
    [super layoutSubviews];
    [self _hookSearchBar];
}

@end
