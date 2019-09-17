//
//  DistributionOrderModel.h
//  KukeApp
//
//  Created by 库课 on 2019/3/25.
//  Copyright © 2019 KukeZangMing. All rights reserved.
//

#import "JSONModel.h"

NS_ASSUME_NONNULL_BEGIN
@protocol DistributionOrderData <NSObject>
@end
@interface DistributionOrderData : JSONModel
@property (nonatomic,strong)NSString<Optional> *stu_mobile;
@property (nonatomic,strong)NSString<Optional> *order_sn;
@property (nonatomic,strong)NSString<Optional> *goods_id;
@property (nonatomic,strong)NSString<Optional> *goods_type;
@property (nonatomic,strong)NSString<Optional> *goods_num;
@property (nonatomic,strong)NSString<Optional> *goods_title;
@property (nonatomic,strong)NSString<Optional> *goods_img;
@property (nonatomic,strong)NSString<Optional> *goods_price;
@property (nonatomic,strong)NSString<Optional> *order_money;
@property (nonatomic,strong)NSString<Optional> *bro_money;
@property (nonatomic,strong)NSString<Optional> *status;
@property (nonatomic,strong)NSString<Optional> *create_time;
@property (nonatomic,strong)NSString<Optional> *goods_url;

@property (nonatomic,strong)NSString<Optional> *trans_type_text;

@property (nonatomic,strong)NSString<Optional> *trans_type;
@property (nonatomic,strong)NSString<Optional> *trans_flag;
@property (nonatomic,strong)NSString<Optional> *trans_money;

@property (nonatomic,strong)NSString<Optional> *trans_status;

@end
@interface DistributionOrderModel : JSONModel
@property (nonatomic,strong)NSArray<DistributionOrderData,Optional> *list;
@end

NS_ASSUME_NONNULL_END
