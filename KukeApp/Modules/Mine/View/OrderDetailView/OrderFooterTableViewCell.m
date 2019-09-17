//
//  OrderFooterTableViewCell.m
//  KukeApp
//
//  Created by 库课 on 2019/1/3.
//  Copyright © 2019 zhangming. All rights reserved.
//

#import "OrderFooterTableViewCell.h"

@implementation OrderFooterTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.onlineServiceBtn.layer.borderWidth = 0.5;
    self.onlineServiceBtn.layer.borderColor = [[UIColor blackColor] CGColor];
    self.onlineServiceBtn.layer.cornerRadius = 3;
    self.onlineServiceBtn.layer.masksToBounds = YES;
    
    self.serviceTelephoneBtn.layer.borderWidth = 0.5;
    self.serviceTelephoneBtn.layer.borderColor = [[UIColor blackColor] CGColor];
    self.serviceTelephoneBtn.layer.cornerRadius = 3;
    self.serviceTelephoneBtn.layer.masksToBounds = YES;
    
}
- (IBAction)onlineServiceAction:(id)sender {
    if ([[UserDefaultsUtils valueWithKey:@"access_token"] length] !=0 ) {
        [BaseTools openKefuWithObj:[[AppDelegate shareAppDelegate] getCurrentUIVC]];
        
        QYSource *source = [[QYSource alloc] init];
        source.title =  @"库课网校";
        source.urlString = @"https://www.kuke99.com/";
        
        QYSessionViewController *sessionViewController = [[QYSDK sharedSDK] sessionViewController];
        
        sessionViewController.sessionTitle = @"库课网校";
        sessionViewController.source = source;
        
        if (IS_PAD) {
            UINavigationController* navi = [[UINavigationController alloc]initWithRootViewController:sessionViewController];
            navi.modalPresentationStyle = UIModalPresentationFormSheet;
            [[[AppDelegate shareAppDelegate] getCurrentUIVC] presentViewController:navi animated:YES completion:nil];
        }
        else{
            sessionViewController.hidesBottomBarWhenPushed = YES;
            [[[AppDelegate shareAppDelegate] getCurrentUIVC].navigationController pushViewController:sessionViewController animated:YES];
        }
        
        [[QYSDK sharedSDK] customUIConfig].bottomMargin = 0;
    }else{
        [BaseTools showErrorMessage:@"请登录后再操作"];
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [BaseTools alertLoginWithVC:[[AppDelegate shareAppDelegate] getCurrentUIVC]];
        });
    }
    
//    KefuViewController *vc = [[KefuViewController alloc]init];
//    vc.url = @"https://tb.53kf.com/code/app/10189259/1";
//    vc.title = @"在线客服";
//    [[[AppDelegate shareAppDelegate] getCurrentUIVC].navigationController pushViewController:vc animated:YES];
}
- (IBAction)serviceTelAction:(id)sender {
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",@"400-6529-888"];
    UIWebView * callWebview = [[UIWebView alloc] init];
    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
    [self addSubview:callWebview];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
