//
//  FTTitleViewCell.m
//  FTPageController
//
//  Created by ftao on 04/01/2018.
//  Copyright © 2018 easefun. All rights reserved.
//

#import "FTTitleViewCell.h"

@implementation FTTitleViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.clicked = NO;
}

- (void)setClicked:(BOOL)clicked {
    _clicked = clicked;
    
    _indicatorView.hidden = !clicked;
    _titleLabel.textColor = clicked ? CNavBgColor : CTitleColor;
}

@end
