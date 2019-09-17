//
//  HomePageRecommendTableViewCell.h
//  KukeApp
//
//  Created by iOSDeveloper on 2018/9/25.
//  Copyright © 2018年 zhangming. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CourseListModel.h"
@interface HomePageRecommendTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *picView;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *moneyLab;
@property (weak, nonatomic) IBOutlet UILabel *introduceLab;
@property (weak, nonatomic) IBOutlet UILabel *originalPriceLab;
@property (nonatomic, assign) BOOL isCollection;
@property (nonatomic, strong) CourseDataAryModel *model;
@end
