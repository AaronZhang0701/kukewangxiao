//
//  WKChewieRefreshHeader.h
//  EFFoundation
//
//  Created by 王昆 on 2017/11/7.
//

#import "WKRefreshComponent.h"

@interface WKChewieRefreshHeader : WKRefreshComponent

+ (instancetype)headerWithRefreshingBlock:(void(^)(void))refreshingBlock;

@end
