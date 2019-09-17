//
//  WKRefreshComponent.m
//  EFFoundation
//
//  Created by 王昆 on 2017/11/7.
//

#import "WKRefreshComponent.h"

@interface WKRefreshComponent ()
@property (nonatomic, strong) UIPanGestureRecognizer *pan;
@end

@implementation WKRefreshComponent

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self prepare];
        self.state = WKRefreshStateIdle;
    }
    return self;
}

- (void)layoutSubviews {
    
    [self placeSubviews];
    [super layoutSubviews];
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    if (self.state == WKRefreshStateWillRefresh) {
        // 预防view还没显示出来就调用了beginRefreshing
        self.state = WKRefreshStateRefreshing;
    }
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    [super willMoveToSuperview:newSuperview];
    
    // 如果不是UIScrollView，不做任何事情
    if (newSuperview && ![newSuperview isKindOfClass:[UIScrollView class]]) return;
    
    // 旧的父控件移除监听
    [self removeObservers];

    if (newSuperview) { // 新的父控件
        // 设置宽度
        self.wk_w = newSuperview.wk_w;
        // 设置位置
        self.wk_x = _scrollView.wk_insetL;
        // 记录UIScrollView
        _scrollView = (UIScrollView *)newSuperview;
        // 设置永远支持垂直弹簧效果
        _scrollView.alwaysBounceVertical = YES;
        // 记录UIScrollView最开始的contentInset
        _scrollViewOriginalInset = _scrollView.wk_inset;
        // 添加监听
        [self addObservers];
    }
}

#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
    // 遇到这些情况就直接返回
    if (!self.userInteractionEnabled) return;
    // 看不见
    if (self.hidden) return;
    
    if ([keyPath isEqualToString:WKRefreshKeyPathContentOffset]) {
        [self scrollViewContentOffsetDidChange:change];
    } else if ([keyPath isEqualToString:WKRefreshKeyPathPanState]) {
        [self scrollViewPanStateDidChange:change];
    }
}

#pragma mark - public methids
- (void)beginRefreshing {
    
    if (self.window) {
        self.state = WKRefreshStateRefreshing;
    } else {
        // 预防正在刷新中时，调用本方法使得header inset回置失败
        if (self.state != WKRefreshStateRefreshing) {
            self.state = WKRefreshStateWillRefresh;
            // 刷新(预防从另一个控制器回到这个控制器的情况，回来要重新刷新一下)
            [self setNeedsDisplay];
        }
    }
}

- (void)endRefreshing {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.state = WKRefreshStateIdle;
    });
}

#pragma mark - 交给子类们去实现
- (void)prepare {
    // 基本属性
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.backgroundColor = [UIColor clearColor];
}
- (void)placeSubviews {}
- (void)scrollViewContentOffsetDidChange:(NSDictionary *)change {}
- (void)scrollViewPanStateDidChange:(NSDictionary *)change {}

#pragma mark - private methods
/** 添加观察者 */
- (void)addObservers {
    NSKeyValueObservingOptions options = NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld;
    [self.scrollView addObserver:self forKeyPath:WKRefreshKeyPathContentOffset options:options context:nil];
    self.pan = self.scrollView.panGestureRecognizer;
    [self.pan addObserver:self forKeyPath:WKRefreshKeyPathPanState options:options context:nil];
}

/** 移除观察者 */
- (void)removeObservers {
    [self.superview removeObserver:self forKeyPath:WKRefreshKeyPathContentOffset];
    [self.pan removeObserver:self forKeyPath:WKRefreshKeyPathPanState];
    self.pan = nil;
}


#pragma mark - setters and getters
- (void)setState:(WKRefreshState)state {
    _state = state;
    
    // 加入主队列的目的是等setState:方法调用完毕、设置完文字后再去布局子控件
    dispatch_async(dispatch_get_main_queue(), ^{
        [self setNeedsLayout];
    });
}

- (BOOL)isRefreshing {
    return self.state == WKRefreshStateRefreshing || self.state == WKRefreshStateWillRefresh;
}

@end
