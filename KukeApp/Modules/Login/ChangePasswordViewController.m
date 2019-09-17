//
//  ChangePasswordViewController.m
//  KukeApp
//
//  Created by 库课 on 2019/3/22.
//  Copyright © 2019 KukeZangMing. All rights reserved.
//

#import "ChangePasswordViewController.h"

@interface ChangePasswordViewController ()

@end

@implementation ChangePasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"修改密码";
    
    self.view1.layer.cornerRadius = 5;
    self.view1.layer.masksToBounds = YES;

    self.view2.layer.cornerRadius = 5;
    self.view2.layer.masksToBounds = YES;
    
    self.commitBtn.layer.cornerRadius = 5;
    self.commitBtn.layer.masksToBounds = YES;
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)getCodeAction:(JKCountDownButton *)sender {
    sender.enabled = NO;
    CurrentUserInfo *info= nil;
    NSMutableDictionary *parmDic = [NSMutableDictionary dictionary];
    if ([UserInfoTool persons].count != 0) {
        info = [UserInfoTool persons][0];
        [parmDic setObject:info.Tel forKey:@"mobile"];
    }
    [parmDic setObject:@"set_password" forKey:@"scene"];
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
                sender.enabled = YES;
                [BaseTools showErrorMessage:responseObject[@"msg"]];
            }
        }
    } failure:^(NSError *error) {
        sender.enabled = YES;
        
    }];
    
   
}
- (IBAction)commitAction:(id)sender {
    NSMutableDictionary *parmDic = [NSMutableDictionary dictionary];
    [parmDic setObject:self.codetext.text forKey:@"code"];
    [parmDic setObject:self.passwordText.text forKey:@"newPassword"];
    [ZMNetworkHelper POST:@"/user/set_password" parameters:parmDic cache:NO responseCache:^(id responseCache) {
        
    } success:^(id responseObject) {
        if (responseObject == nil) {
            
        }else{
            if ([responseObject[@"code"] isEqualToString:@"0"]) {
                [BaseTools showErrorMessage:responseObject[@"msg"]];
                [UserInfoTool deleteListData];
                [UserDefaultsUtils saveValue:@"" forKey:@"access_token"];
                [UserDefaultsUtils saveValue:@"0"  forKey:@"IsYouKe"];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                     [BaseTools alertLoginWithVC:self];
                });
                
                
            }else{
                [BaseTools showErrorMessage:responseObject[@"msg"]];
            }
        }
    } failure:^(NSError *error) {
        
    }];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES]; //实现该方法是需要注意view需要是继承UIControl而来的
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
