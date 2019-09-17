//
//  CourseDetailModel.h
//  KukeApp
//
//  Created by iOSDeveloper on 2018/10/12.
//  Copyright © 2018年 zhangming. All rights reserved.
//

#import "JSONModel.h"


@protocol CourseDetailSeckillModel <NSObject>
@end
@interface CourseDetailSeckillModel : JSONModel
@property (nonatomic,strong)NSString<Optional> *start_time;
@property (nonatomic,strong)NSString<Optional> *end_time;
@property (nonatomic,strong)NSString<Optional> *seckill_price;
@property (nonatomic,strong)NSString<Optional> *seckill_status;
@property (nonatomic,strong)NSString<Optional> *seckill_goods_id;

@end

@protocol CourseDetailGroupModel <NSObject>
@end
@interface CourseDetailGroupModel : JSONModel
@property (nonatomic,strong)NSString<Optional> *group_base_num;
@property (nonatomic,strong)NSString<Optional> *group_buy_goods_id;
@property (nonatomic,strong)NSString<Optional> *group_buy_id;
@property (nonatomic,strong)NSString<Optional> *group_buy_price;
@property (nonatomic,strong)NSString<Optional> *group_buy_goods_rule_id;
@property (nonatomic,strong)NSString<Optional> *open_num;
@property (nonatomic,strong)NSString<Optional> *pre_num;
@property (nonatomic,strong)NSString<Optional> *token;
@end

@protocol CourseDetailTeacherModel <NSObject>
@end
@interface CourseDetailTeacherModel : JSONModel
@property (nonatomic,strong)NSString<Optional> *teacher_name;
@property (nonatomic,strong)NSString<Optional> *photo;
@property (nonatomic,strong)NSString<Optional> *title;
@property (nonatomic,strong)NSString<Optional> *intro;
@property (nonatomic,strong)NSString<Optional> *major;

@end


@protocol CourseDetailGroupRecommendModel <NSObject>
@end
@interface CourseDetailGroupRecommendModel : JSONModel
@property (nonatomic,strong)NSString<Optional> *token;
@property (nonatomic,strong)NSString<Optional> *photo;
@property (nonatomic,strong)NSString<Optional> *stu_name;
@property (nonatomic,strong)NSString<Optional> *group_buy_goods_rule_id;
@property (nonatomic,strong)NSString<Optional> *rest_num;
@property (nonatomic,strong)NSString<Optional> *rest_time;
@property (nonatomic,strong)NSString<Optional> *is_include;
@property (nonatomic,strong)NSString<Optional> *is_online;
@end


@protocol CourseDistributionModel <NSObject>
@end
@interface CourseDistributionModel : JSONModel
@property (nonatomic,strong)NSString<Optional> *distribute_status;
@property (nonatomic,strong)NSString<Optional> *distribute;
@property (nonatomic,strong)NSString<Optional> *bro_money;
@property (nonatomic,strong)NSString<Optional> *coalition_id;
@property (nonatomic,strong)NSString<Optional> *dist_id;
@property (nonatomic,strong)NSString<Optional> *distributor_status;
@end



@interface CourseDetailModel : JSONModel
@property (nonatomic,strong)NSString<Optional> *discount_price;
@property (nonatomic,strong)NSString<Optional> *ID;
@property (nonatomic,strong)NSString<Optional> *img;
@property (nonatomic,strong)NSString<Optional> *price;
@property (nonatomic,strong)NSString<Optional> *subtitle;
@property (nonatomic,strong)NSString<Optional> *title;
@property (nonatomic,strong)NSString<Optional> *validity_day;
@property (nonatomic,strong)NSString<Optional> *lesson_num;
@property (nonatomic,strong)NSString<Optional> *content;
@property (nonatomic,strong)NSString<Optional> *is_collect;
@property (nonatomic,strong)NSString<Optional> *testpaper_num;
@property (nonatomic,strong)NSString<Optional> *seckill_flag;
@property (nonatomic,strong)NSString<Optional> *group_sign;
@property (nonatomic,strong)NSString<Optional> *live_exam;
@property (nonatomic,strong)NSString<Optional> *live_start;
@property (nonatomic,strong)NSString<Optional> *live_end;
@property (nonatomic,strong)NSString<Optional> *live_time_text;
@property (nonatomic,strong)NSString<Optional> *is_coupon;
@property (nonatomic,strong)NSArray<CourseDetailTeacherModel,Optional> *teacher;
@property (nonatomic,strong)NSArray<CourseDetailGroupRecommendModel,Optional> *group_recommend;
@property (nonatomic,strong)NSString<Optional> *book_num;
@property (nonatomic,strong)NSString<Optional> *exam_num;
@property (nonatomic,strong)NSString<Optional> *course_num;
@property (nonatomic,strong)NSString<Optional> *live_num;
@property (nonatomic,strong)CourseDetailGroupModel<Optional> *group;
@property (nonatomic,strong)CourseDetailSeckillModel<Optional> *seckill_goods;
@property (nonatomic,strong)CourseDistributionModel<Optional> *distribution;
@property (nonatomic,strong)NSString<Optional> *detail_url;
@property (nonatomic,strong)NSString<Optional> *my_goods_type;
@property (nonatomic,strong)NSString<Optional> *my_ac_type;
@property (nonatomic,strong)NSString<Optional> *is_sell;
@property (nonatomic,strong)NSString<Optional> *default_play_node;
@property (nonatomic,strong)NSString<Optional> *my_click_distribute;
@property (nonatomic,strong)NSString<Optional> *now_goods_group_status;
@end
