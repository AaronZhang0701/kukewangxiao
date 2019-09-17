//
//  DistributionBaseViewController.m
//  KukeApp
//
//  Created by 库课 on 2019/3/18.
//  Copyright © 2019 KukeZangMing. All rights reserved.
//

#import "DistributionBaseViewController.h"
#import "DistributionCommissionTableViewCell.h"
#import "DistributionBillModel.h"
@interface DistributionBaseViewController (){

}

@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, assign) NSInteger pageNO;
@end

@implementation DistributionBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pageTitleViewToTop) name:@"headerViewToTop" object:nil];
    self.dataSource = [NSMutableArray array];
    self.pageNO = 1;
    [self setTab];
    [self loadData];
    self.tableView.frame = CGRectMake(0, 50, screenWidth(), screenHeight()-50-UI_navBar_Height);
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
    [self.tableView registerNib:[UINib nibWithNibName:@"DistributionCommissionTableViewCell" bundle:nil] forCellReuseIdentifier:@"DistributionCommissionTableViewCell"];
}

#pragma mark - 点击背景刷新时执行
- (void)noDataBeginRefresh {
    [self lq_endLoading];
    [self loadData];
    KPostNotification(@"DistributionMianLoadData", nil);
}
- (void)setTab{
    self.tab = @"all";
    
}
#pragma mark —————     请求列表数据  --———

- (void)loadData{
    NSMutableDictionary *parmDic = [NSMutableDictionary dictionary];
    [parmDic setObject:self.tab forKey:@"tab"];
    [parmDic setObject:[NSNumber numberWithInteger:self.pageNO] forKey:@"page"];
    BADataEntity *entity = [BADataEntity new];
    entity.urlString = @"/distribution/brokerage_log";
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
    DistributionBillModel *model = [[DistributionBillModel alloc]initWithDictionary:data error:nil];
    
    [self.dataSource addObjectsFromArray:model.data];
    [self setEmptyViewDelegeta];
    
    [self.tableView reloadData];
    
    
}
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)pageTitleViewToTop {
    self.tableView.contentOffset = CGPointZero;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.tableView.frame = CGRectMake(0, 0, screenWidth(), screenHeight()-UI_navBar_Height-50);
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    // 滚动时发出通知
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"SubTableViewDidScroll" object:scrollView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 69;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    static NSString *ID = @"cell_2";
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
//    if (cell == nil) {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
//    }
//    cell.textLabel.text = [NSString stringWithFormat:@"第%zd行",indexPath.row];
//    return cell;
    DistributionCommissionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DistributionCommissionTableViewCell" forIndexPath:indexPath];
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
