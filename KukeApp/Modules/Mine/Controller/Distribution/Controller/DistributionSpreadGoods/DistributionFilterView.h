//
//  DistributionFilterView.h
//  KukeApp
//
//  Created by 库课 on 2019/6/3.
//  Copyright © 2019 KukeZangMing. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^CourseFiltrateActionBlock)(NSArray *ary);
typedef void(^NewCourseFiltrateActionBlock)(NSMutableDictionary *dict);
@interface DistributionFilterView : UIView


@property (nonatomic ,copy) CourseFiltrateActionBlock myBlock;

@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, assign) NSArray *ary;

- (void)loadData;
@end
