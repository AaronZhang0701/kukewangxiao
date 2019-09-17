//
//  BottomToolView.h
//  KukeApp
//
//  Created by iOSDeveloper on 2018/10/1.
//  Copyright © 2018年 zhangming. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^PayActionBlock)(BOOL isGroup);
typedef void(^HuanxinActionBlock)();
typedef void(^ShareActionBlock)();
@interface BottomToolView : UIView
@property (nonatomic ,copy) PayActionBlock myBlock;
@property (nonatomic ,copy) HuanxinActionBlock myHXBlock;
@property (nonatomic ,copy) ShareActionBlock myShareBlock;
@property (nonatomic ,strong) UIButton *collectionBtn;
@property (nonatomic ,strong) NSDictionary *goodsDict;
@property (nonatomic ,strong) UIButton *buyBtn;
@property (nonatomic, strong) NSString *isDistribute;
@property (nonatomic, strong) NSString *goodsType;



@end
