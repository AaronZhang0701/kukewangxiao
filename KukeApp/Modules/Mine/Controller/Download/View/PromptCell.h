//
//  PromptCell.h
//  云阙普惠
//
//  Created by a on 2019/3/28.
//  Copyright © 2019年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PromptCell;
@protocol promptCellDelegate <NSObject>

-(void)selectRowStr:(NSString *)cellStr indexPath:(NSIndexPath*)selectedIndexPath ;
@end

@interface PromptCell : UITableViewCell
@property (nonatomic , strong) UIButton *lastButton;
@property (assign, nonatomic) NSIndexPath *selectedIndexPath;

@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UIButton *selectBtn;
@property(nonatomic,weak)id<promptCellDelegate>delegate;

@end


