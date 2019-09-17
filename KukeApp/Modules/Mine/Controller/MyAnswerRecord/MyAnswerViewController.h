//
//  MyAnswerViewController.h
//  KukeApp
//
//  Created by 库课 on 2018/12/24.
//  Copyright © 2018 zhangming. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MyAnswerViewController : ZMBaseTableViewController
@property (nonatomic, strong)NSString *imageUrl;
@property (nonatomic, strong)NSString *testPaper_id;
@property (nonatomic, strong)NSString *testPaper_title;
@end

NS_ASSUME_NONNULL_END
