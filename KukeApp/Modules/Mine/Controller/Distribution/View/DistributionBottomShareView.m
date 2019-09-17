//
//  DistributionBottomShareView.m
//  KukeApp
//
//  Created by 库课 on 2019/3/22.
//  Copyright © 2019 KukeZangMing. All rights reserved.
//

#import "DistributionBottomShareView.h"

@implementation DistributionBottomShareView

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    self = [[[NSBundle mainBundle] loadNibNamed:@"DistributionBottomShareView" owner:self options:nil] firstObject];
    if (self) {
        self.frame = frame;

    }
    return self;
}
- (IBAction)closeAction:(id)sender {
    if (self.myCloseBlock) {
        self.myCloseBlock();
    }
}
- (IBAction)fristAction:(id)sender {
    if (self.myWXShareBlock) {
        self.myWXShareBlock();
    }
}
- (IBAction)secondAction:(id)sender {
    if (self.myQQShareBlock) {
        self.myQQShareBlock();
    }
}
- (IBAction)threeAction:(id)sender {
    if (self.myCopyBlock) {
        self.myCopyBlock();
    }
    
}
- (IBAction)fourAction:(id)sender {
    if (self.myPicBlock) {
        self.myPicBlock();
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
