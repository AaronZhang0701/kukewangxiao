//
//  ExamProgoseCollectionCell.h
//  KukeApp
//
//  Created by 库课 on 2019/8/9.
//  Copyright © 2019 KukeZangMing. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ExamProgoseCollectionCell : UICollectionViewCell
@property (nonatomic, strong) UIImageView *imageV;
@property (nonatomic, strong) UILabel *titleLabel;
- (void)configData:(id)data;
@end

NS_ASSUME_NONNULL_END
