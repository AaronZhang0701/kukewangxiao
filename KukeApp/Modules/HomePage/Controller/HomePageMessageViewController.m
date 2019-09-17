//
//  HomePageMessageViewController.m
//  KukeApp
//
//  Created by iOSDeveloper on 2018/10/8.
//  Copyright © 2018年 zhangming. All rights reserved.
//

#import "HomePageMessageViewController.h"
//#import "HConversationsViewController.h"
@interface HomePageMessageViewController ()

@end

@implementation HomePageMessageViewController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO];
    //    [AppUtiles setTabBarHidden:YES];
    
}
- (IBAction)serviceAction:(id)sender {
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:self.navigationItem.backBarButtonItem.style target:nil action:nil];
//    HConversationsViewController *vc = [[HConversationsViewController alloc]init];
//    [self.navigationController pushViewController:vc animated:YES];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"消息中心";
    
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
