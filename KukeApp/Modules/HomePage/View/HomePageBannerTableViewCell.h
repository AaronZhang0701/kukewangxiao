//
//  HomePageBannerTableViewCell.h
//  KukeApp
//
//  Created by iOSDeveloper on 2018/9/25.
//  Copyright © 2018年 zhangming. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^ QRcodeActionBlock)();
typedef void(^ DownLoadActionBlock)();
typedef void(^ RecordActionBlock)();
typedef void(^ BannarActionBlock)(NSInteger index);
@interface HomePageBannerTableViewCell : UITableViewCell
@property (nonatomic ,copy) QRcodeActionBlock myQRcodeBlock;
@property (nonatomic ,copy) DownLoadActionBlock myDownLoadBlock;
@property (nonatomic ,copy) BannarActionBlock myBannarBlock;
@property (nonatomic ,copy) RecordActionBlock myRecordBlock;
@property (nonatomic ,strong) NSArray *imageAry;
@end
