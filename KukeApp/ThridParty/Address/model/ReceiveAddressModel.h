//
//  ReceiveAddressModel.h
//  KukeApp
//
//  Created by 库课 on 2019/2/13.
//  Copyright © 2019 KukeZangMing. All rights reserved.
//

#import "JSONModel.h"

NS_ASSUME_NONNULL_BEGIN
@protocol ReceiveAddressDataListModel <NSObject>
@end
@interface ReceiveAddressDataListModel : JSONModel
@property (nonatomic,strong)NSString<Optional> *ID;
@property (nonatomic,strong)NSString<Optional> *province_id;
@property (nonatomic,strong)NSString<Optional> *is_default;
@property (nonatomic,strong)NSString<Optional> *city_id;
@property (nonatomic,strong)NSString<Optional> *county_id;
@property (nonatomic,strong)NSString<Optional> *address;
@property (nonatomic,strong)NSString<Optional> *province_name;
@property (nonatomic,strong)NSString<Optional> *city_name;
@property (nonatomic,strong)NSString<Optional> *county_name;
@property (nonatomic,strong)NSString<Optional> *receiver;
@property (nonatomic,strong)NSString<Optional> *receive_mobile;
@end


@interface ReceiveAddressModel : JSONModel
@property (nonatomic,strong)NSArray<ReceiveAddressDataListModel,Optional> *data;
@end

NS_ASSUME_NONNULL_END
