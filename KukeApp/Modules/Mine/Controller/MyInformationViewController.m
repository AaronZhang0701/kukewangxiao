//
//  MyInformationViewController.m
//  KukeApp
//
//  Created by iOSDeveloper on 2018/10/30.
//  Copyright © 2018年 zhangming. All rights reserved.
//

#import "MyInformationViewController.h"

@interface MyInformationViewController ()

@end

@implementation MyInformationViewController


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
     [self.navigationController setNavigationBarHidden:NO];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"个人资料";
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:self.navigationItem.backBarButtonItem.style target:nil action:nil];

    self.pic.layer.cornerRadius = 17.5f;
    self.pic.layer.masksToBounds = YES;
    [self changeHeadImageWithHeadImageView:self.pic];
    CurrentUserInfo *info= nil;
    if ([UserInfoTool persons].count != 0) {
        info = [UserInfoTool persons][0];
         [self.pic sd_setImageWithURL:[NSURL URLWithString:info.photo] placeholderImage:[UIImage imageNamed:@"个人中心未登录头像"]];
        self.nameLab.text = info.NiName;
    }else{
        [self.pic sd_setImageWithURL:[NSURL URLWithString:info.photo] placeholderImage:[UIImage imageNamed:@"个人中心未登录头像"]];
        self.nameLab.text = info.NiName;
    }
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)headerImageAction:(id)sender {
}
- (IBAction)setNameAction:(id)sender {
}
- (IBAction)setSexAction:(id)sender {
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
