//
//  WechatAlterView.m
//  KukeApp
//
//  Created by 库课 on 2019/7/18.
//  Copyright © 2019 KukeZangMing. All rights reserved.
//

#import "WechatAlterView.h"

@implementation WechatAlterView
- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    self = [[[NSBundle mainBundle] loadNibNamed:@"WechatAlterView" owner:self options:nil] lastObject];
    if (self) {
        self.frame = frame;
        self.saveBtn.layer.cornerRadius = 5;
        self.saveBtn.layer.masksToBounds = YES;
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (IBAction)saveAction:(id)sender {
    if (self.saveBlock) {
        self.saveBlock(self.pic);
    }
}
- (IBAction)closeAction:(id)sender {
    if (self.closeBlock) {
        self.closeBlock();
    }
}

@end
