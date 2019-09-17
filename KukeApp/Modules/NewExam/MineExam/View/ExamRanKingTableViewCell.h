//
//  ExamRanKingTableViewCell.h
//  KukeApp
//
//  Created by 库课 on 2019/8/9.
//  Copyright © 2019 KukeZangMing. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ExamRanKingTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *ranking;
@property (weak, nonatomic) IBOutlet UIImageView *pic;
@property (weak, nonatomic) IBOutlet UILabel *Tel;
@property (weak, nonatomic) IBOutlet UILabel *number;
- (void)configCellWithData:(id)data withType:(NSString *)type;
@end

NS_ASSUME_NONNULL_END
