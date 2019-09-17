//  KukeApp
//
//  Created by iOSDeveloper on 2018/8/9.
//  Copyright © 2018年 zhangming. All rights reserved.
//


#import "XSIAPChooseCollectionViewCell.h"
#import "XSIAPViewController.h"
#import <StoreKit/StoreKit.h>
#import <CommonCrypto/CommonCrypto.h>
#import "XSIAPManage.h"
#import "PLVDownloadManagerViewController.h"
@interface XSIAPViewController () <UICollectionViewDelegate, UICollectionViewDataSource, IApRequestResultsDelegate,SKProductsRequestDelegate,QYConversationManagerDelegate, QYSessionViewDelegate,NoDataTipsDelegate>{
    NSInteger indexItem;
}

@property (nonatomic) NSMutableArray *productArray;

@property (nonatomic) IBOutlet UIImageView *headerImageView;

@property (nonatomic) IBOutlet UILabel *nickNameLabel;

@property (nonatomic) IBOutlet UILabel *userBalanceLabel;

@property (nonatomic) IBOutlet UICollectionView *chooseCollectionView;

@property (nonatomic) SKProductsRequest *request;

@property (nonatomic) NSMutableArray *products;

@property (nonatomic) NSString *orderSN;

@property (nonatomic) MBProgressHUD *hud;
@property (assign, nonatomic) NSIndexPath *selIndex;//单选，当前选中的行
@property (nonatomic,assign) BOOL isSel;
@property (nonatomic,assign) BOOL isLogins;
@property (nonatomic, strong) NoDataTipsView *loadNetView;
@end

@implementation XSIAPViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:self.navigationItem.backBarButtonItem.style target:nil action:nil];

    self.title = @"充值";

    indexItem = -1;
    CurrentUserInfo *info = nil;
    if ([UserInfoTool persons].count !=0 ) {
        self.isLogins = YES;
        info = [UserInfoTool persons][0];
        [_headerImageView sd_setImageWithURL:[NSURL URLWithString:info.photo] placeholderImage:[UIImage imageNamed:@"个人中心未登录头像"]];
        if (info.NiName.length <= 0) {
            _nickNameLabel.text = info.Tel;
        }else {
            _nickNameLabel.text = info.NiName;
            
        }
    }else{
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"友情提示"
                                                                                 message:@"在未登录或登录失效状态下充值，您的金币可能会在更换手机后丢失"
                                                                          preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定"
                                                               style:UIAlertActionStyleCancel
                                                             handler:nil];
        
        [alertController addAction:cancelAction];
        
        [self presentViewController:alertController animated:YES completion:nil];
        self.isLogins = NO;
        [_headerImageView sd_setImageWithURL:[NSURL URLWithString:info.photo] placeholderImage:[UIImage imageNamed:@"个人中心未登录头像"]];
//        _nickNameLabel.text = @"游客用户";
    }
    self.userBalanceLabel.text = self.money;

    
    UINib *cellNib = [UINib nibWithNibName:@"XSIAPChooseCollectionViewCell" bundle:[NSBundle mainBundle]];
    [self.chooseCollectionView registerNib:cellNib forCellWithReuseIdentifier:@"cell"];
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    [flowLayout setItemSize:CGSizeMake((SCREEN_WIDTH - 40 - 32) / 3, 70)];
    
    [flowLayout setSectionInset:UIEdgeInsetsMake(20, 20, 20, 20)];
    
    [self.chooseCollectionView setCollectionViewLayout:flowLayout animated:YES];
    self.chooseCollectionView.backgroundColor = [UIColor clearColor];
    
//    if (![CoreStatus isNetworkEnable]) {
//        [self.view addSubview:self.loadNetView];
//    }else{
        [self setProductData];
