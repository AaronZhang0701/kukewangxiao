//
//  HomeLiveTableViewCell.h
//  KukeApp
//
//  Created by 库课 on 2019/7/17.
//  Copyright © 2019 KukeZangMing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomePageMenuModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface HomeLiveTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *timeLab1;
@property (weak, nonatomic) IBOutlet UILabel *timeLab2;
@property (weak, nonatomic) IBOutlet UIView *view1;
@property (weak, nonatomic) IBOutlet UIView *view2;
@property (weak, nonatomic) IBOutlet UILabel *typeLab1;
@property (weak, nonatomic) IBOutlet UILabel *typeLab2;
@property (weak, nonatomic) IBOutlet UILabel *titleLab1;
@property (weak, nonatomic) IBOutlet UILabel *titleLab2;
@property (weak, nonatomic) IBOutlet UIImageView *header1_1;
@property (weak, nonatomic) IBOutlet UIImageView *header1_2;
@property (weak, nonatomic) IBOutlet UIImageView *header1_3;
@property (weak, nonatomic) IBOutlet UIImageView *header2_1;
@property (weak, nonatomic) IBOutlet UIImageView *header2_2;
@property (weak, nonatomic) IBOutlet UIImageView *header2_3;

@property (nonatomic,strong) NSMutableArray *modelAry;
@end

NS_ASSUME_NONNULL_END
