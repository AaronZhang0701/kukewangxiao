//
//  NY_AddressListVC.m
//  中安生态商城
//
//  Created by NewYear on 2017/7/18.
//  Copyright © 2017年 王鑫年. All rights reserved.
//

#import "NY_AddressListVC.h"
#import "NY_AddressListCell.h"

#import "NY_UpdateAddress.h"
#import "NY_AddAddressVC.h"




@interface NY_AddressListVC ()<AddressListCellDelegate>

@property (nonatomic, copy) NSMutableArray *addressListArr;

@property (nonatomic, copy) NSMutableArray *dataAry;
@property (assign, nonatomic) NSIndexPath *selIndex;//单选，当前选中的行
@property (nonatomic,assign) BOOL isSel;
@end

@implementation NY_AddressListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

//    [self getAddressList];
    self.title = @"我的地址";
    self.tableView.frame = CGRectMake(0, 0, screenWidth(), screenHeight()-UI_navBar_Height-50);

    [self.tableView registerNib:[UINib nibWithNibName:@"NY_AddressListCell" bundle:nil] forCellReuseIdentifier:@"NY_AddressListCell"];
}
#pragma mark - 点击背景刷新时执行
- (void)noDataBeginRefresh {
    [self lq_endLoading];
    [self getAddressList];
}
- (void)getAddressList {


    BADataEntity *entity = [BADataEntity new];
    entity.urlString = @"/stucommon/get_stu_address_list";
    entity.needCache = NO;
    entity.parameters = nil;
    if (![CoreStatus isNetworkEnable]) {
        self.btn.hidden = YES;
        [self lq_showFailLoadWithType:(LQTableViewFailLoadViewTypeNoData) tipsString:@"无法连接到网络,点击页面刷新"];
        return;
    }else{
        
        self.tableView.loading = YES;
    }
    
    // 如果打印数据不完整，是因为 Xcode 8 版本问题，请下断点打印数据
    [BANetManager ba_request_POSTWithEntity:entity successBlock:^(id response) {
        
        if (response == nil) {
            
        }else{
            if ([response[@"code"] isEqualToString:@"0"]) {
                [self dataAnalysis:response];
            }else if ([response[@"code"] isEqualToString:@"-10000"]){
                [BaseTools showErrorMessage:@"请登录后再操作"];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [BaseTools alertLoginWithVC:self];
                });
            }else{
                [BaseTools showErrorMessage:response[@"msg"]];
            }
        }
        
    } failureBlock:^(NSError *error) {
        [self setEmptyViewDelegeta];
    } progressBlock:^(int64_t bytesProgress, int64_t totalBytesProgress) {
        /*! 封装方法里已经回到主线程，所有这里不用再调主线程了 */
        
    }];
}

    // 取本地地址列表
