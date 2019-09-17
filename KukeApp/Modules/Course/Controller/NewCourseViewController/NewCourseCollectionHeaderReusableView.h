//
//  NewCourseCollectionHeaderReusableView.h
//  KukeApp
//
//  Created by 库课 on 2019/4/16.
//  Copyright © 2019 KukeZangMing. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^StyleActionBlock)();
typedef void(^PickActionBlock)();
typedef void(^ZhongheActionBlock)();
typedef void(^XiaoliangActionBlock)();
typedef void(^PriceActionBlock)(NSString *sort_id);

@interface NewCourseCollectionHeaderReusableView : UICollectionReusableView

@property (nonatomic ,copy) StyleActionBlock myStyleActionBlock;
@property (nonatomic ,copy) PickActionBlock myPickActionBlock;
@property (nonatomic ,copy) ZhongheActionBlock myZhongheActionBlock;
@property (nonatomic ,copy) XiaoliangActionBlock myXiaoliangActionBlock;
@property (nonatomic ,copy) PriceActionBlock myPriceActionBlock;
@property (weak, nonatomic) IBOutlet UIButton *zhongheBtn;
@property (weak, nonatomic) IBOutlet UIButton *xiaoliangBtn;
@property (weak, nonatomic) IBOutlet UIButton *priceBtn;
@property (weak, nonatomic) IBOutlet UIButton *styleBtn;
@property (weak, nonatomic) IBOutlet UIButton *pickBtn;
@property (nonatomic, assign) BOOL isSelect;
@end

NS_ASSUME_NONNULL_END
