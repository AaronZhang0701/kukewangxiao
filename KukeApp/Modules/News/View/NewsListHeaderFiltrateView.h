//
//  NewsListHeaderFiltrateView.h
//  KukeApp
//
//  Created by 库课 on 2019/7/8.
//  Copyright © 2019 KukeZangMing. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^CourseFiltrateActionBlock)(NSInteger city_id);

@interface NewsListHeaderFiltrateView : UIView
@property (nonatomic ,copy) CourseFiltrateActionBlock myBlock;
@property (nonatomic, strong) UIView *bgView;
- (void)loadDataWithNewsCateId:(NSString *)news_cate_id NewsOid:(NSString *)news_oid;
@property (nonatomic, assign) NSInteger city_id;
@end

NS_ASSUME_NONNULL_END
