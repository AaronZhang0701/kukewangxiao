//
//  ShareManager.h
//  MiAiApp
//
//  Created by 张明 on 2017/6/1.
//  Copyright © 2017年 张明. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UtilsMacros.h"
/**
 分享 相关服务
 */
@interface ShareManager : NSObject

//单例
SINGLETON_FOR_HEADER(ShareManager)


/**
 展示分享页面
 */
-(void)showShareView;
@end
