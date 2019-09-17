//
//  TYTabPagerController.h
//  TYPagerControllerDemo
//
//  Created by tanyang on 2017/7/18.
//  Copyright © 2017年 tany. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZMTabPagerBar.h"
#import "TYPagerController.h"

NS_ASSUME_NONNULL_BEGIN

@class ZMTabPagerController;
@protocol ZMTabPagerControllerDataSource <NSObject>

- (NSInteger)numberOfControllersInTabPagerController;

- (UIViewController *)tabPagerController:(ZMTabPagerController *)tabPagerController controllerForIndex:(NSInteger)index prefetching:(BOOL)prefetching;

- (NSString *)tabPagerController:(ZMTabPagerController *)tabPagerController titleForIndex:(NSInteger)index;

@end

@protocol ZMTabPagerControllerDelegate <NSObject>
@optional

// display cell
- (void)tabPagerController:(ZMTabPagerController *)tabPagerController willDisplayCell:(UICollectionViewCell<ZMTabPagerBarCellProtocol> *)cell atIndex:(NSInteger)index;

// did select cell item
- (void)tabPagerController:(ZMTabPagerController *)tabPagerController didSelectTabBarItemAtIndex:(NSInteger)index;

// scrolling
- (void)tabPagerControllerWillBeginScrolling:(ZMTabPagerController *)tabPagerController animate:(BOOL)animate;
- (void)tabPagerControllerDidEndScrolling:(ZMTabPagerController *)tabPagerController animate:(BOOL)animate;

@end

@interface ZMTabPagerController : ZMBaseViewController

@property (nonatomic, strong, readonly) ZMTabPagerBar *tabBar;
@property (nonatomic, strong, readonly) TYPagerController *pagerController;
@property (nonatomic, strong, readonly) TYPagerViewLayout<UIViewController *> *layout;

@property (nonatomic, weak, nullable) id<ZMTabPagerControllerDataSource> dataSource;
@property (nonatomic, weak, nullable) id<ZMTabPagerControllerDelegate> delegate;

// you can custom tabBar orignY and height.
@property (nonatomic, assign) CGFloat tabBarOrignY;
@property (nonatomic, assign) CGFloat tabBarHeight;

// register tabBar cell
- (void)registerClass:(Class)Class forTabBarCellWithReuseIdentifier:(NSString *)identifier;
- (void)registerNib:(UINib *)nib forTabBarCellWithReuseIdentifier:(NSString *)identifier;

// register && dequeue pager Cell, usage like tableView
- (void)registerClass:(Class)Class forPagerCellWithReuseIdentifier:(NSString *)identifier;
- (void)registerNib:(UINib *)nib forPagerCellWithReuseIdentifier:(NSString *)identifier;
- (UIViewController *)dequeueReusablePagerCellWithReuseIdentifier:(NSString *)identifier forIndex:(NSInteger)index;


- (void)scrollToControllerAtIndex:(NSInteger)index animate:(BOOL)animate;

- (void)updateData;

- (void)reloadData;


@end

NS_ASSUME_NONNULL_END
