//
//  CourseCatalogModel.h
//  KukeApp
//
//  Created by iOSDeveloper on 2018/10/15.
//  Copyright © 2018年 zhangming. All rights reserved.
//

#import "JSONModel.h"



//三级分类
@protocol CourseCatalogThreeModel <NSObject>
@end
@interface CourseCatalogThreeModel : JSONModel
@property (nonatomic,strong)NSArray<Optional> *children;
@property (nonatomic,strong)id<Optional> node;
@property (assign, nonatomic) BOOL open;
@end

//二级分类
@protocol CourseCatalogTwoModel <NSObject>
@end
@interface CourseCatalogTwoModel : JSONModel
@property (nonatomic,strong)NSArray<CourseCatalogThreeModel,Optional> *children;
@property (nonatomic,strong)id<Optional> node;
@property (assign, nonatomic) BOOL open;
@end


//一级分类
@protocol CourseCatalogDataModel <NSObject>
@end
@interface CourseCatalogDataModel : JSONModel
@property (nonatomic,strong)NSArray<CourseCatalogTwoModel,Optional> *children;
@property (nonatomic,strong)id<Optional> node;
@property (assign, nonatomic) BOOL open;
@end
@interface CourseCatalogModel : JSONModel
@property (nonatomic,strong)NSArray<CourseCatalogDataModel,Optional> *data;
@end
