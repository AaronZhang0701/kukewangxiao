//
//  SeckillListModel.h
//  KukeApp
//
//  Created by 库课 on 2019/2/22.
//  Copyright © 2019 KukeZangMing. All rights reserved.
//

#import "JSONModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol SeckillListDataModel <NSObject>
@end
@interface SeckillListDataModel : JSONModel
@property (nonatomic,strong)NSString<Optional> *seckill_status;
@property (nonatomic,strong)NSString<Optional> *seckill_price;
@property (nonatomic,strong)NSString<Optional> *stock_occupied_ratio;
@property (nonatomic,strong)NSString<Optional> *goods_id;
@property (nonatomic,strong)NSString<Optional> *goods_type;
@property (nonatomic,strong)NSString<Optional> *goods_price;
@property (nonatomic,strong)NSString<Optional> *goods_title;
@property (nonatomic,strong)NSString<Optional> *goods_img;
@property (nonatomic,strong)NSString<Optional> *stock_total;
@end






@interface SeckillListModel : JSONModel
@property (nonatomic,strong)NSArray<SeckillListDataModel,Optional> *data;
@end


NS_ASSUME_NONNULL_END
