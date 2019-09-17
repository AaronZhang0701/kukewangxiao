//
//  NY_AddressModel.h
//  中安生态商城
//
//  Created by NewYear on 2017/7/18.
//  Copyright © 2017年 王鑫年. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NY_AddressModel : NSObject <NSCoding>

@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSString *province;
@property (nonatomic, copy) NSString *city;
@property (nonatomic, copy) NSString *district;
@property (nonatomic, assign) NSInteger addressId;
@property (nonatomic, assign) bool is_default;
@property (nonatomic, copy) NSString *mobile;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *tel;
@property (nonatomic, copy) NSString *zip_code;
@property (nonatomic, copy) NSString *PCAaddress;
@property (nonatomic, copy) NSString *region;

@end
