//
//  SeckillCourseDetailView.h
//  KukeApp
//
//  Created by 库课 on 2019/2/25.
//  Copyright © 2019 KukeZangMing. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SeckillCourseDetailView : UIView
@property (weak, nonatomic) IBOutlet UILabel *seckillPrice;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UIProgressView *progress;
@property (weak, nonatomic) IBOutlet UILabel *progressNumber;
@property (weak, nonatomic) IBOutlet UILabel *seckillTimeLab;
@property (weak, nonatomic) IBOutlet UILabel *startPay;
@property (weak, nonatomic) IBOutlet SeckillCourseDetailView *backView;
- (instancetype)initWithFrame:(CGRect)frame dict:(NSDictionary *)data;

//- (void)updataDict:(NSDictionary *)dict;
@end

NS_ASSUME_NONNULL_END
