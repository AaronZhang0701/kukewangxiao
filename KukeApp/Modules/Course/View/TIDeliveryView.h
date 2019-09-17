//
//  TIDeliveryView.h
//  Toing_Test
//
//  Created by 刘山国 on 2018/1/26.
//  Copyright © 2018年 dufei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TIDeliveryView : UIView
- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)titleStr price:(NSString *)priceStr;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
//@property (weak, nonatomic) IBOutlet UILabel *sonTitle;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UIButton *allPrice;
@property (weak, nonatomic) IBOutlet UIButton *onePrice;

@end
