//
//  CourseDetailHeaderView.m
//  KukeApp
//
//  Created by iOSDeveloper on 2018/10/1.
//  Copyright © 2018年 zhangming. All rights reserved.
//

#import "CourseDetailHeaderView.h"
#import <SDWebImage/UIImageView+WebCache.h>
@interface CourseDetailHeaderView()
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, assign) CGRect imageViewFrame;
@end

@implementation CourseDetailHeaderView

- (instancetype)initWithFrame:(CGRect)frame goodsType:(NSString *)type
{
    self = [super initWithFrame:frame];
    if (self) {
        _imageView = [[UIImageView alloc] init];
        self.imageView.clipsToBounds = YES;
//        if ([type isEqualToString:@"4"]) {
//            self.imageView.frame = CGRectMake((screenWidth()-frame.size.height/9*8)/2, 0, frame.size.height/9*8, SCREEN_WIDTH/16*9);
//        }else{
            self.imageView.frame = CGRectMake(0, 0, frame.size.width, SCREEN_WIDTH/16*9);
//        }
        
        [self addSubview:self.imageView];
        self.imageViewFrame = self.imageView.frame;
//        self.imageView.contentMode=UIViewContentModeScaleAspectFill;
//        self.imageView.clipsToBounds=YES;
//        //  是否剪切掉超出 UIImageView 范围的图片
//        [self.imageView setContentScaleFactor:[[UIScreen mainScreen] scale]];

    }
    return self;
}
- (void)setImageUrl:(NSString *)imageUrl{

    [self.imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",imageUrl]]placeholderImage:nil];
}
- (void)scrollViewDidScroll:(CGFloat)contentOffsetY {
    CGRect frame = self.imageViewFrame;
    frame.size.height -= contentOffsetY;
    frame.origin.y = contentOffsetY;
    self.imageView.frame = frame;
}


@end
