//
//  BindingPhoneViewController.m
//  KukeApp
//
//  Created by iOSDeveloper on 2018/10/29.
//  Copyright © 2018年 zhangming. All rights reserved.
//

#import "BindingPhoneViewController.h"

@interface BindingPhoneViewController (){
    NSDictionary *statisticsDit;
}

@end

@implementation BindingPhoneViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"绑定手机号";
    self.view1.layer.borderWidth = 0.5f;
    self.view1.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    self.view1.layer.cornerRadius = 5;
    self.view2.layer.borderWidth = 0.5f;
    self.view2.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    self.view2.layer.cornerRadius = 5;
    
    [[OpenInstallSDK defaultManager] getInstallParmsCompleted:^(OpeninstallData*_Nullable appData) {
        //在主线程中回调
        if (appData.data) {//(动态安装参数)
            
            statisticsDit = appData.data;
            //e.g.如免填邀请码建立邀请关系、自动加好友、自动进入某个群组或房间等
        }
        if (appData.channelCode) {//(通过渠道链接或二维码安装会返回渠道编号)
            //e.g.可自己统计渠道相关数据等
        }
        
    }];
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)getCodeAction:(JKCountDownButton *)sender {
    sender.enabled = NO;
    //button type要 设置成custom 否则会闪动
    
  if ([BaseTools valiMobile:self.telText.text]) {
    
        NSMutableDictionary *parmDic = [NSMutableDictionary dictionary];
        [parmDic setObject:self.telText.text forKey:@"mobile"];
        [parmDic setObject:@"bind_phone" forKey:@"scene"];
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

- (IBAction)commitAction:(id)sender {
    NSMutableDictionary *parmDic = [NSMutableDictionary dictionary];

    [parmDic setObject:self.codeText.text forKey:@"code"];
    [parmDic setObject:self.telText.text forKey:@"mobile"];
    [parmDic setObject:self.loginType forKey:@"type"];
    [parmDic setObject:_resp.openid forKey:@"oauth_open_id"];
    [parmDic setObject:_resp.unionId forKey:@"oauth_union_id"];
    [parmDic setObject:_resp.name forKey:@"oauth_nick_name"];
    [parmDic setObject:[[statisticsDit br_toJsonStringNoFormat] base64EncodedString] forKey:@"share_data"];
    [ZMNetworkHelper POST:@"/oauth/oauth_bind" parameters:parmDic cache:NO responseCache:^(id responseCache) {
        
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
                [UserDefaultsUtils saveValue:responseObject[@"data"][@"access_token"] forKey:@"access_token"];
                KPostNotification(KNotificationLoginUpdata, nil);
                //返回上一个界面
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[[AppDelegate shareAppDelegate] getCurrentUIVC].navigationController popToRootViewControllerAnimated:YES];
                });
                [OpenInstallSDK reportRegister];
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
