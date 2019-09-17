//
//  ExamListHeaderView.m
//  KukeApp
//
//  Created by 库课 on 2019/8/7.
//  Copyright © 2019 KukeZangMing. All rights reserved.
//

#import "ExamListHeaderView.h"
//#import "AFCircleChart.h"

@interface ExamListHeaderView ()

@end

@implementation ExamListHeaderView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

        self.width = screenWidth();

        self.backgroundColor = [UIColor whiteColor];
     
        [self initView];
        
    
    }
    return self;
}


- (void)setModel:(NewExamListHeaderDataModel *)model{
    [self.btn1 setTitle:[NSString stringWithFormat:@"错题本(%@)",model.wrong_count] forState:(UIControlStateNormal)];
    [self.btn2 setTitle:[NSString stringWithFormat:@"收藏本(%@)",model.collection_count] forState:(UIControlStateNormal)];
    [self.btn3 setTitle:@"提升建议" forState:(UIControlStateNormal)];
    
    NSString *str1 = [NSString stringWithFormat:@"%@%%\n正确率",model.right_radio];
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:str1 attributes:@{NSFontAttributeName: [UIFont fontWithName:@"PingFang-SC-Medium" size: 20],NSForegroundColorAttributeName: [UIColor colorWithRed:71/255.0 green:200/255.0 blue:138/255.0 alpha:1.0]}];
    
    [string addAttributes:@{NSFontAttributeName: [UIFont fontWithName:@"PingFang-SC-Medium" size: 10], NSForegroundColorAttributeName: [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1.0]} range:NSMakeRange(model.right_radio.length, 5)];
    
    self.lab1.attributedText = string;
    
    
    NSString *str2 = [NSString stringWithFormat:@"%@时%@分\n做题时长",model.hours,model.minutes];
    NSMutableAttributedString *string2 = [[NSMutableAttributedString alloc] initWithString:str2 attributes:@{NSFontAttributeName: [UIFont fontWithName:@"PingFang-SC-Medium" size: 20],NSForegroundColorAttributeName: [UIColor colorWithRed:235/255.0 green:135/255.0 blue:5/255.0 alpha:1.0]}];
    
    [string2 addAttributes:@{NSFontAttributeName: [UIFont fontWithName:@"PingFang-SC-Medium" size: 10], NSForegroundColorAttributeName: [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1.0]} range:NSMakeRange(model.hours.length, 1)];
    
    [string2 addAttributes:@{NSFontAttributeName: [UIFont fontWithName:@"PingFang-SC-Medium" size: 10], NSForegroundColorAttributeName: [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1.0]} range:NSMakeRange(model.hours.length + model.minutes.length +1, 6)];
    
    self.lab2.attributedText = string2;
    
    NSString *str3 = [NSString stringWithFormat:@"%@\n做题量",model.do_count];
    NSMutableAttributedString *string3 = [[NSMutableAttributedString alloc] initWithString:str3 attributes:@{NSFontAttributeName: [UIFont fontWithName:@"PingFang-SC-Medium" size: 20],NSForegroundColorAttributeName: [UIColor colorWithRed:249/255.0 green:90/255.0 blue:30/255.0 alpha:1.0]}];
    [string3 addAttributes:@{NSFontAttributeName: [UIFont fontWithName:@"PingFang-SC-Medium" size: 10], NSForegroundColorAttributeName: [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1.0]} range:NSMakeRange(model.do_count.length, 4)];
    self.lab3.attributedText = string3;
    
}
- (void)initView{

    
    self.line1 = [[UILabel alloc]init];
    self.line1.backgroundColor = CBackgroundColor;
    [self addSubview:self.line1];
    
    
    self.line2 = [[UILabel alloc]init];
    self.line2.backgroundColor = CBackgroundColor;
    [self addSubview:self.line2];
    
    self.lab1 = [[UILabel alloc]init];
    self.lab1.layer.borderWidth = 3;
    self.lab1.layer.borderColor = [[UIColor colorWithHexString:@"#F3F2F2"] CGColor];
    self.lab1.lineBreakMode = NSLineBreakByWordWrapping;
    self.lab1.textAlignment = NSTextAlignmentCenter;
    self.lab1.numberOfLines = 2;
    [self addSubview:self.lab1];
    
    self.lab2 = [[UILabel alloc]init];
    self.lab2.layer.borderWidth = 3;
    self.lab2.layer.borderColor = [[UIColor colorWithHexString:@"#F3F2F2"] CGColor];
    self.lab2.lineBreakMode = NSLineBreakByWordWrapping;
    self.lab2.numberOfLines = 2;
    self.lab2.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.lab2];
    
    self.lab3 = [[UILabel alloc]init];
    self.lab3.layer.borderWidth = 3;
    self.lab3.numberOfLines = 2;
    self.lab3.layer.borderColor = [[UIColor colorWithHexString:@"#F3F2F2"] CGColor];
    self.lab3.lineBreakMode = NSLineBreakByWordWrapping;
    self.lab3.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.lab3];
    
    
    
    self.btn1 = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self.btn1 setTitleColor:CTitleColor forState:(UIControlStateNormal)];
    self.btn1.backgroundColor = [UIColor colorWithRed:242/255.0 green:240/255.0 blue:245/255.0 alpha:1.0];
    self.btn1.layer.cornerRadius = 3;
    self.btn1.titleLabel.font = [UIFont systemFontOfSize:14];
  
    [self addSubview:self.btn1];
    
    self.btn2 = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self.btn2 setTitleColor:CTitleColor forState:(UIControlStateNormal)];
    self.btn2.backgroundColor = [UIColor colorWithRed:242/255.0 green:240/255.0 blue:245/255.0 alpha:1.0];
    self.btn2.layer.cornerRadius = 3;
    
    self.btn2.titleLabel.font = [UIFont systemFontOfSize:14];
    [self addSubview:self.btn2];
    
    self.btn3 = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self.btn3 setTitleColor:CTitleColor forState:(UIControlStateNormal)];
    self.btn3.backgroundColor = [UIColor colorWithRed:242/255.0 green:240/255.0 blue:245/255.0 alpha:1.0];
    self.btn3.layer.cornerRadius = 3;
    
    self.btn3.titleLabel.font = [UIFont systemFontOfSize:14];
    [self addSubview:self.btn3];
    
    [self.line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(9);
    }];
    
   
    
    // ------ 添加约束
    [self.lab1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(25);
        make.top.mas_equalTo(self.line1.mas_bottom).offset(15);
        make.size.mas_equalTo(CGSizeMake((screenWidth()-90)/3,(screenWidth()-90)/3));

    }];
    
    // ------ 添加约束
    [self.lab2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.mas_equalTo(self.line1.mas_bottom).offset(15);
        make.size.mas_equalTo(CGSizeMake((screenWidth()-90)/3,(screenWidth()-90)/3));

    }];
    
    // ------ 添加约束
    [self.lab3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-25);
        make.top.mas_equalTo(self.line1.mas_bottom).offset(15);
        make.size.mas_equalTo(CGSizeMake((screenWidth()-90)/3,(screenWidth()-90)/3));

    }];
    self.lab1.layer.cornerRadius = (screenWidth()-90)/3/2;
    self.lab2.layer.cornerRadius = (screenWidth()-90)/3/2;
    self.lab3.layer.cornerRadius = (screenWidth()-90)/3/2;
    
    
    [@[self.btn1, self.btn2, self.btn3] mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:5 leadSpacing:15 tailSpacing:15];
    [@[self.btn1, self.btn2, self.btn3] mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lab1.mas_bottom).offset(15);
