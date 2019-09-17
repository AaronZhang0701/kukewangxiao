//
//  JoinGroupListModel.h
//  KukeApp
//
//  Created by 库课 on 2019/1/17.
//  Copyright © 2019 zhangming. All rights reserved.
//

#import "JSONModel.h"

NS_ASSUME_NONNULL_BEGIN


@protocol JoinGroupListSonModel <NSObject>
@end
@interface JoinGroupListSonModel : JSONModel
@property (nonatomic,strong)NSString<Optional> *photo;
@property (nonatomic,strong)NSString<Optional> *stu_name;

@end


@protocol JoinGroupListDataModel <NSObject>
@end
@interface JoinGroupListDataModel : JSONModel
@property (nonatomic,strong)NSString<Optional> *add_time;
@property (nonatomic,strong)NSString<Optional> *group_buy_goods_id;
@property (nonatomic,strong)NSString<Optional> *group_buy_goods_rule_id;
@property (nonatomic,strong)NSString<Optional> *group_buy_id;
@property (nonatomic,strong)NSString<Optional> *photo;
@property (nonatomic,strong)NSString<Optional> *rest_num;
@property (nonatomic,strong)NSString<Optional> *rest_time;
@property (nonatomic,strong)NSString<Optional> *stu_name;
@property (nonatomic,strong)NSString<Optional> *token;
@property (nonatomic,strong)NSString<Optional> *goods_type;
@property (nonatomic,strong)NSString<Optional> *goods_id;
@property (nonatomic,strong)NSString<Optional> *is_include;
@property (nonatomic,strong)NSArray<JoinGroupListSonModel,Optional> *son;

@end

@interface JoinGroupListModel : JSONModel
@property (nonatomic,strong)NSArray<JoinGroupListDataModel,Optional> *data;
@end

NS_ASSUME_NONNULL_END
