//
//  RegisterDistributionViewController.h
//  KukeApp
//
//  Created by 库课 on 2019/3/14.
//  Copyright © 2019 KukeZangMing. All rights reserved.
//

#import "ZMBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface RegisterDistributionViewController : ZMBaseViewController
@property (weak, nonatomic) IBOutlet UITextField *userName;
@property (weak, nonatomic) IBOutlet UITextField *zhifubao;
@property (weak, nonatomic) IBOutlet UITextField *userTel;
@property (weak, nonatomic) IBOutlet UITextField *code;
@property (weak, nonatomic) IBOutlet UIButton *getCodeBtn;
@property (weak, nonatomic) IBOutlet UIButton *commitBtn;
@property (weak, nonatomic) IBOutlet UIButton *agreeBtn;
@property (weak, nonatomic) IBOutlet UIView *view1;
@property (weak, nonatomic) IBOutlet UIView *view2;
@property (weak, nonatomic) IBOutlet UIView *view3;
@property (weak, nonatomic) IBOutlet UIView *view4;
@property (nonatomic, strong) NSString *rootVC;
@end

NS_ASSUME_NONNULL_END
