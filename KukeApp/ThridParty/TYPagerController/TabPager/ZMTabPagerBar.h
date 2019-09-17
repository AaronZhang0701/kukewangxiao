//
//  TYTabPagerBar.h
//  TYPagerControllerDemo
//
//  Created by tany on 2017/7/13.
//  Copyright © 2017年 tany. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZMTabPagerBarLayout.h"

NS_ASSUME_NONNULL_BEGIN

@class ZMTabPagerBar;
@protocol ZMTabPagerBarDataSource <NSObject>

- (NSInteger)numberOfItemsInPagerTabBar;

- (UICollectionViewCell<ZMTabPagerBarCellProtocol> *)pagerTabBar:(ZMTabPagerBar *)pagerTabBar cellForItemAtIndex:(NSInteger)index;

@end

@protocol ZMTabPagerBarDelegate <NSObject>

@optional

// configure layout
- (void)pagerTabBar:(ZMTabPagerBar *)pagerTabBar configureLayout:(ZMTabPagerBarLayout *)layout;

// if cell wdith is not variable,you can set layout.cellWidth. otherwise ,you can implement this return cell width. cell width not contain cell edge
- (CGFloat)pagerTabBar:(ZMTabPagerBar *)pagerTabBar widthForItemAtIndex:(NSInteger)index;

// did select cell item
- (void)pagerTabBar:(ZMTabPagerBar *)pagerTabBar didSelectItemAtIndex:(NSInteger)index;

// transition frome cell to cell with animated
- (void)pagerTabBar:(ZMTabPagerBar *)pagerTabBar transitionFromeCell:(UICollectionViewCell<ZMTabPagerBarCellProtocol> * _Nullable)fromCell toCell:(UICollectionViewCell<ZMTabPagerBarCellProtocol> * _Nullable)toCell animated:(BOOL)animated;

// transition frome cell to cell with progress
- (void)pagerTabBar:(ZMTabPagerBar *)pagerTabBar transitionFromeCell:(UICollectionViewCell<ZMTabPagerBarCellProtocol> * _Nullable)fromCell toCell:(UICollectionViewCell<ZMTabPagerBarCellProtocol> * _Nullable)toCell progress:(CGFloat)progress;

@end

@interface ZMTabPagerBar : UIView

@property (nonatomic, weak, readonly) UICollectionView *collectionView;
@property (nonatomic, strong) UIView *progressView;
// automatically resized to self.bounds
@property (nonatomic, strong) UIView *backgroundView;

@property (nonatomic, weak, nullable) id<ZMTabPagerBarDataSource> dataSource;

@property (nonatomic, weak, nullable) id<ZMTabPagerBarDelegate> delegate;

@property (nonatomic, strong) ZMTabPagerBarLayout *layout;

@property (nonatomic, assign) BOOL autoScrollItemToCenter;

@property (nonatomic, assign, readonly) NSInteger countOfItems;

@property (nonatomic, assign, readonly) NSInteger curIndex;

@property (nonatomic, assign) UIEdgeInsets contentInset;

- (void)registerClass:(Class)Class forCellWithReuseIdentifier:(NSString *)identifier;
- (void)registerNib:(UINib *)nib forCellWithReuseIdentifier:(NSString *)identifier;

- (__kindof UICollectionViewCell<ZMTabPagerBarCellProtocol> *)dequeueReusableCellWithReuseIdentifier:(NSString *)identifier forIndex:(NSInteger)index;

- (void)reloadData;

- (void)scrollToItemFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex animate:(BOOL)animate;
- (void)scrollToItemFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex progress:(CGFloat)progress;
- (void)scrollToItemAtIndex:(NSInteger)index atScrollPosition:(UICollectionViewScrollPosition)scrollPosition animated:(BOOL)animated;

- (CGFloat)cellWidthForTitle:(NSString * _Nullable)title;
- (CGRect)cellFrameWithIndex:(NSInteger)index;
- (nullable UICollectionViewCell<ZMTabPagerBarCellProtocol> *)cellForIndex:(NSInteger)index;

@end

NS_ASSUME_NONNULL_END
