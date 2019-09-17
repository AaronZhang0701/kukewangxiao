//
//  MyCouponModel.h
//  KukeApp
//
//  Created by iOSDeveloper on 2018/12/11.
//  Copyright © 2018年 zhangming. All rights reserved.
//

#import "JSONModel.h"

NS_ASSUME_NONNULL_BEGIN




@protocol MyCouponDataModel <NSObject>
@end
@interface MyCouponDataModel : JSONModel
@property (nonatomic,strong)NSString<Optional> *coupon_name;
@property (nonatomic,strong)NSString<Optional> *coupon_type;
@property (nonatomic,strong)NSString<Optional> *coupon_value;
@property (nonatomic,strong)NSString<Optional> *direction;
@property (nonatomic,strong)NSString<Optional> *valid_start_time;
@property (nonatomic,strong)NSString<Optional> *valid_end_time;
@property (nonatomic,strong)NSString<Optional> *discount_note;

@end


@protocol MyCouponListModel <NSObject>
@end
@interface MyCouponListModel : JSONModel
@property (nonatomic,strong)NSString<Optional> *status;
@property (nonatomic,strong)NSString<Optional> *discount_amount;
@property (nonatomic,strong)NSString<Optional> *coupon_id;
@property (nonatomic,strong)NSString<Optional> *is_best;
@property (nonatomic,strong)MyCouponDataModel *coupon;
@end

@interface MyCouponModel : JSONModel
@property (nonatomic,strong)NSArray<MyCouponListModel,Optional> *data;
@end


NS_ASSUME_NONNULL_END
