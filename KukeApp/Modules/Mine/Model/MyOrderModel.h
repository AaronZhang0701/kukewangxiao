//
//  MyOrderModel.h
//  KukeApp
//
//  Created by iOSDeveloper on 2018/10/22.
//  Copyright © 2018年 zhangming. All rights reserved.
//

#import "JSONModel.h"



@protocol MyOrderDataModel <NSObject>
@end
@interface MyOrderDataModel : JSONModel
@property (nonatomic,strong)NSString<Optional> *order_type;
@property (nonatomic,strong)NSString<Optional> *order_sn;
@property (nonatomic,strong)NSString<Optional> *order_status;
@property (nonatomic,strong)NSString<Optional> *order_price;
@property (nonatomic,strong)NSString<Optional> *order_time;
@property (nonatomic,strong)NSString<Optional> *auto_end_time;
@property (nonatomic,strong)NSString<Optional> *order_id;
@property (nonatomic,strong)NSDictionary<Optional> *goods;
@property (nonatomic,strong)NSString<Optional> *third_pay;
@property (nonatomic,strong)NSString<Optional> *allow_apply;
@property (nonatomic,strong)NSString<Optional> *status_name;
@property (nonatomic,strong)NSString<Optional> *status_time;
@property (nonatomic,strong)NSString<Optional> *kinds;
@property (nonatomic,strong)NSString<Optional> *is_discuss;
@property (nonatomic,strong)NSString<Optional> *rest_time;
@property (nonatomic,strong)NSString<Optional> *group_status;
@property (nonatomic,strong)NSString<Optional> *token;
@property (nonatomic,strong)NSString<Optional> *group_buy_goods_rule_id;
@end

@interface MyOrderModel : JSONModel
@property (nonatomic,strong)NSArray<MyOrderDataModel,Optional> *data;
@end
