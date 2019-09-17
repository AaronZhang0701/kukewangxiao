//
//  KKGuideView.m
//  kuke
//
//  Created by iOSDeveloper on 2017/10/28.
//  Copyright © 2017年 iOSDeveloper. All rights reserved.
//

#import "KKGuideView.h"

#define SELF_Width self.frame.size.width
#define SELF_Height self.frame.size.height

@interface KKGuideView () <UIScrollViewDelegate>

@property (nonatomic, strong) UIPageControl *contentPageControl;

@end

@implementation KKGuideView

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        [self baseInit];
        
    }
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    
    if (self = [super initWithCoder:aDecoder]) {
        
        [self baseInit];
    }
    
    return self;
}

- (void)baseInit {
    
    self.imageScrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    self.imageScrollView.userInteractionEnabled = YES;
    self.imageScrollView.pagingEnabled = YES;
    self.imageScrollView.showsHorizontalScrollIndicator = NO;
    self.imageScrollView.bounces = NO;
    self.imageScrollView.delegate = self;
    
    [self addSubview:self.imageScrollView];
    
//    self.contentPageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(0, SELF_Height - 30, SELF_Width, 30)];
//    self.contentPageControl.userInteractionEnabled = NO;
//    self.contentPageControl.currentPage = 0;
//    [self.contentPageControl addTarget:self action:@selector(pageControlValueChange:) forControlEvents:UIControlEventValueChanged];
//    [self addSubview:self.contentPageControl];
    
    self.closeButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.closeButton.frame = CGRectMake(8, [UIApplication sharedApplication].statusBarFrame.size.height + 8, 40, 30);
    [self.closeButton setTitle:@"跳过" forState:UIControlStateNormal];
    [self.closeButton addTarget:self action:@selector(closeButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:self.closeButton];
    
}

- (void)closeButtonClick {
    
    [UIView animateWithDuration:0.5
                     animations:^{
                         
                         self.alpha = 0;
                         
                     }
                     completion:^(BOOL finished) {
                         
                         [self removeFromSuperview];
                         
                     }];
    
}

- (void)setGuideImages:(NSArray *)images {
    
    NSInteger imageNumber = images.count;
    
    if (imageNumber == 1) {
        
        self.contentPageControl.hidden = YES;
    }
    
    self.contentPageControl.numberOfPages = imageNumber;
    
    self.imageScrollView.contentSize = CGSizeMake(SELF_Width * imageNumber, SELF_Height);
    
    for (NSInteger i = 0; i < imageNumber; i ++) {
        
        UIImageView *imageV = [[UIImageView alloc]initWithFrame:CGRectMake(i * SELF_Width, 0, SELF_Width, SELF_Height)];
        imageV.image = images[i];
        imageV.contentMode = UIViewContentModeScaleAspectFill;
        imageV.clipsToBounds = YES;
        [self.imageScrollView addSubview:imageV];
        
    }
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    NSInteger index = fabs(scrollView.contentOffset.x) / scrollView.frame.size.width;
    [self.contentPageControl setCurrentPage:index];
    
}

- (void)pageControlValueChange:(UIPageControl *)pageControl {
    
    [self.imageScrollView setContentOffset:CGPointMake(pageControl.currentPage * SELF_Width, 0) animated:YES];
    
}

@end
