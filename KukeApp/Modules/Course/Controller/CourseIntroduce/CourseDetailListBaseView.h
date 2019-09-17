//  KukeApp
//
//  Created by iOSDeveloper on 2018/8/23.
//  Copyright © 2018年 zhangming. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JXPagingView.h"

@protocol TestListViewDelegate <NSObject>
- (void)listViewDidScroll:(UIScrollView *)scrollView;
@end

@interface CourseDetailListBaseView : UIView <JXPagingViewListViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, weak) id<TestListViewDelegate> delegate;

@end

