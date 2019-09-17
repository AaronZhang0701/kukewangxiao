//
//  HomePageMessageTableViewCell.h
//  KukeApp
//
//  Created by 库课 on 2019/5/22.
//  Copyright © 2019 KukeZangMing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomePageMenuModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface HomePageMessageTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UIImageView *img;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UILabel *descripLab;
@property (nonatomic, strong) HomeNewsModel *model;
@end

NS_ASSUME_NONNULL_END
