//
//  DownLoadDataBaseModel.h
//  KukeApp
//
//  Created by iOSDeveloper on 2018/12/6.
//  Copyright © 2018年 zhangming. All rights reserved.
//

#import "JSONModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface DownLoadDataBaseModel : JSONModel

///  视频截图
@property (nonatomic, copy) NSString *videoImage;

/// cataid 分类ID
@property (nonatomic, copy) NSString *categoryId;

/// cataname 分类名称
@property (nonatomic, copy) NSString *categoryName;

/// vid
@property (nonatomic, copy) NSString *vid;

/// title 标题
@property (nonatomic, copy) NSString *title;

/// 课时个数
@property (nonatomic, copy) NSString *videoCount;

/// 视频状态
@property (nonatomic, copy) NSString *videoType;
/// 第几节
@property (nonatomic, copy) NSString *lessonNO;
@end

NS_ASSUME_NONNULL_END
