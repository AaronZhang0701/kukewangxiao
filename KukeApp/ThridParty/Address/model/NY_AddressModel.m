//
//  NY_AddressModel.m
//  中安生态商城
//
//  Created by NewYear on 2017/7/18.
//  Copyright © 2017年 王鑫年. All rights reserved.
//

#import "NY_AddressModel.h"

@implementation NY_AddressModel


- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.address forKey:@"address"];
    [aCoder encodeObject:self.province forKey:@"province"];
    [aCoder encodeObject:self.city forKey:@"city"];
    [aCoder encodeObject:self.district forKey:@"district"];
    [aCoder encodeInteger:self.addressId forKey:@"addressId"];
    [aCoder encodeBool:self.is_default forKey:@"is_default"];
    [aCoder encodeObject:self.mobile forKey:@"mobile"];
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:self.tel forKey:@"tel"];
    [aCoder encodeObject:self.PCAaddress forKey:@"PCAaddress"];
    [aCoder encodeObject:self.zip_code forKey:@"zip_code"];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        self.address = [aDecoder decodeObjectForKey:@"address"];
        self.province = [aDecoder decodeObjectForKey:@"province"];
        self.city = [aDecoder decodeObjectForKey:@"city"];
        self.district = [aDecoder decodeObjectForKey:@"district"];
        self.addressId = [aDecoder decodeIntegerForKey:@"addressId"];
        self.is_default = [aDecoder decodeBoolForKey:@"is_default"];
        self.mobile = [aDecoder decodeObjectForKey:@"mobile"];
        self.name = [aDecoder decodeObjectForKey:@"name"];
        self.tel = [aDecoder decodeObjectForKey:@"tel"];
        self.zip_code = [aDecoder decodeObjectForKey:@"zip_code"];
        self.PCAaddress = [aDecoder decodeObjectForKey:@"PCAaddress"];
    }
    return self;
}

@end
