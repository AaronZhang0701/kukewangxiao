//
//  LoginViewCell.h
//  KukeApp
//
//  Created by iOSDeveloper on 2018/9/21.
//  Copyright © 2018年 zhangming. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^LoginActionBlock)(NSString *action);
@interface LoginViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imagePhone;
@property (weak, nonatomic) IBOutlet UIImageView *imageCode;
@property (weak, nonatomic) IBOutlet UITextField *phoneText;
@property (weak, nonatomic) IBOutlet UITextField *codeText;
//@property (weak, nonatomic) IBOutlet UIButton *codeBtn;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UIButton *passwordLoginBtn;
@property (weak, nonatomic) IBOutlet UIButton *forgetPasswordBtn;
@property (weak, nonatomic) IBOutlet UIButton *wxLoginBtn;
@property (weak, nonatomic) IBOutlet UIButton *QQLoginBtn;
@property (weak, nonatomic) IBOutlet UIButton *youkeLogin;
@property (weak, nonatomic) IBOutlet UIButton *agreeBtn;

@property (weak, nonatomic) IBOutlet JKCountDownButton *getCodeBtn;
@property (weak, nonatomic) IBOutlet UIView *view1;
@property (weak, nonatomic) IBOutlet UIView *view2;
@property (weak, nonatomic) IBOutlet UILabel *readLab;
@property (weak, nonatomic) IBOutlet UIButton *tiaokuanLab;
@property (weak, nonatomic) IBOutlet UIButton *zhengcelab;

@property (nonatomic ,copy) LoginActionBlock myBlock;

@property (nonatomic,strong) NSString *isRegister;
@end
