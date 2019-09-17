//
//  GoodDetailGroupTableViewCell.h
//  KukeApp
//
//  Created by 库课 on 2019/7/15.
//  Copyright © 2019 KukeZangMing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CourseDetailModel.h"

typedef void(^JoinGroupActionBlock)();
NS_ASSUME_NONNULL_BEGIN

@interface GoodDetailGroupTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headerImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *groupMsgLab;
@property (weak, nonatomic) IBOutlet UIButton *jionGroupBtn;
@property (strong, nonatomic) CourseDetailGroupRecommendModel *dict;
@property (nonatomic ,copy) JoinGroupActionBlock myBlock;
- (void)setConfigWithSecond:(NSInteger)second ;
@end

NS_ASSUME_NONNULL_END