//        make.height.mas_equalTo(self.btn3.mas_width).multipliedBy(0.4f);
        make.height.mas_equalTo(44);
    }];
    
//    // ------ 添加约束
//    [self.btn1 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(15);
////        make.bottom.mas_equalTo(self.line2.mas_top).offset(-15);
//        make.top.mas_equalTo(self.lab1.mas_bottom).offset(15);
//        make.width.mas_equalTo((screenWidth()-40)/3);
//        make.height.mas_equalTo(self.btn1.mas_width).multipliedBy(0.4f);
//
//
//    }];
    [self.line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.btn1.mas_bottom).offset(15);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(9);
        
    }];
//    // ------ 添加约束
//    [self.btn2 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(self);
////        make.bottom.mas_equalTo(self.line2.mas_top).offset(-15);
//        make.top.mas_equalTo(self.lab2.mas_bottom).offset(15);
//        make.width.mas_equalTo((screenWidth()-40)/3);
//        make.height.mas_equalTo(self.btn1.mas_width).multipliedBy(0.4f);
//
//    }];
//
//    // ------ 添加约束
//    [self.btn3 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.mas_equalTo(-15);
////        make.bottom.mas_equalTo(self.line2.mas_top).offset(-15);
//        make.top.mas_equalTo(self.lab3.mas_bottom).offset(15);
//        make.width.mas_equalTo((screenWidth()-40)/3);
//        make.height.mas_equalTo(self.btn1.mas_width).multipliedBy(0.4f);
//
//    }];
//
    
//
//    [self mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(0);
//        make.left.mas_equalTo(0);
//        make.right.mas_equalTo(0);
//        make.height.mas_equalTo(self.line2.mas_bottom);
//        [self layoutIfNeeded];
//
//    }];
//
    
    
//    [self mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.width.equalTo(self.line2);
//        make.bottom.equalTo(self.line2);
//    }];
//
}

@end
