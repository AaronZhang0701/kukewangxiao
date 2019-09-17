//
//  DownLoadVideoDataBaseTool.m
//  KukeApp
//
//  Created by iOSDeveloper on 2018/12/6.
//  Copyright © 2018年 zhangming. All rights reserved.
//

#import "DownLoadVideoDataBaseTool.h"
#import "DownLoadDataBaseModel.h"
#define PERSON_PATH  [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject]stringByAppendingPathComponent:@"MyDownLoadVideos.sqlite"]

@implementation DownLoadVideoDataBaseTool

static FMDatabase *_dbase;

+ (void)initialize
{
    // 1.打开数据库
    _dbase = [FMDatabase databaseWithPath:PERSON_PATH];
    NSLog(@"%@",PERSON_PATH);
    [_dbase open];
    // 2.创表
    [_dbase executeUpdate:@"CREATE TABLE IF NOT EXISTS t_video (vid text, title text, videoImage text, categoryId text, categoryName text, videoCount text, videoType text,lessonNO text);"];
}

+ (void)addVideo:(DownLoadDataBaseModel *)video{
    
    BOOL ret = [_dbase executeUpdateWithFormat:@"INSERT INTO t_video(vid,title,videoImage,categoryId,categoryName,videoCount,videoType,lessonNO) VALUES (%@,%@,%@,%@,%@,%@,%@,%@);", video.vid,video.title,video.videoImage,video.categoryId,video.categoryName,video.videoCount,video.videoType,video.lessonNO];
    if(ret){
        NSLog(@"插入视频数据成功");
    }else{
        NSLog(@"插入视频数据失败");
    }
}
//根据categoryID查询数据
+ (DownLoadDataBaseModel *)selectWithCategoryID:(NSString *)categoryID
{
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM t_video WHERE categoryId='%@'",categoryID];
    FMResultSet *set = [_dbase executeQuery:sql];
    DownLoadDataBaseModel *videoModel = [[DownLoadDataBaseModel alloc]init];
    while (set.next) {
        // 获得当前所指向的数据
        videoModel.videoImage = [set stringForColumn:@"videoImage"];
        videoModel.videoCount = [set stringForColumn:@"videoCount"];
        videoModel.categoryId = [set stringForColumn:@"categoryId"];
        videoModel.categoryName = [set stringForColumn:@"categoryName"];
        videoModel.lessonNO = [set stringForColumn:@"lessonNO"];
    }
    return videoModel;
}


//根据vid查询数据
+ (DownLoadDataBaseModel *)selectModeWithVid:(NSString *)vid
{
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM t_video WHERE vid='%@'",vid];
    FMResultSet *set = [_dbase executeQuery:sql];
    DownLoadDataBaseModel *videoModel = [[DownLoadDataBaseModel alloc]init];
    while (set.next) {
        // 获得当前所指向的数据
        videoModel.videoImage = [set stringForColumn:@"videoImage"];
        videoModel.videoCount = [set stringForColumn:@"videoCount"];
        videoModel.categoryId = [set stringForColumn:@"categoryId"];
        videoModel.categoryName = [set stringForColumn:@"categoryName"];
        videoModel.title = [set stringForColumn:@"title"];
        videoModel.lessonNO = [set stringForColumn:@"lessonNO"];
    }
    return videoModel;
}

//根据categoryID 和type 查询数据 本分类下下载完成的视频
+ (NSMutableArray *)selectVideoCountWithCategoryID:(NSString *)categoryId andVideoType:(NSString *)type
{
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM t_video WHERE categoryId='%@' and videoType='%@'",categoryId,type];
    FMResultSet *set = [_dbase executeQuery:sql];
    
    // 不断往下取数据
    NSMutableArray *shops = [NSMutableArray array];
    while (set.next) {
        DownLoadDataBaseModel *videoModel = [[DownLoadDataBaseModel alloc]init];
        videoModel.videoImage = [set stringForColumn:@"videoImage"];
        videoModel.vid = [set stringForColumn:@"vid"];
        videoModel.title = [set stringForColumn:@"title"];
        [shops addObject:videoModel];
    }
    return shops;
}


//根据categoryID 和type 查询数据 本分类下下载完成的vid
+ (NSMutableArray *)selectVidWithCategoryID:(NSString *)categoryId andVideoType:(NSString *)type
{
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM t_video WHERE categoryId='%@' and videoType='%@'",categoryId,type];
    FMResultSet *set = [_dbase executeQuery:sql];
    
    // 不断往下取数据
    NSMutableArray *shops = [NSMutableArray array];
    while (set.next) {
       
        NSString *vid =[set stringForColumn:@"vid"];
        [shops addObject:vid];
    }
    return shops;
}



//根据categoryID 和vid 查询数据是否存在
+ (NSMutableArray *)selectVideoWithCategoryID:(NSString *)categoryId andVid:(NSString *)vid
{
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM t_video WHERE categoryId='%@' and vid='%@'",categoryId,vid];
    FMResultSet *set = [_dbase executeQuery:sql];
    
    // 不断往下取数据
    NSMutableArray *shops = [NSMutableArray array];
    while (set.next) {
        
        NSString *vid =[set stringForColumn:@"vid"];
        [shops addObject:vid];
    }
    return shops;
}

//根据type查询数据的categoryID
+ (NSMutableArray *)selectType:(NSString *)type
{
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM t_video WHERE videoType='%@'",type];
    FMResultSet *set = [_dbase executeQuery:sql];
    
    // 不断往下取数据
    NSMutableArray *shops = [NSMutableArray array];
    while (set.next) {
        // 获得当前所指向的数据
        NSString *categoryId = nil;
        categoryId = [set stringForColumn:@"categoryId"];
        [shops addObject:categoryId];
    }
    return shops;
}
//修改视频下载状态
+ (void)updateVideoType:(NSString *)videoType whenVid:(NSString *)vid
{
    
    if ([_dbase open]) {
        NSString *updateSql = [NSString stringWithFormat:@"update t_video set videoType='%@' where vid='%@'",videoType,vid];
        BOOL res = [_dbase executeUpdate:updateSql];
        
        if (res) {
            NSLog(@"视频状态修改成功");
            
        } else {
            NSLog(@"视频状态修改失败");
            
        }
        
    }
    
}

+ (void)deleteVideoWithVid:(NSString *)vid
{

    
    if ([_dbase open]) {
        NSString *updateSql = [NSString stringWithFormat:@"DELETE FROM t_video where vid='%@'",vid];
        BOOL res = [_dbase executeUpdate:updateSql];
        
        if (res) {
            NSLog(@"视频删除成功");
            
        } else {
            NSLog(@"视频删除失败");
            
        }
        
    }
    
}




+ (BOOL)deleteListData
{
    BOOL result = [_dbase executeUpdate:@"DELETE FROM t_video"];
    return result;
}

+ (NSMutableArray *)getAllVideos
{
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM t_video;"];
    FMResultSet *set = [_dbase executeQuery:sql];
    
    // 不断往下取数据
    NSMutableArray *shops = [NSMutableArray array];
    while (set.next) {
        DownLoadDataBaseModel *videoModel = [[DownLoadDataBaseModel alloc]init];
        videoModel.videoImage = [set stringForColumn:@"videoImage"];
        videoModel.vid = [set stringForColumn:@"vid"];
        videoModel.title = [set stringForColumn:@"title"];
        videoModel.videoType = [set stringForColumn:@"videoType"];
        videoModel.lessonNO = [set stringForColumn:@"lessonNO"];

        [shops addObject:videoModel];
    }
    return shops;
}

@end
