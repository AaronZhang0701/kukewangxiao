//
//  NewsNoticeViewController.m
//  KukeApp
//
//  Created by iOSDeveloper on 2018/11/5.
//  Copyright © 2018年 zhangming. All rights reserved.
//

#import "NewsNoticeViewController.h"
#import "NewsNoticeTableViewCell.h"
@interface NewsNoticeViewController (){

    NSString *goods_type;
    NSString *goods_id;
}

@property (nonatomic, strong) NSMutableArray *dataAry;
@property (nonatomic, assign) NSInteger pageNO;
@end

@implementation NewsNoticeViewController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO];
    //[AppUtiles setTabBarHidden:YES];
    //    [_tableView.mj_header beginRefreshing];
}
- (void)viewDidLoad {
    [super viewDidLoad];
 
    self.title = @"通知消息";
    self.dataAry = [NSMutableArray array];
    self.pageNO = 1;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadData) name:KNotificationLoginUpdata object:nil];
    [self loadData];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self initRefresh];
    //（避免循环引用）

    //下拉刷新
//    [self addWaterDropPullRefreshWithBlock:^{
//        weakSelf.pageNO = 1;
//        [weakSelf loadData];
//    }];
//
//    //上拉加载更多
//    [self addMoreLoadingWithBlock:^{
//        weakSelf.pageNO ++;
//        [weakSelf loadData];
//
//    }];
    __weak typeof(self) weakSelf = self;
    self.header_block = ^{
        weakSelf.pageNO = 1;
        [weakSelf loadData];
    };
    self.footre_block = ^{
        weakSelf.pageNO ++;
        [weakSelf loadData];
    };
    [self.tableView registerNib:[UINib nibWithNibName:@"NewsNoticeTableViewCell" bundle:nil] forCellReuseIdentifier:@"NewsNoticeTableViewCell"];
    
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
    [parmDic setObject:@"10" forKey:@"limit"];
    [parmDic setObject:[NSNumber numberWithInteger:self.pageNO] forKey:@"page"];
    BADataEntity *entity = [BADataEntity new];
    entity.urlString = @"/ucenter/notice";
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
        [self.dataAry removeAllObjects];
    }
    [self.dataAry addObjectsFromArray:data[@"data"]];
    [self setEmptyViewDelegeta];

    [self.tableView reloadData];

}
#pragma mark - UITableViewDataSource, UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataAry.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 190;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NewsNoticeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NewsNoticeTableViewCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.timeLab.text = [BaseTools getDateStringWithTimeStr:self.dataAry[indexPath.row][@"create_time"]];
    cell.contentLab.text = self.dataAry[indexPath.row][@"content"];
    cell.titleLab.text = self.dataAry[indexPath.row][@"title"];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    HomePageBannerViewController *vc = [[HomePageBannerViewController alloc]init];
    vc.url = self.dataAry[indexPath.row][@"news_url"];
    vc.title = @"通知详情";
    [self.navigationController pushViewController:vc animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return YES;
}
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIImage imageNamed:@"无消息"];
}
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *title = @"您还没有消息通知哦~";
    NSDictionary *attributes = @{
                                 NSFontAttributeName:[UIFont systemFontOfSize:13.0f],
                                 NSForegroundColorAttributeName:[UIColor colorWithHexString:@"8a8a8a"]
                                 };
    return [[NSAttributedString alloc] initWithString:title attributes:attributes];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
