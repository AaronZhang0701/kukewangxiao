//
//  NY_AddAddressVC.m
//  中安生态商城
//
//  Created by NewYear on 2017/7/18.
//  Copyright © 2017年 王鑫年. All rights reserved.
//

#import "NY_AddAddressVC.h"

#import "WXNProvincialPickerview.h"

#import "NY_AddressModel.h"

@interface NY_AddAddressVC ()<UITextFieldDelegate, UITextViewDelegate>
@property (nonatomic, strong) WXNProvincialPickerview *regionPickerView;
@property (weak, nonatomic) IBOutlet UIView *backView;

@property (weak, nonatomic) IBOutlet UITextField *user_name;
@property (weak, nonatomic) IBOutlet UITextField *user_tel;
@property (weak, nonatomic) IBOutlet UILabel *lb_adress;
@property (weak, nonatomic) IBOutlet UITextView *tx_detailAddress;
@property (weak, nonatomic) IBOutlet UISwitch *isDefault;

@property (copy, nonatomic) NSString *pid;
@property (copy, nonatomic) NSString *ciid;
@property (copy, nonatomic) NSString *coid;
@property (copy, nonatomic) NSString *PCAaddress;
@property (nonatomic, strong) NSString *isTure;

@end

@implementation NY_AddAddressVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self addRightNavBarWithText:@"保存"];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewEndEditing)];
    [self.backView addGestureRecognizer:tap];
    [self.user_name addTarget:self action:@selector(textFieldDidChanges:) forControlEvents:UIControlEventEditingChanged];
    [self.addresstext addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
//    _tx_detailAddress.placeholder = @"请填写详细地址，不少于5个字...";
    _isTure = @"";
    self.tx_detailAddress.delegate = self;
}
//实现方法
- (void)textFieldDidChange:(UITextField *)textField
{
    self.addresstext.hidden = YES;
    
}
- (void)textFieldDidChanges:(UITextField *)textField
{
    if (textField.text.length > 20) {
        //提示语
        [BaseTools showErrorMessage:@"输入限制10个字符以内"];
        //截取
        textField.text = [textField.text substringToIndex:20];
    }
    
}
- (void)textViewDidEndEditing:(UITextView *)textView
{
    if(textView.text.length < 1){
        textView.text = @"请输入所在区域、街道、小区门牌等详细信息";
        textView.textColor = [UIColor grayColor];
    }
}
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if([textView.text isEqualToString:@"请输入所在区域、街道、小区门牌等详细信息"]){
        textView.text=@"";
        textView.textColor=[UIColor blackColor];
    }
}
- (void)textViewDidChange:(UITextView *)textView{
    
    if (textView.markedTextRange == nil && textView.text.length > 50) {
        //提示语
        [BaseTools showErrorMessage:@"输入限制50个字符以内"];
        //截取
        textView.text = [textView.text substringToIndex:50];
        
    }
    self.stringLab.text = [NSString stringWithFormat:@"%ld/50",textView.text.length];
}
- (void)addRightNavBarWithText:(NSString*)title {
    
    if (self.navigationItem.rightBarButtonItem)
    {
        self.navigationItem.rightBarButtonItem= nil;
    }
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 44)];
    [button setTitle:title forState:UIControlStateNormal];
    [button  setTitleColor:CTitleColor forState:(UIControlStateNormal)];
    button.titleLabel.textAlignment = NSTextAlignmentRight;
    [button addTarget:self action:@selector(naviRightAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = rightBtn;
    
}

- (void)viewEndEditing {
    [self.view endEditing:YES];
}


- (BOOL )isValidName:(NSString *)nameStr {
    return nameStr.length > 1;
}

- (BOOL )isValidTel:(NSString *)tel {
    return tel.length > 10;
}

- (BOOL )isValidDetailAddress:(NSString *)address {
    return address.length > 4;
}


- (IBAction)selectAddress:(UIButton *)sender {
    [self.view endEditing:YES];
    
    NSString *address = _lb_adress.text;
    NSArray *array = [address componentsSeparatedByString:@" "];
    
    NSString *province = @"";//省
    NSString *city = @"";//市
    NSString *county = @"";//县
    if (array.count > 2) {
        province = array[0];
        city = array[1];
        county = array[2];
    } else if (array.count > 1) {
        province = array[0];
        city = array[1];
    } else if (array.count > 0) {
        province = array[0];
    }
    
    [self.regionPickerView showPickerWithProvinceName:province cityName:city countyName:county];
    
}

- (void)naviRightAction {

    if (![CoreStatus isNetworkEnable]) {
        [BaseTools showErrorMessage:@"无法连接到网络"];
    }else{
        if (_pid == nil || ([_pid.class isSubclassOfClass:NSString.class] && [_pid isEqualToString:@""])) {
            [BaseTools showErrorMessage:@"请选择所在省"];
            NSLog(@"请选择所在省");
            
        } else if (_ciid == nil || ([_ciid.class isSubclassOfClass:NSString.class] && [_ciid isEqualToString:@""])) {
            [BaseTools showErrorMessage:@"请选择所在市"];
            NSLog(@"请选择所在市");
            
        } else if (_coid == nil || ([_coid.class isSubclassOfClass:NSString.class] && [_coid isEqualToString:@""])) {
            [BaseTools showErrorMessage:@"请选择所在区"];
            NSLog(@"请选择所在区");
            
        }else if (![BaseTools valiMobile:_user_tel.text]) {
            [BaseTools showErrorMessage:@"请输入正确的手机号"];
            
        }else if (_tx_detailAddress.text.length == 0) {
            [BaseTools showErrorMessage:@"请输入您的详细地址"];
            
        }else if (_user_name.text.length == 0) {
            [BaseTools showErrorMessage:@"请输入收件人姓名"];
            
        }
        else {
            
            NY_AddressModel *address = [[NY_AddressModel alloc] init];
            address.address = _tx_detailAddress.text;
            address.province = _pid != nil ? _pid : @"";
            address.city = _ciid != nil ? _ciid : @"";;
            address.district = _coid != nil ? _coid : @"";
            address.is_default = false;
            address.mobile = _user_tel.text;
            address.name =_user_name.text;
            address.tel = _user_tel.text;
            address.PCAaddress = self.PCAaddress;
            // 取本地地址列表
            NSMutableArray *arr = [NSMutableArray array];
            NSData * data1 = [[NSUserDefaults standardUserDefaults] objectForKey:@"Test"];
            [arr addObjectsFromArray:[NSKeyedUnarchiver unarchiveObjectWithData:data1]];
            // 添加新地址
            [arr addObject:address];
            
            
            NSData * data = [NSKeyedArchiver archivedDataWithRootObject:arr];
            [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"Test"];
            
            
            NSMutableDictionary *parmDic = [NSMutableDictionary dictionary];
            [parmDic setObject:self.pid forKey:@"province_id"];
            [parmDic setObject:self.ciid forKey:@"city_id"];
            [parmDic setObject:self.coid  forKey:@"county_id"];
            [parmDic setObject:address.address forKey:@"address"];
            [parmDic setObject:address.name forKey:@"receiver"];
            [parmDic setObject:address.mobile  forKey:@"receive_mobile"];
            [ZMNetworkHelper POST:@"/stucommon/add_student_address" parameters:parmDic cache:NO responseCache:^(id responseCache) {
                
            } success:^(id responseObject) {
                if ([responseObject[@"code"] isEqualToString:@"0"]) {
                    [BaseTools showErrorMessage:responseObject[@"msg"]];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        [self.navigationController popViewControllerAnimated:YES];
                    });
                    
                }else{
                    [BaseTools showErrorMessage:responseObject[@"msg"]];
                }
                
            } failure:^(NSError *error) {
                
            }];
        }
    }
    
//    }
}

- (WXNProvincialPickerview *)regionPickerView {
    if (!_regionPickerView) {
        _regionPickerView = [[WXNProvincialPickerview alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
        __weak typeof(self) wself = self;
        _regionPickerView.completion = ^(NSString *provinceName,NSString *cityName,NSString *countyName,NSString *provinceId,NSString *cityId,NSString *countyId) {
            __strong typeof(wself) self = wself;
            self.lb_adress.text = [NSString stringWithFormat:@"%@ %@ %@",provinceName,cityName,countyName];
            self.lb_adress.textColor = [UIColor darkGrayColor];
            self.pid = provinceId;
            self.ciid = cityId;
            self.coid = countyId;
            self.PCAaddress = [NSString stringWithFormat:@"%@ %@ %@",provinceName,cityName,countyName];
            
            
        };
        [self.navigationController.view addSubview:_regionPickerView];
    }
    return _regionPickerView;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.view endEditing:YES];
    return YES;
}

- (BOOL)textViewShouldReturn:(UITextView *)textView {
    [self.view endEditing:YES];
    return YES;
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
