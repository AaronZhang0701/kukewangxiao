//
//  NY_UpdateAddress.h
//  中安生态商城
//
//  Created by NewYear on 2017/7/18.
//  Copyright © 2017年 王鑫年. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NY_AddressModel.h"
#import "ReceiveAddressModel.h"
@interface NY_UpdateAddress : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *addressText;
@property (nonatomic, strong) NY_AddressModel *addressModel;
@property (weak, nonatomic) IBOutlet UILabel *stringNumber;
@property (nonatomic, strong) ReceiveAddressDataListModel *model;
@end
