//
//  MineHeaderTableViewCell.h
//  KukeApp
//
//  Created by iOSDeveloper on 2018/10/2.
//  Copyright © 2018年 zhangming. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^HeaderActionBlock)();
typedef void(^SingInActionBlock)();
@interface MineHeaderTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *headImage;
@property (weak, nonatomic) IBOutlet UIButton *signInBtn;
@property (nonatomic, strong) NSString *imageUrl;
@property (weak, nonatomic) IBOutlet UIImageView *pic;
@property (weak, nonatomic) IBOutlet UIView *recordView;
@property (weak, nonatomic) IBOutlet UILabel *messgeUnreadNumberLab;

@property (nonatomic ,copy) HeaderActionBlock headerActionBlock;
@property (nonatomic ,copy) SingInActionBlock singinActionBlock;
@property (weak, nonatomic) IBOutlet UIButton *courseRecord;
@property (weak, nonatomic) IBOutlet UIButton *testPaperRecord;
@property (weak, nonatomic) IBOutlet UIButton *registerBtn;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
-(void)loadView;
@end
