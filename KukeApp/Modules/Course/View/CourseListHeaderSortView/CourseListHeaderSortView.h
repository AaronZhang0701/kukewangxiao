//
//  HZNewListHeaderSortView.h
//  YXYC
//
//  Created by ios hzjt on 2018/6/5.
//  Copyright © 2018年 hzjt. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^CourseSortActionBlock)(NSString  *sortName,NSUInteger sortID);

@interface CourseListHeaderSortView : UIView

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic ,copy) CourseSortActionBlock myBlock;
@end
