//
//  FeedbackViewController.m
//  KukeApp
//
//  Created by iOSDeveloper on 2018/10/29.
//  Copyright © 2018年 zhangming. All rights reserved.
//

#import "FeedbackViewController.h"
#import "PlaceholderTextView.h"
#import "ACMediaFrame.h"
#import "UIView+ACMediaExt.h"
#import <sys/utsname.h>//要导入头文件
@interface FeedbackViewController ()<UITextViewDelegate>{
    NSString *feedback_type_str;
}
@property (nonatomic, strong) PlaceholderTextView * textView;
@property (nonatomic, strong) NSMutableArray *ary;
@property (nonatomic, strong) NSMutableArray *urlAry;
@end

@implementation FeedbackViewController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO];
    
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"意见反馈";
    feedback_type_str = @"-1";
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:@"* 问题类型" attributes:@{NSFontAttributeName: [UIFont fontWithName:@"PingFang-SC-Regular" size: 14],NSForegroundColorAttributeName: [UIColor colorWithRed:230/255.0 green:33/255.0 blue:41/255.0 alpha:1.0]}];
    
    [string addAttributes:@{NSFontAttributeName: [UIFont fontWithName:@"PingFang-SC-Medium" size: 14], NSForegroundColorAttributeName: [UIColor colorWithRed:73/255.0 green:73/255.0 blue:73/255.0 alpha:1.0]} range:NSMakeRange(1, 1)];
    
    [string addAttributes:@{NSForegroundColorAttributeName: [UIColor colorWithRed:73/255.0 green:73/255.0 blue:73/255.0 alpha:1.0]} range:NSMakeRange(2, 4)];

    self.lab.attributedText = string;
    
    
    NSMutableAttributedString *string1 = [[NSMutableAttributedString alloc] initWithString:@"* 问题描述" attributes:@{NSFontAttributeName: [UIFont fontWithName:@"PingFang-SC-Regular" size: 14],NSForegroundColorAttributeName: [UIColor colorWithRed:230/255.0 green:33/255.0 blue:41/255.0 alpha:1.0]}];
    
    [string1 addAttributes:@{NSFontAttributeName: [UIFont fontWithName:@"MicrosoftYaHei" size: 14]} range:NSMakeRange(1, 1)];
    
    [string1 addAttributes:@{NSForegroundColorAttributeName: [UIColor colorWithRed:73/255.0 green:73/255.0 blue:73/255.0 alpha:1.0]} range:NSMakeRange(2, 4)];
    
    self.lab1.attributedText = string1;
    
    
    [self.view2 addSubview:self.textView];
    ACSelectMediaView *mediaView = [[ACSelectMediaView alloc] initWithFrame:CGRectMake(0, maxY(self.textView), [[UIScreen mainScreen] bounds].size.width-32, 1)];
    mediaView.backgroundColor = CBackgroundColor;
    mediaView.type = ACMediaTypePhotoAndCamera;
    mediaView.maxImageSelected = 3;
    mediaView.naviBarBgColor = [UIColor redColor];
    mediaView.rowImageCount = 3;
    mediaView.lineSpacing = 20;
    mediaView.interitemSpacing = 20;
    mediaView.sectionInset = UIEdgeInsetsMake(20, 20, 20, 20);
    [mediaView observeViewHeight:^(CGFloat mediaHeight) {
        
    }];
    [mediaView observeSelectedMediaArray:^(NSArray<ACMediaModel *> *list) {
        self.ary = [NSMutableArray array];
        for (ACMediaModel *model in list) {
            [self.ary addObject:model.image];
        }
        
    }];
    //        observeViewHeight 存在时可以不写
    //        [mediaView reload];
    [self.view2 addSubview:mediaView];
    
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    tap1.cancelsTouchesInView = NO;
    [mediaView addGestureRecognizer:tap1];
    
    // Do any additional setup after loading the view from its nib.
}
-(PlaceholderTextView *)textView{
    
    if (!_textView) {
        _textView = [[PlaceholderTextView alloc]initWithFrame:CGRectMake(0, 0, screenWidth() - 32, 150)];
        _textView.backgroundColor = CBackgroundColor;
        _textView.delegate = self;
        _textView.font = [UIFont systemFontOfSize:14.f];
        _textView.textColor = [UIColor blackColor];
        _textView.textAlignment = NSTextAlignmentLeft;
        _textView.editable = YES;
        _textView.placeholderColor =[UIColor lightGrayColor];
        _textView.placeholder = @"请选择问题类型，以便我们更快的处理您的反馈";
    }
    
    return _textView;
}
- (IBAction)questionAction1:(UIButton *)sender {
    
    sender.selected = !sender.selected;
    if (sender.selected) {
        self.questionBtn4.selected = NO;
        self.questionBtn3.selected = NO;
        self.questionBtn2.selected = NO;
        self.questionBtn1.selected = YES;
        feedback_type_str = @"1";
        _textView.placeholder = @"请输入您的具体建议";
    }else{
        self.questionBtn1.selected = NO;
        feedback_type_str = @"-1";
        _textView.placeholder = @"请选择问题类型，以便我们更快的处理您的反馈";
    }
    
   
}
- (IBAction)questionAction2:(UIButton *)sender {
    
    sender.selected = !sender.selected;
    if (sender.selected) {
        self.questionBtn4.selected = NO;
        self.questionBtn3.selected = NO;
        self.questionBtn2.selected = YES;
        self.questionBtn1.selected = NO;
        feedback_type_str = @"2";
        _textView.placeholder = @"请说明服务人员的名称和存在的问题";
    }else{
        self.questionBtn2.selected = NO;
        feedback_type_str = @"-1";
        _textView.placeholder = @"请选择问题类型，以便我们更快的处理您的反馈";
    }
    
    
}
- (IBAction)questionAction3:(UIButton *)sender {
    
    sender.selected = !sender.selected;
    if (sender.selected) {
        self.questionBtn4.selected = NO;
        self.questionBtn3.selected = YES;
        self.questionBtn2.selected = NO;
        self.questionBtn1.selected = NO;
        feedback_type_str = @"3";
        _textView.placeholder = @"请说明课程的具体名称和存在的问题";
    }else{
        self.questionBtn3.selected = NO;
        feedback_type_str = @"-1";
        _textView.placeholder = @"请选择问题类型，以便我们更快的处理您的反馈";
    }
    
    
}
- (IBAction)questionAction4:(UIButton *)sender {
    
    sender.selected = !sender.selected;
    if (sender.selected) {
        self.questionBtn4.selected = YES;
        self.questionBtn3.selected = NO;
        self.questionBtn2.selected = NO;
        self.questionBtn1.selected = NO;
        feedback_type_str = @"0";
        _textView.placeholder = @"请输入您的具体问题";
    }else{
        self.questionBtn4.selected = NO;
        feedback_type_str = @"-1";
        _textView.placeholder = @"请选择问题类型，以便我们更快的处理您的反馈";
    }
    
    
}
- (IBAction)commitAction:(id)sender {
    if ([feedback_type_str isEqualToString:@"-1"]) {
        [BaseTools showErrorMessage:@"请选择问题类型"];
    }else{
        if (_textView.text.length>0) {
            if (self.ary.count>0) {
                [self uploadImage];
            }else{
                [self postData];
            }
            
        }else{
            [BaseTools showErrorMessage:@"请输入问题描述"];
        }
    }
    
}
- (void)uploadImage{
    self.urlAry = [NSMutableArray array];
    [BaseTools showProgressMessage:@"上传中..."];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //接收类型不一致请替换一致text/html或别的
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",
                                                         @"text/html",
                                                         @"image/jpeg",
                                                         @"image/png",
                                                         @"application/octet-stream",
                                                         @"text/json",
                                                         nil];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager.requestSerializer setValue:[UserDefaultsUtils valueWithKey:@"access_token"] forHTTPHeaderField:@"accessToken"];
    [manager.requestSerializer setValue:[NSString stringWithFormat:@"%@",[[[NSBundle mainBundle]infoDictionary]objectForKey:@"CFBundleShortVersionString"]] forHTTPHeaderField:@"version"];
    [manager.requestSerializer setValue:@"4" forHTTPHeaderField:@"clientType"];
    [manager.requestSerializer setValue:[OpenUDID value] forHTTPHeaderField:@"UUID"];
    NSURLSessionDataTask *task = [manager POST:[NSString stringWithFormat:@"%@/app/upload",SERVER_HOST] parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        [self.ary enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSData *imageData = UIImageJPEGRepresentation(obj, 0.5);
            long index = idx;
            NSTimeInterval interval = [[NSDate date] timeIntervalSince1970];
            long long totalMilliseconds = interval * 1000 ;
            NSString *fileName = [NSString stringWithFormat:@"%lld.png", totalMilliseconds];
            NSString *name1 =  @"image[]";
            [formData appendPartWithFileData:imageData name:name1 fileName:fileName mimeType:@"image/jpeg"];
        }];
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        //打印下上传进度
        NSLog(@"%@",uploadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        // 查看 data 是否是 JSON 数据.
        // JSON 解析.
        id obj = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:NULL];
        
        if ([obj[@"code"] isEqualToString:@"0"]) {
            [self.urlAry addObjectsFromArray:obj[@"data"]];
            [self postData];
        }else{
            [BaseTools showErrorMessage:obj[@"msg"]];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //上传失败
        NSLog(@"上传失败");
    }];

}
- (void)postData{
    NSMutableDictionary *parmDic = [NSMutableDictionary dictionary];
    NSString *string = [self.urlAry componentsJoinedByString:@"|"];
    [parmDic setObject:_textView.text forKey:@"content"];
    if (self.urlAry.count == 0) {
        [parmDic setObject:@"" forKey:@"imgs"];
    }else{
        [parmDic setObject:string forKey:@"imgs"];
    }
    
    [parmDic setObject:@"1" forKey:@"client_type"];
 
    [parmDic setObject:feedback_type_str forKey:@"feedback_type"];

    [parmDic setObject:@"" forKey:@"remark"];
    [parmDic setObject:[[[NSBundle mainBundle]infoDictionary]objectForKey:@"CFBundleShortVersionString"] forKey:@"ver_name"];
    [parmDic setObject:[NSString stringWithFormat:@"设备名称:%@手机系统版本:%@手机型号:%@",[[UIDevice currentDevice] systemName],[[UIDevice currentDevice] systemVersion], [self getCurrentDeviceModel]] forKey:@"client_info"];
    [ZMNetworkHelper POST:@"/app/feedback_add" parameters:parmDic cache:YES responseCache:^(id responseCache) {
        
    } success:^(id responseObject) {
        [BaseTools dismissHUD];
        if (responseObject == nil) {
            
        }else{
            if ([responseObject[@"code"] isEqualToString:@"0"]) {
                [BaseTools showErrorMessage:responseObject[@"msg"]];
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [self.navigationController popViewControllerAnimated:YES];
                });
            }else if ([responseObject[@"code"] isEqualToString:@"-10000"]){
                [BaseTools showErrorMessage:@"请登录后再操作"];
                dispatch_async(dispatch_get_main_queue(), ^{

                     [BaseTools alertLoginWithVC:self];
                });
               
            }else{
                [BaseTools showErrorMessage:responseObject[@"msg"]];
            }
        }
        
    } failure:^(NSError *error) {
        
    }];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    if (![self.textView isExclusiveTouch]) {
        [self.textView resignFirstResponder];
    }
    return YES;
}
-(void)viewTapped:(UITapGestureRecognizer*)tap1
{
    
    [self.view endEditing:YES];
    
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self.view endEditing:YES];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [BaseTools dismissHUD];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSString *)getCurrentDeviceModel{
    struct utsname systemInfo;
    uname(&systemInfo);
    
    NSString *deviceModel = [NSString stringWithCString:systemInfo.machine encoding:NSASCIIStringEncoding];
    
    
    if ([deviceModel isEqualToString:@"iPhone3,1"])    return @"iPhone 4";
    if ([deviceModel isEqualToString:@"iPhone3,2"])    return @"iPhone 4";
    if ([deviceModel isEqualToString:@"iPhone3,3"])    return @"iPhone 4";
    if ([deviceModel isEqualToString:@"iPhone4,1"])    return @"iPhone 4S";
    if ([deviceModel isEqualToString:@"iPhone5,1"])    return @"iPhone 5";
    if ([deviceModel isEqualToString:@"iPhone5,2"])    return @"iPhone 5 (GSM+CDMA)";
    if ([deviceModel isEqualToString:@"iPhone5,3"])    return @"iPhone 5c (GSM)";
    if ([deviceModel isEqualToString:@"iPhone5,4"])    return @"iPhone 5c (GSM+CDMA)";
    if ([deviceModel isEqualToString:@"iPhone6,1"])    return @"iPhone 5s (GSM)";
    if ([deviceModel isEqualToString:@"iPhone6,2"])    return @"iPhone 5s (GSM+CDMA)";
    if ([deviceModel isEqualToString:@"iPhone7,1"])    return @"iPhone 6 Plus";
    if ([deviceModel isEqualToString:@"iPhone7,2"])    return @"iPhone 6";
    if ([deviceModel isEqualToString:@"iPhone8,1"])    return @"iPhone 6s";
    if ([deviceModel isEqualToString:@"iPhone8,2"])    return @"iPhone 6s Plus";
    if ([deviceModel isEqualToString:@"iPhone8,4"])    return @"iPhone SE";
    // 日行两款手机型号均为日本独占，可能使用索尼FeliCa支付方案而不是苹果支付
    if ([deviceModel isEqualToString:@"iPhone9,1"])    return @"iPhone 7";
    if ([deviceModel isEqualToString:@"iPhone9,2"])    return @"iPhone 7 Plus";
    if ([deviceModel isEqualToString:@"iPhone9,3"])    return @"iPhone 7";
    if ([deviceModel isEqualToString:@"iPhone9,4"])    return @"iPhone 7 Plus";
    if ([deviceModel isEqualToString:@"iPhone10,1"])   return @"iPhone_8";
    if ([deviceModel isEqualToString:@"iPhone10,4"])   return @"iPhone_8";
    if ([deviceModel isEqualToString:@"iPhone10,2"])   return @"iPhone_8_Plus";
    if ([deviceModel isEqualToString:@"iPhone10,5"])   return @"iPhone_8_Plus";
    if ([deviceModel isEqualToString:@"iPhone10,3"])   return @"iPhone X";
    if ([deviceModel isEqualToString:@"iPhone10,6"])   return @"iPhone X";
    if ([deviceModel isEqualToString:@"iPhone11,8"])   return @"iPhone XR";
    if ([deviceModel isEqualToString:@"iPhone11,2"])   return @"iPhone XS";
    if ([deviceModel isEqualToString:@"iPhone11,6"])   return @"iPhone XS Max";
    if ([deviceModel isEqualToString:@"iPhone11,4"])   return @"iPhone XS Max";
    if ([deviceModel isEqualToString:@"iPod1,1"])      return @"iPod Touch 1G";
    if ([deviceModel isEqualToString:@"iPod2,1"])      return @"iPod Touch 2G";
    if ([deviceModel isEqualToString:@"iPod3,1"])      return @"iPod Touch 3G";
    if ([deviceModel isEqualToString:@"iPod4,1"])      return @"iPod Touch 4G";
    if ([deviceModel isEqualToString:@"iPod5,1"])      return @"iPod Touch (5 Gen)";
    if ([deviceModel isEqualToString:@"iPad1,1"])      return @"iPad";
    if ([deviceModel isEqualToString:@"iPad1,2"])      return @"iPad 3G";
    if ([deviceModel isEqualToString:@"iPad2,1"])      return @"iPad 2 (WiFi)";
    if ([deviceModel isEqualToString:@"iPad2,2"])      return @"iPad 2";
    if ([deviceModel isEqualToString:@"iPad2,3"])      return @"iPad 2 (CDMA)";
    if ([deviceModel isEqualToString:@"iPad2,4"])      return @"iPad 2";
    if ([deviceModel isEqualToString:@"iPad2,5"])      return @"iPad Mini (WiFi)";
    if ([deviceModel isEqualToString:@"iPad2,6"])      return @"iPad Mini";
    if ([deviceModel isEqualToString:@"iPad2,7"])      return @"iPad Mini (GSM+CDMA)";
    if ([deviceModel isEqualToString:@"iPad3,1"])      return @"iPad 3 (WiFi)";
    if ([deviceModel isEqualToString:@"iPad3,2"])      return @"iPad 3 (GSM+CDMA)";
    if ([deviceModel isEqualToString:@"iPad3,3"])      return @"iPad 3";
    if ([deviceModel isEqualToString:@"iPad3,4"])      return @"iPad 4 (WiFi)";
    if ([deviceModel isEqualToString:@"iPad3,5"])      return @"iPad 4";
    if ([deviceModel isEqualToString:@"iPad3,6"])      return @"iPad 4 (GSM+CDMA)";
    if ([deviceModel isEqualToString:@"iPad4,1"])      return @"iPad Air (WiFi)";
    if ([deviceModel isEqualToString:@"iPad4,2"])      return @"iPad Air (Cellular)";
    if ([deviceModel isEqualToString:@"iPad4,4"])      return @"iPad Mini 2 (WiFi)";
    if ([deviceModel isEqualToString:@"iPad4,5"])      return @"iPad Mini 2 (Cellular)";
    if ([deviceModel isEqualToString:@"iPad4,6"])      return @"iPad Mini 2";
    if ([deviceModel isEqualToString:@"iPad4,7"])      return @"iPad Mini 3";
    if ([deviceModel isEqualToString:@"iPad4,8"])      return @"iPad Mini 3";
    if ([deviceModel isEqualToString:@"iPad4,9"])      return @"iPad Mini 3";
    if ([deviceModel isEqualToString:@"iPad5,1"])      return @"iPad Mini 4 (WiFi)";
    if ([deviceModel isEqualToString:@"iPad5,2"])      return @"iPad Mini 4 (LTE)";
    if ([deviceModel isEqualToString:@"iPad5,3"])      return @"iPad Air 2";
    if ([deviceModel isEqualToString:@"iPad5,4"])      return @"iPad Air 2";
    if ([deviceModel isEqualToString:@"iPad6,3"])      return @"iPad Pro 9.7";
    if ([deviceModel isEqualToString:@"iPad6,4"])      return @"iPad Pro 9.7";
    if ([deviceModel isEqualToString:@"iPad6,7"])      return @"iPad Pro 12.9";
    if ([deviceModel isEqualToString:@"iPad6,8"])      return @"iPad Pro 12.9";
    
    if ([deviceModel isEqualToString:@"AppleTV2,1"])      return @"Apple TV 2";
    if ([deviceModel isEqualToString:@"AppleTV3,1"])      return @"Apple TV 3";
    if ([deviceModel isEqualToString:@"AppleTV3,2"])      return @"Apple TV 3";
    if ([deviceModel isEqualToString:@"AppleTV5,3"])      return @"Apple TV 4";
    
    if ([deviceModel isEqualToString:@"i386"])         return @"Simulator";
    if ([deviceModel isEqualToString:@"x86_64"])       return @"Simulator";
    return deviceModel;
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
