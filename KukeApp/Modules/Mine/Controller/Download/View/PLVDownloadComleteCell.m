//
//  PLVDownloadComleteCell.m
//  PolyvVodSDKDemo
//
//  Created by mac on 2018/7/24.
//  Copyright © 2018年 POLYV. All rights reserved.
//

#import "PLVDownloadComleteCell.h"
//#import <YYWebImage/YYWebImage.h>

@implementation PLVDownloadComleteCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.thumbnailView.clipsToBounds = YES;
    self.thumbnailView.layer.cornerRadius = 5.0;
    
    UIColor *color = [UIColor blackColor];
    self.isLook.backgroundColor = [color colorWithAlphaComponent:0.5];
    self.isLook.layer.masksToBounds = YES;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setThumbnailUrl:(NSString *)thumbnailUrl {
    _thumbnailUrl = thumbnailUrl;
//    [self.thumbnailView yy_setImageWithURL:[NSURL URLWithString:thumbnailUrl] placeholder:[UIImage imageNamed:@"plv_ph_courseCover"]];
    [self.thumbnailView sd_setImageWithURL:[NSURL URLWithString:thumbnailUrl] placeholderImage:nil];
}

+ (NSString *)identifier{
    return NSStringFromClass([self class]);
}

@end
