//
//  NY_UpdateAddress.m
//  中安生态商城
//
//  Created by NewYear on 2017/7/18.
//  Copyright © 2017年 王鑫年. All rights reserved.
//

#import "NY_UpdateAddress.h"

#import "WXNProvincialPickerview.h"
#import "WXNAddressManager.h"

@interface NY_UpdateAddress ()<UITextFieldDelegate, UITextViewDelegate>

@property (nonatomic, strong) WXNProvincialPickerview *regionPickerView;
@property (weak, nonatomic) IBOutlet UITextField *tx_name;
@property (weak, nonatomic) IBOutlet UITextField *tx_phone;
@property (weak, nonatomic) IBOutlet UILabel *lb_adress;
@property (weak, nonatomic) IBOutlet UITextView *tx_detailAddress;
@property (weak, nonatomic) IBOutlet UIView *backView;

@property (assign, nonatomic) NSString *pid;
@property (assign, nonatomic) NSString *ciid;
@property (assign, nonatomic) NSString *coid;

@property (copy, nonatomic) NSArray *addressArr;

@property (nonatomic, strong) NSString *isTure;
@end

@implementation NY_UpdateAddress

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self addRightNavBarWithText:@"保存"];
    
    _addressArr = kAddressManager.provinceDicAry;
    _tx_name.delegate = self;
    //添加事件
    [_tx_name addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    _tx_name.text = _model.receiver;
    _tx_phone.text = _model.receive_mobile;
    self.tx_detailAddress.delegate = self;
    _tx_detailAddress.text = _model.address;
    _lb_adress.text = [NSString stringWithFormat:@"%@ %@ %@",_model.province_name,_model.city_name,_model.county_name];
    self.lb_adress.textColor = [UIColor darkGrayColor];
    self.pid = self.model.province_id;
    self.ciid = self.model.city_id;
    self.coid = self.model.county_id;
//    _tx_detailAddress.placeholder = @"请填写详细地址，不少于5个字...";
    self.stringNumber.text = [NSString stringWithFormat:@"%ld/50",_tx_detailAddress.text.length];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewEndEditing)];
    [self.backView addGestureRecognizer:tap];
    _isTure = @"";
//    [self createRac];
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
//实现方法
- (void)textFieldDidChange:(UITextField *)textField
{
    if (textField.text.length > 20) {
        //提示语
         [BaseTools showErrorMessage:@"输入限制10个字符以内"];
        //截取
        textField.text = [textField.text substringToIndex:20];
    }

}
- (void)textViewDidChange:(UITextView *)textView{
    
    if (textView.markedTextRange == nil && textView.text.length > 50) {
        //提示语
        [BaseTools showErrorMessage:@"输入限制50个字符以内"];
        //截取
        textView.text = [textView.text substringToIndex:50];
        
    }
    self.stringNumber.text = [NSString stringWithFormat:@"%ld/50",textView.text.length];
}
- (void)addRightNavBarWithText:(NSString*)title {
    
    if (self.navigationItem.rightBarButtonItem)
    {
        self.navigationItem.rightBarButtonItem= nil;
    }
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 44)];
    [button setTitle:title forState:UIControlStateNormal];
    [button  setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    button.titleLabel.textAlignment = NSTextAlignmentRight;
    [button addTarget:self action:@selector(naviRightAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = rightBtn;
    
}

- (void)viewEndEditing {
    [self.view endEditing:YES];
}

//- (void)createRac {
//
//    // 创建验证用户名的信道
//    RACSignal *Signal1 = [self.tx_name.rac_textSignal
//                          map:^id(NSString *text) {
//                              return @([self isValidName:text]);
//                          }];
//
//
//    // 创建用户名的信道
//    RACSignal *Signal2 = [self.tx_phone.rac_textSignal
//                          map:^id(NSString *text) {
//                              return @([self isValidTel:text]);
//                          }];
//
//    // 创建验证身份证的信号
//    RACSignal *Signal3 = [self.tx_detailAddress.rac_textSignal
//                          map:^id(NSString *text) {
//                              return @([self isValidDetailAddress:text]);
//                          }];
//
//    // 创建登录按扭的信号，把用户名与密码合成一个信道
//    RACSignal *step2NextSignal = [RACSignal
//                                  combineLatest:@[
//                                                  Signal1,
//                                                  Signal2,
//                                                  Signal3
//                                                  ]
//                                  reduce:^id(NSNumber*usernameValid, NSNumber *passwordValid, NSNumber *detailValid) {
//                                      return @([usernameValid boolValue] && [passwordValid boolValue] && [detailValid boolValue]);
//                                  }];
//
//
//    // 订阅 loginActiveSignal, 使按扭是否可用
//    [step2NextSignal subscribeNext:^(NSNumber*loginActiveSignal) {
//
//        if ([loginActiveSignal boolValue]) {
//            _isTure = @"1";
//        }
//        else {
//            _isTure = @"";
//        }
//    }];
//
//
//}

- (BOOL )isValidName:(NSString *)nameStr {
    return nameStr.length > 1;
}

- (BOOL )isValidTel:(NSString *)tel {
    return tel.length > 10;
}

- (BOOL )isValidDetailAddress:(NSString *)address {
    return address.length > 4;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)naviRightAction {

    if (_pid == nil || ([_pid.class isSubclassOfClass:NSString.class] && [_pid isEqualToString:@""])) {
        [BaseTools showErrorMessage:@"请选择所在省"];
        NSLog(@"请选择所在省");
        
    } else if (_ciid == nil || ([_ciid.class isSubclassOfClass:NSString.class] && [_ciid isEqualToString:@""])) {
        [BaseTools showErrorMessage:@"请选择所在市"];
        NSLog(@"请选择所在市");
        
    } else if (_coid == nil || ([_coid.class isSubclassOfClass:NSString.class] && [_coid isEqualToString:@""])) {
        [BaseTools showErrorMessage:@"请选择所在区"];
        NSLog(@"请选择所在区");
        
    }else if (![BaseTools valiMobile:_tx_phone.text]) {
        [BaseTools showErrorMessage:@"请输入正确的手机号"];
        
    }else if (_tx_detailAddress.text.length == 0) {
        [BaseTools showErrorMessage:@"请输入您的详细地址"];
        
    }else if (_tx_name.text.length == 0) {
        [BaseTools showErrorMessage:@"请输入收件人姓名"];
        
    }
    else {
            
            NY_AddressModel *address = [[NY_AddressModel alloc] init];
            address.address = _tx_detailAddress.text;
            address.province = _pid != nil ? _pid : @"";
            address.city = _ciid != nil ? _ciid : @"";;
            address.district = _coid != nil ? _coid : @"";
            address.is_default = false;
            address.mobile = _tx_phone.text;
            address.name = _tx_name.text;
            address.tel = _tx_phone.text;
            
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
            [parmDic setObject:_model.ID  forKey:@"id"];
            [ZMNetworkHelper POST:@"/stucommon/edit_stu_address" parameters:parmDic cache:NO responseCache:^(id responseCache) {
                
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

- (IBAction)selectAddress:(UIButton *)sender {
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

- (IBAction)deleteAddress:(UIButton *)sender {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"确定要删除该地址吗"
                                                                             message:@""
                                                                      preferredStyle:UIAlertControllerStyleAlert ];
    
    //添加取消到UIAlertController中
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:cancelAction];
    
    //添加确定到UIAlertController中
    UIAlertAction *OKAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertController addAction:OKAction];
    [self presentViewController:alertController animated:YES completion:nil];
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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
