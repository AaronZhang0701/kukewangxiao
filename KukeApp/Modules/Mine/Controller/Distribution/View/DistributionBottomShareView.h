//
//  DistributionBottomShareView.h
//  KukeApp
//
//  Created by 库课 on 2019/3/22.
//  Copyright © 2019 KukeZangMing. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^WXShareActionBlock)();
typedef void(^QQShareActionBlock)();
typedef void(^CopyActionBlock)();
typedef void(^PicShareActionBlock)();
typedef void(^CloseActionBlock)();
NS_ASSUME_NONNULL_BEGIN

@interface DistributionBottomShareView : UIView
@property (weak, nonatomic) IBOutlet UIImageView *wxImage;
@property (weak, nonatomic) IBOutlet UIImageView *qqImage;
@property (weak, nonatomic) IBOutlet UIImageView *wbImage;
@property (weak, nonatomic) IBOutlet UIImageView *pyqImage;
@property (weak, nonatomic) IBOutlet UILabel *fristLab;
@property (weak, nonatomic) IBOutlet UILabel *secondLab;
@property (weak, nonatomic) IBOutlet UILabel *threeLab;
@property (weak, nonatomic) IBOutlet UILabel *fourLab;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (nonatomic ,copy) WXShareActionBlock myWXShareBlock;
@property (nonatomic ,copy) QQShareActionBlock myQQShareBlock;
@property (nonatomic ,copy) CopyActionBlock myCopyBlock;
@property (nonatomic ,copy) PicShareActionBlock myPicBlock;
@property (nonatomic ,copy) CloseActionBlock myCloseBlock;
@end

NS_ASSUME_NONNULL_END
