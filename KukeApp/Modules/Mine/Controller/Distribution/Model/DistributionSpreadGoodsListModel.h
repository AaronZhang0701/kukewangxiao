//
//  DistributionSpreadGoodsListModel.h
//  KukeApp
//
//  Created by 库课 on 2019/3/25.
//  Copyright © 2019 KukeZangMing. All rights reserved.
//

#import "JSONModel.h"

NS_ASSUME_NONNULL_BEGIN


@protocol DistributionSpreadGoodsListData <NSObject>
@end
@interface DistributionSpreadGoodsListData : JSONModel
@property (nonatomic,strong)NSString<Optional> *coalition_id;
@property (nonatomic,strong)NSString<Optional> *goods_id;
@property (nonatomic,strong)NSString<Optional> *goods_type;
@property (nonatomic,strong)NSString<Optional> *goods_title;
@property (nonatomic,strong)NSString<Optional> *goods_img;
@property (nonatomic,strong)NSString<Optional> *goods_discount_price;
@property (nonatomic,strong)NSString<Optional> *bro_money;

@end

@interface DistributionSpreadGoodsListModel : JSONModel
@property (nonatomic,strong)NSArray<DistributionSpreadGoodsListData,Optional> *data;
@end

NS_ASSUME_NONNULL_END

