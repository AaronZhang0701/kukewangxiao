//
//  MenuCollectionViewCell.h
//  KukeApp
//
//  Created by iOSDeveloper on 2018/9/25.
//  Copyright © 2018年 zhangming. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomePageMenuModel.h"
@interface MenuCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) HomePageCategoryModel *model;
@property (weak, nonatomic) IBOutlet UIImageView *menuImage;
@property (weak, nonatomic) IBOutlet UILabel *menuTitle;

@end
