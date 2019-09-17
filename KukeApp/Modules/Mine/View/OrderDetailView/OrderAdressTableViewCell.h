//
//  OrderAdressTableViewCell.h
//  KukeApp
//
//  Created by 库课 on 2019/1/3.
//  Copyright © 2019 zhangming. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface OrderAdressTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *telLab;
@property (weak, nonatomic) IBOutlet UILabel *addressLab;

@end

NS_ASSUME_NONNULL_END
