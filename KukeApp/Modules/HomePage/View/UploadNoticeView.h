//
//  UploadNoticeView.h
//  KukeApp
//
//  Created by 库课 on 2019/5/21.
//  Copyright © 2019 KukeZangMing. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^UploadBlock)();
typedef void(^CloseBlock)();
@interface UploadNoticeView : UIView
@property (weak, nonatomic) IBOutlet UILabel *contentLab;
@property (weak, nonatomic) IBOutlet UIImageView *imageBackView;
@property (nonatomic ,copy) UploadBlock uploadBlock;
@property (weak, nonatomic) IBOutlet UIButton *closeBtn;
@property (nonatomic ,copy) CloseBlock closeBlock;
@end

NS_ASSUME_NONNULL_END
