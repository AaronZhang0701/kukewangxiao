//
//  RegisterDistributionViewController.m
//  KukeApp
//
//  Created by 库课 on 2019/3/14.
//  Copyright © 2019 KukeZangMing. All rights reserved.
//

#import "RegisterDistributionViewController.h"
#import <ReactiveObjC/ReactiveObjC.h>
#import "DistributionCentreViewController.h"
#import "CourseDetailViewController.h"
#import "MineViewController.h"

@interface RegisterDistributionViewController ()

@end

@implementation RegisterDistributionViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view1.layer.cornerRadius = 5;
    self.view1.layer.masksToBounds = YES;
    self.view2.layer.cornerRadius = 5;
    self.view2.layer.masksToBounds = YES;
    self.view3.layer.cornerRadius = 5;
    self.view3.layer.masksToBounds = YES;
    self.view4.layer.cornerRadius = 5;
    self.view4.layer.masksToBounds = YES;

    self.commitBtn.layer.cornerRadius = 5;
    self.commitBtn.layer.masksToBounds = YES;
    self.title = @"申请成为分销员";
    
    [self.userName addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    // 创建验证用户名的信道
    RACSignal *validUsernameSignal = [self.userName.rac_textSignal
                                      map:^id(NSString *text) {
                                          return @([self isValidUserName:text]);
                                      }];
//    // 创建验证支付宝
//    RACSignal *validZFBSignal = [self.zhifubao.rac_textSignal
//                                 map:^id(NSString *text) {
//                                     return @(text.length>0);
//                                 }];
    
//    // 创建验证手机号
//    RACSignal *validTelSignal = [self.userTel.rac_textSignal
//                                      map:^id(NSString *text) {
//                                          return @([BaseTools valiMobile:text]);
//                                      }];
    // 创建验证码
    RACSignal *validCodeSignal = [self.code.rac_textSignal
                                 map:^id(NSString *text) {
                                     return @(text.length == 6);
                                 }];
    
    
    
    // 通过信道返回的值，设置文本框的文字色
    RAC(self.userName, textColor) = [validUsernameSignal
                                      map:^id(NSNumber *usernameValid) {
                                          return [usernameValid boolValue] ? [UIColor blackColor]:[UIColor grayColor];
                                      }];
    
    
//    // 通过信道返回的值，设置文本框的文字色
//    RAC(self.zhifubao, textColor) = [validZFBSignal
//                                     map:^id(NSNumber *ZFBValid) {
//                                         return [ZFBValid boolValue] ? [UIColor blackColor]:[UIColor grayColor];
//                                     }];
    
//    // 通过信道返回的值，设置文本框的文字色
//    RAC(self.userTel, textColor) = [validTelSignal
//                                     map:^id(NSNumber *TElValid) {
//                                         return [TElValid boolValue] ? [UIColor blackColor]:[UIColor grayColor];
//                                     }];
    
    // 通过信道返回的值，设置文本框的文字色
    RAC(self.code, textColor) = [validCodeSignal
                                    map:^id(NSNumber *codeValid) {
                                        return [codeValid boolValue] ? [UIColor blackColor]:[UIColor grayColor];
                                    }];
    
    
    
//    // 创建登录按扭的信号，把用户名与密码合成一个信道
//    RACSignal *codeActiveSignal = [RACSignal
//                                   combineLatest:@[
//                                                   validTelSignal
//                                                   ]
//                                   reduce:^id(NSNumber*TElValid) {
//                                       return @([TElValid boolValue]);
//                                   }];
//
//
//
//    [codeActiveSignal subscribeNext:^(NSNumber* getCodeActiveSignal) {
//
//        if ([getCodeActiveSignal boolValue]) {
//
//            self.getCodeBtn.enabled = YES;
//            self.getCodeBtn.backgroundColor = CNavBgColor;
//        }
//        else {
//            self.getCodeBtn.enabled = NO;
//            self.getCodeBtn.backgroundColor = [UIColor colorWithHexString:@"f39094"];
//        }
//    }];
    
    // 创建登录按扭的信号，把用户名与密码合成一个信道
    RACSignal *commitActiveSignal = [RACSignal
                                    combineLatest:@[
                                                    validUsernameSignal,
//                                                    validZFBSignal,
//                                                    validTelSignal,
                                                    validCodeSignal
                                                    ]
                                    reduce:^id(NSNumber *usernameValid,  NSNumber *codeValid) {
                                        return @([usernameValid boolValue]  && [codeValid boolValue]);
                                    }];
    
    
    // 订阅 loginActiveSignal, 使按扭是否可用
    [commitActiveSignal subscribeNext:^(NSNumber *commitActiveSignal) {
        
        if ([commitActiveSignal boolValue]) {
            
            self.commitBtn.enabled = YES;
            self.commitBtn.backgroundColor = CNavBgColor;

        }
        else {
            self.commitBtn.enabled = NO;
            self.commitBtn.backgroundColor = [UIColor colorWithHexString:@"f39094"];
        }
    }];

    CurrentUserInfo *info= nil;
    if ([UserInfoTool persons].count != 0) {
        info = [UserInfoTool persons][0];
        self.userTel.text = info.Tel;
        self.userTel.userInteractionEnabled = NO;
    }
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)getCodeAction:(JKCountDownButton *)sender {
    sender.enabled = NO;
    //button type要 设置成custom 否则会闪动
    
    if ([BaseTools valiMobile:self.userTel.text]) {
        
        NSMutableDictionary *parmDic = [NSMutableDictionary dictionary];
        [parmDic setObject:self.userTel.text forKey:@"mobile"];
        [parmDic setObject:@"dist_register" forKey:@"scene"];
        [ZMNetworkHelper POST:@"/user/send_sms_code" parameters:parmDic cache:NO responseCache:^(id responseCache) {
            
        } success:^(id responseObject) {
            if (responseObject == nil) {
                
            }else{
                if ([responseObject[@"code"] isEqualToString:@"0"]) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [sender startCountDownWithSecond:59];
                        
                        [sender countDownChanging:^NSString *(JKCountDownButton *countDownButton,NSUInteger second) {
                            NSString *title = [NSString stringWithFormat:@"%zd秒后重试",second];
                            return title;
                        }];
                        [sender countDownFinished:^NSString *(JKCountDownButton *countDownButton, NSUInteger second) {
                            countDownButton.enabled = YES;
                            return @"获取验证码";
                            
                        }];
                    });
                    
                }else{
                    self.getCodeBtn.enabled = YES;
                    [BaseTools showErrorMessage:responseObject[@"msg"]];
                }
            }
        } failure:^(NSError *error) {
            sender.enabled = YES;
            
        }];
    }else{
        
        [BaseTools showErrorMessage:@"请检查手机号是否输入正确"];
        sender.enabled = YES;
    }
}
- (IBAction)agreeAction:(UIButton *)sender {
    
    sender.selected = !sender.selected;
    if (sender.selected) {
        
        self.agreeBtn.selected = YES;
    }else{
        self.agreeBtn.selected = NO;
        
    }
}
- (IBAction)protocolAction:(id)sender {
    HomePageBannerViewController *vc = [[HomePageBannerViewController alloc]init];
    vc.url = [NSString stringWithFormat:@"%@/distribution/agreement",SERVER_HOSTM];
    vc.title = @"库课网校分销员协议";
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)commitAction:(id)sender {

    if (self.agreeBtn.selected) {

        if (self.zhifubao.text.length == 11) {
            NSMutableDictionary *parmDic = [NSMutableDictionary dictionary];
            [parmDic setObject:self.zhifubao.text forKey:@"pmobile"];
            [ZMNetworkHelper POST:@"/distribution/check_pdistor" parameters:parmDic cache:NO responseCache:^(id responseCache) {
                
            } success:^(id responseObject) {
                if (responseObject == nil) {
                    
                }else{
                    if ([responseObject[@"code"] isEqualToString:@"0"]) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self postRegisterData];
                        });
                        
                    }else{
                        
                        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"邀请人手机号无效，确定提交吗？" preferredStyle:UIAlertControllerStyleAlert];
                        UIAlertAction *actionOne = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                            [self postRegisterData];
                            
                        }];
                        UIAlertAction *actionTwo = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
                        [alertController addAction:actionOne];
                        [alertController addAction:actionTwo];
                        [self presentViewController:alertController animated:YES completion:nil];
                    }
                }
            } failure:^(NSError *error) {
                
                
            }];
        }else if (self.zhifubao.text.length == 0 || self.zhifubao.text == nil) {
            [self postRegisterData];
        }else{
            [BaseTools showErrorMessage:@"您输入的邀请人账号有误！"];
        }
    }else{
        [BaseTools showErrorMessage:@"请阅读并同意协议后再进行操作"];
    }
}
- (void)postRegisterData{
    NSMutableDictionary *parmDic = [NSMutableDictionary dictionary];
    [parmDic setObject:self.userName.text forKey:@"truename"];
    [parmDic setObject:self.userTel.text forKey:@"mobile"];
    [parmDic setObject:self.code.text forKey:@"code"];
    [parmDic setObject:self.zhifubao.text forKey:@"pmobile"];
    [ZMNetworkHelper POST:@"/distribution/distributor_register" parameters:parmDic cache:NO responseCache:^(id responseCache) {
        
    } success:^(id responseObject) {
        if (responseObject == nil) {
            
        }else{
            if ([responseObject[@"code"] isEqualToString:@"0"]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [BaseTools showErrorMessage:responseObject[@"msg"]];
                    if ([self.rootVC isEqualToString:@"个人中心"]) {
                        if ([responseObject[@"data"] isEqualToString:@"0"]) {//需审核
                            [self.navigationController popToRootViewControllerAnimated:YES];
                        }else{//无需审核
                            DistributionCentreViewController *vc = [[DistributionCentreViewController alloc]init];
                            vc.title = @"分销员中心";
                            vc.isEnable = YES;
                            [self.navigationController pushViewController:vc animated:YES];
                        }
                    }else{
                        if ([responseObject[@"data"] isEqualToString:@"0"]) {//需审核
                            AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                            
                            UITabBarController *tabViewController = (UITabBarController *) appDelegate.window.rootViewController;
                            
                            [tabViewController setSelectedIndex:3];
                            [self.navigationController popToRootViewControllerAnimated:YES];
                        }else{//无需审核
                            KPostNotification(@"RelodaDetailData", nil);
                            int index = (int)[[self.navigationController viewControllers]indexOfObject:self];
                            [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:(index -2)] animated:YES];
                        }
                    }
                    
                });
                
            }else{
                
                [BaseTools showErrorMessage:responseObject[@"msg"]];
            }
        }
    } failure:^(NSError *error) {
        
        
    }];
}
// 验证真实姓名
- (BOOL)isValidUserName:(NSString *)name {
    
    return [name zm_isValidChinese] && name.length>=2;
    
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self.view endEditing:YES];
}
- (void)textFieldDidChange:(UITextField *)textField{
    if (![textField.text zm_isValidChinese]) {
        [BaseTools showErrorMessage:@"请输入10位之内的汉字"];
    }
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
