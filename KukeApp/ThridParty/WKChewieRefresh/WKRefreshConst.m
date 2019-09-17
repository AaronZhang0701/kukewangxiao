//
//  WKRefreshConst.m
//  EFFoundation
//
//  Created by 王昆 on 2017/11/7.
//

#import "WKRefreshConst.h"


NSString *const WKRefreshKeyPathContentOffset = @"contentOffset";
NSString *const WKRefreshKeyPathPanState = @"state";

const CGFloat WKRefreshFastAnimationDuration = 0.25; 
const CGFloat WKRefreshSlowAnimationDuration = 0.4;

CGFloat const WKRefreshOpenHeight = 33.0f;  /**< 刷新ing高度 */
CGFloat const WKRefreshTopMaxPadding = 9.0f;  /**< 最大上边距 */
CGFloat const WKRefreshTopMinPadding = 7.0f;  /**< 最小上边距 */
CGFloat const WKRefreshTopMaxRadius = 14.0f;  /**< 最大上圆半径 */
CGFloat const WKRefreshTopMinRadius = 11.5f;  /**< 最小上圆半径 */
CGFloat const WKRefreshBottomMaxPadding = 6.0f;  /**< 最大下边距 */
CGFloat const WKRefreshBottomMinPadding = 5.0f;  /**< 最小下边距 */
CGFloat const WKRefreshBottomMaxRadius = WKRefreshTopMaxRadius;  /**< 最大下圆半径 */
CGFloat const WKRefreshBottomMinRadius = 3.0f;  /**< 最小下圆半径 */
CGFloat const WKRefreshArrowMaxSize = 2.5f;  /**< 最大箭头 */
CGFloat const WKRefreshArrowMinSize = 1.5f;  /**< 最小箭头 */
CGFloat const WKRefreshArrowMaxRadius = 6.0f;  /**< 最大箭头半径 */
CGFloat const WKRefreshArrowMinRadius = 5.0f;  /**< 最小箭头半径 */
CGFloat const WKRefreshMaxDistnce = 43.0f;  /**< 拉伸回弹的距离 */
CGFloat const WKRefreshPulling2RefreshingHeight = WKRefreshTopMaxPadding + WKRefreshTopMaxRadius + WKRefreshBottomMaxRadius + WKRefreshBottomMaxPadding + WKRefreshMaxDistnce; /**< 拉拽多高开始刷新 拉拽到刷新的临界点 */  //86.0f

