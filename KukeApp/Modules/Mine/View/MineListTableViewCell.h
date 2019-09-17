//
//  MineListTableViewCell.h
//  KukeApp
//
//  Created by iOSDeveloper on 2018/10/2.
//  Copyright © 2018年 zhangming. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MineListTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *titleImage;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *numBer;
- (void)configWithDic:(NSDictionary *)dic;
@end
