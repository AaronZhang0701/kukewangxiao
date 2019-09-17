//
//  MineExamListModel.h
//  KukeApp
//
//  Created by 库课 on 2019/8/8.
//  Copyright © 2019 KukeZangMing. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

//二级分类
@protocol NewExamListHeaderDataModel <NSObject>
@end
@interface NewExamListHeaderDataModel : JSONModel
@property (nonatomic,strong)NSString<Optional> *do_count;
@property (nonatomic,strong)NSString<Optional> *subjective_item_count;
@property (nonatomic,strong)NSString<Optional> *right_radio;
@property (nonatomic,strong)NSString<Optional> *right_item_count;
@property (nonatomic,strong)NSString<Optional> *used_time;
@property (nonatomic,strong)NSString<Optional> *hours;
@property (nonatomic,strong)NSString<Optional> *minutes;
@property (nonatomic,strong)NSString<Optional> *wrong_count;
@property (nonatomic,strong)NSString<Optional> *collection_count;
@end



@protocol NewExamListData <NSObject>
@end
@interface NewExamListData : JSONModel
@property (nonatomic,strong)NSString<Optional> *stu_id;
@property (nonatomic,strong)NSString<Optional> *exam_id;
@property (nonatomic,strong)NSString<Optional> *deadline;
@property (nonatomic,strong)NSString<Optional> *title;
@property (nonatomic,strong)NSString<Optional> *img;
@property (nonatomic,strong)NSString<Optional> *testpaper_num;
@property (nonatomic,strong)NSString<Optional> *over_num;
@property (nonatomic,strong)NSString<Optional> *study_status;
@property (nonatomic,strong)NSString<Optional> *ave_score;
@property (nonatomic,strong)NSString<Optional> *is_expired;
@end


@protocol NewExamDataModel <NSObject>
@end
@interface NewExamDataModel : JSONModel
@property (nonatomic,strong)NSArray<NewExamListData,Optional> *record;
@property (nonatomic,strong)NewExamListHeaderDataModel<Optional> *report;
@end

@interface MineExamListModel : JSONModel
@property (nonatomic,strong)NewExamDataModel<Optional> *data;
@end

NS_ASSUME_NONNULL_END
