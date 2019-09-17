//
//  WKRefreshComponent.h
//  EFFoundation
//
//  Created by 王昆 on 2017/11/7.
//

#import <UIKit/UIKit.h>
#import "WKRefreshConst.h"
#import "UIView+WKExtension.h"
#import "UIScrollView+WKExtension.h"

@interface WKRefreshComponent : UIView
{
    /** 记录scrollView刚开始的inset */
    UIEdgeInsets _scrollViewOriginalInset;
    /** 父控件 */
    __weak UIScrollView *_scrollView;
}

/** 刷新状态 一般交给子类内部实现 */
@property (nonatomic, assign) WKRefreshState state;

/** 记录scrollView刚开始的inset */
@property (nonatomic, assign, readonly) UIEdgeInsets scrollViewOriginalInset;

/** 父控件 */
@property (nonatomic, weak, readonly) UIScrollView *scrollView;

/** 是否正在刷新 */
@property (nonatomic, assign, readonly, getter=isRefreshing) BOOL refreshing;

/** 刷新中回调block */
@property (nonatomic, copy) void(^refreshingBlock)(void);

/** 开始刷新 */
- (void)beginRefreshing;

/** 结束刷新 */
- (void)endRefreshing;


#pragma mark - 交给子类们去实现
/** 初始化 */
- (void)prepare;
/** 摆放子控件frame */
- (void)placeSubviews;
/** 当scrollView的contentOffset发生改变的时候调用 */
- (void)scrollViewContentOffsetDidChange:(NSDictionary *)change;
/** 当scrollView的拖拽状态发生改变的时候调用 */
- (void)scrollViewPanStateDidChange:(NSDictionary *)change;

@end
