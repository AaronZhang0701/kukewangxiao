//
//  NY_AddressListCell.m
//  中安生态商城
//
//  Created by NewYear on 2017/7/18.
//  Copyright © 2017年 王鑫年. All rights reserved.
//

#import "NY_AddressListCell.h"


@interface NY_AddressListCell (){
    NSString *addressId;
}
@property (weak, nonatomic) IBOutlet UILabel *lb_name;
@property (weak, nonatomic) IBOutlet UILabel *lb_tel;
@property (weak, nonatomic) IBOutlet UILabel *lb_address;
@property (weak, nonatomic) IBOutlet UILabel *PCAaddress;

@property (weak, nonatomic) IBOutlet UIImageView *im_isDefalt;
@property (weak, nonatomic) IBOutlet UILabel *lb_isDefalt;

@end

@implementation NY_AddressListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)setModel:(ReceiveAddressDataListModel *)model{
    addressId = model.ID;
    _lb_name.text = model.receiver;
    _lb_address.text = model.address;
    _lb_tel.text = model.receive_mobile;
    _PCAaddress.text = [NSString stringWithFormat:@"%@ %@ %@",model.province_name,model.city_name,model.county_name];
    if ([model.is_default isEqualToString:@"1"]) {
        _is_default.image = [UIImage imageNamed:@"shopcarsel"];
        _is_defaultLab.text = @"默认地址";
        _is_defaultLab.textColor = [UIColor redColor];
    } else {
        _is_default.image = [UIImage imageNamed:@"shopcar"];
        _is_defaultLab.text = @"设为默认";
        _is_defaultLab.textColor = [UIColor grayColor];
    }
}
- (void)setAddressModel:(NY_AddressModel *)addressModel {
    if (_addressModel != addressModel) {
        _addressModel = addressModel;
        
        _lb_name.text = addressModel.name;
        _lb_address.text = addressModel.address;
        _lb_tel.text = addressModel.tel;
        _PCAaddress.text = addressModel.PCAaddress;
        
        if (_addressModel.is_default) {
            _im_isDefalt.image = [UIImage imageNamed:@"shopcarsel"];
            _lb_isDefalt.text = @"默认地址";
            _lb_isDefalt.textColor = [UIColor redColor];
        } else {
            _im_isDefalt.image = [UIImage imageNamed:@"shopcar"];
            _lb_isDefalt.text = @"设为默认";
            _lb_isDefalt.textColor = [UIColor grayColor];
        }
        
        
    }
}
- (IBAction)defaltAddress:(UIButton *)sender {
    [self.delegate defaltAddressWithId:[addressId integerValue] withIndex:_selIndex];
}
- (IBAction)bianjiAddress:(UIButton *)sender {
    [self.delegate upDateAddressWithId:_addressModel.addressId withIndex:_index];
}
- (IBAction)deleteAddress:(UIButton *)sender {
    [self.delegate deleteAddressWithId:[addressId integerValue] withIndex:_index];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
