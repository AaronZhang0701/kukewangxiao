//
//  ReturnGoodsViewController.h
//  KukeApp
//
//  Created by iOSDeveloper on 2018/10/23.
//  Copyright © 2018年 zhangming. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyOrderModel.h"
@interface ReturnGoodsViewController : ZMBaseViewController
@property (weak, nonatomic) IBOutlet UIImageView *pic;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *lab;
@property (weak, nonatomic) IBOutlet UITextView *myText;
@property (nonatomic, strong) MyOrderDataModel  *orderData;
@property (nonatomic, strong) NSDictionary *data;
@end
