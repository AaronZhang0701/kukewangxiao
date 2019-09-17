//
//  PLVVodSkinPlayerController.h
//  PolyvVodSDK
//
//  Created by BqLin on 2017/10/28.
//  Copyright © 2017年 POLYV. All rights reserved.
//

#import <PLVVodSDK/PLVVodPlayerViewController.h>
//#import "PLVCastControllView.h"

@interface PLVVodSkinPlayerController : PLVVodPlayerViewController

@property (nonatomic, assign, readonly) BOOL isLockScreen;
@property (nonatomic, strong) NSString *is_hideNav;
@property (nonatomic, strong) NSDictionary *videoInfo;
@property (nonatomic, strong) NSDictionary *lessonInfo;//课时的下载信息
@end
