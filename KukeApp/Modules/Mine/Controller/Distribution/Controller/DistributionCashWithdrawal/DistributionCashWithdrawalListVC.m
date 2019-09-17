//
//  DistributionCashWithdrawalListVC.m
//  KukeApp
//
//  Created by 库课 on 2019/3/18.
//  Copyright © 2019 KukeZangMing. All rights reserved.
//

#import "DistributionCashWithdrawalListVC.h"
#import "DistributionOrderTableViewCell.h"
#import "CourseDetailViewController.h"
#import "DistributionOrderHeader.h"
#import "DistributionOrderModel.h"

@interface DistributionCashWithdrawalListVC (){

    NSString *str1;
    NSString *str2;

}
//列表数组
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, assign) NSInteger pageNO;

@end

@implementation DistributionCashWithdrawalListVC

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.dataSource = [NSMutableArray array];

    [self loadData];
    
    self.pageNO = 1;
    self.tableView.frame = CGRectMake(0, 0, screenWidth(), screenHeight()-50-UI_navBar_Height);
    //初始化刷新控件
    [self initRefresh];
    __weak typeof(self) weakSelf = self;
    self.header_block = ^{
        weakSelf.pageNO = 1;
        [weakSelf loadData];
    };
    self.footre_block = ^{
        weakSelf.pageNO ++;
        [weakSelf loadData];
    };
    [self.tableView registerNib:[UINib nibWithNibName:@"DistributionOrderTableViewCell" bundle:nil] forCellReuseIdentifier:@"DistributionOrderTableViewCell"];
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
    [parmDic setObject:self.tab forKey:@"tab"];
    [parmDic setObject:self.status forKey:@"status"];
    [parmDic setObject:[NSNumber numberWithInteger:self.pageNO] forKey:@"page"];

    BADataEntity *entity = [BADataEntity new];
    entity.urlString = @"/distribution/dist_order";
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
                str1 = response[@"data"][@"statistics"][@"order_price_amount"];
                str2 = response[@"data"][@"statistics"][@"brokerage_amount"];
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
        if ([[response objectForKey:@"data"] count] < 10 && self.pageNO >1) {
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
        [self.dataSource removeAllObjects];
    }
    

    DistributionOrderModel *model = [[DistributionOrderModel alloc]initWithDictionary:data error:nil];

    [self.dataSource addObjectsFromArray:model.list];
    [self setEmptyViewDelegeta];
    
    [self.tableView reloadData];
    
}
#pragma mark - UITableViewDataSource, UITableViewDelegate
//头视图高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 68;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {

    DistributionOrderHeader *headerView = [[DistributionOrderHeader alloc] initWithFrame:CGRectMake(0, 0, screenHeight(), 68)];
    if ([self.type isEqualToString:@"TGDD"]) {
        headerView.fristLab.text = @"推广总金额";
        headerView.secondLab.text = @"佣金金额";
    }else if ([self.type isEqualToString:@"ZGDD"]) {
        headerView.fristLab.text = @"自购金额";
        headerView.secondLab.text = @"佣金金额";
    }else if ([self.type isEqualToString:@"XJFY"]) {
        headerView.fristLab.text = @"下级推广金额";
        headerView.secondLab.text = @"下级分佣";
    }
    headerView.firstMoneyLab.text = [NSString stringWithFormat:@"%@",str1];
    headerView.secondMoneyLab.text = [NSString stringWithFormat:@"%@",str2];
    return headerView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;

}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 204;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DistributionOrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DistributionOrderTableViewCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = self.dataSource[indexPath.row];
    return cell;
}
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIImage imageNamed:@"无数据"];
}
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *title = @"暂无数据哦～";
    NSDictionary *attributes = @{
                                 NSFontAttributeName:[UIFont systemFontOfSize:13.0f],
                                 NSForegroundColorAttributeName:[UIColor colorWithHexString:@"8a8a8a"]
                                 };
    return [[NSAttributedString alloc] initWithString:title attributes:attributes];
}


@end
