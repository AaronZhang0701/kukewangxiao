//
//  DistributionInviteModel.h
//  KukeApp
//
//  Created by 库课 on 2019/3/27.
//  Copyright © 2019 KukeZangMing. All rights reserved.
//

#import "JSONModel.h"

NS_ASSUME_NONNULL_BEGIN
@protocol DistributionInviteData <NSObject>
@end
@interface DistributionInviteData : JSONModel
@property (nonatomic,strong)NSString<Optional> *dist_id;
@property (nonatomic,strong)NSString<Optional> *truename;
@property (nonatomic,strong)NSString<Optional> *mobile;
@property (nonatomic,strong)NSString<Optional> *money;
@property (nonatomic,strong)NSString<Optional> *bro_money;
@end



@interface DistributionInviteModel : JSONModel
@property (nonatomic,strong)NSArray<DistributionInviteData,Optional> *data;
@end

NS_ASSUME_NONNULL_END
