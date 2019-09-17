//
//  CommissionViewController.m
//  KukeApp
//
//  Created by iOSDeveloper on 2018/10/3.
//  Copyright © 2018年 zhangming. All rights reserved.
//

#import "CommissionViewController.h"

@interface CommissionViewController ()

@end

@implementation CommissionViewController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO];
    //    [AppUtiles setTabBarHidden:YES];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"佣金";
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:self.navigationItem.backBarButtonItem.style target:nil action:nil];

    // Do any additional setup after loading the view from its nib.
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
