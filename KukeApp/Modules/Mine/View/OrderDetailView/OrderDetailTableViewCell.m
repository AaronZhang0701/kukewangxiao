//
//  OrderDetailTableViewCell.m
//  KukeApp
//
//  Created by 库课 on 2019/1/3.
//  Copyright © 2019 zhangming. All rights reserved.
//

#import "OrderDetailTableViewCell.h"

@implementation OrderDetailTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (IBAction)seeDetailAction:(id)sender {
    if (_seeBlock) {
        self.seeBlock();
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
