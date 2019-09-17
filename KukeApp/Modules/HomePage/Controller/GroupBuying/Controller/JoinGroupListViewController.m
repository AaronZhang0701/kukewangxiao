//
//  JoinGroupListViewController.m
//  KukeApp
//
//  Created by 库课 on 2019/1/11.
//  Copyright © 2019 zhangming. All rights reserved.
//

#import "JoinGroupListViewController.h"
#import "JoinGroupListTableViewCell.h"
#import "JoinGroupListModel.h"
#import "JoinGroupDetailViewController.h"
@interface JoinGroupListViewController (){
    

    JoinGroupListModel *model;

}
//列表数组
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, assign) NSInteger pageNO;

@end

@implementation JoinGroupListViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO];
    //    [self.tableView.mj_header beginRefreshing];
    [self loadData];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
 
    self.dataSource = [NSMutableArray array];
    self.pageNO = 1;
    self.title = @"参团列表";
    //    [self loadData];

    [self.tableView registerNib:[UINib nibWithNibName:@"JoinGroupListTableViewCell" bundle:nil] forCellReuseIdentifier:@"JoinGroupListTableViewCell"];
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

- (void)relodData{
    
    self.dataSource = [NSMutableArray array];
    [self.tableView.mj_footer resetNoMoreData];
    [self.tableView reloadData];
    self.pageNO = 1;
    [self loadData];
    [self.tableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:NO];
    
    
}
#pragma mark —————     请求列表数据  --———
- (void)loadData{
    
    NSMutableDictionary *parmDic = [NSMutableDictionary dictionary];
    [parmDic setObject:[NSNumber numberWithInteger:self.pageNO] forKey:@"page"];
    [parmDic setObject:self.group_buy_goods_id forKey:@"group_buy_goods_id"];

    BADataEntity *entity = [BADataEntity new];
    entity.urlString = @"/groupbuy/join_group_list";
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
    
    model = [[JoinGroupListModel alloc]initWithDictionary:data error:nil];
    
    [self.dataSource addObjectsFromArray:model.data];
    [self setEmptyViewDelegeta];
    
    [self.tableView reloadData];
    
    
}
#pragma mark - UITableViewDataSource, UITableViewDelegate


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 119;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JoinGroupListDataModel *model = self.dataSource[indexPath.row];
    JoinGroupListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JoinGroupListTableViewCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = model;
    NSLog(@"%@",model.rest_time);
    [cell setConfigWithSecond:[model.rest_time integerValue]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    JoinGroupDetailViewController *vc = [[JoinGroupDetailViewController alloc]init];
    vc.token = [self.dataSource[indexPath.row] token];
    vc.group_buy_goods_rule_id =  [self.dataSource[indexPath.row] group_buy_goods_rule_id];
    [self.navigationController pushViewController:vc animated:YES];
    
}


- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIImage imageNamed:@"无购买课程"];
}
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *title = @"暂无团购信息哦～";
    NSDictionary *attributes = @{
                                 NSFontAttributeName:[UIFont systemFontOfSize:13.0f],
                                 NSForegroundColorAttributeName:[UIColor colorWithHexString:@"8a8a8a"]
                                 };
    return [[NSAttributedString alloc] initWithString:title attributes:attributes];
}
@end

