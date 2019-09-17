//
//  WKChewieRefreshHeader.m
//  EFFoundation
//
//  Created by 王昆 on 2017/11/7.
//

#import "WKChewieRefreshHeader.h"
#import <QuartzCore/QuartzCore.h>


@interface WKChewieRefreshHeader ()
@property (nonatomic, strong) CAShapeLayer *shapeLayer;  /**< 橡皮糖 */
@property (nonatomic, strong) CAShapeLayer *arrowLayer;  /**< 箭头 */
@property (nonatomic, strong) UIActivityIndicatorView *activityView; /**< 圈圈 */
@property (nonatomic, assign) CGFloat insetTDelta;  /**< insetT的变化值 */
@property (weak,nonatomic) UIImageView *tipIcon;
@end

@implementation WKChewieRefreshHeader

+ (instancetype)headerWithRefreshingBlock:(void(^)(void))refreshingBlock {
    WKChewieRefreshHeader *header = [[self alloc] init];
    header.refreshingBlock = refreshingBlock;
    return header;
}

#pragma mark - override
- (void)beginRefreshing {
    [super beginRefreshing];
    //清一下layer
    [self clearLayer];
}

- (void)prepare {
    [super prepare];
    
    // 设置高度
    self.wk_h = WKRefreshOpenHeight;
 
    [self addSubview:self.activityView];
    [self.layer addSublayer:self.shapeLayer];
    [self.layer addSublayer:self.arrowLayer];
}

- (void)placeSubviews {
    [super placeSubviews];
    //设置y坐标
    self.wk_y = - self.wk_h;
}

- (void)scrollViewContentOffsetDidChange:(NSDictionary *)change {
    [super scrollViewContentOffsetDidChange:change];
    
    // sectionheader停留解决
    if (self.state == WKRefreshStateRefreshing) {
        if (self.window == nil) return;
        // 当前的contentOffset
        CGFloat offsetY = self.scrollView.wk_offsetY;
        // 头部控件刚好出现的offsetY
        CGFloat happenOffsetY = - self.scrollViewOriginalInset.top;
        
        CGFloat insetT = fmax(-offsetY, -happenOffsetY);
        insetT = fmin(insetT, WKRefreshOpenHeight-happenOffsetY);
        self.scrollView.wk_insetT = insetT;
        self.insetTDelta = _scrollViewOriginalInset.top - insetT;
        
        // 如果是向上滚动到看不见头部控件，直接返回
        if (offsetY > happenOffsetY) return;
        [self updateLoadingViewPosition];
        return;
    }
    
    if (self.state != WKRefreshStatePulling && self.state != WKRefreshStatePullingLoading) {
        // 跳转到下一个控制器时，contentInset可能会变
        _scrollViewOriginalInset = self.scrollView.wk_inset;
    }
    // 当前的contentOffset
    CGFloat offsetY = self.scrollView.wk_offsetY;
    // 头部控件刚好出现的offsetY
    CGFloat happenOffsetY = - self.scrollViewOriginalInset.top;
    
    //更新UI
    [self updateLoadingViewPosition];
    if (offsetY > happenOffsetY) return;
    
    // 圈圈出来的临界点  WKRefreshStatePulling->WKRefreshStatePullingLoading的临界点
    CGFloat pulling2refreshingOffsetY = happenOffsetY - WKRefreshPulling2RefreshingHeight;
    CGFloat realOffsetY = offsetY-happenOffsetY;
    if (self.scrollView.isDragging) {
        //如果当前是初始状态
        if (self.state == WKRefreshStateIdle) {
            //当前偏移量绝对值小于临界值绝对值
            if (fabs(offsetY) < fabs(pulling2refreshingOffsetY)) {
                // 状态修改为开始刷新动画的拉拽
                self.state = WKRefreshStatePulling;
                // 状态改变后就绘制橡皮糖，为了当极快速度下拉的时候，没有橡皮糖的效果
                [self drawAnimateWithOffset:realOffsetY];
            } else {
                //转为开始拉拽
                self.state = WKRefreshStatePullingLoading;
                [self drawAnimateWithOffset:realOffsetY];
            }
        } else if (self.state == WKRefreshStatePulling) {
            
            //当前偏移量绝对值小于临界值绝对值
            if (fabs(offsetY) < fabs(pulling2refreshingOffsetY)) {
                
                // 状态改变后就绘制橡皮糖，为了当极快速度下拉的时候，没有橡皮糖的效果
                [self drawAnimateWithOffset:realOffsetY];
            } else {
                //转为开始拉拽
                self.state = WKRefreshStatePullingLoading;
                [self drawAnimateWithOffset:realOffsetY];
            }
        } else if (self.state == WKRefreshStatePullingLoading) {
            //这里场景是，拉拽到圈圈出来了，然后往上推，推到小于33的高度
            //保持loading
        }
    } else {
        if (self.state == WKRefreshStatePulling) {
            if (realOffsetY >= 0) {
                //回弹到看不见的时候就恢复idle了
                self.state = WKRefreshStateIdle;
            } else {
                [self drawAnimateWithOffset:realOffsetY];
            }
        }  else if (self.state == WKRefreshStatePullingLoading) {
            if (realOffsetY >= 0) {
                //当看不见刷新头的时候，才将状态置为 idle
                self.state = WKRefreshStateIdle;
            } else if (realOffsetY < -WKRefreshOpenHeight) {
                //如果当前松开手指的时候偏移大于33，就进入刷新状态
//                [self beginRefreshing]; //这里进入刷新状态不能清掉layer，因为弹性动画还没结束
                self.state = WKRefreshStateRefreshing;
            }
        }
    }
}

