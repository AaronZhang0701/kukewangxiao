//
//  DistributionBillModel.h
//  KukeApp
//
//  Created by 库课 on 2019/3/25.
//  Copyright © 2019 KukeZangMing. All rights reserved.
//

#import "JSONModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol DistributionBillData <NSObject>
@end
@interface DistributionBillData : JSONModel
@property (nonatomic,strong)NSString<Optional> *trans_type;
@property (nonatomic,strong)NSString<Optional> *trans_flag;
@property (nonatomic,strong)NSString<Optional> *trans_money;
@property (nonatomic,strong)NSString<Optional> *create_time;
@property (nonatomic,strong)NSString<Optional> *trans_status;
@property (nonatomic,strong)NSString<Optional> *trans_type_text;

@end
@interface DistributionBillModel : JSONModel
@property (nonatomic,strong)NSArray<DistributionBillData,Optional> *data;
@end

NS_ASSUME_NONNULL_END
