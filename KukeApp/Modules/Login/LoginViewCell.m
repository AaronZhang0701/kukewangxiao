//
//  LoginViewCell.m
//  KukeApp
//
//  Created by iOSDeveloper on 2018/9/21.
//  Copyright © 2018年 zhangming. All rights reserved.
//

#import "LoginViewCell.h"
#import "BindingPhoneViewController.h"
#import "ForgetPasswordController.h"
#import <ReactiveObjC/ReactiveObjC.h>
#import "NSDictionary+ZMAdd.h"
static NSString * const QYKey = @"key";
static NSString * const QYValue = @"value";
static NSString * const QYHidden = @"hidden";
static NSString * const QYIndex = @"index";
static NSString * const QYLabel = @"label";

@interface LoginViewCell (){
    NSDictionary *statisticsDit;
    NSString *statisticsStr;
}

@end

@implementation LoginViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.forgetPasswordBtn.hidden = YES;
    //这里设置的是左上和左下角
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.getCodeBtn.bounds byRoundingCorners:UIRectCornerBottomRight| UIRectCornerTopRight    cornerRadii:CGSizeMake(8, 8)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.getCodeBtn.bounds;
    maskLayer.path = maskPath.CGPath;
    self.getCodeBtn.layer.mask = maskLayer;

    self.view1.layer.cornerRadius = 5;
    self.view1.layer.masksToBounds  = YES;
    self.view2.layer.cornerRadius = 5;
    self.view2.layer.masksToBounds  = YES;

    self.loginBtn.layer.cornerRadius = 5;
    self.loginBtn.layer.masksToBounds = YES;

    
