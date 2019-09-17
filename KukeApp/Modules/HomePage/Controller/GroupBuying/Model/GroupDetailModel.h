//
//  GroupDetailModel.h
//  KukeApp
//
//  Created by 库课 on 2019/1/17.
//  Copyright © 2019 zhangming. All rights reserved.
//

#import "JSONModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol GroupDetailGoodsModel <NSObject>
@end
@interface GroupDetailGoodsModel : JSONModel
@property (nonatomic,strong)NSString<Optional> *group_buy_goods_rule_id;
@property (nonatomic,strong)NSString<Optional> *group_buy_price;
@property (nonatomic,strong)NSString<Optional> *group_base_num;
@property (nonatomic,strong)NSString<Optional> *goods_id;
@property (nonatomic,strong)NSString<Optional> *goods_type;
@property (nonatomic,strong)NSString<Optional> *goods_name;
@property (nonatomic,strong)NSString<Optional> *goods_img;
@property (nonatomic,strong)NSString<Optional> *goods_price;
@property (nonatomic,strong)NSString<Optional> *group_buy_id;
@property (nonatomic,strong)NSString<Optional> *end_time;
@property (nonatomic,strong)NSString<Optional> *limit_time;
@property (nonatomic,strong)NSString<Optional> *rest_time;
@property (nonatomic,strong)NSString<Optional> *rest_num;
@property (nonatomic,strong)NSString<Optional> *is_include;
@end


@protocol GroupDetailStuModel <NSObject>
@end
@interface GroupDetailStuModel : JSONModel
@property (nonatomic,strong)NSString<Optional> *token;
@property (nonatomic,strong)NSString<Optional> *stu_id;
@property (nonatomic,strong)NSString<Optional> *stu_name;
@property (nonatomic,strong)NSString<Optional> *is_collar;
@property (nonatomic,strong)NSString<Optional> *add_time;
@property (nonatomic,strong)NSString<Optional> *photo;
@property (nonatomic,strong)NSString<Optional> *group_buy_goods_id;
@end


@protocol GroupDetailGroupModel <NSObject>
@end
@interface GroupDetailGroupModel : JSONModel
@property (nonatomic,strong)NSString<Optional> *group_buy_id;
@property (nonatomic,strong)NSString<Optional> *group_buy_goods_id;
@property (nonatomic,strong)NSString<Optional> *goods_id;
@property (nonatomic,strong)NSString<Optional> *goods_img;
@property (nonatomic,strong)NSString<Optional> *goods_name;
@property (nonatomic,strong)NSString<Optional> *goods_price;
@property (nonatomic,strong)NSString<Optional> *goods_type;
@property (nonatomic,strong)NSString<Optional> *group_buy_price;
@property (nonatomic,strong)NSString<Optional> *group_base_num;
@property (nonatomic,strong)NSString<Optional> *pre_num;
@end


@protocol GroupDetailDataModel <NSObject>
@end
@interface GroupDetailDataModel : JSONModel
@property (nonatomic,strong)NSArray<GroupDetailGroupModel,Optional> *group;
@property (nonatomic,strong)NSArray<GroupDetailStuModel,Optional> *stu;
@property (nonatomic,strong)GroupDetailGoodsModel<Optional> *goods;

@end


@interface GroupDetailModel : JSONModel
@property (nonatomic,strong)GroupDetailDataModel<Optional> *data;
@end

NS_ASSUME_NONNULL_END


