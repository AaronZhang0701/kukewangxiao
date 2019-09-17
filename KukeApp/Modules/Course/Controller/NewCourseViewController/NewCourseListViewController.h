//
//  NewCourseListViewController.h
//  KukeApp
//
//  Created by 库课 on 2019/4/15.
//  Copyright © 2019 KukeZangMing. All rights reserved.
//

#import "ZMBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface NewCourseListViewController : ZMBaseCollectionViewController
@property (nonatomic, assign) NSInteger cate_id;
@property (nonatomic, assign) NSString *isChangeCateID;
- (void)upLoadData;
- (void)upLoadData1;
- (void)pushUpLoadData;
@end

NS_ASSUME_NONNULL_END
