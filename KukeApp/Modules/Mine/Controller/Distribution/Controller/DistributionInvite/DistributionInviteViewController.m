//
//  DistributionInviteViewController.m
//  KukeApp
//
//  Created by 库课 on 2019/3/20.
//  Copyright © 2019 KukeZangMing. All rights reserved.
//

#import "DistributionInviteViewController.h"
#import "DistributionInviteHeaderView.h"
#import "DistributionInviteTableViewCell.h"
#import "DistributionInviteModel.h"
@interface DistributionInviteViewController (){

    
}
//列表数组
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, assign) NSInteger pageNO;


@end

@implementation DistributionInviteViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.dataSource = [NSMutableArray array];
    
    self.title = @"邀请分销员";
    [self loadData];
    
    self.pageNO = 1;
    self.tableView.frame = CGRectMake(0, 0, screenWidth(), screenHeight()-UI_navBar_Height);
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
    [self.tableView registerNib:[UINib nibWithNibName:@"DistributionInviteTableViewCell" bundle:nil] forCellReuseIdentifier:@"DistributionInviteTableViewCell"];
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
    entity.urlString = @"/distribution/distributor_subordinate";
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
    
    DistributionInviteModel *model = [[DistributionInviteModel alloc]initWithDictionary:data error:nil];
    [self.dataSource addObjectsFromArray:model.data];
    [self setEmptyViewDelegeta];
    [self.tableView reloadData];

    
    
}
#pragma mark - UITableViewDataSource, UITableViewDelegate
//头视图高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 44;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    DistributionInviteHeaderView *headerView = [[DistributionInviteHeaderView alloc] initWithFrame:CGRectMake(0, 0, screenHeight(), 44)];
    
    return headerView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
        return self.dataSource.count;

}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 44;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DistributionInviteTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DistributionInviteTableViewCell" forIndexPath:indexPath];
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
