//
//  AdWebViewController.m
//  KukeApp
//
//  Created by iOSDeveloper on 2018/11/14.
//  Copyright © 2018年 zhangming. All rights reserved.
//

#import "AdWebViewController.h"
#import "HomePageViewController.h"
@interface AdWebViewController ()

@end

@implementation AdWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.title = @"活动详情";
    // Do any additional setup after loading the view.
}
- (void)back:(UIBarButtonItem *)btn
{
    if ([self.web canGoBack]) {
        [self.web goBack];
        
    }else{
       
        
        [self.view resignFirstResponder];
        if (self.presentingViewController) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }else{
            [self.navigationController popViewControllerAnimated:YES];
        }
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
