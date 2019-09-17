//
//  DownLoadCategoryCell.h
//  KukeApp
//
//  Created by iOSDeveloper on 2018/12/7.
//  Copyright © 2018年 zhangming. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DownLoadCategoryCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *pic;
@property (weak, nonatomic) IBOutlet UILabel *categoryName;
@property (weak, nonatomic) IBOutlet UILabel *courseCount;
@property (weak, nonatomic) IBOutlet UILabel *downLoadCount;
@property (weak, nonatomic) IBOutlet UIImageView *isLook;

- (void)upDataWithCategoryID:(NSString *)categoryID;

@end

NS_ASSUME_NONNULL_END
