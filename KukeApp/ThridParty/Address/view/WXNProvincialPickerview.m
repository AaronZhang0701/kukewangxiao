//
//  HXProvincialCitiesCountiesPickerview.m
//  中安生态商城
//
//  Created by NewYear on 2017/7/18.
//  Copyright © 2017年 王鑫年. All rights reserved.
//

#import "WXNProvincialPickerview.h"
#import "WXNAddressManager.h"

#define SHAddressPickerViewHeight 200

@interface WXNProvincialPickerview () <UIPickerViewDataSource,UIPickerViewDelegate>

@property (nonatomic,strong) UIView *backView;
@property (nonatomic,strong) UIView *headView;
@property (strong, nonatomic) UIPickerView *pickView;
@property (strong,nonatomic) NSArray *firstAry;//一级数据源
@property (strong,nonatomic) NSArray *secondAry;//二级数据源
@property (strong,nonatomic) NSArray *thirdAry;//三级数据源
@property (nonatomic,assign) NSInteger firstCurrentIndex;//第一行当前位置
@property (nonatomic,assign) NSInteger secondCurrentIndex;//第二行当前位置
@property (nonatomic,assign) NSInteger thirdCurrentIndex;//第三行当前位置

@end

@implementation WXNProvincialPickerview

- (instancetype)initWithFrame:(CGRect)frame {
    self =  [super initWithFrame:frame];
    if (self) {
        [self internalConfig];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self internalConfig];
    }
    return self;
}

- (void)internalConfig {
    _backView = [[UIView alloc] initWithFrame:self.frame];
    _backView.backgroundColor = [UIColor blackColor];
    _backView.alpha = 0.6;
    [self addSubview:_backView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hide)];
    [_backView addGestureRecognizer:tap];
    
    self.backgroundColor = [UIColor clearColor];
    [self addSubview:self.pickView];
    
    _headView = [[UIView alloc] initWithFrame:CGRectMake(0, self.pickView.frame.origin.y - 43.5, self.frame.size.width, 43.5)];
    _headView.backgroundColor = [UIColor whiteColor];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(10, 0, 43.5, 43.5);
    button.backgroundColor = [UIColor clearColor];
    button.titleLabel.font = [UIFont systemFontOfSize:16];
    [button setTitleColor:[UIColor colorWithRed:0/255.0 green:122/255.0 blue:255/255.0 alpha:1.0] forState:UIControlStateNormal];
    [button setTitle:@"取消" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(cancleButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [_headView addSubview:button];
    
    button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(self.frame.size.width - 42, 0, 43.5, 43.5);
    button.backgroundColor = [UIColor clearColor];
    button.titleLabel.font = [UIFont systemFontOfSize:16];
    [button setTitleColor:[UIColor colorWithRed:0/255.0 green:122/255.0 blue:255/255.0 alpha:1.0] forState:UIControlStateNormal];
    [button setTitle:@"确定" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(completionButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [_headView addSubview:button];
    
    [self addSubview:_headView];
}

- (void)showPickerWithProvinceName:(NSString *)provinceName cityName:(NSString *)cityName countyName:(NSString *)countyName {
    
    _firstAry = kAddressManager.provinceDicAry;
    
    if (provinceName.length > 0) {
        [_firstAry enumerateObjectsUsingBlock:^(NSDictionary *provinceDic, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([provinceDic[@"area_name"] isEqualToString:provinceName]) {
                _firstCurrentIndex = idx+1;
                _secondAry = provinceDic[@"child"];
            }
        }];
    } else {
        _firstCurrentIndex = 0;
        _secondCurrentIndex = 0;
        _thirdCurrentIndex = 0;
    }                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          
    
    
    if (cityName.length > 0) {
        [_secondAry enumerateObjectsUsingBlock:^(NSDictionary *cityDic, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([cityDic[@"area_name"] isEqualToString:cityName]) {
                _secondCurrentIndex = idx+1;
                if ([cityDic[@"child"] isKindOfClass:[NSArray class]]) {
                    _thirdAry = cityDic[@"child"];
                }
            }
        }];
    } else {
        _secondCurrentIndex = 0;
        _thirdCurrentIndex = 0;
        
    }
    
    if (countyName.length > 0) {
        [_thirdAry enumerateObjectsUsingBlock:^(NSDictionary *county, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([county[@"area_name"] isEqualToString:countyName]) {
                _thirdCurrentIndex = idx+1;
                if ([county[@"child"] isKindOfClass:[NSArray class]]) {
                    _thirdAry = county[@"child"];
                }
            }
        }];
    } else {
        _thirdCurrentIndex = 0;
    }
    
    

    [self.pickView reloadAllComponents];
    [self.pickView selectRow:_firstCurrentIndex inComponent:0 animated:NO];
    if (_secondAry.count > 0) {
        [self.pickView selectRow:_secondCurrentIndex inComponent:1 animated:NO];
    }
    
    if (_thirdAry.count > 0) {
        [self.pickView selectRow:_thirdCurrentIndex inComponent:2 animated:NO];
    }

    [self show];
}

- (void)show {
    self.hidden = NO;
    
    NSLog(@"%.2f", [UIScreen mainScreen].bounds.size.height);
    _backView.alpha = 0.6;
    [UIView animateWithDuration:0.5 animations:^{
        self.pickView.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height - SHAddressPickerViewHeight, self.frame.size.width, SHAddressPickerViewHeight);
        _headView.frame = CGRectMake(0, self.pickView.frame.origin.y - 43.5, self.frame.size.width, 43.5);
    }];
}

- (void)hide {
    _backView.alpha = 0;
    [UIView animateWithDuration:0.5 animations:^{
        self.pickView.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height+44, self.frame.size.width, SHAddressPickerViewHeight);
        _headView.frame = CGRectMake(0, self.pickView.frame.origin.y, self.frame.size.width, 43.5);
    } completion:^(BOOL finished) {
        self.hidden = YES;
    }];
}

#pragma mark - UIPickerViewDataSource,UIPickerViewDelegate

//选项默认值
- (void)selectRow:(NSInteger)row inComponent:(NSInteger)component animated:(BOOL)animated {
    return;
}

//设置列数
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)thePickerView {
//    if (_thirdAry.count > 0) {
        return 3;
//    }
//    
//    if (_secondAry.count > 0) {
//        _thirdCurrentIndex = 0;
//        return 2;
//    }
//    
//    _secondCurrentIndex = 0;
//    return 1;
}

