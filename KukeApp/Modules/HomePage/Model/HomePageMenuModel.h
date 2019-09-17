//
//  HomePageMenuModel.h
//  KukeApp
//
//  Created by iOSDeveloper on 2018/10/8.
//  Copyright © 2018年 zhangming. All rights reserved.
//

#import "JSONModel.h"

@protocol HomePagePlaySeckillListModel <NSObject>
@end
@interface HomePagePlaySeckillListModel : JSONModel
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

@protocol HomePagePlaySeckillModel <NSObject>
@end
@interface HomePagePlaySeckillModel : JSONModel
@property (nonatomic,strong)NSString<Optional> *start_time;
@property (nonatomic,strong)NSString<Optional> *end_time;
@property (nonatomic,strong)NSString<Optional> *seckill_status;
@property (nonatomic,strong)NSString<Optional> *seckill_date;
@property (nonatomic,strong)NSArray<HomePagePlaySeckillListModel,Optional> *goods;

@end



@protocol HomeGroupBuyingModel <NSObject>
@end
@interface HomeGroupBuyingModel : JSONModel
@property (nonatomic,strong)NSString<Optional> *group_buy_id;
@property (nonatomic,strong)NSString<Optional> *group_buy_goods_id;
@property (nonatomic,strong)NSString<Optional> *goods_id;
@property (nonatomic,strong)NSString<Optional> *goods_name;
@property (nonatomic,strong)NSString<Optional> *goods_img;
@property (nonatomic,strong)NSString<Optional> *goods_price;
@property (nonatomic,strong)NSString<Optional> *goods_type;
@property (nonatomic,strong)NSString<Optional> *group_buy_price;
@property (nonatomic,strong)NSString<Optional> *group_base_num;
@property (nonatomic,strong)NSString<Optional> *pre_num;

@end


@protocol HomeNewsModel <NSObject>
@end
@interface HomeNewsModel : JSONModel
@property (nonatomic,strong)NSString<Optional> *url;
@property (nonatomic,strong)NSString<Optional> *title;
@property (nonatomic,strong)NSString<Optional> *picture;
@property (nonatomic,strong)NSString<Optional> *add_time;
@property (nonatomic,strong)NSString<Optional> *label_name;


@end

//banner
@protocol HomePagePlayModel <NSObject>
@end
@interface HomePagePlayModel : JSONModel
@property (nonatomic,strong)NSString<Optional> *course_id;
@property (nonatomic,strong)NSString<Optional> *course_img;
@property (nonatomic,strong)NSString<Optional> *last_node_id;
@property (nonatomic,strong)NSString<Optional> *last_node_number;
@property (nonatomic,strong)NSString<Optional> *last_node_title;
@property (nonatomic,strong)NSString<Optional> *last_time_point;
@property (nonatomic,strong)NSString<Optional> *course_title;
@end

//banner
@protocol HomePageAdModel <NSObject>
@end
@interface HomePageAdModel : JSONModel
@property (nonatomic,strong)NSString<Optional> *image;
@property (nonatomic,strong)NSString<Optional> *title;
@property (nonatomic,strong)NSString<Optional> *url;
@end


//banner
@protocol HomePageCategoryModel <NSObject>
@end
@interface HomePageCategoryModel : JSONModel
@property (nonatomic,strong)NSString<Optional> *icon;
@property (nonatomic,strong)NSString<Optional> *ID;
@property (nonatomic,strong)NSString<Optional> *name;
@end


//banner
@protocol HomePageBannerModel <NSObject>
@end
@interface HomePageBannerModel : JSONModel
@property (nonatomic,strong)NSString<Optional> *image;
@property (nonatomic,strong)NSString<Optional> *title;
@property (nonatomic,strong)NSString<Optional> *url;
@end


//liveteacher
@protocol HomePageLiveTeacherModel <NSObject>
@end
@interface HomePageLiveTeacherModel : JSONModel
@property (nonatomic,strong)NSString<Optional> *teacher_name;
@property (nonatomic,strong)NSString<Optional> *photo;

@end

//live
@protocol HomeLiveModel <NSObject>
@end
@interface HomeLiveModel : JSONModel
@property (nonatomic,strong)NSString<Optional> *live_time_text;
@property (nonatomic,strong)NSString<Optional> *title;
@property (nonatomic,strong)NSString<Optional> *live_id;
@property (nonatomic,strong)NSString<Optional> *live_status;
@property (nonatomic,strong)NSArray<HomePageLiveTeacherModel,Optional> *teachers;
@end



@protocol HomePageDataModel <NSObject>
@end
@interface HomePageDataModel : JSONModel
@property (nonatomic,strong)NSArray<HomePageBannerModel,Optional> *carousel;
@property (nonatomic,strong)HomePageAdModel<Optional> *ad;
@property (nonatomic,strong)NSArray<HomePageCategoryModel,Optional> *category;
@property (nonatomic,strong)HomePagePlayModel<Optional> *course_last_play;
@property (nonatomic,strong)NSArray<HomeGroupBuyingModel,Optional> *group;
@property (nonatomic,strong)HomePagePlaySeckillModel<Optional> *seckill;
@property (nonatomic,strong)NSArray<HomeNewsModel,Optional> *news;
@property (nonatomic,strong)NSArray<HomeLiveModel,Optional> *lives;
@end






@interface HomePageMenuModel : JSONModel
@property (nonatomic,strong)HomePageDataModel<Optional> *data;
@end
