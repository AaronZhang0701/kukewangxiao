//
//  ExamTableViewController.h
//  KukeApp
//
//  Created by 库课 on 2019/8/7.
//  Copyright © 2019 KukeZangMing. All rights reserved.
//

#import "ZMBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface ExamTableViewController : ZMBaseTableViewController

@property (nonatomic, strong) NSString *exam_cate_id;
@property (nonatomic, assign) NSInteger number;
@end

NS_ASSUME_NONNULL_END