//    [self.codeBtn addTarget:self action:@selector(getCodeAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.loginBtn addTarget:self action:@selector(loginAction:) forControlEvents:UIControlEventTouchUpInside];
    // 创建验证用户名的信道
    RACSignal *validUsernameSignal = [self.phoneText.rac_textSignal
                                      map:^id(NSString *text) {
                                          return @([BaseTools valiMobile:text]);
                                      }];
    
    // 创建验证密码的信号
    RACSignal *validPasswordSignal = [self.codeText.rac_textSignal
                                      map:^id(NSString *text) {
                                          return @([self isValidPassword:text]);
                                      }];
    
    
    // 通过信道返回的值，设置文本框的文字色
    RAC(self.phoneText, textColor) = [validUsernameSignal
                                              map:^id(NSNumber *usernameValid) {
                                                  return [usernameValid boolValue] ? [UIColor blackColor]:[UIColor grayColor];
                                              }];
    
    
    // 通过信道返回的值，设置文本框的文字色
    RAC(self.codeText, textColor) = [validPasswordSignal
                                              map:^id(NSNumber *passwordValid) {
                                                  return [passwordValid boolValue] ? [UIColor blackColor]:[UIColor grayColor];
                                              }];
    // 创建登录按扭的信号，把用户名与密码合成一个信道
    RACSignal *codeActiveSignal = [RACSignal
                                    combineLatest:@[
                                                    validUsernameSignal
                                                    ]
                                    reduce:^id(NSNumber*usernameValid) {
                                        return @([usernameValid boolValue]);
                                    }];
    
   
    [codeActiveSignal subscribeNext:^(NSNumber*loginActiveSignal) {
        
        if ([loginActiveSignal boolValue]) {
            
            self.getCodeBtn.enabled = YES;
            self.getCodeBtn.backgroundColor = CNavBgColor;
            
            //            [self.loginButton setBackgroundColor:[UIColor colorFromHexCode:@"1cbf61"]];
        }
        else {
            self.getCodeBtn.enabled = NO;
            self.getCodeBtn.backgroundColor = [UIColor colorWithHexString:@"f39094"];
            //            [self.loginButton setBackgroundColor:[UIColor grayColor]];
        }
    }];
    
    // 创建登录按扭的信号，把用户名与密码合成一个信道
    RACSignal *loginActiveSignal = [RACSignal
                                    combineLatest:@[
                                                    validUsernameSignal,
                                                    validPasswordSignal
                                                    ]
                                    reduce:^id(NSNumber*usernameValid, NSNumber *passwordValid) {
                                        return @([usernameValid boolValue] && [passwordValid boolValue]);
                                    }];
    
    
    // 订阅 loginActiveSignal, 使按扭是否可用
    [loginActiveSignal subscribeNext:^(NSNumber*loginActiveSignal) {
        
        if ([loginActiveSignal boolValue]) {
            
            self.loginBtn.enabled = YES;
            self.loginBtn.backgroundColor = CNavBgColor;
            
            //            [self.loginButton setBackgroundColor:[UIColor colorFromHexCode:@"1cbf61"]];
        }
        else {
            self.loginBtn.enabled = NO;
            self.loginBtn.backgroundColor = [UIColor colorWithHexString:@"f39094"];
            //            [self.loginButton setBackgroundColor:[UIColor grayColor]];
        }
    }];
    [[OpenInstallSDK defaultManager] getInstallParmsCompleted:^(OpeninstallData*_Nullable appData) {
        //在主线程中回调
        if (appData.data) {//(动态安装参数)
            
            statisticsDit = appData.data;
            statisticsStr =[[statisticsDit br_toJsonStringNoFormat] base64EncodedString];
            //e.g.如免填邀请码建立邀请关系、自动加好友、自动进入某个群组或房间等
        }
        if (appData.channelCode) {//(通过渠道链接或二维码安装会返回渠道编号)
            //e.g.可自己统计渠道相关数据等
        }

    }];
    // Initialization code
}
- (void)setIsRegister:(NSString *)isRegister{
    if ([isRegister isEqualToString:@"0"]) {
        [self.loginBtn setTitle:@"登录" forState:(UIControlStateNormal)];
        self.agreeBtn.hidden = YES;
        self.readLab.hidden  = YES;
        self.tiaokuanLab.hidden = YES;
        self.zhengcelab.hidden = YES;
         _youkeLogin.hidden = NO;
    }else{
        [self.loginBtn setTitle:@"注册" forState:(UIControlStateNormal)];
        self.passwordLoginBtn.hidden = YES;
        self.forgetPasswordBtn.hidden = YES;
        self.agreeBtn.hidden = NO;
        self.readLab.hidden  = NO;
        self.tiaokuanLab.hidden = NO;
        self.zhengcelab.hidden = NO;
        _youkeLogin.hidden = YES;
        
    }
    
}
// 验证密码的长度
- (BOOL)isValidPassword:(NSString *)password {

        return password.length > 5;

    
}
- (IBAction)getCodeClike:(JKCountDownButton *)sender {
    sender.enabled = NO;
    //button type要 设置成custom 否则会闪动
    
    if ([BaseTools valiMobile:self.phoneText.text]) {

        NSMutableDictionary *parmDic = [NSMutableDictionary dictionary];
        [parmDic setObject:self.phoneText.text forKey:@"mobile"];
        [parmDic setObject:@"login" forKey:@"scene"];
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


- (IBAction)methodLoginAction:(id)sender {
//    if (_myBlock) {
//        self.myBlock(self.passwordLoginBtn.currentTitle);
//    }
    
    if ([[self.passwordLoginBtn currentTitle] isEqualToString:@"账号密码登录"]) {
    
        self.imagePhone.image = [UIImage imageNamed:@"手机"];
        self.imageCode.image = [UIImage imageNamed:@"验证码"];
        self.phoneText.placeholder = @"请输入账号/手机号码";
        self.codeText.placeholder = @"请输入您的密码";
        self.getCodeBtn.hidden = YES;
        self.codeText.secureTextEntry = YES;
//        self.phoneText.text = @"";
        self.codeText.text = @"";
        [self.passwordLoginBtn setTitle:@"手机快捷登录" forState:(UIControlStateNormal)];
        self.forgetPasswordBtn.hidden = NO;
        
    }else{
        self.imagePhone.image = [UIImage imageNamed:@"账号"];
        self.imageCode.image = [UIImage imageNamed:@"密码 (1)"];
        self.codeText.secureTextEntry = NO;
        self.phoneText.placeholder = @"请输入手机号码";
        self.codeText.placeholder = @"请输入验证码";
        self.getCodeBtn.hidden = NO;
//        self.phoneText.text = @"";
        self.codeText.text = @"";
        [self.passwordLoginBtn setTitle:@"账号密码登录" forState:(UIControlStateNormal)];
         self.forgetPasswordBtn.hidden = YES;
    }
}
- (void)loginAction:(UIButton *)button{
    
//    [[ShareInstallSDK getInitializeInstance] getInstallCallBackBlock:^(NSString*jsonStr){
//        if(jsonStr){ //动态安装参数
//            NSDictionary *paramsDic = [self dictionaryWithJsonString:jsonStr];
//            //拿到参数，处理客户自己的逻辑
//        }
//    }];
//
    
    
    if ([self.loginBtn.currentTitle isEqualToString:@"登录"]) {
        
        NSMutableDictionary *parmDic = [NSMutableDictionary dictionary];
        if ([[self.passwordLoginBtn currentTitle] isEqualToString:@"账号密码登录"]) {
            [parmDic setObject:self.codeText.text forKey:@"code"];
        }else{
            [parmDic setObject:self.codeText.text forKey:@"password"];
        }
        [parmDic setObject:self.phoneText.text forKey:@"mobile"];

//        [parmDic setObject:statisticsStr forKey:@"share_data"];
        
        [ZMNetworkHelper POST:@"/user/login" parameters:parmDic cache:NO responseCache:^(id responseCache) {
            
        } success:^(id responseObject) {
            if (responseObject == nil) {
                
            }else{
                if ([responseObject[@"code"] isEqualToString:@"0"]) {
                    [UserInfoTool initialize];
                    [UserInfoTool deleteListData];
                    CurrentUserInfo *userInfo = [[CurrentUserInfo alloc]init];
                    userInfo.token = responseObject[@"data"][@"access_token"];
                    userInfo.NiName = responseObject[@"data"][@"stu_name"];
                    userInfo.Tel = responseObject[@"data"][@"mobile"];
                    userInfo.StudentID = responseObject[@"data"][@"stu_id"];
                    userInfo.photo = responseObject[@"data"][@"photo"];
                    [UserInfoTool addPerson:userInfo];
                    
                    [UserDefaultsUtils saveValue:responseObject[@"data"][@"stu_id"] forKey:@"user_id"];
                    [UserDefaultsUtils saveValue:responseObject[@"data"][@"access_token"] forKey:@"access_token"];
                    //                [UserDefaultsUtils saveValue:self.codeText.text  forKey:@"userPassword"];
                    //                [UserDefaultsUtils saveValue:self.phoneText.text forKey:@"userMobile"];
                    [UserDefaultsUtils saveValue:@"0"  forKey:@"IsYouKe"];
                    
                    if ([responseObject[@"data"][@"photo"] isEqualToString:@"18317726063"]) {
                        [UserDefaultsUtils saveBoolValue:YES withKey:KIsAudit];
                    }
                    KPostNotification(KNotificationLoginUpdata, nil);
                    [JPUSHService setAlias:responseObject[@"data"][@"stu_id"] completion:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
                        NSLog(@"iResCode = %ld, iTags = %ld, iAlias = %@",iResCode,seq,iAlias);
                    } seq:1];
                    
                    QYUserInfo *QYuserInfo = [[QYUserInfo alloc] init];
                    QYuserInfo.userId = responseObject[@"data"][@"stu_id"];
                    NSDictionary *nameDict = @{
                                               QYKey : @"real_name",
                                               QYValue : responseObject[@"data"][@"stu_name"],
                                               };
                   
                    NSArray *array = @[nameDict];
                    NSData *data = [NSJSONSerialization dataWithJSONObject:array options:0 error:nil];
                    if (data) {
                        QYuserInfo.data = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                    }
                
                    [[[QYSDK sharedSDK] customUIConfig] setCustomerHeadImageUrl:responseObject[@"data"][@"photo"]];
                    [[QYSDK sharedSDK] setUserInfo:QYuserInfo];
                    
                    //返回上一个界面
                    dispatch_async(dispatch_get_main_queue(), ^{
                        //                    KPostNotification(KNotificationLoginStateChange, @YES)
                        KPostNotification(@"RelodaDetailData", nil);
                        if (_myBlock) {
                            self.myBlock(self.passwordLoginBtn.currentTitle);
                        }
                    });
                    
                }else{
                    [BaseTools showErrorMessage:responseObject[@"msg"]];
                }
            }
        } failure:^(NSError *error) {
            
        }];
    }else{
        if (self.agreeBtn.selected) {
            NSMutableDictionary *parmDic = [NSMutableDictionary dictionary];
            if ([[self.passwordLoginBtn currentTitle] isEqualToString:@"账号密码登录"]) {
                [parmDic setObject:self.codeText.text forKey:@"code"];
            }else{
                [parmDic setObject:self.codeText.text forKey:@"password"];
            }
            [parmDic setObject:self.phoneText.text forKey:@"mobile"];
            
            [parmDic setObject:[[statisticsDit br_toJsonStringNoFormat] base64EncodedString] forKey:@"share_data"];
            
            [ZMNetworkHelper POST:@"/user/login" parameters:parmDic cache:NO responseCache:^(id responseCache) {
                
            } success:^(id responseObject) {
                if (responseObject == nil) {
                    
                }else{
                    if ([responseObject[@"code"] isEqualToString:@"0"]) {
                        [UserInfoTool initialize];
                        [UserInfoTool deleteListData];
                        CurrentUserInfo *userInfo = [[CurrentUserInfo alloc]init];
                        userInfo.token = responseObject[@"data"][@"access_token"];
                        userInfo.NiName = responseObject[@"data"][@"stu_name"];
                        userInfo.Tel = responseObject[@"data"][@"mobile"];
                        userInfo.StudentID = responseObject[@"data"][@"stu_id"];
                        userInfo.photo = responseObject[@"data"][@"photo"];
                        [UserInfoTool addPerson:userInfo];
                        [UserDefaultsUtils saveValue:responseObject[@"data"][@"stu_id"] forKey:@"user_id"];
                        [UserDefaultsUtils saveValue:responseObject[@"data"][@"access_token"] forKey:@"access_token"];
                        //                [UserDefaultsUtils saveValue:self.codeText.text  forKey:@"userPassword"];
                        //                [UserDefaultsUtils saveValue:self.phoneText.text forKey:@"userMobile"];
                        [UserDefaultsUtils saveValue:@"0"  forKey:@"IsYouKe"];
                        
                        KPostNotification(KNotificationLoginUpdata, nil);
                        [JPUSHService setAlias:responseObject[@"data"][@"stu_id"] completion:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
                            NSLog(@"iResCode = %ld, iTags = %ld, iAlias = %@",iResCode,seq,iAlias);
                        } seq:1];
                        QYUserInfo *QYuserInfo = [[QYUserInfo alloc] init];
                        QYuserInfo.userId = responseObject[@"data"][@"stu_id"];
                        NSDictionary *nameDict = @{
                                                   QYKey : @"real_name",
                                                   QYValue : responseObject[@"data"][@"stu_name"],
                                                   };
                        
                        NSArray *array = @[nameDict];
                        NSData *data = [NSJSONSerialization dataWithJSONObject:array options:0 error:nil];
                        if (data) {
                            QYuserInfo.data = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                        }
                        
                        [[[QYSDK sharedSDK] customUIConfig] setCustomerHeadImageUrl:responseObject[@"data"][@"photo"]];
                        [[QYSDK sharedSDK] setUserInfo:QYuserInfo];
                        //返回上一个界面
                        dispatch_async(dispatch_get_main_queue(), ^{
                            //                    KPostNotification(KNotificationLoginStateChange, @YES)
                            KPostNotification(@"RelodaDetailData", nil);
                            if (_myBlock) {
                                self.myBlock(self.passwordLoginBtn.currentTitle);
                            }
                        });
                        //用户注册成功后调用
                        [OpenInstallSDK reportRegister];
//                        //使用Shareinstall控制中心提供的渠道统计时，在App用户注册完成后调用，可以统计渠道注册量
//                        [ShareInstallSDK reportRegister];
                    }else{
                        [BaseTools showErrorMessage:responseObject[@"msg"]];
                    }
                }
            } failure:^(NSError *error) {
                
            }];
        }else{
            [BaseTools showErrorMessage:@"请阅读并同意协议后再进行操作"];
        }
    }

    
}
- (IBAction)forgetAction:(id)sender {
    ForgetPasswordController *vc = [[ForgetPasswordController alloc]init];
    [[[AppDelegate shareAppDelegate] getCurrentUIVC].navigationController pushViewController:vc animated:YES];
}
- (IBAction)wxLoginAction:(id)sender {
//    if (self.agreeBtn.selected) {
        [[UMSocialManager defaultManager] getUserInfoWithPlatform:UMSocialPlatformType_WechatSession currentViewController:nil completion:^(id result, NSError *error) {
            if (error) {
                
            } else {
                UMSocialUserInfoResponse *resp = result;
                [self loginWithQQorWeixin:@"Weixin" data:resp];
                // 授权信息
                NSLog(@"Wechat uid: %@", resp.uid);
                NSLog(@"Wechat openid: %@", resp.openid);
                NSLog(@"Wechat unionid: %@", resp.unionId);
                NSLog(@"Wechat accessToken: %@", resp.accessToken);
                NSLog(@"Wechat refreshToken: %@", resp.refreshToken);
                NSLog(@"Wechat expiration: %@", resp.expiration);
                
                // 用户信息
                NSLog(@"Wechat name: %@", resp.name);
                NSLog(@"Wechat iconurl: %@", resp.iconurl);
                NSLog(@"Wechat gender: %@", resp.unionGender);
                
                // 第三方平台SDK源数据
                NSLog(@"Wechat originalResponse: %@", resp.originalResponse);
            }
        }];
        
//    }else{
//        [BaseTools showErrorMessage:@"请阅读并同意协议后再进行操作"];
//    }
    
}
- (IBAction)qqLoginAction:(id)sender {
    

    
//    if (self.agreeBtn.selected) {
        [[UMSocialManager defaultManager] getUserInfoWithPlatform:UMSocialPlatformType_QQ currentViewController:nil completion:^(id result, NSError *error) {
            if (error) {

            } else {
                UMSocialUserInfoResponse *resp = result;
                [self loginWithQQorWeixin:@"QQ" data:resp];
                // 授权信息
                NSLog(@"QQ uid: %@", resp.uid);
                NSLog(@"QQ openid: %@", resp.openid);
                NSLog(@"QQ unionid: %@", resp.unionId);
                NSLog(@"QQ accessToken: %@", resp.accessToken);
                NSLog(@"QQ expiration: %@", resp.expiration);

                // 用户信息
                NSLog(@"QQ name: %@", resp.name);
                NSLog(@"QQ iconurl: %@", resp.iconurl);
                NSLog(@"QQ gender: %@", resp.unionGender);

                // 第三方平台SDK源数据
                NSLog(@"QQ originalResponse: %@", resp.originalResponse);
            }
        }];
//
//    }else{
//        [BaseTools showErrorMessage:@"请阅读并同意协议后再进行操作"];
//    }

}
- (void)loginWithQQorWeixin:(NSString *)type data:(UMSocialUserInfoResponse *)resp{
    NSMutableDictionary *parmDic = [NSMutableDictionary dictionary];
    [parmDic setObject:type forKey:@"type"];
    [parmDic setObject:resp.openid forKey:@"oauth_open_id"];
    [parmDic setObject:resp.unionId forKey:@"oauth_union_id"];
    [ZMNetworkHelper POST:@"/oauth/oauth_login" parameters:parmDic cache:NO responseCache:^(id responseCache) {
        
    } success:^(id responseObject) {
        if (responseObject == nil) {
            
        }else{
            if ([responseObject[@"code"] isEqualToString:@"0"]) {
                [UserInfoTool initialize];
                [UserInfoTool deleteListData];
                CurrentUserInfo *userInfo = [[CurrentUserInfo alloc]init];
                userInfo.token = responseObject[@"data"][@"access_token"];
                userInfo.NiName = responseObject[@"data"][@"stu_name"];
                userInfo.Tel = responseObject[@"data"][@"mobile"];
                userInfo.StudentID = responseObject[@"data"][@"stu_id"];
                userInfo.photo = responseObject[@"data"][@"photo"];
                [UserInfoTool addPerson:userInfo];
                [UserDefaultsUtils saveValue:responseObject[@"data"][@"stu_id"] forKey:@"user_id"];
                [UserDefaultsUtils saveValue:responseObject[@"data"][@"access_token"] forKey:@"access_token"];
                KPostNotification(KNotificationLoginUpdata, nil);
                [JPUSHService setAlias:responseObject[@"data"][@"stu_id"] completion:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
                    NSLog(@"iResCode = %ld, iTags = %ld, iAlias = %@",iResCode,seq,iAlias);
                } seq:1];
                QYUserInfo *QYuserInfo = [[QYUserInfo alloc] init];
                QYuserInfo.userId = responseObject[@"data"][@"stu_id"];
                NSDictionary *nameDict = @{
                                           QYKey : @"real_name",
                                           QYValue : responseObject[@"data"][@"stu_name"],
                                           };
                
                NSArray *array = @[nameDict];
                NSData *data = [NSJSONSerialization dataWithJSONObject:array options:0 error:nil];
                if (data) {
                    QYuserInfo.data = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                }
                
                [[[QYSDK sharedSDK] customUIConfig] setCustomerHeadImageUrl:responseObject[@"data"][@"photo"]];
                [[QYSDK sharedSDK] setUserInfo:QYuserInfo];
                //返回上一个界面
                dispatch_async(dispatch_get_main_queue(), ^{
                    KPostNotification(@"RelodaDetailData", nil);
                    if (_myBlock) {
                        self.myBlock(self.passwordLoginBtn.currentTitle);
                    }
                });
            }else if ([responseObject[@"code"] isEqualToString:@"1"]){
                dispatch_async(dispatch_get_main_queue(), ^{
                    BindingPhoneViewController *vc = [[BindingPhoneViewController alloc]init];
                    vc.resp = resp;
                    vc.loginType = type;
                    [[[AppDelegate shareAppDelegate] getCurrentUIVC].navigationController pushViewController:vc animated:YES];
                });
                
            }else{
                [BaseTools showErrorMessage:responseObject[@"msg"]];
            }
        }
    } failure:^(NSError *error) {
        
    }];
}
- (IBAction)youkeAction:(id)sender {

        [UserDefaultsUtils saveBoolValue:YES withKey:KIsAudit];

        NSMutableDictionary *parmDic = [NSMutableDictionary dictionary];
        [parmDic setObject:[OpenUDID value] forKey:@"uuid"];
        [ZMNetworkHelper POST:@"/user/guest_login" parameters:parmDic cache:NO responseCache:^(id responseCache) {
            
        } success:^(id responseObject) {
            if (responseObject == nil) {
                
            }else{
                if ([responseObject[@"code"] isEqualToString:@"0"]) {
                    [UserInfoTool initialize];
                    [UserInfoTool deleteListData];
                    CurrentUserInfo *userInfo = [[CurrentUserInfo alloc]init];
                    userInfo.token = responseObject[@"data"][@"access_token"];
                    userInfo.NiName = responseObject[@"data"][@"stu_name"];
                    userInfo.Tel = responseObject[@"data"][@"mobile"];
                    userInfo.StudentID = responseObject[@"data"][@"stu_id"];
                    userInfo.photo = responseObject[@"data"][@"photo"];
                    [UserInfoTool addPerson:userInfo];
                    [UserDefaultsUtils saveValue:responseObject[@"data"][@"stu_id"] forKey:@"user_id"];
                    [UserDefaultsUtils saveValue:responseObject[@"data"][@"access_token"] forKey:@"access_token"];
                    [UserDefaultsUtils saveValue:@"1"  forKey:@"IsYouKe"];
//                    KPostNotification(KNotificationLoginUpdata, nil);
//                    KPostNotification(@"RelodaDetailData", nil);
                    [JPUSHService setAlias:responseObject[@"data"][@"stu_id"] completion:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
                        NSLog(@"iResCode = %ld, iTags = %ld, iAlias = %@",iResCode,seq,iAlias);
                    } seq:1];
                    QYUserInfo *QYuserInfo = [[QYUserInfo alloc] init];
                    QYuserInfo.userId = responseObject[@"data"][@"stu_id"];
                    NSDictionary *nameDict = @{
                                               QYKey : @"real_name",
                                               QYValue : responseObject[@"data"][@"stu_name"],
                                               };
                    
                    NSArray *array = @[nameDict];
                    NSData *data = [NSJSONSerialization dataWithJSONObject:array options:0 error:nil];
                    if (data) {
                        QYuserInfo.data = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                    }
                    [[[QYSDK sharedSDK] customUIConfig] setCustomerHeadImageUrl:responseObject[@"data"][@"photo"]];

                    [[QYSDK sharedSDK] setUserInfo:QYuserInfo];
                    //返回上一个界面
                    dispatch_async(dispatch_get_main_queue(), ^{
                        KPostNotification(@"RelodaDetailData", nil);
                        if (_myBlock) {
                            self.myBlock(self.passwordLoginBtn.currentTitle);
                        }
                    });
                    
                }else{
                    
                    [BaseTools showErrorMessage:responseObject[@"msg"]];
                }
            }
        } failure:^(NSError *error) {
            
            
        }];