- (void)scrollViewPanStateDidChange:(NSDictionary *)change {
    if (self.scrollView.panGestureRecognizer.state == UIGestureRecognizerStateEnded) {
        if (self.state == WKRefreshStatePullingLoading) {
            // 当前的contentOffset
            CGFloat offsetY = self.scrollView.wk_offsetY;
            // 头部控件刚好出现的offsetY
            CGFloat happenOffsetY = - self.scrollViewOriginalInset.top;
            if (offsetY >= happenOffsetY) {
                //当前刷新头看不见的时候，设置为idle
                self.state = WKRefreshStateIdle;
            }
        }
    }
}

- (void)setState:(WKRefreshState)state {
    WKRefreshState oldState = self.state;
    if (state == oldState) return;
    [super setState:state];
    if (state == WKRefreshStateIdle) {
        [self clearLayer];//清掉layer
        [self hideActivityIndicator];//隐藏圈圈
        if (oldState != WKRefreshStateRefreshing) return;
        [UIView animateWithDuration:WKRefreshSlowAnimationDuration animations:^{
            self.scrollView.wk_insetT += self.insetTDelta;
        } completion:^(BOOL finished) {
            
        }];
    } else if (state == WKRefreshStateRefreshing) {        
        if ([NSThread currentThread] != [NSThread mainThread]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self beginShowHeader];
            });
        } else {
            [self beginShowHeader];
        }
    }
}



/** 开始刷新 显示header */
- (void)beginShowHeader {
    [self showActivityIndicator];//显示圈圈
    [UIView animateWithDuration:WKRefreshFastAnimationDuration animations:^{
        CGFloat top = self.scrollViewOriginalInset.top + WKRefreshOpenHeight;
        // 增加滚动区域top
        self.scrollView.wk_insetT = top;
        // 设置滚动位置
        CGPoint offset = self.scrollView.contentOffset;
        offset.y = -top;
        [self.scrollView setContentOffset:offset animated:NO];
    } completion:^(BOOL finished) {
        [self executeRefreshingCallback];
    }];
}

- (void)updateLoadingViewPosition {
    // 当前的contentOffset
    CGFloat offsetY = self.scrollView.wk_offsetY;
    // 头部控件刚好出现的offsetY
    CGFloat happenOffsetY = - self.scrollViewOriginalInset.top;
    // 相对偏移量
    CGFloat realOffsetY = offsetY-happenOffsetY;
    //设置header的高度
    self.wk_h = fmax(fabs(realOffsetY), WKRefreshOpenHeight);
    //修正圈圈的位置，圈圈一定是处于顶部的，不管header高度有多大
    self.activityView.center = CGPointMake(self.scrollView.wk_w*0.5, fmin(self.wk_h-WKRefreshOpenHeight*0.5, self.wk_h+WKRefreshOpenHeight*0.5+realOffsetY));
    //设置header的y坐标
    self.wk_y = - self.wk_h;
}

