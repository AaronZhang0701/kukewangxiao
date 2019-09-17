//
//  TIDeliveryView.m
//  Toing_Test
//
//  Created by 刘山国 on 2018/1/26.
//  Copyright © 2018年 dufei. All rights reserved.
//

#import "TIDeliveryView.h"
#import "SGBrowserView.h"

@interface TIDeliveryView()
@property (strong, nonatomic) IBOutlet UIView *contentView;

@end

@implementation TIDeliveryView

- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)titleStr price:(NSString *)priceStr
{


    self = [super initWithFrame:frame];
    if (self) {
        self.contentView = [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass([self class]) owner:self options:nil] firstObject];//(owner:self ，firstObject必要)
        self.contentView.frame = self.bounds;
        self.contentView.layer.cornerRadius = 5;
        self.contentView.layer.masksToBounds = YES;
        [self addSubview:self.contentView];
        
        self.titleLab.text = titleStr;
//        self.sonTitle.text = sonTitleStr;
        self.price.text = priceStr;
//        [self.allPrice setTitle:allPriceStr forState:(UIControlStateNormal)];
//        [self.onePrice setTitle:priceStr forState:(UIControlStateNormal)];
        self.allPrice.layer.cornerRadius = 5;
        self.allPrice.layer.masksToBounds =YES;
        self.allPrice.layer.borderWidth = 1;
        self.allPrice.layer.borderColor = [[UIColor whiteColor] CGColor];
        self.onePrice.layer.cornerRadius = 5;
        self.onePrice.layer.masksToBounds = YES;
        self.onePrice.layer.borderWidth = 1;
        self.onePrice.layer.borderColor = [CNavBgColor CGColor];
        
    }
    return self;
}


@end
