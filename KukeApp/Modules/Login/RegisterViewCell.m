//
//  RegisterViewCell.m
//  KukeApp
//
//  Created by iOSDeveloper on 2018/9/21.
//  Copyright © 2018年 zhangming. All rights reserved.
//

#import "RegisterViewCell.h"

@implementation RegisterViewCell

- (void)awakeFromNib {
    [super awakeFromNib];

    // Initialization code
}
- (IBAction)getCodeAction:(id)sender {
   if ([BaseTools valiMobile:self.phoneText.text]) {
        [self postCode];
    }else{
        
        [BaseTools showErrorMessage:@"请检查手机号是否输入正确"];
    }
    
}
- (void)postCode{
    
    NSMutableDictionary *parmDic = [NSMutableDictionary dictionary];
    [parmDic setObject:self.phoneText.text forKey:@"mobile"];
    [parmDic setObject:@"register" forKey:@"scene"];
    [ZMNetworkHelper POST:@"/user/send_sms_code" parameters:parmDic cache:NO responseCache:^(id responseCache) {
        
    } success:^(id responseObject) {
        if (responseObject == nil) {
            
        }else{
            if ([responseObject[@"code"] isEqualToString:@"0"]) {
                self.codeBtn.time = 59;
                self.codeBtn.format = @"%ld秒后重试";
                [self.codeBtn startTimer];
            }else{
                [BaseTools showErrorMessage:responseObject[@"msg"]];
            }
        }
    } failure:^(NSError *error) {
        
    }];
    
    
}
- (IBAction)registerAction:(id)sender {
    
    [self postRegister];
    
}
- (void)postRegister{
    NSMutableDictionary *parmDic = [NSMutableDictionary dictionary];
    [parmDic setObject:self.userNameText.text forKey:@"name"];
    [parmDic setObject:self.phoneText.text forKey:@"mobile"];
    [parmDic setObject:self.codeText.text forKey:@"code"];
    [parmDic setObject:self.passwordText.text forKey:@"password"];
    [ZMNetworkHelper POST:@"/user/register" parameters:parmDic cache:NO responseCache:^(id responseCache) {
        
    } success:^(id responseObject) {
        if (responseObject == nil) {
            
        }else{
            if ([responseObject[@"code"] isEqualToString:@"0"]) {
                 [BaseTools showErrorMessage:responseObject[@"msg"]];
            
                KPostNotification(@"RegisterSuccess", nil);
            }else if ([responseObject[@"code"] isEqualToString:@"-204"]){
                 [BaseTools showErrorMessage:responseObject[@"msg"]];
                 KPostNotification(@"RegisterSuccess", nil);
            }else{
                 [BaseTools showErrorMessage:responseObject[@"msg"]];
            }
        }
    } failure:^(NSError *error) {
        
    }];
}
- (IBAction)readAction:(id)sender {
}

@end
