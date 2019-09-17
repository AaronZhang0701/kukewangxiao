//
//  OrderAllStateViewController.m
//  KukeApp
//
//  Created by 库课 on 2019/1/4.
//  Copyright © 2019 zhangming. All rights reserved.
//

#import "OrderAllStateViewController.h"
#import "OrderAllStateLogisticsTableViewCell.h"
#import "OrderAdressTableViewCell.h"
#import "OrderAllStateModel.h"
#import "OrderProcessTableViewCell.h"
@interface OrderAllStateViewController ()
@property (nonatomic, strong) NSMutableArray *dataAry;
@property (nonatomic, strong) NSDictionary *dataDict;
@property (nonatomic, strong) OrderAllStateModel *model;
@end

@implementation OrderAllStateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadData];
    self.title = @"全部状态";
    [self.tableView registerNib:[UINib nibWithNibName:@"OrderAllStateLogisticsTableViewCell" bundle:nil] forCellReuseIdentifier:@"OrderAllStateLogisticsTableViewCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"OrderAdressTableViewCell" bundle:nil] forCellReuseIdentifier:@"OrderAdressTableViewCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"OrderProcessTableViewCell" bundle:nil] forCellReuseIdentifier:@"OrderProcessTableViewCell"];
    // Do any additional setup after loading the view.
}
#pragma mark - 点击背景刷新时执行
- (void)noDataBeginRefresh {
    [self lq_endLoading];
    [self loadData];
}

#pragma mark —————     请求列表数据  --———
- (void)loadData{

    
    NSMutableDictionary *parmDic = [NSMutableDictionary dictionary];
    [parmDic setObject:self.order_sn forKey:@"order_sn"];
    BADataEntity *entity = [BADataEntity new];
    entity.urlString = @"/order_handler/get_all_status";
    entity.needCache = NO;
    entity.parameters = parmDic;
    if (![CoreStatus isNetworkEnable]) {
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
#pragma mark —————  请求到的数据进行解析  --———
- (void)dataAnalysis:(id)data{
    
    self.model = [[OrderAllStateModel alloc] initWithDictionary:data error:nil];
    [self setEmptyViewDelegeta];
    
    //通知主线程刷新
    [self.tableView reloadData];
    
}
#pragma mark - UITableViewDataSource, UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (self.model.data == nil) {
        return 0;
    }else
    {
        if ([self.model.data.kinds integerValue] == 0) {
            return 3;
        }else{
            return 1;
        }
    }
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([self.model.data.kinds integerValue] == 0) {
        if (section==2) {
            return self.model.data.status_info.count;
        }else{
            return 1;
        }
        
   
    }else{
        return self.model.data.status_info.count;
    }
   
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    OrderAllStateDataModel *dict = self.model.data;
    if ([self.model.data.kinds integerValue] == 0) {
        if (indexPath.section == 2) {
           
            return [[dict.status_info[indexPath.row] name] zm_getTextHeight:[UIFont systemFontOfSize:14] width:screenWidth()-118] +35;
        }else if (indexPath.section == 1){
            return 70;
        }else{
            return 86;
        }
        
        
    }else{

        return [[dict.status_info[indexPath.row] name] zm_getTextHeight:[UIFont systemFontOfSize:14] width:screenWidth()-118] +35;

    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    OrderAllStateDataModel *dict = self.model.data;
    if ([self.model.data.kinds integerValue] == 0) {
        if (indexPath.section == 0) {
            OrderAdressTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OrderAdressTableViewCell" forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.nameLab.text = self.model.data.receiver;
            cell.telLab.text = self.model.data.receive_mobile;
            cell.addressLab.text = self.model.data.address;
            return cell;
        }else if (indexPath.section ==1){
            OrderAllStateLogisticsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OrderAllStateLogisticsTableViewCell" forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            if (self.model.data.courier_number.length ==0) {
                cell.name.text = @"暂无物流信息";
                cell.number.text = self.model.data.courier_number;
                cell.numCopy.hidden = YES;
            }else{
                cell.name.text = self.model.data.express_type;
                cell.number.text = self.model.data.courier_number;
            }
            
            return cell;
        }else{
            OrderProcessTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OrderProcessTableViewCell" forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.time.text = [BaseTools getDateStringWithTimeMdHm:[dict.status_info[indexPath.row] status_time]];
            cell.detaile.text = [dict.status_info[indexPath.row] name];
            cell.detaile.frame =  CGRectMake(103, 15, screenWidth()-118, [[dict.status_info[indexPath.row] name] zm_getTextHeight:[UIFont systemFontOfSize:14] width:screenWidth()-118]+5);
            return cell;
        }
    }else{
        OrderProcessTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OrderProcessTableViewCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.time.text = [BaseTools getDateStringWithTimeMdHm:[dict.status_info[indexPath.row] status_time]];
        cell.detaile.text = [dict.status_info[indexPath.row] name];
        cell.detaile.frame =  CGRectMake(103, 15, screenWidth()-118, [[dict.status_info[indexPath.row] name] zm_getTextHeight:[UIFont systemFontOfSize:14] width:screenWidth()-118]+5);
        return cell;
    }
    
    
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

//头视图高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = [UIColor clearColor];
    return headerView;
}

//脚视图高度
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 5;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth(), 5)];
    footerView.backgroundColor = CBackgroundColor;
    return footerView;
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
