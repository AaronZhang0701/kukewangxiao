//
//  ExamListHeaderView.h
//  KukeApp
//
//  Created by 库课 on 2019/8/7.
//  Copyright © 2019 KukeZangMing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ExamListViewModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface ExamListHeaderView : UIView
@property (nonatomic, strong) UILabel *lab1;
@property (nonatomic, strong) UILabel *lab2;
@property (nonatomic, strong) UILabel *lab3;


@property (nonatomic, strong) UILabel *line1;
@property (nonatomic, strong) UILabel *line2;

@property (nonatomic, strong) UIButton *btn1;
@property (nonatomic, strong) UIButton *btn2;
@property (nonatomic, strong) UIButton *btn3;
@property (nonatomic, strong) NewExamListHeaderDataModel *model;

@end

NS_ASSUME_NONNULL_END
