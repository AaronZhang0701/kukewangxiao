//
//  MyOrderBaseViewController.h
//  KukeApp
//
//  Created by iOSDeveloper on 2018/10/22.
//  Copyright © 2018年 zhangming. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^MyOrderListIdActionBlock)(NSString *url);
@interface MyOrderBaseViewController : ZMBaseTableViewController
@property (nonatomic ,copy) MyOrderListIdActionBlock myBlock;
- (void)loadData:(NSInteger)index;
@end
