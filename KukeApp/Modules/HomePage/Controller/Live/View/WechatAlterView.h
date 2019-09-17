//
//  WechatAlterView.h
//  KukeApp
//
//  Created by 库课 on 2019/7/18.
//  Copyright © 2019 KukeZangMing. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^CloseBlock)();
typedef void(^SaveBlock)(UIImageView *pic);
NS_ASSUME_NONNULL_BEGIN

@interface WechatAlterView : UIView
@property (weak, nonatomic) IBOutlet UIButton *saveBtn;
@property (weak, nonatomic) IBOutlet UIImageView *pic;
@property (nonatomic ,copy) CloseBlock closeBlock;
@property (nonatomic ,copy) SaveBlock saveBlock;
@end

NS_ASSUME_NONNULL_END
