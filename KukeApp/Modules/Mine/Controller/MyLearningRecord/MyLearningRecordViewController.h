//
//  MyLearningRecordViewController.h
//  KukeApp
//
//  Created by 库课 on 2018/12/20.
//  Copyright © 2018 zhangming. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MyLearningRecordViewController :  ZMBaseTableViewController

@property (nonatomic, strong) NSString *imageUrl;
@property (nonatomic, strong) NSString *course_id;

@property (nonatomic, strong) NSString *course_name;
@property (nonatomic, strong) NSString *course_lesson_num;
@property (nonatomic, strong) NSString *continueLearningID;
@property (nonatomic, strong) NSString *course_discount_price;
@property (nonatomic, assign) BOOL isLive;
@property (nonatomic, strong) NSString *living;
@end

NS_ASSUME_NONNULL_END