//    }
//    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
}
#pragma mark - 懒加载失败默认视图
- (NoDataTipsView *)loadNetView {
    if (!_loadNetView) {
        
        _loadNetView = [NoDataTipsView setTipsBackGroupWithframe:CGRectMake(0, 0, screenWidth(), self.view.height) tipsIamgeName:@"无网络" tipsStr:@"无法连接到网络,点击页面刷新"];
        _loadNetView.backgroundColor = CBackgroundColor;
        _loadNetView.noDataBtn.hidden = NO;
        _loadNetView.delegate = self;
    }
    return _loadNetView;
}
#pragma mark - <NoDataTipsDelegate> - 提示按钮点击
- (void)tipsNoDataBtnDid {
    if ([[UserDefaultsUtils valueWithKey:@"access_token"] length] !=0 ) {
        UIViewController *rootViewController = [[UIApplication sharedApplication] keyWindow].rootViewController;
        UIViewController *topViewController = [BaseTools topViewControllerWithRootViewController:rootViewController];
        PLVDownloadManagerViewController *vc = [[PLVDownloadManagerViewController alloc]init];
        [topViewController.navigationController pushViewController:vc animated:YES];
    }else{
        [BaseTools showErrorMessage:@"请登录后再操作"];
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [BaseTools alertLoginWithVC:self];
        });
    }
}
- (void)tipsRefreshBtnClicked{
    [self setProductData];
}
- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    [BaseTools dismissHUD];
//    [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];

}

- (void)setProductData {
    
    [BaseTools showProgressMessage:@"获取充值列表..."];
    [ZMNetworkHelper POST:@"/special/iphone_recharge_list" parameters:nil cache:NO responseCache:^(id responseCache) {
        
    } success:^(id responseObject) {
        [self.loadNetView removeFromSuperview];
        if ([responseObject[@"code"] isEqualToString:@"0"]) {
            NSArray *dataArray = responseObject[@"data"];
            
            self.productArray = [[NSMutableArray alloc]initWithArray:dataArray];
            self.products = [[NSMutableArray alloc]init];
            [self validateProductIdentifiers:dataArray];
            
        }else if ([responseObject[@"code"] isEqualToString:@"-10000"]){
            
           
            [BaseTools showErrorMessage:@"请登录后再操作"];
            dispatch_async(dispatch_get_main_queue(), ^{

                [BaseTools alertLoginWithVC:self];
            });
        }else{
            [BaseTools showErrorMessage:responseObject[@"msg"]];
        }
        
    } failure:^(NSError *error) {
        
    }];
}

// Custom method
- (void)validateProductIdentifiers:(NSArray *)productIdentifiers {
    
    SKProductsRequest *productsRequest = [[SKProductsRequest alloc]initWithProductIdentifiers:[NSSet setWithArray:productIdentifiers]];
    
    // Keep a strong reference to the request.
    self.request = productsRequest;
    productsRequest.delegate = self;
    [productsRequest start];
    
}

