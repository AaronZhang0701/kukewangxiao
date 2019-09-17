//
//  DownLoadVideoDataBaseTool.h
//  KukeApp
//
//  Created by iOSDeveloper on 2018/12/6.
//  Copyright © 2018年 zhangming. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DownLoadDataBaseModel.h"

@interface DownLoadVideoDataBaseTool : NSObject
+ (void)addVideo:(DownLoadDataBaseModel *)video;
+ (DownLoadDataBaseModel *)selectModeWithVid:(NSString *)vid;
+ (BOOL)deleteListData;

//修改视频下载状态
+ (void)updateVideoType:(NSString *)videoType whenVid:(NSString *)vid;
//根据type查询数据的categoryID
+ (NSMutableArray *)selectType:(NSString *)type;
+ (DownLoadDataBaseModel *)selectWithCategoryID:(NSString *)categoryID;
//根据categoryID 和type 查询数据 本分类下下载完成的视频
+ (NSMutableArray *)selectVideoCountWithCategoryID:(NSString *)categoryId andVideoType:(NSString *)type;
//根据categoryID 和type 查询数据 本分类下下载完成的vid
+ (NSMutableArray *)selectVidWithCategoryID:(NSString *)categoryId andVideoType:(NSString *)type;
+ (void)deleteVideoWithVid:(NSString *)vid;

+ (NSMutableArray *)selectVideoWithCategoryID:(NSString *)categoryId andVid:(NSString *)vid;

+ (NSMutableArray *)getAllVideos;
@end

