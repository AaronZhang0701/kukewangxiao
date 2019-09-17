//
//  PaySuccessViewController.h
//  KukeApp
//
//  Created by 库课 on 2019/1/5.
//  Copyright © 2019 zhangming. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PaySuccessViewController : ZMBaseViewController
@property (weak, nonatomic) IBOutlet UIButton *startLearning;
@property (weak, nonatomic) IBOutlet UIButton *seeOrder;
@property (weak, nonatomic) IBOutlet UIButton *continueBtn;
@property (weak, nonatomic) IBOutlet UILabel *messageLab;
@property (weak, nonatomic) IBOutlet UIButton *continueGroupBtn;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *token;
@property (nonatomic, strong) NSString *group_buy_goods_rule_id;
@property (nonatomic, strong) NSDictionary *dataDict;
@end

NS_ASSUME_NONNULL_END
