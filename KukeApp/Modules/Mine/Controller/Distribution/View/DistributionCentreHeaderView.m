//
//  DistributionCentreHeaderView.m
//  KukeApp
//
//  Created by 库课 on 2019/3/14.
//  Copyright © 2019 KukeZangMing. All rights reserved.
//

#import "DistributionCentreHeaderView.h"
#import "DistributionCashWithdrawalViewController.h"
#import "DistributionTotalCommissionViewController.h"
#import "DistrubutionWaitCommissionViewController.h"
#import "DistributionInviteViewController.h"
#import "DistributionSpreadOrderViewController.h"
#import "DistributionSpreadGoodsListViewController.h"
#import "DistributionInviteCardViewController.h"

@interface DistributionCentreHeaderView (){
    BOOL isClick;
}

@end

@implementation DistributionCentreHeaderView
- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    self = [[[NSBundle mainBundle] loadNibNamed:@"DistributionCentreHeaderView" owner:self options:nil] lastObject];
    if (self) {
        self.frame = frame;
        self.headerImage.layer.cornerRadius = 25;
        self.headerImage.layer.masksToBounds = YES;
    }
    return self;
}
//-(void)drawRect:(CGRect)rect
//{
//    self.frame = CGRectMake(0, 0, screenWidth(), 447);
//}
//提现
- (void)setIsEnable:(BOOL)isEnable{
    isClick = isEnable;
}
- (IBAction)cashWithdrawalAction:(id)sender {
    if (!isClick) {
        [BaseTools showErrorMessage:@"分销员资格已经被禁用"];
    }else{
        DistributionCashWithdrawalViewController *vc = [[DistributionCashWithdrawalViewController alloc]init];
        [[[AppDelegate shareAppDelegate] getCurrentUIVC].navigationController pushViewController:vc animated:YES];
    }
    
}
//分销商品
- (IBAction)spreadAction:(id)sender {
    if (!isClick) {
        [BaseTools showErrorMessage:@"分销员资格已经被禁用"];
    }else{
    
        DistributionSpreadGoodsListViewController *vc = [[DistributionSpreadGoodsListViewController alloc]init];
        [[[AppDelegate shareAppDelegate] getCurrentUIVC].navigationController pushViewController:vc animated:YES];
    }
}
//累计邀请
- (IBAction)requestTotalAction:(id)sender {
    if (!isClick) {
        [BaseTools showErrorMessage:@"分销员资格已经被禁用"];
    }else{
        
        DistributionInviteViewController *vc = [[DistributionInviteViewController alloc]init];
        [[[AppDelegate shareAppDelegate] getCurrentUIVC].navigationController pushViewController:vc animated:YES];
    }
   
}
//推广订单
- (IBAction)distributionAction:(id)sender {
    if (!isClick) {
        [BaseTools showErrorMessage:@"分销员资格已经被禁用"];
    }else{
        
        DistributionSpreadOrderViewController *vc = [[DistributionSpreadOrderViewController alloc]init];
        [[[AppDelegate shareAppDelegate] getCurrentUIVC].navigationController pushViewController:vc animated:YES];
    }
    
}
//邀请分销员
- (IBAction)requestAction:(id)sender {
    if (!isClick) {
        [BaseTools showErrorMessage:@"分销员资格已经被禁用"];
    }else{
        
        DistributionInviteCardViewController *vc = [[DistributionInviteCardViewController alloc]init];
        [[[AppDelegate shareAppDelegate] getCurrentUIVC].navigationController pushViewController:vc animated:YES];
    }
    
}
//总计收益
- (IBAction)totalMoneyAction:(id)sender {
    if (!isClick) {
        [BaseTools showErrorMessage:@"分销员资格已经被禁用"];
    }else{
        
        DistributionTotalCommissionViewController *vc = [[DistributionTotalCommissionViewController alloc]init];
        [[[AppDelegate shareAppDelegate] getCurrentUIVC].navigationController pushViewController:vc animated:YES];
    }
   
}
//待结算受益
- (IBAction)waitMoneyAction:(id)sender {
    if (!isClick) {
        [BaseTools showErrorMessage:@"分销员资格已经被禁用"];
    }else{
        
        DistrubutionWaitCommissionViewController *vc = [[DistrubutionWaitCommissionViewController alloc]init];
        [[[AppDelegate shareAppDelegate] getCurrentUIVC].navigationController pushViewController:vc animated:YES];
    }
    
    
}
- (IBAction)distributionPolicyAction:(id)sender {
    if (!isClick) {
        [BaseTools showErrorMessage:@"分销员资格已经被禁用"];
    }else{
        HomePageBannerViewController *vc = [[HomePageBannerViewController alloc]init];
        vc.url = [NSString stringWithFormat:@"%@/distribution/agreement",SERVER_HOSTM];
        vc.title = @"分销政策";
        [[[AppDelegate shareAppDelegate] getCurrentUIVC].navigationController pushViewController:vc animated:YES];
    }
   
}
@end
