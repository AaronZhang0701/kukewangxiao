//
//  NY_AddressListCell.h
//  中安生态商城
//
//  Created by NewYear on 2017/7/18.
//  Copyright © 2017年 王鑫年. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NY_AddressModel.h"
#import "ReceiveAddressModel.h"
@protocol AddressListCellDelegate <NSObject>

- (void)deleteAddressWithId:(NSInteger)addressId withIndex:(NSInteger)index;
- (void)upDateAddressWithId:(NSInteger)addressId withIndex:(NSInteger)index;
- (void)defaltAddressWithId:(NSInteger)addressId withIndex:(NSIndexPath *)index;

@end

@interface NY_AddressListCell : UITableViewCell

@property (nonatomic, weak) id<AddressListCellDelegate> delegate;

@property (nonatomic, strong) NY_AddressModel *addressModel;
@property (nonatomic, assign) NSInteger index;
@property (weak, nonatomic) IBOutlet UIImageView *is_default;
@property (weak, nonatomic) IBOutlet UILabel *is_defaultLab;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) ReceiveAddressDataListModel *model;
@property (assign, nonatomic) NSIndexPath *selIndex;//单选，当前选中的行
@end