//    _addressListArr = [NSMutableArray array];
//    NSData * data1 = [[NSUserDefaults standardUserDefaults] objectForKey:@"Test"];
//    _addressListArr = [NSKeyedUnarchiver unarchiveObjectWithData:data1];
//    [_mTableView reloadData];
//}
#pragma mark —————  请求到的数据进行解析  --———
- (void)dataAnalysis:(id)data{
    [_addressListArr removeAllObjects];
    [_dataAry removeAllObjects];
    ReceiveAddressModel *model = [[ReceiveAddressModel alloc]initWithDictionary:data error:nil];
    [_dataAry addObjectsFromArray:model.data];
    self.btn.hidden = NO;
    [self setEmptyViewDelegeta];

    [self.tableView reloadData];
    
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataAry.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 150;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NY_AddressListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NY_AddressListCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    ReceiveAddressDataListModel *model =_dataAry[indexPath.row];
//    if (_isSel && _selIndex == indexPath && [model.is_default isEqualToString:@"1"]) {
//        cell.is_default.image = [UIImage imageNamed:@"shopcarsel"];
//        cell.is_defaultLab.text = @"默认地址";
//        cell.is_defaultLab.textColor = [UIColor redColor];
//    } else {
//        cell.is_default.image = [UIImage imageNamed:@"shopcar"];
//        cell.is_defaultLab.text = @"设为默认";
//        cell.is_defaultLab.textColor = [UIColor grayColor];
//    }
    cell.model = _dataAry[indexPath.row];
    cell.index = indexPath.row;
    
    cell.delegate = self;
    cell.selIndex = indexPath;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ReceiveAddressDataListModel *model = _dataAry[indexPath.row];
    NSMutableDictionary *parmDic = [NSMutableDictionary dictionary];
    [parmDic setObject:model.ID forKey:@"id"];
    [ZMNetworkHelper POST:@"/stucommon/edit_address_def" parameters:parmDic cache:NO responseCache:^(id responseCache) {
        
    } success:^(id responseObject) {
        if ([responseObject[@"code"] isEqualToString:@"0"]) {
//            [BaseTools showErrorMessage:responseObject[@"msg"]];
            dispatch_async(dispatch_get_main_queue(), ^{
//                if (_addressBlcok) {
//
//                    _addressBlcok(model);
                    [self.navigationController popViewControllerAnimated:YES];
//                }
            });
            
        }else{
            [BaseTools showErrorMessage:responseObject[@"msg"]];
        }
        
    } failure:^(NSError *error) {
        
    }];

    
}
- (void)deleteAddressWithId:(NSInteger)addressId withIndex:(NSInteger)index {
    
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"您确定要删除该地址吗？" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *actionOne = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSMutableDictionary *parmDic = [NSMutableDictionary dictionary];
        [parmDic setObject:[NSNumber numberWithInteger:addressId] forKey:@"id"];
        [ZMNetworkHelper POST:@"/stucommon/del_stu_address" parameters:parmDic cache:NO responseCache:^(id responseCache) {
            
        } success:^(id responseObject) {
            if ([responseObject[@"code"] isEqualToString:@"0"]) {
                [BaseTools showErrorMessage:responseObject[@"msg"]];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self getAddressList];
                });
                
            }else{
                [BaseTools showErrorMessage:responseObject[@"msg"]];
            }
            
        } failure:^(NSError *error) {
            
        }];

        
    }];
    UIAlertAction *actionTwo = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    [alertController addAction:actionOne];
    [alertController addAction:actionTwo];
    
    [self presentViewController:alertController animated:YES completion:nil];
    
}
//
- (void)upDateAddressWithId:(NSInteger)addressId withIndex:(NSInteger)index {

    NY_UpdateAddress *addAddressVC = [[NY_UpdateAddress alloc] initWithNibName:@"NY_UpdateAddress" bundle:nil];
//    addAddressVC.addressModel = [_addressListArr objectAtIndex:index];
    addAddressVC.model = _dataAry[index];
    addAddressVC.title = @"编辑地址";
    [self.navigationController pushViewController:addAddressVC animated:YES];

}

- (void)defaltAddressWithId:(NSInteger)addressId withIndex:(NSIndexPath *)index {

    NSMutableDictionary *parmDic = [NSMutableDictionary dictionary];
    [parmDic setObject:[NSNumber numberWithInteger:addressId] forKey:@"id"];
    [ZMNetworkHelper POST:@"/stucommon/edit_address_def" parameters:parmDic cache:NO responseCache:^(id responseCache) {
        
    } success:^(id responseObject) {
        if ([responseObject[@"code"] isEqualToString:@"0"]) {
            [BaseTools showErrorMessage:responseObject[@"msg"]];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self getAddressList];
            });
            
        }else{
            [BaseTools showErrorMessage:responseObject[@"msg"]];
        }
        
    } failure:^(NSError *error) {
        
    }];

}


- (IBAction)addNewAddresss:(UIButton *)sender {

    NY_AddAddressVC *addAddressVC = [[NY_AddAddressVC alloc] initWithNibName:@"NY_AddAddressVC" bundle:nil];
    addAddressVC.title = @"添加新地址";
    [self.navigationController pushViewController:addAddressVC animated:YES];

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    _addressListArr = [NSMutableArray array];
    _dataAry = [NSMutableArray array];
    [self getAddressList];
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
