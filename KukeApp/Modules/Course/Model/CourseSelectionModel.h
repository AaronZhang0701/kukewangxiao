//
//  CourseSelectionModel.h
//  KukeApp
//
//  Created by iOSDeveloper on 2018/9/30.
//  Copyright © 2018年 zhangming. All rights reserved.
//

#import "JSONModel.h"

//三级分类
@protocol CourseSubjectModel <NSObject>
@end
@interface CourseSubjectModel : JSONModel
@property (nonatomic,strong)NSString<Optional> *ID;
@property (nonatomic,strong)NSString<Optional> *name;
@end



//二级分类
@protocol CourseCateSonModel <NSObject>
@end
@interface CourseCateSonModel : JSONModel
@property (nonatomic,strong)NSArray<CourseSubjectModel,Optional> *subject;
@property (nonatomic,strong)NSString<Optional> *ID;
@property (nonatomic,strong)NSString<Optional> *name;
@end






//以及分类
@protocol CourseTopCategoryModel <NSObject>
@end
@interface CourseTopCategoryModel : JSONModel
@property (nonatomic,strong)NSArray<CourseCateSonModel,Optional> *cate_son;
@property (nonatomic,assign)NSInteger ID;
@property (nonatomic,strong)NSString<Optional> *name;
@end


//数据最外层
@interface CourseSelectionModel : JSONModel
@property (nonatomic,strong)NSArray<CourseTopCategoryModel,Optional> *data;
@end
