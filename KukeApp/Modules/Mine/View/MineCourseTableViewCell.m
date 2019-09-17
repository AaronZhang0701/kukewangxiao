//
//  MineCourseTableViewCell.m
//  KukeApp
//
//  Created by iOSDeveloper on 2018/10/2.
//  Copyright © 2018年 zhangming. All rights reserved.
//

#import "MineCourseTableViewCell.h"
#import "MyOrderViewController.h"
@implementation MineCourseTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self.noPayment setTitle:@"待付款" forState:(UIControlStateNormal)];
    [self.noPayment setImage:[UIImage imageNamed:@"个人中心代付款"] forState:(UIControlStateNormal)];
    [self.noPayment br_layoutButtonWithEdgeInsetsStyle:(BRButtonEdgeInsetsStyleTop) imageTitleSpace:15];
    
    
    
    [self.noSend setTitle:@"待发货" forState:(UIControlStateNormal)];
    [self.noSend setImage:[UIImage imageNamed:@"个人中心代发货"] forState:(UIControlStateNormal)];
    [self.noSend br_layoutButtonWithEdgeInsetsStyle:(BRButtonEdgeInsetsStyleTop) imageTitleSpace:15];
    
    [self.noReceive setTitle:@"待收货" forState:(UIControlStateNormal)];
    [self.noReceive setImage:[UIImage imageNamed:@"个人中心待收货"] forState:(UIControlStateNormal)];
    [self.noReceive br_layoutButtonWithEdgeInsetsStyle:(BRButtonEdgeInsetsStyleTop) imageTitleSpace:15];
    
    [self.afterSale setTitle:@"售后" forState:(UIControlStateNormal)];
    [self.afterSale setImage:[UIImage imageNamed:@"个人中心-售后服务拷贝"] forState:(UIControlStateNormal)];
    [self.afterSale br_layoutButtonWithEdgeInsetsStyle:(BRButtonEdgeInsetsStyleTop) imageTitleSpace:15];
    
    
    [self.order setTitle:@"我的订单" forState:(UIControlStateNormal)];
    [self.order setImage:[UIImage imageNamed:@"个人中心-我的订单拷贝"] forState:(UIControlStateNormal)];
    [self.order br_layoutButtonWithEdgeInsetsStyle:(BRButtonEdgeInsetsStyleTop) imageTitleSpace:15];
    
    
    
    self.unread1.layer.cornerRadius = 7;
    self.unread1.layer.masksToBounds = YES;
    self.unread2.layer.cornerRadius = 7;
    self.unread2.layer.masksToBounds = YES;
    self.unread3.layer.cornerRadius = 7;
    self.unread3.layer.masksToBounds = YES;
    
}
- (IBAction)noPaymentAction:(id)sender {
    if ([[UserDefaultsUtils valueWithKey:@"access_token"] length] != 0) {
        MyOrderViewController *vc = [[MyOrderViewController alloc]init];
        vc.index_id = 1;
        [[[AppDelegate shareAppDelegate] getCurrentUIVC].navigationController pushViewController:vc animated:YES];
    }else{
        [BaseTools showErrorMessage:@"请登录后再操作"];
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [BaseTools alertLoginWithVC:[[AppDelegate shareAppDelegate]getCurrentUIVC]];
        });
    }
}
- (IBAction)noSendAction:(id)sender {
    if ([[UserDefaultsUtils valueWithKey:@"access_token"] length] != 0) {
        MyOrderViewController *vc = [[MyOrderViewController alloc]init];
        vc.index_id = 2;
        [[[AppDelegate shareAppDelegate] getCurrentUIVC].navigationController pushViewController:vc animated:YES];
    }else{
        [BaseTools showErrorMessage:@"请登录后再操作"];
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [BaseTools alertLoginWithVC:[[AppDelegate shareAppDelegate]getCurrentUIVC]];
        });
    }
}
- (IBAction)noReceiveAction:(id)sender {
    if ([[UserDefaultsUtils valueWithKey:@"access_token"] length] != 0) {
        MyOrderViewController *vc = [[MyOrderViewController alloc]init];
        vc.index_id = 3;
        [[[AppDelegate shareAppDelegate] getCurrentUIVC].navigationController pushViewController:vc animated:YES];
    }else{
        [BaseTools showErrorMessage:@"请登录后再操作"];
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [BaseTools alertLoginWithVC:[[AppDelegate shareAppDelegate]getCurrentUIVC]];
        });
    }
}
- (IBAction)afterSaleAction:(id)sender {
    if ([[UserDefaultsUtils valueWithKey:@"access_token"] length] != 0) {
        MyOrderViewController *vc = [[MyOrderViewController alloc]init];
        vc.index_id = 5;
        [[[AppDelegate shareAppDelegate] getCurrentUIVC].navigationController pushViewController:vc animated:YES];
    }else{
        [BaseTools showErrorMessage:@"请登录后再操作"];
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [BaseTools alertLoginWithVC:[[AppDelegate shareAppDelegate]getCurrentUIVC]];
        });
    }
}
- (IBAction)orderAction:(id)sender {
    if ([[UserDefaultsUtils valueWithKey:@"access_token"] length] != 0) {
        MyOrderViewController *vc = [[MyOrderViewController alloc]init];
        vc.index_id = 0;
       [[[AppDelegate shareAppDelegate] getCurrentUIVC].navigationController pushViewController:vc animated:YES];
    }else{
        [BaseTools showErrorMessage:@"请登录后再操作"];
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [BaseTools alertLoginWithVC:[[AppDelegate shareAppDelegate]getCurrentUIVC]];
        });
    }

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
