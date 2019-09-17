//
//  DistributionFirstViewController.m
//  KukeApp
//
//  Created by 库课 on 2019/3/18.
//  Copyright © 2019 KukeZangMing. All rights reserved.
//

#import "DistributionFirstViewController.h"

@interface DistributionFirstViewController ()

@end

@implementation DistributionFirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tab = @"all";
    if (!self.isEnable) {

        [BaseTools showErrorMessage:@"分销员资格已经被禁用"];
    }
    // Do any additional setup after loading the view.
}
- (void)setTab{
    self.tab = @"all";
    
}
@end
