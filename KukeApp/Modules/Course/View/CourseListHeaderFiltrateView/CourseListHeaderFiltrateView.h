//
//  CourseListHeaderFiltrateView.h
//  YXYC
//
//  Created by ios hzjt on 2018/6/8.
//  Copyright © 2018年 hzjt. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^CourseFiltrateActionBlock)(NSArray *ary);
typedef void(^NewCourseFiltrateActionBlock)(NSMutableDictionary *dict);
@interface CourseListHeaderFiltrateView : UIView
@property (nonatomic ,copy) CourseFiltrateActionBlock myBlock;
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) NSString *index;
@property (nonatomic, strong) NSString *keyWord;
@property (nonatomic, strong) NSString *resource_type;
- (void)loadDataWithCateId:(NSString *)cate_id;
@property (nonatomic, assign) NSString *isChangeCateID;
@property (nonatomic, assign) NSArray *ary;
@end
