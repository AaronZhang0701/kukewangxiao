//
//  TypeSwitchingAndSearchView.h
//  KukeApp
//
//  Created by 库课 on 2019/4/15.
//  Copyright © 2019 KukeZangMing. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^GoodsTypeActionBlock)(NSString *goodsType);
NS_ASSUME_NONNULL_BEGIN

@interface TypeSwitchingAndSearchView : UIView
- (instancetype)initWithFrame:(CGRect)frame;
@property (nonatomic ,copy) GoodsTypeActionBlock goodsTypeActionBlock;
@property (nonatomic, strong) NSString *goodsType;
@property (nonatomic, strong) NSString *cate_id;

@property (nonatomic, strong) NSString *push_cate_id;

@end

NS_ASSUME_NONNULL_END
