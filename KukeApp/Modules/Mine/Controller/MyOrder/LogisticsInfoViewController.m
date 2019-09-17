//
//  LogisticsInfoViewController.m
//  KukeApp
//
//  Created by iOSDeveloper on 2018/10/22.
//  Copyright © 2018年 zhangming. All rights reserved.
//

#import "LogisticsInfoViewController.h"

@interface LogisticsInfoViewController ()<UIWebViewDelegate>

@end

@implementation LogisticsInfoViewController

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
//    [self.navigationController.navigationBar removeAllSubviews];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"物流信息";
    UIWebView *web = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, screenWidth(), screenHeight())];
    web.delegate = self;
    web.scrollView.bounces=NO;
   
    web.scalesPageToFit = YES;
    //        设置检测网页中的格式类型，all表示检测所有类型包括超链接、电话号码、地址等。
    web.dataDetectorTypes = UIDataDetectorTypeNone;
    [self.view addSubview:web];
    
    
    NSMutableDictionary *parmDic = [NSMutableDictionary dictionary];
    [parmDic setObject:self.orderID forKey:@"order_sn"];
    [ZMNetworkHelper POST:@"/order_handler/logistics" parameters:parmDic cache:YES responseCache:^(id responseCache) {
        
    } success:^(id responseObject) {
        if (responseObject == nil) {
            
        }else{
            if ([responseObject[@"code"] isEqualToString:@"0"]) {
                NSString *str =[NSString stringWithFormat:@"%@",responseObject[@"data"][@"link"]];
                NSURL *url = [NSURL URLWithString:str];
                NSURLRequest *request = [NSURLRequest requestWithURL:url];
                [web loadRequest:request];
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
