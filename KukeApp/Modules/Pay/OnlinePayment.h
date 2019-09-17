//
//  OnlinePayment.h
//  KukeApp
//
//  Created by iOSDeveloper on 2018/10/23.
//  Copyright © 2018年 zhangming. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^PaySuccessBlock)();
typedef void(^PayFailureBlock)();

@interface OnlinePayment : UIView
- (instancetype)initWithDoneBlock:(void(^)(OnlinePayment *view,NSInteger selectIndex))block;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;

@property (weak, nonatomic) IBOutlet UIButton *twoBtn;
@property (weak, nonatomic) IBOutlet UIButton *threeBtn;
@property (nonatomic ,copy) PaySuccessBlock myBlock;
@property (nonatomic ,copy) PayFailureBlock myFailureBlock;
@property (nonatomic, strong) NSDictionary *dicts;
@end
