//
//  NewCourseListModel.h
//  KukeApp
//
//  Created by 库课 on 2019/4/18.
//  Copyright © 2019 KukeZangMing. All rights reserved.
//

#import "JSONModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol NewCourseListDataAryModel <NSObject>


@end
@interface NewCourseListDataAryModel : JSONModel

@property (nonatomic,strong)NSString<Optional> *goods_type;
@property (nonatomic,strong)NSString<Optional> *book_num;
@property (nonatomic,strong)NSString<Optional> *validity_day;
@property (nonatomic,strong)NSString<Optional> *lesson_num;
@property (nonatomic,strong)NSString<Optional> *course_num;
@property (nonatomic,strong)NSString<Optional> *exam_num;
@property (nonatomic,strong)NSString<Optional> *live_num;
@property (nonatomic,strong)NSString<Optional> *student_num;
@property (nonatomic,strong)NSString<Optional> *goods_discount_price;
@property (nonatomic,strong)NSString<Optional> *goods_price;
@property (nonatomic,strong)NSString<Optional> *testpaper_num;
@property (nonatomic,strong)NSString<Optional> *goods_img;
@property (nonatomic,strong)NSString<Optional> *goods_title;
@property (nonatomic,strong)NSString<Optional> *goods_id;
@end
@interface NewCourseListModel : JSONModel
@property (nonatomic,strong)NSArray<NewCourseListDataAryModel,Optional> *data;
@end

NS_ASSUME_NONNULL_END
