//
//  ZMQYkefuViewController.m
//  KukeApp
//
//  Created by 库课 on 2019/8/6.
//  Copyright © 2019 KukeZangMing. All rights reserved.
//

#import "ZMQYkefuViewController.h"

@interface ZMQYkefuViewController ()

@end

@implementation ZMQYkefuViewController
//使用这里的代码也是oK的。 这里利用 NSInvocation 调用 对象的消息
- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if([[UIDevice currentDevice]respondsToSelector:@selector(setOrientation:)]) {

        SEL selector = NSSelectorFromString(@"setOrientation:");

        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];

        [invocation setSelector:selector];

        [invocation setTarget:[UIDevice currentDevice]];

        int val = UIInterfaceOrientationLandscapeLeft;//横屏

        [invocation setArgument:&val atIndex:2];

        [invocation invoke];

    }
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
//- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
//    return UIInterfaceOrientationMaskPortrait;
//}
//
//#pragma mark 强制横屏(针对present方式)
//- (BOOL)shouldAutorotate{
//    return YES;
//}
//
////必须有
//-(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
//    return UIInterfaceOrientationPortrait;
//}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
