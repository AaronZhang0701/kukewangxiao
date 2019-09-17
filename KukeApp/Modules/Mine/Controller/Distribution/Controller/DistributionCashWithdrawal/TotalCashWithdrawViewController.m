//
//  TotalCashWithdrawViewController.m
//  KukeApp
//
//  Created by 库课 on 2019/3/19.
//  Copyright © 2019 KukeZangMing. All rights reserved.
//

#import "TotalCashWithdrawViewController.h"
#import "DistributionCommissionTableViewCell.h"
#import "DistributionOrderModel.h"
@interface TotalCashWithdrawViewController (){

    UILabel *lab2;

    
}
//列表数组
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, assign) NSInteger pageNO;

@end

@implementation TotalCashWithdrawViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.dataSource = [NSMutableArray array];
    self.title = @"累计提现";
    self.view.backgroundColor = CBackgroundColor;
    self.pageNO = 1;
    
    if (self.isHeader) {
     
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 1, screenWidth(), 60)];
        view.backgroundColor = [UIColor whiteColor];
        
        UILabel *lab1 = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, screenWidth(), 30)];
        lab1.text = @"已打款金额";
        lab1.textColor = [UIColor colorWithRed:138/255.0 green:138/255.0 blue:138/255.0 alpha:1.0];
        lab1.font = [UIFont systemFontOfSize:14];
        lab1.textAlignment = NSTextAlignmentCenter;
        [view addSubview:lab1];
        
        lab2 = [[UILabel alloc]initWithFrame:CGRectMake(0, 30, screenWidth(), 30)];
        lab2.textColor = [UIColor colorWithRed:138/255.0 green:138/255.0 blue:138/255.0 alpha:1.0];
        lab2.font = [UIFont systemFontOfSize:18];
        lab2.textAlignment = NSTextAlignmentCenter;
        [view addSubview:lab2];
        [self.view addSubview:view];
    }
    [self loadData];
    if (self.isHeader) {
        self.tableView.frame = CGRectMake(0, 68, KScreenWidth, screenHeight()-UI_navBar_Height-68);
    }else{
         self.tableView.frame = CGRectMake(0, 0, KScreenWidth, screenHeight()-UI_navBar_Height);
    }
    
    [self.tableView registerNib:[UINib nibWithNibName:@"DistributionCommissionTableViewCell" bundle:nil] forCellReuseIdentifier:@"DistributionCommissionTableViewCell"];
    

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
    [parmDic setObject:[NSNumber numberWithInteger:self.pageNO] forKey:@"page"];
    BADataEntity *entity = [BADataEntity new];
    entity.urlString = @"/distribution/withdraw_brokerage_log";
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
        if ([response[@"data"][@"list"] count] < 10 && self.pageNO >1) {
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
    lab2.text = [NSString stringWithFormat:@"%@",data[@"data"][@"statistics"][@"brokerage_paid_total"]];
    DistributionOrderModel *model = [[DistributionOrderModel alloc]initWithDictionary:data error:nil];
    
    [self.dataSource addObjectsFromArray:model.list];
    [self setEmptyViewDelegeta];
    
    [self.tableView reloadData];
    
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;

}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 69;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DistributionCommissionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DistributionCommissionTableViewCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.data = self.dataSource[indexPath.row];
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
