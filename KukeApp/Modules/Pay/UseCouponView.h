//
//  UseCouponView.h
//  KukeApp
//
//  Created by iOSDeveloper on 2018/12/12.
//  Copyright © 2018年 zhangming. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyCouponModel.h"
typedef void(^CloseUseCouponActionBlock)();

typedef void(^UseCouponActionBlock)(MyCouponListModel *model);
NS_ASSUME_NONNULL_BEGIN

@interface UseCouponView : UIView
@property (nonatomic ,copy) CloseUseCouponActionBlock myBlock;
@property (nonatomic ,copy) UseCouponActionBlock couponBlock;
- (void)getGoodsID:(NSString *)goods_id withGoodsType:(NSString *)goods_type andGoodsNumber:(NSString *)num;
@end

NS_ASSUME_NONNULL_END
