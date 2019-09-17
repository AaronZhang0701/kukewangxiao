//
//  GoodsDetailBottomBarView.h
//  KukeApp
//
//  Created by 库课 on 2019/9/7.
//  Copyright © 2019 KukeZhangMing. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface GoodsDetailBottomBarView : UIView
- (instancetype)initWithFrame:(CGRect)frame withData:(NSMutableDictionary *)data;
@property (nonatomic, strong) UIButton *advisoryBtn;

@property (nonatomic, strong) UIButton *collectionBtn;

@property (nonatomic, strong) UIButton *oneBtn;

@property (nonatomic, strong) UIButton *twoBtn;

@property (nonatomic, strong) UIButton *rightBtn;

@property (nonatomic, strong) NSString *isDistribute;

@property (nonatomic, strong) NSString *goodsType;
@end

NS_ASSUME_NONNULL_END
