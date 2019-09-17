//
//  LiveListModel.h
//  KukeApp
//
//  Created by 库课 on 2019/7/22.
//  Copyright © 2019 KukeZangMing. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


@protocol LiveListDataModel <NSObject>
@end
@interface LiveListDataModel : JSONModel
@property (nonatomic,strong)NSString<Optional> *discount_price;
@property (nonatomic,strong)NSString<Optional> *student_num;
@property (nonatomic,strong)NSString<Optional> *live_status;
@property (nonatomic,strong)NSString<Optional> *live_time_text;
@property (nonatomic,strong)NSString<Optional> *price;
@property (nonatomic,strong)NSString<Optional> *img;
@property (nonatomic,strong)NSString<Optional> *title;
@property (nonatomic,strong)NSString<Optional> *live_id;
@end

@interface LiveListModel : JSONModel
@property (nonatomic,strong)NSArray<LiveListDataModel,Optional> *data;
@end

NS_ASSUME_NONNULL_END
