//
//  CourseListModel.h
//  KukeApp
//
//  Created by iOSDeveloper on 2018/9/30.
//  Copyright © 2018年 zhangming. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@protocol CourseDataAryModel <NSObject>


@end
@interface CourseDataAryModel : JSONModel
@property (nonatomic,strong)NSString<Optional> *discount_price;
@property (nonatomic,strong)NSString<Optional> *ID;
@property (nonatomic,strong)NSString<Optional> *img;
@property (nonatomic,strong)NSString<Optional> *price;
@property (nonatomic,strong)NSString<Optional> *sorting;
@property (nonatomic,strong)NSString<Optional> *student_num;
@property (nonatomic,strong)NSString<Optional> *subtitle;
@property (nonatomic,strong)NSString<Optional> *title;
@property (nonatomic,strong)NSString<Optional> *type;
@property (nonatomic,strong)NSString<Optional> *goods_type;
@property (nonatomic,strong)NSString<Optional> *add_time;
@property (nonatomic,strong)NSString<Optional> *book_num;
@property (nonatomic,strong)NSString<Optional> *is_recommend;
@property (nonatomic,strong)NSString<Optional> *student_num_base;

@property (nonatomic,strong)NSString<Optional> *validity_day;

@property (nonatomic,strong)NSString<Optional> *lesson_num;
@property (nonatomic,strong)NSString<Optional> *course_num;
@property (nonatomic,strong)NSString<Optional> *exam_num;
@property (nonatomic,strong)NSString<Optional> *update_time;
@property (nonatomic,strong)NSString<Optional> *live_num;
@property (nonatomic,strong)NSString<Optional> *content;
@property (nonatomic,strong)NSString<Optional> *is_collect;


@property (nonatomic,strong)NSString<Optional> *picture;
@property (nonatomic,strong)NSString<Optional> *news_detail;
@property (nonatomic,strong)NSString<Optional> *name;
@property (nonatomic,strong)NSString<Optional> *label_name;
@property (nonatomic,strong)NSString<Optional> *url;


@property (nonatomic,strong)NSString<Optional> *node_number;
@property (nonatomic,strong)NSString<Optional> *over_num;
@property (nonatomic,strong)NSString<Optional> *ave_score;
@property (nonatomic,strong)NSString<Optional> *testpaper_num;

@property (nonatomic,strong)NSString<Optional> *node;
@property (nonatomic,strong)NSString<Optional> *node_title;
@property (nonatomic,strong)NSString<Optional> *over_time;

@property (nonatomic,strong)NSString<Optional> *live_status;
@property (nonatomic,strong)NSString<Optional> *live_time_text;


@property (nonatomic,strong)NSString<Optional> *goods_id;
@property (nonatomic,strong)NSString<Optional> *is_expired;
@end

@interface CourseListModel : JSONModel
@property (nonatomic,strong)NSArray<CourseDataAryModel,Optional> *data;
@end