- (void)executeRefreshingCallback {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.refreshingBlock) {
            self.refreshingBlock();
        }
    });
}

/** 显示活动指示器 */
- (void)showActivityIndicator {
    [self.activityView startAnimating];
    self.activityView.hidden = NO;
    self.activityView.alpha = 1.0f;
    self.activityView.layer.transform = CATransform3DIdentity;
}

/** 隐藏活动指示器 */
- (void)hideActivityIndicator {
    [self.activityView stopAnimating];
    self.activityView.hidden = NO;
    self.activityView.alpha = 0.0f;
    self.activityView.layer.transform = CATransform3DMakeScale(0.1, 0.1, 1);
}

#pragma mark -
- (CAShapeLayer *)shapeLayer {
    if (!_shapeLayer) {
        _shapeLayer = [CAShapeLayer layer];
        UIColor *color = [UIColor colorWithRed:193/255.0 green:193/255.0 blue:193/255.0 alpha:1];
        _shapeLayer.fillColor = color.CGColor;
        _shapeLayer.strokeColor = color.CGColor;
        _shapeLayer.lineWidth = 0.5;
    }
    return _shapeLayer;
}

- (CAShapeLayer *)arrowLayer {
    if (!_arrowLayer) {
        _arrowLayer = [CAShapeLayer layer];
        _arrowLayer.fillColor = [UIColor whiteColor].CGColor;
        _arrowLayer.strokeColor = [UIColor whiteColor].CGColor;
        _arrowLayer.lineWidth = 0.5;
    }
    return _arrowLayer;
}

- (UIActivityIndicatorView *)activityView {
    
    if (!_activityView) {
        _activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _activityView.frame = CGRectMake(0, 0, 28, 28);
        _activityView.center = CGPointMake(self.scrollView.wk_w/2.0f, WKRefreshOpenHeight/2.0f);
        [self hideActivityIndicator];
    }
    return _activityView;
}

/** 计算动态改变的大小 */
CGFloat fetchLerp2(CGFloat a,CGFloat b,CGFloat p) {
    return a + (b - a) * p;
}

