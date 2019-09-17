//
//  ViewController.m
//  KukeApp
//
//  Created by iOSDeveloper on 2018/8/9.
//  Copyright © 2018年 zhangming. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor redColor];
    
    
    UIButton *button = [UIButton buttonWithType:(UIButtonTypeCustom)];
    button.frame = CGRectMake(100, 100, 100, 100);
    button.backgroundColor = [UIColor blueColor];
    [self.view addSubview:button];
    [button addTarget:self action:@selector(btn) forControlEvents:(UIControlEventTouchUpInside)];
    
    // Do any additional setup after loading the view, typically from a nib.
}
-(void)btn{
   
    
    [[UMSocialManager defaultManager] getUserInfoWithPlatform:UMSocialPlatformType_QQ
                                        currentViewController:self
                                                   completion:^(id result, NSError *error) {
                                                       
                                                       UMSocialUserInfoResponse *userinfo = result;
                                                       
                                                       if (!(int)error.code) {
                                                           
                                                           NSLog(@"%@",result);
                                                           
                                                       }else {
                                                           
                                                       }
                                                       
                                                   }];
//    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
//
//
//        //UMShareMusicObject  UMShareWebpageObject
//
//        UMShareWebpageObject * object = [UMShareWebpageObject shareObjectWithTitle:@"123" descr:@"234" thumImage:[UIImage imageNamed:@"Icon"]];
//
//        object.webpageUrl = @"123";
//
//        UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObjectWithMediaObject:object];
//
//        [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:nil];
//
//    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
