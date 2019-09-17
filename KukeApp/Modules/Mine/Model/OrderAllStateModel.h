//
//  OrderAllStateModel.h
//  KukeApp
//
//  Created by 库课 on 2019/1/4.
//  Copyright © 2019 zhangming. All rights reserved.
//

#import "JSONModel.h"


@protocol OrderAllStateDataStatusModel <NSObject>
@end
@interface OrderAllStateDataStatusModel : JSONModel
@property (nonatomic,strong)NSString<Optional> *name;
@property (nonatomic,strong)NSString<Optional> *status_time;


@end


@protocol OrderAllStateDataModel <NSObject>
@end
@interface OrderAllStateDataModel : JSONModel
@property (nonatomic,strong)NSString<Optional> *kinds;
@property (nonatomic,strong)NSString<Optional> *express_type;
@property (nonatomic,strong)NSString<Optional> *courier_number;
@property (nonatomic,strong)NSString<Optional> *receive_mobile;
@property (nonatomic,strong)NSString<Optional> *receiver;
@property (nonatomic,strong)NSString<Optional> *address;

@property (nonatomic,strong)NSArray<OrderAllStateDataStatusModel,Optional> *status_info;
@end

@interface OrderAllStateModel : JSONModel
@property (nonatomic,strong)OrderAllStateDataModel *data;
@end

