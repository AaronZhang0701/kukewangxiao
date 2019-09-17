//
//  CourseDetailHeaderView.h
//  KukeApp
//
//  Created by iOSDeveloper on 2018/10/1.
//  Copyright © 2018年 zhangming. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CourseDetailHeaderView : UIView
- (instancetype)initWithFrame:(CGRect)frame goodsType:(NSString *)type;
- (void)scrollViewDidScroll:(CGFloat)contentOffsetY;
@property (nonatomic, strong) NSString *imageUrl;
@property (nonatomic, strong) NSString  *isBook;
@end
