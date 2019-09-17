//
//  ForgetPasswordController.m
//  KukeApp
//
//  Created by iOSDeveloper on 2018/9/21.
//  Copyright © 2018年 zhangming. All rights reserved.
//

#import "ForgetPasswordController.h"

@interface ForgetPasswordController ()

@end

@implementation ForgetPasswordController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"忘记密码";
    // Do any additional setup after loading the view from its nib.
}




- (IBAction)getCode:(JKCountDownButton *)sender {
    sender.enabled = NO;
    //button type要 设置成custom 否则会闪动
    
    if ([BaseTools valiMobile:self.tel.text]) {
    NSMutableDictionary *parmDic = [NSMutableDictionary dictionary];
    [parmDic setObject:self.tel.text forKey:@"mobile"];
    [parmDic setObject:@"find_password" forKey:@"scene"];
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
    }else{
        
        [BaseTools showErrorMessage:@"请检查手机号是否输入正确"];
        sender.enabled = YES;
    }
}
- (IBAction)commit:(id)sender {
    
    if (self.password.text.length <6) {
        [BaseTools showErrorMessage:@"请输入6位以上数字加字母密码"];
    }else{
        NSMutableDictionary *parmDic = [NSMutableDictionary dictionary];
        [parmDic setObject:self.tel.text forKey:@"mobile"];
        [parmDic setObject:self.code.text forKey:@"code"];
        [parmDic setObject:self.password.text forKey:@"password"];
        [parmDic setObject:self.secondPassword.text forKey:@"re_password"];
        
        [ZMNetworkHelper POST:@"/user/find_password" parameters:parmDic cache:NO responseCache:^(id responseCache) {
            
        } success:^(id responseObject) {
            if (responseObject == nil) {
                
            }else{
                if ([responseObject[@"code"] isEqualToString:@"0"]) {
                    [BaseTools showErrorMessage:responseObject[@"msg"]];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.navigationController popViewControllerAnimated:YES];
                    });
                    
                }else{
                    [BaseTools showErrorMessage:responseObject[@"msg"]];
                }
            }
        } failure:^(NSError *error) {
            
        }];
    }
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
