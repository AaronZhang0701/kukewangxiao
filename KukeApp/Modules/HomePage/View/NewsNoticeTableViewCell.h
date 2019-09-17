//
//  NewsNoticeTableViewCell.h
//  KukeApp
//
//  Created by iOSDeveloper on 2018/11/5.
//  Copyright © 2018年 zhangming. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewsNoticeTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UILabel *contentLab;
@property (weak, nonatomic) IBOutlet UIView *bigView;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;

@end
