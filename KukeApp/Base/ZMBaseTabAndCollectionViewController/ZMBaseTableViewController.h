//
//  ZMBaseTableViewController.h
//  kukeapp
//
//  Created by KUKE on 16/5/9.
//  Copyright © 2016年 Zhangming. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NoDataTipsView.h"
#import "YLGIFImage.h"
#import "YLImageView.h"
typedef void(^headreRefreshBlock)(void);
typedef void(^footreRefreshBlock)(void);
typedef NS_ENUM(NSInteger, LQTableViewLoadingViewType) {
    LQTableViewLoadingViewTypeDefault = 0,//默认菊花加载动画
    LQTableViewLoadingViewTypeGif,
    LQTableViewLoadingViewTypeCustom
};
typedef NS_ENUM(NSInteger, LQTableViewFailLoadViewType) {
    LQTableViewFailLoadViewTypeDefault = 0,//默认数据加载失败
    LQTableViewFailLoadViewTypeNoData,
    LQTableViewFailLoadViewTypeGif,
    LQTableViewFailLoadViewTypeCustom
};


@interface ZMBaseTableViewController : ZMBaseViewController<NoDataTipsDelegate>

@property (nonatomic ,copy) headreRefreshBlock _Nullable header_block;
@property (nonatomic ,copy) footreRefreshBlock _Nullable footre_block;
@property (nonatomic, strong) UITableView * _Nonnull tableView;
/**
 *  隐藏加载中动画,根据获得数据显示空状态占位图
 */
- (void)setEmptyViewDelegeta;

/**
 *  加载中动画类型，默认菊花加载动画
 */
@property(nonatomic,assign) LQTableViewLoadingViewType lq_loadingViewType;
/**
 *  加载失败动画类型，默认圆感叹号
 */
@property(nonatomic,assign) LQTableViewFailLoadViewType lq_failLoadViewType;
/**
 *  加载中动画自定义的View
 */
@property(nullable, nonatomic,strong) UIView *lq_loadingView;
/**
 *  加载中动画gif文件名称
 */
@property(nullable, nonatomic,strong) NSString *lq_loadingGifName;
/**
 *  加载失败自定义的View
 */
@property(nullable, nonatomic,strong) UIView *lq_failLoadView;
/**
 *  加载失败动画gif文件名称
 */
@property(nullable, nonatomic,strong) NSString *lq_faildLoadGifName;
/**
 *  加载失败默认背景View
 */
@property(nullable, nonatomic,strong) NoDataTipsView *lq_failLoadDefaultView;
/**
 *  加载失败默认显示的图片名称
 */
@property(nullable, nonatomic,strong) NSString *lq_faildLoadDefaultTipsIamgeName;
/**
 *  加载失败默认显示的说明文字
 */
@property(nullable, nonatomic,strong) NSString *lq_faildLoadDefaultTipsStr;
/**
 *  加载失败按钮上显示的文字
 */
@property(nullable, nonatomic,strong) NSString *lq_faildLoadDefaultTipsBtnStr;
/**
 *  菊花加载视图
 */
@property(nullable, nonatomic,strong) UIActivityIndicatorView *lq_activityIndicator;

/**
 *  加载中gif
 */
@property(nullable, nonatomic,strong) YLImageView *lq_loadingGifView;

/**
 *  加载失败gif
 */
@property(nullable, nonatomic,strong) YLImageView *lq_faildLoadGifView;
/**
 *  显示加载ing背景
 */
- (void)lq_showLoading;

/**
 *  显示加载空数据
 */
- (void)lq_showFailLoadWithType:(LQTableViewFailLoadViewType)type tipsString:(nullable NSString *)tipsString;

/**
 *  清除背景
 */
- (void)lq_cleanBackgroud;
/**
 *  停止loading
 */
- (void)lq_endLoading;
/**
 *  无数据刷新
 */
- (void)noDataBeginRefresh;
/**
 *  加footer影藏多余分割线
 */
- (void)setExtraCellLineHidden;
/**
 *  添加影藏键盘单击事件
 */
- (void)setHideKeyBoardTap;
-(void)initRefresh;
/**
 添加下拉刷新
 */
- (void)addPullRefreshWithBlock:(nullable void(^)(void))block;//MJ
- (void)addWaterDropPullRefreshWithBlock:(nullable void(^)(void))block;//水滴
/**
 添加上拉加载更多
 
 @param block 上拉加载回调
 */
- (void)addMoreLoadingWithBlock:(nullable void(^)(void))block;
/**
结束刷新
 */
- (void)endRefreshWithFooterHidden;
- (void)endWaterDropRefreshWithHeaderHidden;
@end
