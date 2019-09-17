//
//  UIScrollView+WKRefresh.m
//  UICollectionViewTest
//
//  Created by 王昆 on 16/11/24.
//  Copyright © 2016年 wangkun. All rights reserved.
//

#import "UIScrollView+WKRefresh.h"
#import <objc/runtime.h>
#import "WKChewieRefresh.h"

@implementation UIScrollView (WKRefresh)

- (void)wk_configureRefresh {
    __weak typeof(self) weakSelf = self;
    WKChewieRefreshHeader *header = [WKChewieRefreshHeader headerWithRefreshingBlock:^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (strongSelf.wk_beginRefreshCallBack) {
            strongSelf.wk_beginRefreshCallBack();
        }
    }];
    self.wk_header = header;
}

- (void)wk_beginRefresh {
    if (!self.wk_header.isRefreshing) {
        [self.wk_header beginRefreshing];
    }
}

- (void)wk_endRefresh {
    [self.wk_header endRefreshing];
}

- (void)wk_setRefreshEnable:(BOOL)enable {
    self.wk_header.hidden = !enable;
}


#pragma mark -
static const char WKRefreshBeginRefreshCallBackKey = '\0';
- (void)setWk_beginRefreshCallBack:(void (^)(void))wk_beginRefreshCallBack {
    objc_setAssociatedObject(self, &WKRefreshBeginRefreshCallBackKey, wk_beginRefreshCallBack, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void (^)(void))wk_beginRefreshCallBack {
    return objc_getAssociatedObject(self, &WKRefreshBeginRefreshCallBackKey);
}

@end
