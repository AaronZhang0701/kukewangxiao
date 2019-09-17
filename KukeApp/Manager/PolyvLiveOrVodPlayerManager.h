//
//  PolyvLiveOrVodPlayerManager.h
//  KukeApp
//
//  Created by 库课 on 2019/7/10.
//  Copyright © 2019 KukeZangMing. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PolyvLiveOrVodPlayerManager : NSObject

+ (void)zm_verifyPermissionWithChannelId:(NSString *)channelId vid:(NSString *)vid playerType:(NSString *)playerType  ToPlayerFromViewController:(UIViewController *)vc dataSource:(id)data;
@end

NS_ASSUME_NONNULL_END
