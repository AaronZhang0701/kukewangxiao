//
//  DistributionOrderHeader.m
//  KukeApp
//
//  Created by 库课 on 2019/3/19.
//  Copyright © 2019 KukeZangMing. All rights reserved.
//

#import "DistributionOrderHeader.h"

@implementation DistributionOrderHeader
- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    self = [[[NSBundle mainBundle] loadNibNamed:@"DistributionOrderHeader" owner:self options:nil] lastObject];
    if (self) {
        self.frame = frame;
    }
    return self;
}

@end