/** 拉拽动画 */
- (void)drawAnimateWithOffset:(CGFloat)offset {
    
    //有橡皮糖形变的时候，肯定是看不见圈圈的
    [self hideActivityIndicator];
    
    BOOL triggered = NO; //默认是不触发刷新的
    CGMutablePathRef path = CGPathCreateMutable();
    //计算垂直方向的移动
    CGFloat verticalShift = fmaxf(0, -(WKRefreshTopMaxRadius + WKRefreshBottomMaxRadius + WKRefreshTopMaxPadding + WKRefreshBottomMaxPadding + offset));
    
    //计算间距 需要形变的间距
    CGFloat distance = fminf(WKRefreshMaxDistnce, fabs(verticalShift));
    
    //形变百分比 在橡皮糖不需要形变的时候，为1
    CGFloat percentage = 1 - (distance / WKRefreshMaxDistnce);
    
    //上面间隙
    CGFloat currentTopPadding = fetchLerp2(WKRefreshTopMinPadding, WKRefreshTopMaxPadding, percentage);
    
    //上圆的半径
    CGFloat currentTopRadius = fetchLerp2(WKRefreshTopMinRadius, WKRefreshTopMaxRadius, percentage);
    
    //下圆的半径
    CGFloat currentBottomRadius = fetchLerp2(WKRefreshBottomMinRadius, WKRefreshBottomMaxRadius, percentage);
    
    //下面的间隙
    CGFloat currentBottomPadding = fetchLerp2(WKRefreshBottomMinPadding, WKRefreshBottomMaxPadding, percentage);
    
    //下圆心
    CGPoint bottomOrigin = CGPointMake(self.bounds.size.width/2, self.bounds.size.height - currentBottomPadding - currentBottomRadius);
    
    //上圆心
    CGPoint topOrigin = CGPointZero;
    if (distance == 0) {
        topOrigin = CGPointMake(self.bounds.size.width*0.5, bottomOrigin.y);
    } else {
        topOrigin = CGPointMake(self.bounds.size.width*0.5, self.bounds.size.height + offset + currentTopPadding + currentTopRadius);
        if (percentage == 0) {
            //要触发刷新了
            triggered = YES;
            bottomOrigin.y -= verticalShift - WKRefreshMaxDistnce;
        }
    }
    
    //绘上圆
    CGPathAddArc(path, NULL, topOrigin.x, topOrigin.y, currentTopRadius, 0, M_PI, YES);
    
    //左外切曲线
    CGPoint leftCp1 = CGPointMake(fetchLerp2(topOrigin.x - currentTopRadius, bottomOrigin.x - currentBottomRadius, 0.1), fetchLerp2(topOrigin.y, bottomOrigin.y, 0.2));
    CGPoint leftCp2 = CGPointMake(fetchLerp2(topOrigin.x - currentTopRadius, bottomOrigin.x - currentBottomRadius, 0.9), fetchLerp2(topOrigin.y, bottomOrigin.y, 0.2));
    CGPoint leftDestination = CGPointMake(bottomOrigin.x - currentBottomRadius, bottomOrigin.y);
    CGPathAddCurveToPoint(path, NULL, leftCp1.x, leftCp1.y, leftCp2.x, leftCp2.y, leftDestination.x, leftDestination.y);
    //绘下圆
    CGPathAddArc(path, NULL, bottomOrigin.x, bottomOrigin.y, currentBottomRadius, M_PI, 0, YES);
    
    //右外切曲线
    CGPoint rightCp1 = CGPointMake(fetchLerp2(topOrigin.x + currentTopRadius, bottomOrigin.x + currentBottomRadius, 0.9), fetchLerp2(topOrigin.y, bottomOrigin.y, 0.2));
    CGPoint rightCp2 = CGPointMake(fetchLerp2(topOrigin.x + currentTopRadius, bottomOrigin.x + currentBottomRadius, 0.1), fetchLerp2(topOrigin.y, bottomOrigin.y, 0.2));
    CGPoint rightDestination = CGPointMake(topOrigin.x + currentTopRadius, topOrigin.y);
    CGPathAddCurveToPoint(path, NULL, rightCp1.x, rightCp1.y, rightCp2.x, rightCp2.y, rightDestination.x, rightDestination.y);
    
    //闭合路径
    CGPathCloseSubpath(path);
    
    //不触发刷新
    if (!triggered) {
        //设置形变
        _shapeLayer.path = path;
        _shapeLayer.shadowPath = path;
        
        ////绘制箭头
        
        //箭头宽度
        CGFloat currentArrowSize = fetchLerp2(WKRefreshArrowMinSize, WKRefreshArrowMaxSize, percentage);
        //箭头半径
        CGFloat currentArrowRadius = fetchLerp2(WKRefreshArrowMinRadius, WKRefreshArrowMaxRadius, percentage);
        //箭头外圆
        CGFloat arrowBigRadius = currentArrowRadius + currentArrowSize*0.5;
        //箭头内圆
        CGFloat arrowSmallRadius = currentArrowRadius - currentArrowSize*0.5;
        //箭头路径
        CGMutablePathRef arrowPath = CGPathCreateMutable();
        //绘制外圆
        CGPathAddArc(arrowPath, NULL, topOrigin.x, topOrigin.y, arrowBigRadius, 0 * M_PI_2, 3 * M_PI_2, NO);
        //绘制箭头的4根线
        CGPathAddLineToPoint(arrowPath, NULL, topOrigin.x, topOrigin.y - arrowBigRadius - currentArrowSize);
        CGPathAddLineToPoint(arrowPath, NULL, topOrigin.x + (2 * currentArrowSize), topOrigin.y - arrowBigRadius + currentArrowSize/2);
        CGPathAddLineToPoint(arrowPath, NULL, topOrigin.x, topOrigin.y - arrowBigRadius + 2*currentArrowSize);
        CGPathAddLineToPoint(arrowPath, NULL, topOrigin.x, topOrigin.y - arrowBigRadius + currentArrowSize);
        //绘制内圆
        CGPathAddArc(arrowPath, NULL, topOrigin.x, topOrigin.y, arrowSmallRadius, 3 * M_PI_2, 0 * M_PI_2, YES);
        //闭合路径
        CGPathCloseSubpath(arrowPath);
        //设置箭头
        _arrowLayer.path = arrowPath;
        [_arrowLayer setFillRule:kCAFillRuleEvenOdd];
        //释放
        CGPathRelease(arrowPath);
        
        //拉拽到位，开始刷新了
    } else {
        
        //消失动画
        CGFloat radius = fetchLerp2(WKRefreshBottomMinRadius, WKRefreshBottomMaxRadius, 0.2);
        CABasicAnimation *pathMorph = [CABasicAnimation animationWithKeyPath:@"path"];
        pathMorph.duration = 0.15;
        pathMorph.fillMode = kCAFillModeForwards;
        pathMorph.removedOnCompletion = NO;
        
        //shape的回弹消失动画
        CGMutablePathRef toPath = CGPathCreateMutable();
        CGPathAddArc(toPath, NULL, topOrigin.x, topOrigin.y, radius, 0, M_PI, YES);
        CGPathAddCurveToPoint(toPath, NULL, topOrigin.x - radius, topOrigin.y, topOrigin.x - radius, topOrigin.y, topOrigin.x - radius, topOrigin.y);
        CGPathAddArc(toPath, NULL, topOrigin.x, topOrigin.y, radius, M_PI, 0, YES);
        CGPathAddCurveToPoint(toPath, NULL, topOrigin.x + radius, topOrigin.y, topOrigin.x + radius, topOrigin.y, topOrigin.x + radius, topOrigin.y);
        CGPathCloseSubpath(toPath);
        pathMorph.toValue = (__bridge id)toPath;
        [_shapeLayer addAnimation:pathMorph forKey:nil];
        
//        CABasicAnimation *shadowPathMorph = [CABasicAnimation animationWithKeyPath:@"shadowPath"];
//        shadowPathMorph.duration = 0.15;
//        shadowPathMorph.fillMode = kCAFillModeForwards;
//        shadowPathMorph.removedOnCompletion = NO;
//        shadowPathMorph.toValue = (__bridge id)toPath;
//        [_shapeLayer addAnimation:shadowPathMorph forKey:nil];
//        CGPathRelease(toPath);
        
        //shape的透明度动画
        CABasicAnimation *shapeAlphaAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
        shapeAlphaAnimation.duration = 0.25;
        shapeAlphaAnimation.toValue = [NSNumber numberWithFloat:0];
        shapeAlphaAnimation.fillMode = kCAFillModeForwards;
        shapeAlphaAnimation.removedOnCompletion = NO;
        [_shapeLayer addAnimation:shapeAlphaAnimation forKey:nil];
        
        //箭头的透明度动画
        CABasicAnimation *alphaAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
        alphaAnimation.duration = 0.1;
        alphaAnimation.toValue = [NSNumber numberWithFloat:0];
        alphaAnimation.fillMode = kCAFillModeForwards;
        alphaAnimation.removedOnCompletion = NO;
        [_arrowLayer addAnimation:alphaAnimation forKey:nil];
        
//        [CATransaction begin];
//        [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
//        [self hideActivityIndicator];
//        [CATransaction commit];
        
        //指示器渐变显示出来
        [UIView animateWithDuration:0.2f delay:0.15f options:UIViewAnimationOptionCurveLinear animations:^{
            [self showActivityIndicator];
        } completion:^(BOOL finished) {
            //清除layer
            [self clearLayer];
        }];
        
        //判断当前是否仍旧拖拽。这里拖拽情况下，开始刷新动画，但是不是真正的刷新，不会发出请求。
        if (self.scrollView.isDragging) {
            //转为开始刷新动画的拉拽
            self.state = WKRefreshStatePullingLoading;
        } else {
            //转为开始刷新，真正的刷新
//            [self beginRefreshing]; //这里进入刷新状态不能清掉layer，因为弹性动画还没结束
            self.state = WKRefreshStateRefreshing;
        }
    }
    CGPathRelease(path);
}


/** 清除layer */
- (void)clearLayer {
    [self.shapeLayer removeAllAnimations];
    self.shapeLayer.path = nil;
    self.shapeLayer.shadowPath = nil;
    self.shapeLayer.position = CGPointZero;
    [self.arrowLayer removeAllAnimations];
    self.arrowLayer.path = nil;
}

@end
