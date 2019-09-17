//
//  ReturnGoodsViewController.m
//  KukeApp
//
//  Created by iOSDeveloper on 2018/10/23.
//  Copyright © 2018年 zhangming. All rights reserved.
//

#import "ReturnGoodsViewController.h"

@interface ReturnGoodsViewController ()<UITextViewDelegate>

@end

@implementation ReturnGoodsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"退换原因";
    self.myText.delegate = self;
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:self.navigationItem.backBarButtonItem.style target:nil action:nil];
    self.pic.layer.cornerRadius = 5;
    self.pic.layer.masksToBounds = YES;
    
    
    if (self.data) {
        [self.pic sd_setImageWithURL:[NSURL URLWithString:self.data[@"goods"][@"goods_image"]] placeholderImage:[UIImage imageNamed:@"goodsImage"]];
        self.name.text =self.data[@"goods"][@"goods_name"];
        self.price.text = [NSString stringWithFormat:@"%@",self.data[@"third_pay"]];
    }else{
        [self.pic sd_setImageWithURL:[NSURL URLWithString:self.orderData.goods[@"goods_image"]] placeholderImage:[UIImage imageNamed:@"goodsImage"]];
        self.name.text =self.orderData.goods[@"goods_name"];
        self.price.text = [NSString stringWithFormat:@"%@",self.orderData.third_pay];
    }
    
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)commit:(id)sender {
    
    
    if (self.myText.text.length == 0) {
         [BaseTools showErrorMessage:@"内容不能为空"];
    }else{
        NSMutableDictionary *parmDic = [NSMutableDictionary dictionary];
        if (self.data) {
            [parmDic setObject:self.data[@"order_sn"] forKey:@"order_sn"];
        }else{
            [parmDic setObject:self.orderData.order_sn forKey:@"order_sn"];
        }
        
        [parmDic setObject:self.myText.text forKey:@"refund_reason"];
        
        [ZMNetworkHelper POST:@"/order_handler/refund" parameters:parmDic cache:YES responseCache:^(id responseCache) {
            
        } success:^(id responseObject) {
            if (responseObject == nil) {
                
            }else{
                if ([responseObject[@"code"] isEqualToString:@"0"]) {
                    [BaseTools showErrorMessage:responseObject[@"msg"]];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.navigationController popViewControllerAnimated:YES];
                         KPostNotification(KNotificationLoginUpdata, nil);
                    });
                }else if ([responseObject[@"code"] isEqualToString:@"-10000"]){
                    [BaseTools showErrorMessage:@"请登录后再操作"];
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
    
    
}
- (void)textViewDidBeginEditing:(UITextView *)textView{
    
    self.lab.hidden = YES;
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
