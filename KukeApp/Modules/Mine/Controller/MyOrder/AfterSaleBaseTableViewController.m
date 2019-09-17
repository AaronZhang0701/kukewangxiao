//
//  AfterSaleBaseTableViewController.m
//  KukeApp
//
//  Created by iOSDeveloper on 2018/10/23.
//  Copyright © 2018年 zhangming. All rights reserved.
//

#import "AfterSaleBaseTableViewController.h"
#import "MyOrderModel.h"
#import "CourseSelectionModel.h"
#import "AfterSaleTableViewCell.h"

@interface AfterSaleBaseTableViewController ()<ZMEmptyDataSetSource,ZMEmptyDataSetDelegate>{
    //考试动态0。 备考指导1
    NSInteger titleIndex;
    //无数据提示
    UILabel *footerLable;
    //列表的页数
    NSInteger pageNO;
    MJRefreshAutoNormalFooter *footer;
    MJRefreshNormalHeader *header;
    NSString *orderID;
}
@property (nonatomic,strong)EasyLoadingView *LoadingV;
//列表数组
@property (nonatomic, strong) NSMutableArray *dataSource;
@end

@implementation AfterSaleBaseTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.loading = YES;
    titleIndex = 0;
    pageNO = 1;
    
    //初始化刷新控件
    [self initRefresh];
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    [self.tableView registerNib:[UINib nibWithNibName:@"AfterSaleTableViewCell" bundle:nil] forCellReuseIdentifier:@"AfterSaleTableViewCell"];
    self.tableView.backgroundColor = CBackgroundColor;
    // 删除单元格分隔线的一个小技巧
    self.tableView.tableFooterView = [UIView new];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadData) name:KNotificationLoginUpdata object:nil];
    // Do any additional setup after loading the view.
}

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIImage imageNamed:@"无订单"];
}
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *title = @"还没有相关记录哦～";
    NSDictionary *attributes = @{
                                 NSFontAttributeName:[UIFont systemFontOfSize:13.0f],
                                 NSForegroundColorAttributeName:[UIColor colorWithHexString:@"8a8a8a"]
                                 };
    return [[NSAttributedString alloc] initWithString:title attributes:attributes];
}

#pragma mark —————     请求列表数据  --———
- (void)loadData:(NSInteger)index {
    self.dataSource = [NSMutableArray array];
    pageNO = 1;
    titleIndex = index;
    [self loadData];
    
}
-(void)loadData{
    
    NSMutableDictionary *parmDic = [NSMutableDictionary dictionary];
    [parmDic setObject:[NSNumber numberWithInteger:titleIndex+3] forKey:@"tab"];
    [parmDic setObject:@"10" forKey:@"limit"];
    [parmDic setObject:[NSNumber numberWithInteger:pageNO] forKey:@"page"];
    [ZMNetworkHelper POST:@"/ucenter/order" parameters:parmDic cache:YES responseCache:^(id responseCache) {
        
    } success:^(id responseObject) {
        if (responseObject == nil) {
            
        }else{
            if ([responseObject[@"code"] isEqualToString:@"0"]) {
                [self dataAnalysis:responseObject];
            }else if ([responseObject[@"code"] isEqualToString:@"-10000"]){
                [BaseTools showErrorMessage:@"请登录后再操作"];
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [BaseTools alertLoginWithVC:[[AppDelegate shareAppDelegate]getCurrentUIVC]];
                });
            }else{
                [BaseTools showErrorMessage:responseObject[@"msg"]];
            }
        }
        if(pageNO >1) {
            [self.tableView.mj_footer endRefreshing];
        }else{
            [self.tableView.mj_header endRefreshing];
        }
        if ([[responseObject objectForKey:@"data"] count] < 10 && pageNO >1) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
    } failure:^(NSError *error) {
        
    }];
    
}
#pragma mark —————  请求到的数据进行解析  --———
- (void)dataAnalysis:(id)data{
    if (pageNO == 1) {
        [self.dataSource removeAllObjects];
    }
    
    MyOrderModel *model = [[MyOrderModel alloc]initWithDictionary:data error:nil];
    [self.dataSource addObjectsFromArray:model.data];
    self.tableView.loading = NO;
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
    //通知主线程刷新
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
    
    
}
//- (void)loadDataForFirst {
//    //第一次才加载，后续触发的不处理
//    if (!self.isDataLoaded) {
//        //手动设置contentoffset
//        [self.tableView setContentOffset:CGPointMake(0, -self.refreshControl.bounds.size.height) animated:YES];
//        [self loadData:titleIndex withCateID:cate_id];
//        self.isDataLoaded = YES;
//    }
//}

#pragma mark - UITableViewDataSource, UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataSource.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 210;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AfterSaleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AfterSaleTableViewCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = self.dataSource[indexPath.section];

    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *allBgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenHeight(), 10)];
    allBgView.backgroundColor = CBackgroundColor;
    return allBgView;
    
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.0000001;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSLog(@"%ld",indexPath.row);
    NSDictionary *dict =[[NSDictionary alloc]initWithObjectsAndKeys:[self.dataSource[indexPath.section] order_sn],@"AfterSaleOrder_sn", nil];
    KPostNotification(@"MyAfterSaleDetail",dict);
    //    MyOrderDataModel *model = self.dataSource[indexPath.row];
    //    if (_myBlock) {
    //        _myBlock(model.url);
    //
    //    }
}
#pragma mark - 刷新方法的初始化
//*********************刷新及网络请求********************
-(void)initRefresh{
    //设置下拉
    header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRefresh)];
    self.tableView.mj_header = header;
    
    //设置上拉
    footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRefresh)];
    [footer setTitle:@"" forState:MJRefreshStateIdle];
    // 设置文字
    //  [footer setTitle:NOMOREDATA forState:MJRefreshStateNoMoreData];
    self.tableView.mj_footer = footer;
    
    footerLable = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, screenWidth()-20, 44-10)];
    // footerLable.textColor = GrayColor;
    footerLable.textAlignment = NSTextAlignmentCenter;
    footerLable.font = [UIFont systemFontOfSize:13.0f];
    footerLable.text = @"暂无数据";
    
}
/**
 *
 *  下拉刷新
 */
-(void)headerRefresh{
    //    [footerLable removeFromSuperview];
    //    if ([NetWorkStatusTool isNetworkReachable] == NO) {
    //        [BaseTools  showError:@"网络已断开，请检查网络"];
    //    }
    
    pageNO =1;
    [ self.tableView.mj_footer resetNoMoreData];
    [self loadData];
}

/**
 
 *
 *  上拉加载
 */
-(void)footerRefresh{
    //    if ([NetWorkStatusTool isNetworkReachable] == NO) {
    //        [BaseTools  showError:@"网络已断开，请检查网络"];
    //    }
    
    [footerLable removeFromSuperview];
    pageNO++;
    [self loadData];
    
}



@end