//    }else{
//        [BaseTools showErrorMessage:@"请阅读并同意协议后再进行操作"];
//    }
    
    
    
   
}
- (IBAction)agreeAction:(UIButton *)sender {
    
    sender.selected = !sender.selected;
    if (sender.selected) {
        
        self.agreeBtn.selected = YES;
    }else{
        self.agreeBtn.selected = NO;
        
    }
}
- (IBAction)serviceAction:(id)sender {
    HomePageBannerViewController *vc = [[HomePageBannerViewController alloc]init];
    vc.url = [NSString stringWithFormat:@"%@/help/term",SERVER_HOSTM];
    vc.title = @"服务条款";
    [[[AppDelegate shareAppDelegate] getCurrentUIVC].navigationController pushViewController:vc animated:YES];
}
- (IBAction)policyAction:(id)sender {
    HomePageBannerViewController *vc = [[HomePageBannerViewController alloc]init];
    vc.url = [NSString stringWithFormat:@"%@/help/policy",SERVER_HOSTM];
    vc.title = @"售后政策";
    [[[AppDelegate shareAppDelegate] getCurrentUIVC].navigationController pushViewController:vc animated:YES];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self endEditing:YES];
}

#pragma mark json转字典
-(NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString
{
    if (jsonString == nil) {
        return @{};
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    if (!jsonData) {
        return nil;
    }
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err)
    {
        return @{};
    }
    return dic;
}
@end
