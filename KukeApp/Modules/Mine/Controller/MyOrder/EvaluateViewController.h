//
//  EvaluateViewController.h
//  KukeApp
//
//  Created by iOSDeveloper on 2018/10/22.
//  Copyright © 2018年 zhangming. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyOrderModel.h"
@interface EvaluateViewController : ZMBaseViewController
@property (weak, nonatomic) IBOutlet UIImageView *pic;
@property (weak, nonatomic) IBOutlet UILabel *goodName;

@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UITextView *myText;
@property (weak, nonatomic) IBOutlet UILabel *lab;
@property (weak, nonatomic) IBOutlet UIButton *commit;
@property (nonatomic, strong) MyOrderDataModel *model;

@property (nonatomic, strong) NSDictionary *data;
@property (weak, nonatomic) IBOutlet UIView *starView;


@end
