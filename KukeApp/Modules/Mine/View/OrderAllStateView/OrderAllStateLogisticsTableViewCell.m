//
//  OrderAllStateLogisticsTableViewCell.m
//  KukeApp
//
//  Created by 库课 on 2019/1/4.
//  Copyright © 2019 zhangming. All rights reserved.
//

#import "OrderAllStateLogisticsTableViewCell.h"

@implementation OrderAllStateLogisticsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.numCopy.layer.cornerRadius = 3;
    self.numCopy.layer.masksToBounds = YES;
    self.numCopy.layer.borderWidth = 0.5;
    self.numCopy.layer.borderColor = [[UIColor blackColor] CGColor];
}
- (IBAction)copyNumAction:(id)sender {
    [BaseTools showErrorMessage:@"复制成功"];
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = self.number.text;

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
