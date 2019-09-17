//
//  UploadNoticeView.m
//  KukeApp
//
//  Created by 库课 on 2019/5/21.
//  Copyright © 2019 KukeZangMing. All rights reserved.
//

#import "UploadNoticeView.h"

@implementation UploadNoticeView
- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    self = [[[NSBundle mainBundle] loadNibNamed:@"UploadNoticeView" owner:self options:nil] lastObject];
    if (self) {
        self.frame = frame;
    }
    return self;
}


- (IBAction)closeAction:(id)sender {
    if (self.closeBlock) {
        self.closeBlock();
    }
}
- (IBAction)uploadActon:(id)sender {

    if (self.uploadBlock) {
        self.uploadBlock();
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
