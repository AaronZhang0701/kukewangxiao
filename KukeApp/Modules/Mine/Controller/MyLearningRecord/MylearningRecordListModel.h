//
//  MylearningRecordListModel.h
//  KukeApp
//
//  Created by 库课 on 2018/12/26.
//  Copyright © 2018 zhangming. All rights reserved.
//

#import "JSONModel.h"

NS_ASSUME_NONNULL_BEGIN
@protocol MyLearningListDataModel <NSObject>
@end
@interface MyLearningListDataModel : JSONModel
@property (nonatomic,strong)NSString<Optional> *course_id;
@property (nonatomic,strong)NSString<Optional> *course_title;
@property (nonatomic,strong)NSString<Optional> *course_img;
@property (nonatomic,strong)NSString<Optional> *learn_status;
@property (nonatomic,strong)NSString<Optional> *course_lesson_num;
@property (nonatomic,strong)NSString<Optional> *learned_lesson_num;
@property (nonatomic,strong)NSString<Optional> *last_node_id;
@property (nonatomic,strong)NSString<Optional> *last_node_number;
@property (nonatomic,strong)NSString<Optional> *last_node_title;
@property (nonatomic,strong)NSString<Optional> *learned_media_seconds_count;
@property (nonatomic,strong)NSString<Optional> *over_time;
@property (nonatomic,strong)NSString<Optional> *course_media_count;
@property (nonatomic,strong)NSString<Optional> *learned_media_count;
@property (nonatomic,strong)NSString<Optional> *course_discount_price;
@property (nonatomic,strong)NSString<Optional> *is_expired;



@property (nonatomic,strong)NSString<Optional> *live_id;
@property (nonatomic,strong)NSString<Optional> *title;
@property (nonatomic,strong)NSString<Optional> *img;
@property (nonatomic,strong)NSString<Optional> *discount_price;
@property (nonatomic,strong)NSString<Optional> *lesson_num;
@property (nonatomic,strong)NSString<Optional> *media_count;
@property (nonatomic,strong)NSString<Optional> *live_time_text;
@property (nonatomic,strong)NSString<Optional> *live_status;
@property (nonatomic,strong)NSString<Optional> *node_time_text;




@end

@interface MylearningRecordListModel : JSONModel
@property (nonatomic,strong)NSArray<MyLearningListDataModel,Optional> *data;
@end

NS_ASSUME_NONNULL_END
