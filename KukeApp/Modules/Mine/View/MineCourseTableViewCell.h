//
//  MineCourseTableViewCell.h
//  KukeApp
//
//  Created by iOSDeveloper on 2018/10/2.
//  Copyright © 2018年 zhangming. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MineCourseTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *noPayment;
@property (weak, nonatomic) IBOutlet UIButton *noSend;
@property (weak, nonatomic) IBOutlet UIButton *noReceive;
@property (weak, nonatomic) IBOutlet UIButton *afterSale;
@property (weak, nonatomic) IBOutlet UIButton *order;
@property (weak, nonatomic) IBOutlet UILabel *unread1;
@property (weak, nonatomic) IBOutlet UILabel *unread2;
@property (weak, nonatomic) IBOutlet UILabel *unread3;

@end
