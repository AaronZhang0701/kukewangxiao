//
//  MyBalanceViewController.m
//  KukeApp
//
//  Created by iOSDeveloper on 2018/10/29.
//  Copyright © 2018年 zhangming. All rights reserved.
//

#import "MyBalanceViewController.h"
#import "XSIAPViewController.h"
#import "RechargeRecordTableViewCell.h"
#import "RechargeRecordModel.h"

@interface MyBalanceViewController (){
    NSString *moneyStr;

}
@property (nonatomic, assign)NSInteger pageNO;
@property (nonatomic, strong) NSMutableArray *dataAry;
@end

@implementation MyBalanceViewController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [self.navigationController setNavigationBarHidden:NO];

}
- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"我的余额";
    self.pageNO = 1;
    self.dataAry = [NSMutableArray array];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:self.navigationItem.backBarButtonItem.style target:nil action:nil];

    /**启动IAP工具类*/
    [[IAPManager shared] startManager];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadData) name:KNotificationLoginUpdata object:nil];
    [self loadData];
    [self.view addSubview:self.tableView];
    
    [self initRefresh];
    //（避免循环引用）
    __weak typeof(self) weakSelf = self;
    self.header_block = ^{
        weakSelf.pageNO = 1;
        [weakSelf loadData];
    };
    self.footre_block = ^{
        weakSelf.pageNO ++;
        [weakSelf loadData];
    };
    [self.tableView registerNib:[UINib nibWithNibName:@"RechargeRecordTableViewCell" bundle:nil] forCellReuseIdentifier:@"RechargeRecordTableViewCell"];

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
    [parmDic setObject:@"1" forKey:@"type"];
    [parmDic setObject:@"10" forKey:@"limit"];
    [parmDic setObject:[NSNumber numberWithInteger:self.pageNO] forKey:@"page"];
    BADataEntity *entity = [BADataEntity new];
    entity.urlString = @"/ucenter/wallet_account_coin";
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
        if(self.pageNO >1) {
            [self endRefreshWithFooterHidden];
        }else{

            [self endWaterDropRefreshWithHeaderHidden];
        }
        if ([[response objectForKey:@"data"][@"log"] count] < 10 && self.pageNO >1) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
    } failureBlock:^(NSError *error) {
        [self setEmptyViewDelegeta];
    } progressBlock:^(int64_t bytesProgress, int64_t totalBytesProgress) {
        /*! 封装方法里已经回到主线程，所有这里不用再调主线程了 */

    }];
}

#pragma mark —————  请求到的数据进行解析  --———
- (void)dataAnalysis:(id)data{
    if (self.pageNO == 1) {
        [self.dataAry removeAllObjects];
        
        self.balanceLab.text = [NSString stringWithFormat:@"%@",data[@"data"][@"wallet"][@"account"]];
        moneyStr =data[@"data"][@"wallet"][@"account"];
    }
    self.tableView.tableHeaderView = self.headerView;
    RechargeRecordModel *model = [[RechargeRecordModel alloc]initWithDictionary:data error:nil];
    [self.dataAry addObjectsFromArray:model.data.log];
    [self setEmptyViewDelegeta];
    
    [self.tableView reloadData];


}
#pragma mark - UITableViewDataSource, UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataAry.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 60;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RechargeRecordTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RechargeRecordTableViewCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = self.dataAry[indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

}


- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIImage imageNamed:@"无交易明细"];
}
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *title = @"暂无交易明细哦~";
    NSDictionary *attributes = @{
                                 NSFontAttributeName:[UIFont systemFontOfSize:13.0f],
                                 NSForegroundColorAttributeName:[UIColor colorWithHexString:@"8a8a8a"]
                                 };
    return [[NSAttributedString alloc] initWithString:title attributes:attributes];
}
- (IBAction)detialAction:(id)sender {

}
- (IBAction)rechargeAction:(id)sender {
    XSIAPViewController *vc = [[XSIAPViewController alloc]init];
    vc.money = moneyStr;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewWillDisappear:(BOOL)animated {

    [super viewWillDisappear:animated];
    [BaseTools dismissHUD];
    //    [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];

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
