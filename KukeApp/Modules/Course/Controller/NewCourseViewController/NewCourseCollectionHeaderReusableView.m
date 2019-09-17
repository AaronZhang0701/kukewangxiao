//
//  NewCourseCollectionHeaderReusableView.m
//  KukeApp
//
//  Created by 库课 on 2019/4/16.
//  Copyright © 2019 KukeZangMing. All rights reserved.
//

#import "NewCourseCollectionHeaderReusableView.h"

@implementation NewCourseCollectionHeaderReusableView

- (void)awakeFromNib {
    [super awakeFromNib];
    self.zhongheBtn.selected = YES;
    // Initialization code
}
- (void)setIsSelect:(BOOL)isSelect
{
    if (isSelect) {
        self.pickBtn.selected = YES;
        [self.pickBtn setTitleColor:CNavBgColor forState:(UIControlStateNormal)];
    }else{
        self.pickBtn.selected = NO;
        [self.pickBtn setTitleColor:CTitleColor forState:(UIControlStateNormal)];
    }
    
}
- (IBAction)zhongheAction:(UIButton *)sender  {
    
    if (_myZhongheActionBlock) {
        
        self.myZhongheActionBlock();
    }
    sender.selected = !sender.selected;
    if (sender.selected) {
        self.xiaoliangBtn.selected = NO;
        self.zhongheBtn.selected = YES;
    }else{
        self.zhongheBtn.selected = NO;
        self.xiaoliangBtn.selected = YES;
    }
    [self.priceBtn setTitleColor:CTitleColor forState:(UIControlStateNormal)];
    [self.priceBtn setImage:[UIImage imageNamed:@"灰色状态"] forState:(UIControlStateNormal)];
    self.priceBtn.selected = NO;
}
- (IBAction)xiaoliangAction:(UIButton *)sender  {
    if (_myXiaoliangActionBlock) {
        
        self.myXiaoliangActionBlock();
    }
    sender.selected = !sender.selected;
    if (sender.selected) {
        self.zhongheBtn.selected = NO;
        self.xiaoliangBtn.selected = YES;
    }else{
        self.xiaoliangBtn.selected = NO;
        self.zhongheBtn.selected = YES;
    }
    [self.priceBtn setTitleColor:CTitleColor forState:(UIControlStateNormal)];
    [self.priceBtn setImage:[UIImage imageNamed:@"灰色状态"] forState:(UIControlStateNormal)];
    self.priceBtn.selected = NO;
}
- (IBAction)priceAction:(UIButton *)sender {
    
    sender.selected = !sender.selected;
    if (sender.selected) {
        if (_myPickActionBlock) {
            
            self.myPriceActionBlock(@"2");
        }
        [self.priceBtn setTitleColor:CNavBgColor forState:(UIControlStateNormal)];
        [self.priceBtn setImage:[UIImage imageNamed:@"下箭头红色"] forState:(UIControlStateNormal)];
        self.priceBtn.selected = YES;
        
    }else{
        if (_myPickActionBlock) {
            
            self.myPriceActionBlock(@"4");
        }
        [self.priceBtn setTitleColor:CNavBgColor forState:(UIControlStateNormal)];
        [self.priceBtn setImage:[UIImage imageNamed:@"上箭头红色"] forState:(UIControlStateNormal)];
        self.priceBtn.selected = NO;
    }
    self.xiaoliangBtn.selected = NO;
    self.zhongheBtn.selected = NO;
    
}
- (IBAction)styleAction:(UIButton *)sender {
    if (_myStyleActionBlock) {
    
        self.myStyleActionBlock();
    }
    
    sender.selected = !sender.selected;
    if (sender.selected) {
        
        self.styleBtn.selected = YES;
    }else{
        self.styleBtn.selected = NO;
        
    }
    
    
}
- (IBAction)pickAction:(id)sender {
    if (_myPickActionBlock) {
        self.myPickActionBlock();
    }
}

@end
