//
//  GetCouponModel.h
//  KukeApp
//
//  Created by iOSDeveloper on 2018/12/12.
//  Copyright © 2018年 zhangming. All rights reserved.
//


#import "JSONModel.h"

NS_ASSUME_NONNULL_BEGIN




@protocol GetCouponListModel <NSObject>
@end
@interface GetCouponListModel : JSONModel
@property (nonatomic,strong)NSString<Optional> *coupon_name;
@property (nonatomic,strong)NSString<Optional> *coupon_type;
@property (nonatomic,strong)NSString<Optional> *coupon_value;
@property (nonatomic,strong)NSString<Optional> *direction;
@property (nonatomic,strong)NSString<Optional> *valid_start_time;
@property (nonatomic,strong)NSString<Optional> *valid_end_time;
@property (nonatomic,strong)NSString<Optional> *coupon_id;
@property (nonatomic,strong)NSString<Optional> *discount_note;
@property (nonatomic,strong)NSString<Optional> *valid_text;
@end

@interface GetCouponModel : JSONModel
@property (nonatomic,strong)NSArray<GetCouponListModel,Optional> *data;
@end


NS_ASSUME_NONNULL_END

