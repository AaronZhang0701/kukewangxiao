//
//  NewsHeaderView.h
//  KukeApp
//
//  Created by 库课 on 2019/5/13.
//  Copyright © 2019 KukeZangMing. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^NewsTypeActionBlock)(NSString *newsType);
@interface NewsHeaderView : UIView
@property (nonatomic, strong) NSString *news_cate_id;
@property (nonatomic ,copy) NewsTypeActionBlock newsTypeActionBlock;
@property (nonatomic,strong)NSString *push_oid;
@end

NS_ASSUME_NONNULL_END
