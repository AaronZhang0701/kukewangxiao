//
//  RechargeRecordModel.h
//  KukeApp
//
//  Created by iOSDeveloper on 2018/10/29.
//  Copyright © 2018年 zhangming. All rights reserved.
//

#import "JSONModel.h"
@protocol MyRechargeRecordeDataListModel <NSObject>
@end
@interface MyRechargeRecordeDataListModel : JSONModel
@property (nonatomic,strong)NSString<Optional> *type;
@property (nonatomic,strong)NSString<Optional> *status;
@property (nonatomic,strong)NSString<Optional> *affect_amount;
@property (nonatomic,strong)NSString<Optional> *add_time;
@property (nonatomic,strong)NSString<Optional> *content;
@end


@protocol MyRechargeRecordeDataModel <NSObject>
@end

@interface MyRechargeRecordeDataModel : JSONModel

@property (nonatomic,strong)NSArray<MyRechargeRecordeDataListModel,Optional> *log;
@end

@interface RechargeRecordModel : JSONModel

@property (nonatomic,strong)MyRechargeRecordeDataModel *data;

@end
