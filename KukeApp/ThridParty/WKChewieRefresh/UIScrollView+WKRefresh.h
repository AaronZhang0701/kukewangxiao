//
//  UIScrollView+WKRefresh.h
//  UICollectionViewTest
//
//  Created by 王昆 on 16/11/24.
//  Copyright © 2016年 wangkun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIScrollView (WKRefresh)

@property (nonatomic, copy) void(^wk_beginRefreshCallBack)(void); /** 开始刷新的回调 */

/** 开启刷新功能 */
- (void)wk_configureRefresh;

/** 开始刷新 */
- (void)wk_beginRefresh;

/** 停止刷新 */
- (void)wk_endRefresh;

/** 设置下拉刷新状态 */
- (void)wk_setRefreshEnable:(BOOL)enable;


@end
