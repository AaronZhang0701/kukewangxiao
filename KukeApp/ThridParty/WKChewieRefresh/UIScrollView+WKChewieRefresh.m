//
//  UIScrollView+WKChewieRefresh.m
//  WKChewieRefreshDemo
//
//  Created by 王昆 on 2017/11/16.
//  Copyright © 2017年 wangkun. All rights reserved.
//

#import "UIScrollView+WKChewieRefresh.h"
#import <objc/runtime.h>
#import "UIScrollView+WKExtension.h"

@implementation UIScrollView (WKChewieRefresh)
static const char WKChewieRefreshHeaderKey = '\0';
- (void)setWk_header:(WKChewieRefreshHeader *)wk_header {
    
    if (wk_header != self.wk_header) {
        [self.wk_header removeFromSuperview];
        [self insertSubview:wk_header atIndex:0];
        [self willChangeValueForKey:@"wk_header"];
        objc_setAssociatedObject(self, &WKChewieRefreshHeaderKey, wk_header, OBJC_ASSOCIATION_ASSIGN);
        [self didChangeValueForKey:@"wk_header"];
    }
}

- (WKChewieRefreshHeader *)wk_header {
    return objc_getAssociatedObject(self, &WKChewieRefreshHeaderKey);
}
@end
