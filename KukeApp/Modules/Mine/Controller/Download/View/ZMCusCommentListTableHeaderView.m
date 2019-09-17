//
//  ZMCusCommentListTableHeaderView.m
//  ZMZX
//
//  Created by Kennith.Zeng on 2018/8/29.
//  Copyright © 2018年 齐家网. All rights reserved.
//

#import "ZMCusCommentListTableHeaderView.h"

@interface ZMCusCommentListTableHeaderView (){
    
}
@property (nonatomic, strong) UIButton *closeBtn;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *selectBtn;
@end;
@implementation ZMCusCommentListTableHeaderView
- (instancetype)initWithFrame:(CGRect)frame{
    
    if ([super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        [self layoutUI];
        
    }
    return self;
}
- (void)layoutUI{
    if (!_closeBtn) {
        UIImage *image = [UIImage imageNamed:@"弹窗关闭按钮"];
        _closeBtn = [[UIButton alloc] init];
        [_closeBtn setImage:image forState:UIControlStateNormal];
        [_closeBtn addTarget:self action:@selector(clostBtnAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_closeBtn];
        [_closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-15);
            make.top.mas_equalTo(16);
            make.size.mas_equalTo(CGSizeMake(16, 16));
        }];
    }

    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:15];
        _titleLabel.textColor = CTitleColor;
        _titleLabel.text = @"选择课时";
        _titleLabel.numberOfLines = 1;
        _titleLabel.backgroundColor = [UIColor clearColor];
        [_titleLabel sizeToFit];
        [self addSubview:_titleLabel];
        _titleLabel.frame = CGRectMake(15, 18, 80, 13);
//        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.mas_equalTo(15);
//            make.top.mas_equalTo(18);
//            make.size.mas_equalTo(CGSizeMake(80, 13));
//        }];
    }
    UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(0, 49, screenWidth(), 1)];
    line.backgroundColor = CBackgroundColor;
    [self addSubview:line];
    
    if (!_selectBtn) {
//        type = @"高清";
        _selectBtn = [[UIButton alloc] init];
        _selectBtn.titleLabel.font = [UIFont systemFontOfSize:14];
//        [_selectBtn setTitleColor:CTitleColor forState:(UIControlStateNormal)];
        
        [_selectBtn addTarget:self action:@selector(downLoadType) forControlEvents:UIControlEventTouchUpInside];
       
//
        [self addSubview:_selectBtn];
        _selectBtn.frame = CGRectMake(maxX(_titleLabel)+10, 18, 100, 13);
//        [_selectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.right.mas_equalTo(_titleLabel.mas_right).mas_offset(10);
//            make.top.mas_equalTo(18);
//            make.size.mas_equalTo(CGSizeMake(80, 13));
//        }];
    }
    
    
}
- (void)setType:(NSString *)type{
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"清晰度： %@ ",type]];
//    [str addAttribute:NSForegroundColorAttributeName value:CNavBgColor range:NSMakeRange(4, 3)];
    [str addAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14], NSForegroundColorAttributeName: CNavBgColor } range:NSMakeRange(4, 3)];
    [str addAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:12], NSForegroundColorAttributeName: [UIColor colorWithHexString:@"#8A8A8A"] } range:NSMakeRange(0, 4)];
//    [str addAttribute:@{NSFontAttributeName: [UIFont systemFontOfSize:12], NSForegroundColorAttributeName:CTitleColor} range:NSMakeRange(0, 4)];
    [_selectBtn setAttributedTitle:str forState:(UIControlStateNormal)];
     [_selectBtn setImage:[UIImage imageNamed:@"清晰度箭头下"] forState:(UIControlStateNormal)];
    [_selectBtn br_layoutButtonWithEdgeInsetsStyle:(BRButtonEdgeInsetsStyleRight) imageTitleSpace:5];
}
- (void)clostBtnAction{
    
    if (self.closeBtnBlock) {
        self.closeBtnBlock();
    }
    
}


-(void)downLoadType{
    if (self.selectTypeBtnBlock) {
        self.selectTypeBtnBlock();
    }
    
}
@end
