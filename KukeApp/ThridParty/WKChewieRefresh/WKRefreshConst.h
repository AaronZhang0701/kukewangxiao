//
//  WKRefreshConst.h
//  EFFoundation
//
//  Created by 王昆 on 2017/11/7.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

UIKIT_EXTERN NSString *const WKRefreshKeyPathContentOffset;
UIKIT_EXTERN NSString *const WKRefreshKeyPathPanState;

UIKIT_EXTERN const CGFloat WKRefreshFastAnimationDuration; /**< 开始刷新了，显示刷新头的动画时间 */
UIKIT_EXTERN const CGFloat WKRefreshSlowAnimationDuration; /** 结束刷新了，消失刷新头的动画时间 */

UIKIT_EXTERN CGFloat const WKRefreshOpenHeight;        /**< 刷新ing高度 */
UIKIT_EXTERN CGFloat const WKRefreshTopMaxPadding;     /**< 最大上边距 */
UIKIT_EXTERN CGFloat const WKRefreshTopMinPadding;     /**< 最小上边距 */
UIKIT_EXTERN CGFloat const WKRefreshTopMaxRadius;      /**< 最大上圆半径 */
UIKIT_EXTERN CGFloat const WKRefreshTopMinRadius;      /**< 最小上圆半径 */
UIKIT_EXTERN CGFloat const WKRefreshBottomMaxPadding;  /**< 最大下边距 */
UIKIT_EXTERN CGFloat const WKRefreshBottomMinPadding;  /**< 最小下边距 */
UIKIT_EXTERN CGFloat const WKRefreshBottomMaxRadius;   /**< 最大下圆半径 */
UIKIT_EXTERN CGFloat const WKRefreshBottomMinRadius;   /**< 最小下圆半径 */
UIKIT_EXTERN CGFloat const WKRefreshArrowMaxSize;      /**< 最大箭头 */
UIKIT_EXTERN CGFloat const WKRefreshArrowMinSize;      /**< 最小箭头 */
UIKIT_EXTERN CGFloat const WKRefreshArrowMaxRadius;    /**< 最大箭头半径 */
UIKIT_EXTERN CGFloat const WKRefreshArrowMinRadius;    /**< 最小箭头半径 */
UIKIT_EXTERN CGFloat const WKRefreshMaxDistnce;        /**< 拉伸回弹的距离 */
UIKIT_EXTERN CGFloat const WKRefreshPulling2RefreshingHeight; /**< 橡皮糖最大高度 */

typedef NS_ENUM(NSInteger, WKRefreshState) {
    /**< 初始状态 */
    WKRefreshStateIdle = 1,
    /**< 拉拽中 还没loading，开始下拉就会变为这个状态，此时会绘制橡皮糖效果 */
    WKRefreshStatePulling,
    /**< 拉拽中 显示loading了，松开大于刷新头高度33则进入刷新，否则恢复直到看不见刷新头设置idle */
    WKRefreshStatePullingLoading,
    /**< 刷新中 */
    WKRefreshStateRefreshing,
    /**< 即将刷新，当页面未显示的时候触发了下拉刷新 */
    WKRefreshStateWillRefresh,
};

