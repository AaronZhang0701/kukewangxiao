//
//  BindingPhoneViewController.h
//  KukeApp
//
//  Created by iOSDeveloper on 2018/10/29.
//  Copyright © 2018年 zhangming. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BindingPhoneViewController : ZMBaseViewController
@property (weak, nonatomic) IBOutlet UITextField *telText;
@property (weak, nonatomic) IBOutlet UITextField *codeText;
@property (weak, nonatomic) IBOutlet UIButton *codeBtn;
@property (weak, nonatomic) IBOutlet UIView *view1;

@property (weak, nonatomic) IBOutlet UIView *view2;

@property (nonatomic, strong) UMSocialUserInfoResponse *resp;
@property (nonatomic, strong) NSString *loginType;
@end
