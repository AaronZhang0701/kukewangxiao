//
//  PromptCell.m
//  云阙普惠
//
//  Created by a on 2019/3/28.
//  Copyright © 2019年 mac. All rights reserved.
//

#import "PromptCell.h"

@implementation PromptCell

- (void)awakeFromNib {
    [super awakeFromNib];

    self.titleLab.textColor = CTitleColor;
    self.titleLab.font =[UIFont systemFontOfSize:14];
}
- (IBAction)selectAction:(UIButton *)sender {
 
    
    
    if ([self.delegate respondsToSelector:@selector(selectRowStr:indexPath:)]) {
        [_delegate selectRowStr:self.titleLab.text indexPath:self.selectedIndexPath];
    }
    
}
- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];
    for (UIControl *control in self.subviews){
        if ([control isMemberOfClass:NSClassFromString(@"UITableViewCellEditControl")]){
            for (UIView *v in control.subviews)
            {
                if ([v isKindOfClass: [UIImageView class]]) {
                    UIImageView *img=(UIImageView *)v;
                    if (!self.selected) {
                        img.image=[UIImage imageNamed:@"未选"];
                    }
                }
            }
        }
    }
    
}

-(void)layoutSubviews
{
    NSLog(@"%@",self.subviews);
    for (UIControl *control in self.subviews){
        if ([control isMemberOfClass:NSClassFromString(@"UITableViewCellEditControl")]){
            for (UIView *v in control.subviews)
            {
                if ([v isKindOfClass: [UIImageView class]]) {
                    UIImageView *img=(UIImageView *)v;
                    if (self.selected) {
                        img.image=[UIImage imageNamed:@"选择"];
                    }else
                    {
                        img.image=[UIImage imageNamed:@"未选"];
                    }
                }
            }
        }
    }
    
    [super layoutSubviews];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
   

    // Configure the view for the selected state
}

@end