//返回数组总数
- (NSInteger)pickerView:(UIPickerView *)thePickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 0) {
        return _firstAry.count + 1;
    } else if (component == 1) {
        return _secondAry.count + 1;
    } else {
        return _thirdAry.count + 1;
    }
}

- (NSString *)pickerView:(UIPickerView *)thePickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (component == 0) {
        if (row > 0) {
            if (row - 1 < _firstAry.count) {
                NSDictionary *data = _firstAry[row - 1];
                //获取省
                NSString *str = data[@"area_name"];
                return str;
            }
        }
    } else if (component == 1) {
        if (row > 0) {
            if (row - 1 < _secondAry.count) {
                NSDictionary *data = _secondAry[row - 1];
                //获取市
                NSString *str = data[@"area_name"];
                return str;
            }
        }
    } else {
        if (row > 0) {
            if (row - 1 < _thirdAry.count) {
                NSDictionary *data = _thirdAry[row - 1];
                //获取区域
                NSString *str = data[@"area_name"];
                return str;
            }
        }
    }
    return @"请选择";
}

//触发事件
- (void)pickerView:(UIPickerView *)thePickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (component == 0) {
        _firstCurrentIndex = row;
        
        if (row > 0) {
            NSDictionary *dic = _firstAry[row - 1];
            _secondAry = dic[@"child"];
            _secondCurrentIndex = 0;
            
            _thirdAry = nil;
            _thirdCurrentIndex = 0;
            
        } else {
            _secondAry = nil;
            _secondCurrentIndex = 0;
            _thirdAry = nil;
            _thirdCurrentIndex = 0;
        }
        
        [self.pickView reloadAllComponents];
        if (_secondAry.count > 0) {
            [self.pickView selectRow:_secondCurrentIndex inComponent:1 animated:NO];
        }
    } else if (component == 1) {
        _secondCurrentIndex = row;
        
        if (row > 0) {
            NSDictionary *dic = _secondAry[row - 1];
            _thirdAry = dic[@"child"];
            _thirdCurrentIndex = 0;
            
        } else {
            _thirdAry = nil;
            _thirdCurrentIndex = 0;
        }
        
        [self.pickView reloadAllComponents];
        if (_thirdAry.count > 0) {
            [self.pickView selectRow:_thirdCurrentIndex inComponent:2 animated:NO];
        }
    } else {
        _thirdCurrentIndex = row;
    }
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel* pickerLabel = (UILabel*)view;
    if (!pickerLabel){
        pickerLabel = [[UILabel alloc] init];
        pickerLabel.adjustsFontSizeToFitWidth = YES;
        [pickerLabel setTextAlignment:NSTextAlignmentCenter];
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
        [pickerLabel setFont:[UIFont systemFontOfSize:16]];
    }
    // Fill the label text here
    pickerLabel.text = [self pickerView:pickerView titleForRow:row forComponent:component];
    return pickerLabel;
}

- (void)completionButtonAction:(UIButton *)sender {
    
    NSString *provinceName = @"";
    NSString *cityName = @"";
    NSString *countyName = @"";
    
    NSString *provinceId = @"";
    NSString *cityId = @"";
    NSString *countyId = @"";
    
    if (_firstAry.count > 0) {
        if (_firstCurrentIndex > 0) {
            if (_firstCurrentIndex - 1 < _firstAry.count) {
                NSDictionary *data = _firstAry[_firstCurrentIndex - 1];
                //获取省
                provinceName = data[@"area_name"];
                provinceId = data[@"id"];
                
            }
        }
    }
    
    if (_secondAry.count > 0) {
        if (_secondCurrentIndex > 0) {
            if (_secondCurrentIndex - 1 < _secondAry.count) {
                NSDictionary *data = _secondAry[_secondCurrentIndex - 1];
                //获取市
                cityName = data[@"area_name"];
                cityId = data[@"id"];
            }
        }
    }
    
    if (_thirdAry.count > 0) {
        if (_thirdCurrentIndex > 0) {
            if (_thirdCurrentIndex - 1 < _thirdAry.count) {
                NSDictionary *data = _thirdAry[_thirdCurrentIndex - 1];
                //获取区
                countyName = data[@"area_name"];
                countyId = data[@"id"];
            }
        }
    }

    if (_completion) {
        _completion(provinceName,cityName,countyName,provinceId,cityId,countyId);
    }
    [self hide];
}

- (void)cancleButtonAction:(UIButton *)sender {
    [self hide];
}

#pragma mark - 懒加载

- (UIPickerView*)pickView {
    if (!_pickView) {
        _pickView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height, self.frame.size.width, SHAddressPickerViewHeight)];
        _pickView.delegate = self;
        _pickView.dataSource = self;
        _pickView.backgroundColor = [UIColor whiteColor];
        [_pickView selectRow:0 inComponent:0 animated:NO];
    }
    return _pickView;
}

@end