// SKProductsRequestDelegate protocol method
- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response {
    
    NSArray *productArray = response.products;
    
    for (NSString *invalidIdentifier in response.invalidProductIdentifiers) {
        // Handle any invalid product identifiers.
        NSLog(@"%@", invalidIdentifier);
        
    }
    
    [self.productArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        NSString *productID = obj;
        
        [productArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            SKProduct *product = obj;
            
            if ([productID isEqualToString:product.productIdentifier]) {
                
                [self.products addObject:product];
                
                *stop = YES;
                
            }
            
        }];
        
    }];
    
    [BaseTools dismissHUD];
    
    [self.chooseCollectionView reloadData];
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.products.count;
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    XSIAPChooseCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    cell.layer.cornerRadius = 5;
    cell.layer.borderWidth = 1;
    cell.layer.borderColor = [[UIColor whiteColor] CGColor];
 
    SKProduct *product = self.products[indexPath.item];
    

    NSString *price1 = [product.productIdentifier stringByReplacingOccurrencesOfString:@"com.kuke99.kukeStudent.ready" withString:@""];
    NSString *price = [price1 stringByReplacingOccurrencesOfString:@"_" withString:@""];
    NSString *formattedPrice = [NSString stringWithFormat:@"%@金币",price];
    
    cell.productNameLabel.text = formattedPrice;
    cell.priceLab.text  = price;
    if (_isSel && _selIndex == indexPath) {
        cell.layer.borderColor = [CNavBgColor CGColor];
        cell.priceLab.textColor = CNavBgColor;
    }else{
        cell.priceLab.textColor = [UIColor blackColor];
        cell.layer.borderColor = [[UIColor whiteColor] CGColor];
    }
    return cell;
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

    indexItem = indexPath.item;
    NSLog(@"选中了:%ld",indexPath.row);
    
    if (_isSel == NO) {
        _isSel = YES;
        _selIndex = indexPath;
    }else{
        
        if (_selIndex == indexPath) {
            _isSel = NO;
        }else{
            
            _selIndex = indexPath;
        }
    }
    
    
    [self.chooseCollectionView reloadData];

}
- (IBAction)payAction:(id)sender {
    if (indexItem == -1) {
        [BaseTools showErrorMessage:@"请选择充值金额后再操作"];
    }else{
        if (!self.isLogins) {
            [BaseTools showProgressMessage:@"正在创建订单..."];
            int64_t delayInSeconds = 5.0;      // 延迟的时间
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                [BaseTools dismissHUD];
                [BaseTools showProgressMessage:@"发起购买请求..."];
                
                int64_t delayInSeconds = 5.0;      // 延迟的时间
                dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
                dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                    [BaseTools dismissHUD];
                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"支付未完成"
                                                                                             message:@"若您已付款，请稍后再余额中查看，或联系客服\n(ErrorCode:0)"
                                                                                      preferredStyle:UIAlertControllerStyleAlert];
                    
                    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定"
                                                                           style:UIAlertActionStyleCancel
                                                                         handler:nil];
                    
                    [alertController addAction:cancelAction];
                    
                    [self presentViewController:alertController animated:YES completion:nil];
                    
                });
            });
            
        }else{
            [BaseTools showProgressMessage:@"正在创建订单..."];
            SKProduct *product = self.products[indexItem];
            NSString *productID = self.productArray[indexItem];
            NSString *price1 = [productID stringByReplacingOccurrencesOfString:@"com.kuke99.kukeStudent.ready" withString:@""];
            NSString *price = [price1 stringByReplacingOccurrencesOfString:@"_" withString:@""];
            
            NSMutableDictionary *parmDic = [NSMutableDictionary dictionary];
            [parmDic setObject:price  forKey:@"order_price"];
            [ZMNetworkHelper POST:@"/order/iphone_recharge" parameters:parmDic cache:NO responseCache:^(id responseCache) {
                
            } success:^(id responseObject) {
                if ([responseObject[@"code"] isEqualToString:@"0"]) {
                    self.orderSN = responseObject[@"data"][@"order_sn"];
                    [BaseTools dismissHUD];
                    [BaseTools showProgressMessage:@"发起购买请求..."];
                    [[IAPManager shared] requestProductWithId:product];
                    [IAPManager shared].sn_orderID = self.orderSN;
                    //                SKMutablePayment *payment = [SKMutablePayment paymentWithProduct:product];
                    ////                payment.applicationUsername = self.orderSN;
                    //                payment.quantity = 1;
                    //                [[SKPaymentQueue defaultQueue] addPayment:payment];
                    
                }else if ([responseObject[@"code"] isEqualToString:@"-10000"]){
                    [BaseTools showErrorMessage:@"请登录后再操作"];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        [BaseTools alertLoginWithVC:self];
                    });
                }else{
                    [BaseTools showErrorMessage:responseObject[@"msg"]];
                }
                
            } failure:^(NSError *error) {
                
            }];
            
        }
    }
    
    
    
    
    
}
#pragma mark IApRequestResultsDelegate
- (void)filedWithErrorCode:(NSInteger)errorCode andError:(NSString *)error {
    
    switch (errorCode) {
        case IAP_FILEDCOED_APPLECODE:
            [BaseTools dismissHUD];
            [BaseTools showProgressMessage:[NSString stringWithFormat:@"用户禁止应用内付费购买:%@",error]];
            NSLog(@"用户禁止应用内付费购买:%@",error);
            break;
            
        case IAP_FILEDCOED_NORIGHT:
            [BaseTools dismissHUD];
            [BaseTools showProgressMessage:@"用户禁止应用内付费购买"];
            break;
            
        case IAP_FILEDCOED_EMPTYGOODS:
            NSLog(@"商品为空");
            [BaseTools dismissHUD];
            [BaseTools showProgressMessage:@"商品为空"];
            break;
            
        case IAP_FILEDCOED_CANNOTGETINFORMATION:
            [BaseTools dismissHUD];
            [BaseTools showProgressMessage:@"无法获取产品信息，请重试"];
            NSLog(@"无法获取产品信息，请重试");
            break;
            
        case IAP_FILEDCOED_BUYFILED:
            NSLog(@"购买失败，请重试");
            [BaseTools dismissHUD];
            [BaseTools showProgressMessage:@"购买失败，请重试"];
            break;
            
        case IAP_FILEDCOED_USERCANCEL:
            [BaseTools dismissHUD];
            [BaseTools showProgressMessage:@"用户取消交易"];
            NSLog(@"用户取消交易");
            break;
            
        default:
            break;
    }
}
//- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray<SKPaymentTransaction *> *)transactions {
//
//
//    for (SKPaymentTransaction *transaction in transactions) {
//        switch (transaction.transactionState) {
//                // Call the appropriate custom method for the transaction state.
//            case SKPaymentTransactionStatePurchasing:
//                [self showTransactionAsInProgress:transaction deferred:NO];
//                break;
//            case SKPaymentTransactionStateDeferred:
//                [self showTransactionAsInProgress:transaction deferred:YES];
//                break;
//            case SKPaymentTransactionStateFailed:
//                [self failedTransaction:transaction];
//                break;
//            case SKPaymentTransactionStatePurchased:
//
//                [ZMNetworkHelper POST:@"/special/iphone_recharge_sn" parameters: @{@"order_sn":self.orderSN} cache:NO responseCache:^(id responseCache) {
//
//                } success:^(id responseObject) {
//
//                } failure:^(NSError *error) {
//
//                }];
//                [self completeTransaction:transaction];
//                break;
//            case SKPaymentTransactionStateRestored:
//                [self restoreTransaction:transaction];
//                break;
//            default:
//                // For debugging
//                NSLog(@"Unexpected transaction state %@", @(transaction.transactionState));
//                break;
//        }
//    }
//
//}
//
//- (void)paymentQueue:(SKPaymentQueue *)queue removedTransactions:(NSArray<SKPaymentTransaction *> *)transactions {
//
//    NSLog(@"Removed Transactions");
//
//}
//
//- (void)paymentQueueRestoreCompletedTransactionsFinished:(SKPaymentQueue *)queue {
//
//    NSLog(@"Payment Queue Restore Completed Transactions Finished");
//
//}
//
//- (void)showTransactionAsInProgress:(SKPaymentTransaction *)transaction deferred:(BOOL)deferred {
//    [BaseTools dismissHUD];
//    NSLog(@"Update your UI to reflect the in-progress status, and wait to be called again.");
//    [BaseTools showProgressMessage:@"发起支付请求..."];
//
//
//}
//
//- (void)failedTransaction:(SKPaymentTransaction *)transaction {
//
//    NSLog(@"Use the value of the error property to present a message to the user. For a list of error constants, see SKErrorDomain in Store Kit Constants Reference.");
//
//    NSError *error = transaction.error;
//    NSString *message;
//    switch (error.code) {
//        case SKErrorUnknown:
//            message = @"未知错误。";
//            break;
//        case SKErrorClientInvalid:
//            message = @"当前账户无法购买商品。如有疑问，请联系Apple客服。";
//            break;
//        case SKErrorPaymentCancelled:
//            message = @"用户取消购买。";
//            break;
//        case SKErrorPaymentInvalid:
//            message = @"订单无效。如有疑问，请联系Apple客服。";
//            break;
//        case SKErrorPaymentNotAllowed:
//            message = @"当前苹果设备无法购买商品。如有疑问，请联系Apple客服。";
//            break;
//        case SKErrorStoreProductNotAvailable:
//            message = @"此商品不允许在当前地区销售。";
//            break;
//        case SKErrorCloudServicePermissionDenied:
//            message = @"User has not allowed access to cloud service information.";
//            break;
//        case SKErrorCloudServiceNetworkConnectionFailed:
//            message = @"此设备未连接到网络。";
//            break;
//        case SKErrorCloudServiceRevoked:
//            message = @"User has revoked permission to use this cloud service.";
//            break;
//        default:
//            message = @"未知错误。";
//            break;
//    }
//
//    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"充值失败"
//                                                                             message:message
//                                                                      preferredStyle:UIAlertControllerStyleAlert];
//
//    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定"
//                                                           style:UIAlertActionStyleCancel
//                                                         handler:nil];
//
//    [alertController addAction:cancelAction];
//
//    [self presentViewController:alertController animated:YES completion:nil];
//    [BaseTools dismissHUD];
//
//    [[SKPaymentQueue defaultQueue]finishTransaction:transaction];
//
//}
//
//- (void)completeTransaction:(SKPaymentTransaction *)transaction {
//    //获取receipt_data
//    NSData *data = [NSData dataWithContentsOfFile:[[[NSBundle mainBundle] appStoreReceiptURL] path]];
////    NSString * receipt_data = [data base64EncodedStringWithOptions:0];
////    //获取product_id
////    NSString *product_id = transaction.payment.productIdentifier;
////    //获取transaction_id
////    NSString * transaction_id = transaction.transactionIdentifier;
//
//
//    NSLog(@"Provide the purchased functionality.");
//
//    _hud.label.text = @"正在获取支付收据...";
//    //获取支付收据
//    NSURL *receiptURL = [[NSBundle mainBundle] appStoreReceiptURL];
//    NSData *receiptData = [NSData dataWithContentsOfURL:receiptURL];
//
//    [[SKPaymentQueue defaultQueue]finishTransaction:transaction];
//
//    [self persistingReceipt:receiptData orderSN:self.orderSN];
//
//}
//
//- (void)restoreTransaction:(SKPaymentTransaction *)transaction {
//
//    NSLog(@"Restore the previously purchased functionality.");
//
//}
//
//- (void)persistingReceipt:(NSData *)receipt orderSN:(NSString *)orderSN {
//    if (!orderSN || !receipt) {
//        return;
//    }
//    [BaseTools dismissHUD];
//    _hud.label.text = @"正在存储支付收据...";
//
//    NSUserDefaults *storage = [NSUserDefaults standardUserDefaults];
//
//    NSDictionary *savedReceipts = [storage dictionaryForKey:@"receipts"];
//    if (!savedReceipts) {
//        // Storing the first receipt
//        [storage setObject:@{orderSN:receipt} forKey:@"receipts"];
//    } else {
//        // Adding another receipt
//        NSMutableDictionary *updatedReceipts = [NSMutableDictionary dictionaryWithDictionary:savedReceipts];
//        [updatedReceipts setObject:receipt forKey:orderSN];
//        [storage setObject:updatedReceipts forKey:@"receipts"];
//    }
//
//    [storage synchronize];
//
//    __weak typeof(self) weakSelf = self;
//
//    savedReceipts = [storage dictionaryForKey:@"receipts"];
//    for (NSString *key in savedReceipts.allKeys) {
//
//        _hud.label.text = @"正在验证支付收据...";
//        [XSIAPManage receipt:savedReceipts[key] orderSN:key callBack:^(NSUInteger code, NSString *message) {
//
//            __strong typeof(weakSelf) strongSelf = weakSelf;
//
//            [_hud hideAnimated:YES];
//
//            if (code) {
//                //充值失败
//                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"充值失败"
//                                                                                         message:message
//                                                                                  preferredStyle:UIAlertControllerStyleAlert];
//
//                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定"
//                                                                       style:UIAlertActionStyleCancel
//                                                                     handler:nil];
//
//                [alertController addAction:cancelAction];
//
//                [strongSelf presentViewController:alertController animated:YES completion:nil];
//
//            } else {
//                [BaseTools showErrorMessage:@"充值成功"];
//                dispatch_async(dispatch_get_main_queue(), ^{
//
//                     [self.navigationController popViewControllerAnimated:YES];
//                });
//
//
//                //创建一个通知对象
//                NSNotification * notice = [NSNotification notificationWithName:@"updateUserInfo" object:nil userInfo:nil];
//                //发送消息
//                [[NSNotificationCenter defaultCenter] postNotification:notice];
//            }
//        }];
//    }
//}

- (IBAction)helpButtonClick:(id)sender {
    

    
    
    if ([[UserDefaultsUtils valueWithKey:@"access_token"] length] !=0 ) {
        
        QYSource *source = [[QYSource alloc] init];
        source.title =  @"库课网校";
        source.urlString = @"https://www.kuke99.com/";
        
        QYSessionViewController *sessionViewController = [[QYSDK sharedSDK] sessionViewController];
        sessionViewController.delegate = self;
        sessionViewController.sessionTitle = @"库课网校";
        sessionViewController.source = source;

        if (IS_PAD) {
            UINavigationController* navi = [[UINavigationController alloc]initWithRootViewController:sessionViewController];
            navi.modalPresentationStyle = UIModalPresentationFormSheet;
            [self presentViewController:navi animated:YES completion:nil];
        }
        else{
            sessionViewController.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:sessionViewController animated:YES];
        }
        
        [[QYSDK sharedSDK] customUIConfig].bottomMargin = 0;
    }else{
        [BaseTools showErrorMessage:@"请登录后再操作"];
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [BaseTools alertLoginWithVC:self];
        });
    }
  
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

