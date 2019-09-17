//
//  AboutOursViewController.m
//  KukeApp
//
//  Created by iOSDeveloper on 2018/10/3.
//  Copyright © 2018年 zhangming. All rights reserved.
//

#import "AboutOursViewController.h"
#import "FeedbackViewController.h"
@interface AboutOursViewController ()

@end

@implementation AboutOursViewController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO];


}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"关于我们";
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:self.navigationItem.backBarButtonItem.style target:nil action:nil];
    self.number.text = [NSString stringWithFormat:@"版本号:%@",[[[NSBundle mainBundle]infoDictionary]objectForKey:@"CFBundleShortVersionString"]];
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)feedback:(id)sender {
    FeedbackViewController *vc = [[FeedbackViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
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
