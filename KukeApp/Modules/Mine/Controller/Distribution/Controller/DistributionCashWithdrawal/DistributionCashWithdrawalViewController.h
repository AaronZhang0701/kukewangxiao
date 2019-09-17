//
//  DistributionCashWithdrawalViewController.h
//  KukeApp
//
//  Created by 库课 on 2019/3/18.
//  Copyright © 2019 KukeZangMing. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DistributionCashWithdrawalViewController : ZMBaseViewController
@property (weak, nonatomic) IBOutlet UILabel *enableMoneyLab;
@property (weak, nonatomic) IBOutlet UILabel *totalMoneyLab;
@property (weak, nonatomic) IBOutlet UITextField *moneyText;
@property (weak, nonatomic) IBOutlet UILabel *myMoneyLab;
@property (weak, nonatomic) IBOutlet UITextField *zhufubaoText;
@property (weak, nonatomic) IBOutlet UILabel *telText;
@property (weak, nonatomic) IBOutlet UITextField *codeText;
@property (weak, nonatomic) IBOutlet UIButton *codeBtn;
@property (weak, nonatomic) IBOutlet UIButton *commitBtn;

@end

NS_ASSUME_NONNULL_END
