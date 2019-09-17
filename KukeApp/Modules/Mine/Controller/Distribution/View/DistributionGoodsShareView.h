//
//  DistributionGoodsShareView.h
//  KukeApp
//
//  Created by 库课 on 2019/3/27.
//  Copyright © 2019 KukeZangMing. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^CloseActionBlock)();
NS_ASSUME_NONNULL_BEGIN

@interface DistributionGoodsShareView : UIView
@property (weak, nonatomic) IBOutlet UIImageView *shareImage;
@property (nonatomic ,copy) CloseActionBlock myCloseBlock;
@property (nonatomic ,strong) NSString  *url;
@end

NS_ASSUME_NONNULL_END
