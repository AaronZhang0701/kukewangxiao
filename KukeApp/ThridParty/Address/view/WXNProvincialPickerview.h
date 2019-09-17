//
//  HXProvincialCitiesCountiesPickerview.h
//  中安生态商城
//
//  Created by NewYear on 2017/7/18.
//  Copyright © 2017年 王鑫年. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WXNProvincialPickerview : UIView

@property (nonatomic,copy) void (^completion)(NSString *provinceName,NSString *cityName,NSString *countyName,NSString *provinceId,NSString *cityId,NSString *countyId);

- (void)showPickerWithProvinceName:(NSString *)provinceName cityName:(NSString *)cityName countyName:(NSString *)countyName;//显示 省 市 县名

@end
