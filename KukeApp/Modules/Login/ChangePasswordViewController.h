//
//  ChangePasswordViewController.h
//  KukeApp
//
//  Created by 库课 on 2019/3/22.
//  Copyright © 2019 KukeZangMing. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ChangePasswordViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *codetext;
@property (weak, nonatomic) IBOutlet UITextField *passwordText;
@property (weak, nonatomic) IBOutlet JKCountDownButton *codeBtn;
@property (weak, nonatomic) IBOutlet UIView *view1;
@property (weak, nonatomic) IBOutlet UIView *view2;
@property (weak, nonatomic) IBOutlet UIButton *commitBtn;

@end

NS_ASSUME_NONNULL_END
