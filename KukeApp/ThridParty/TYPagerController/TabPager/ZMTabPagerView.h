//
//  TYTabPagerView.h
//  TYPagerControllerDemo
//
//  Created by tanyang on 2017/7/18.
//  Copyright © 2017年 tany. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TYPagerView.h"
#import "ZMTabPagerBar.h"

NS_ASSUME_NONNULL_BEGIN

@class ZMTabPagerView;
@protocol ZMTabPagerViewDataSource <NSObject>

- (NSInteger)numberOfViewsInTabPagerView;

- (UIView *)tabPagerView:(ZMTabPagerView *)tabPagerView viewForIndex:(NSInteger)index prefetching:(BOOL)prefetching;

- (NSString *)tabPagerView:(ZMTabPagerView *)tabPagerView titleForIndex:(NSInteger)index;

@end

@protocol ZMTabPagerViewDelegate <NSObject>
@optional

// display cell
- (void)tabPagerView:(ZMTabPagerView *)tabPagerView willDisplayCell:(UICollectionViewCell<ZMTabPagerBarCellProtocol> *)cell atIndex:(NSInteger)index;

// did select cell item
- (void)tabPagerView:(ZMTabPagerView *)tabPagerView didSelectTabBarItemAtIndex:(NSInteger)index;

// appear && disappear
- (void)tabPagerView:(ZMTabPagerView *)tabPagerView willAppearView:(UIView *)view forIndex:(NSInteger)index;
- (void)tabPagerView:(ZMTabPagerView *)tabPagerView didDisappearView:(UIView *)view forIndex:(NSInteger)index;

// scrolling
- (void)tabPagerViewWillBeginScrolling:(ZMTabPagerView *)tabPagerView animate:(BOOL)animate;
- (void)tabPagerViewDidEndScrolling:(ZMTabPagerView *)tabPagerView animate:(BOOL)animate;

@end

@interface ZMTabPagerView : UIView

@property (nonatomic, weak, readonly) ZMTabPagerBar *tabBar;
@property (nonatomic, weak, readonly) TYPagerView *pageView;

@property (nonatomic, strong, readonly) TYPagerViewLayout<UIView *> *layout;

@property (nonatomic, weak, nullable) id<ZMTabPagerViewDataSource> dataSource;
@property (nonatomic, weak, nullable) id<ZMTabPagerViewDelegate> delegate;

@property (nonatomic, assign) CGFloat tabBarHeight;

// register tabBar cell
- (void)registerClass:(Class)Class forTabBarCellWithReuseIdentifier:(NSString *)identifier;
- (void)registerNib:(UINib *)nib forTabBarCellWithReuseIdentifier:(NSString *)identifier;

// register && dequeue pager Cell, usage like tableView
- (void)registerClass:(Class)Class forPagerCellWithReuseIdentifier:(NSString *)identifier;
- (void)registerNib:(UINib *)nib forPagerCellWithReuseIdentifier:(NSString *)identifier;
- (UIView *)dequeueReusablePagerCellWithReuseIdentifier:(NSString *)identifier forIndex:(NSInteger)index;


- (void)scrollToViewAtIndex:(NSInteger)index animate:(BOOL)animate;

- (void)updateData;

- (void)reloadData;

@end

NS_ASSUME_NONNULL_END
