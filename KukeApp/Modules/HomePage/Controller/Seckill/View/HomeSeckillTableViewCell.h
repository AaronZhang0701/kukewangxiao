//
//  HomeSeckillTableViewCell.h
//  KukeApp
//
//  Created by 库课 on 2019/2/18.
//  Copyright © 2019 KukeZangMing. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HomeSeckillTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *seckillBtn;

@property (weak, nonatomic) IBOutlet UILabel *hourLab;
@property (weak, nonatomic) IBOutlet UILabel *minuteLab;
@property (weak, nonatomic) IBOutlet UILabel *secondLab;
@property (weak, nonatomic) IBOutlet UIButton *textLab;
@property (nonatomic, strong) NSMutableArray *ary;
@end

NS_ASSUME_NONNULL_END
