//
//  LoginViewController.m
//  KukeApp
//
//  Created by iOSDeveloper on 2018/8/23.
//  Copyright © 2018年 zhangming. All rights reserved.
//

#import "LoginViewController.h"
#import "HorizontalPageFlowlayout.h"
#import "LoginViewCell.h"
#import "RegisterViewCell.h"
#import "UIViewController+BackButtonHandler.h"
#import "MineViewController.h"
#import "HomePageViewController.h"
@interface LoginViewController ()<UICollectionViewDataSource, UICollectionViewDelegate>{
    
 
}
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UILabel *lineLab;

@end

@implementation LoginViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [[OpenInstallSDK defaultManager] reportEffectPoint:@"register" effectValue:100];
    [self.view addSubview:self.collectionView];
//    [self.view addSubview:self.lineLab];
    
    if ([self.isRegister isEqualToString:@"0"]) {
        self.title = @"登录";

    }else{
        self.title = @"注册";
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(toLoginView) name:@"RegisterSuccess" object:nil];
    // Do any additional setup after loading the view from its nib.
}
- (void)toLoginView{
//    [self layoutIfNeeded];
    [_collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];

}
- (IBAction)loginBtn:(id)sender {
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.5f animations:^{
       weakSelf.lineLab.frame = CGRectMake(0, 49, screenWidth()/2, 2);
    
        
    }];

    _collectionView.contentOffset = CGPointMake(0, 0);
    
 
}
- (IBAction)registerBtn:(id)sender {
//     __weak typeof(self) weakSelf = self;
//    [UIView animateWithDuration:0.5f animations:^{
//        weakSelf.lineLab.frame = CGRectMake(screenWidth()/2, 49, screenWidth()/2, 2);
//    }];
//    _collectionView.contentOffset = CGPointMake(screenWidth(), 0);
}

- (UILabel *)lineLab{
    if (!_lineLab) {
        _lineLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 49, screenWidth()/2, 2)];
        _lineLab.backgroundColor = CNavBgColor;
    }
    return _lineLab;
}
#pragma mark —————  创建循环滚动页 --———
#pragma mark - Lazy
- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        
        /** -----1.使用苹果提供的的UICollectionViewFlowLayout布局----- */
        // UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        
        /** -----2.使用自定义的的HorizontalPageFlowlayout布局----- */
        HorizontalPageFlowlayout *layout = [[HorizontalPageFlowlayout alloc] initWithRowCount:1 itemCountPerRow:1];
        [layout setColumnSpacing:0 rowSpacing:0 edgeInsets:UIEdgeInsetsMake(10, 0, 0, 0)];
        
        /** 注意,此处设置的item的尺寸是理论值，实际是由行列间距、collectionView的内边距和宽高决定 */
        // layout.itemSize = CGSizeMake(ScreenWidth / 4, 60);
        layout.minimumInteritemSpacing = 0;
        layout.minimumLineSpacing = 0;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, screenWidth(), screenHeight()-UI_navBar_Height) collectionViewLayout:layout];
        _collectionView.backgroundColor = CBackgroundColor;
        _collectionView.bounces = YES;
        _collectionView.pagingEnabled = YES;
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([RegisterViewCell class]) bundle:nil] forCellWithReuseIdentifier:@"RegisterViewCell"];
        [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([LoginViewCell class]) bundle:nil] forCellWithReuseIdentifier:@"LoginViewCell"];
    }
    return _collectionView;
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{

    if (indexPath.item == 0) {
        LoginViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"LoginViewCell" forIndexPath:indexPath];
        __weak typeof(self) weakSelf = self;
        cell.isRegister = self.isRegister;
        cell.myBlock = ^(NSString *action) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if ([weakSelf.navigationController.viewControllers[0] isKindOfClass:[MineViewController class]]) {
                    [weakSelf.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:0] animated:YES];
                }else{
                  
                    if (weakSelf.navigationController.viewControllers.count>=2) {
                         [weakSelf.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
                    }
                   
                }
            });
           
        };
        [cell.loginBtn addTarget:self action:@selector(loginAction) forControlEvents:(UIControlEventTouchUpInside)];
//        [cell.getCodeBtn addTarget:self action:@selector(getCodeAction) forControlEvents:(UIControlEventTouchUpInside)];
        [cell.forgetPasswordBtn addTarget:self action:@selector(forgerPasswordAction) forControlEvents:(UIControlEventTouchUpInside)];
        [cell.wxLoginBtn addTarget:self action:@selector(wxLoginAction) forControlEvents:(UIControlEventTouchUpInside)];
        [cell.QQLoginBtn addTarget:self action:@selector(QQLoginAction) forControlEvents:(UIControlEventTouchUpInside)];

        return cell;
    }else{
        RegisterViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"RegisterViewCell" forIndexPath:indexPath];
        return cell;
    }
    
    
  
//    return nil;
}
-(void)loginAction{
    
}
-(void)getCodeAction{
    
}
-(void)forgerPasswordAction{
    
}
-(void)wxLoginAction{
    
}
-(void)QQLoginAction{
    
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{

//    _lineLab.frame = CGRectMake(scrollView.contentOffset.x/2, 49, screenWidth()/2, 2);
    
    
}
- (BOOL)navigationShouldPopOnBackButton{
//    [self.navigationController popToRootViewControllerAnimated:YES];
    
    if ([self.navigationController.viewControllers[0] isKindOfClass:[MineViewController class]] ) {
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:0] animated:YES];
    }else if ([[self.navigationController.viewControllers objectAtIndex:1] isKindOfClass:[LoginViewController class]]){
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:0] animated:YES];
    }
    else{
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
    }

    return NO;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
