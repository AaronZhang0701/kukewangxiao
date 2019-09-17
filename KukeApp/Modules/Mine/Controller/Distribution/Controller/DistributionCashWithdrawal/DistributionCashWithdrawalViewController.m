//
//  DistributionCashWithdrawalViewController.m
//  KukeApp
//
//  Created by 库课 on 2019/3/18.
//  Copyright © 2019 KukeZangMing. All rights reserved.
//

#import "DistributionCashWithdrawalViewController.h"
#import "EnableCashWithdrawalListViewController.h"
#import "TotalCashWithdrawViewController.h"
@interface DistributionCashWithdrawalViewController (){
    NSString *moneyStr;
}

@end

@implementation DistributionCashWithdrawalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"提现中心";
    self.codeBtn.layer.cornerRadius = 5;
    self.codeBtn.layer.masksToBounds = YES;
    [self loadData];
    // Do any additional setup after loading the view from its nib.
}

- (void)loadData{

    [ZMNetworkHelper POST:@"/distribution/withdraw_data" parameters:nil cache:NO responseCache:^(id responseCache) {
        
    } success:^(id responseObject) {
        if (responseObject == nil) {
            
        }else{
            if ([responseObject[@"code"] isEqualToString:@"0"]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.enableMoneyLab.text = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"brokerage_balance"]];
                    self.totalMoneyLab.text = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"brokerage_withdrew"]];
                    self.zhufubaoText.text = responseObject[@"data"][@"alipay_num"];
                    self.telText.text = [NSString stringWithFormat:@"手机号码：%@",responseObject[@"data"][@"sms_mobile"]];
                    moneyStr =responseObject[@"data"][@"brokerage_balance"];
                    self.myMoneyLab.text = [NSString stringWithFormat:@"最多可提：%@",self.enableMoneyLab.text];
                });
                
            }else{
                
                [BaseTools showErrorMessage:responseObject[@"msg"]];
            }
        }
    } failure:^(NSError *error) {
        
    }];
}
- (IBAction)enableMoneyAction:(id)sender {
    EnableCashWithdrawalListViewController *vc = [[EnableCashWithdrawalListViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)totalMoneyAction:(id)sender {
    TotalCashWithdrawViewController *vc = [[TotalCashWithdrawViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)getCodeAction:(JKCountDownButton *)sender {
    NSMutableDictionary *parmDic = [NSMutableDictionary dictionary];
    [parmDic setObject:self.telText.text forKey:@"mobile"];
    [parmDic setObject:@"withdraw" forKey:@"scene"];
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
                self.codeBtn.enabled = YES;
                [BaseTools showErrorMessage:responseObject[@"msg"]];
            }
        }
    } failure:^(NSError *error) {
        sender.enabled = YES;
        
    }];
}

- (IBAction)allMoneyAction:(id)sender {
    self.moneyText.text = moneyStr;
}
- (IBAction)cashWithdrawalAction:(id)sender {
    NSMutableDictionary *parmDic = [NSMutableDictionary dictionary];
    [parmDic setObject:self.moneyText.text forKey:@"money"];
    [parmDic setObject:self.zhufubaoText.text forKey:@"alipay_num"];
    [parmDic setObject:self.codeText.text forKey:@"code"];
    [ZMNetworkHelper POST:@"/distribution/withdraw" parameters:parmDic cache:NO responseCache:^(id responseCache) {
        
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
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self.view endEditing:YES];
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
