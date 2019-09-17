//
//  CourseCommentModel.h
//  KukeApp
//
//  Created by iOSDeveloper on 2018/10/14.
//  Copyright © 2018年 zhangming. All rights reserved.
//

#import "JSONModel.h"
@protocol CourseCommentListModel <NSObject>


@end
@interface CourseCommentListModel : JSONModel
@property (nonatomic,strong)NSString<Optional> *stu_name;
@property (nonatomic,strong)NSString<Optional> *ID;
@property (nonatomic,strong)NSString<Optional> *content;
@property (nonatomic,strong)NSString<Optional> *add_time;
@property (nonatomic,strong)NSString<Optional> *reply;
@property (nonatomic,strong)NSString<Optional> *img;
@property (nonatomic,strong)NSString<Optional> *reply_time;
@property (nonatomic,strong)NSString<Optional> *kuke_star;
@end




@protocol CourseCommentDataListModel <NSObject>
@end
@interface CourseCommentDataListModel : JSONModel
@property (nonatomic,strong)NSArray<CourseCommentListModel,Optional> *data;
@end




@interface CourseCommentModel : JSONModel
@property (nonatomic,strong)CourseCommentDataListModel<Optional> *data;
@property (nonatomic,strong)NSString<Optional> *all_num;
@property (nonatomic,strong)NSString<Optional> *five_num;
@end
