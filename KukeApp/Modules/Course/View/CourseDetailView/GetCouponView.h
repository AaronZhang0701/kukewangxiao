//
//  GetCouponView.h
//  KukeApp
//
//  Created by iOSDeveloper on 2018/12/11.
//  Copyright © 2018年 zhangming. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^CloseGetCouponActionBlock)();
@interface GetCouponView : UIView
@property (nonatomic ,copy) CloseGetCouponActionBlock myBlock;
- (void)getGoodsID:(NSString *)goods_id withGoodsType:(NSString *)goods_type;
@end

NS_ASSUME_NONNULL_END
