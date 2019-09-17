//
//  DistributionSpreadGoodsListViewController.m
//  KukeApp
//
//  Created by 库课 on 2019/3/22.
//  Copyright © 2019 KukeZangMing. All rights reserved.
//

#import "DistributionSpreadGoodsListViewController.h"
#import "DistributionGoodsListTableViewCell.h"
#import "CourseDetailViewController.h"
#import "DistributionOrderHeader.h"
#import "DistributionSpreadGoodsListModel.h"
#import "DistributionFilterView.h"
@interface DistributionSpreadGoodsListViewController (){
    
    UIButton *button1;
    UIButton *button;
    NSString *tab;
    NSString *sort;
    
    NSArray *filtrateAry;
    UIButton *btn;
}
//列表数组
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, assign) NSInteger pageNO;
@property (nonatomic, strong) DistributionFilterView *filterView;
@end

@implementation DistributionSpreadGoodsListViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
  
    self.title = @"分销商品";
    self.dataSource = [NSMutableArray array];
    tab = @"101";
    sort = @"0";
    
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenWidth(), 49)];
    headerView.backgroundColor = [UIColor whiteColor];
    
    button = [UIButton buttonWithType:(UIButtonTypeCustom)];
    button.frame = CGRectMake(0, 0, 80, 49);
    button.backgroundColor = [UIColor whiteColor];
    button.titleLabel.font = [UIFont systemFontOfSize:13];
    [button setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
    [button setTitle:@"佣金" forState:(UIControlStateNormal)];
    //    [button setImage:[UIImage imageNamed:@"下箭头红色"] forState:(UIControlStateNormal)];
    //    [button setImage:[UIImage imageNamed:@"上箭头红色"] forState:(UIControlStateSelected)];
    [button setImage:[UIImage imageNamed:@"灰色状态"] forState:(UIControlStateNormal)];
    [button addTarget:self action:@selector(commissionAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [button br_layoutButtonWithEdgeInsetsStyle:(BRButtonEdgeInsetsStyleRight) imageTitleSpace:10];
    
    [headerView addSubview:button];
    
    button1 = [UIButton buttonWithType:(UIButtonTypeCustom)];
    button1.frame = CGRectMake(80, 0, 80, 49);
    button1.backgroundColor = [UIColor whiteColor];
    [button1 setTitle:@"价格" forState:(UIControlStateNormal)];
    [button1 setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
    button1.titleLabel.font = [UIFont systemFontOfSize:13];
    //    [button1 setImage:[UIImage imageNamed:@"下箭头红色"] forState:(UIControlStateNormal)];
    //    [button1 setImage:[UIImage imageNamed:@"上箭头红色"] forState:(UIControlStateSelected)];
    [button1 setImage:[UIImage imageNamed:@"灰色状态"] forState:(UIControlStateNormal)];
    [button1 addTarget:self action:@selector(priceAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [button1 br_layoutButtonWithEdgeInsetsStyle:(BRButtonEdgeInsetsStyleRight) imageTitleSpace:10];
    [headerView addSubview:button1];
    [self.view addSubview:headerView];
    
    
    btn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    btn.backgroundColor = [UIColor whiteColor];
    btn.frame = CGRectMake(screenWidth()-80, 0,80, 49);
    [btn setTitle:@"筛选 " forState:(UIControlStateNormal)];
    [btn setImage:[UIImage imageNamed:@"筛选"] forState:(UIControlStateNormal)];
    btn.titleLabel.textAlignment = NSTextAlignmentRight;
    btn.titleLabel.font = [UIFont systemFontOfSize:13];
    [btn setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
    [btn br_layoutButtonWithEdgeInsetsStyle:(BRButtonEdgeInsetsStyleRight) imageTitleSpace:5];
    [btn addTarget:self action:@selector(changeList) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:btn];
    
    
    UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(screenWidth()-80, 10, 1, 29)];
    lab.backgroundColor = CBackgroundColor;
    [self.view addSubview:lab];
    
    
    UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(0, 49, screenWidth(), 1)];
    line.backgroundColor = CBackgroundColor;
    [self.view addSubview:line];
    
    
    
    [self loadData];
    
    self.pageNO = 1;
    self.tableView.frame = CGRectMake(0, 50, screenWidth(), screenHeight()-50-UI_navBar_Height);
    
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
    [self.tableView registerNib:[UINib nibWithNibName:@"DistributionGoodsListTableViewCell" bundle:nil] forCellReuseIdentifier:@"DistributionGoodsListTableViewCell"];
    // Do any additional setup after loading the view.
}
#pragma mark - 点击背景刷新时执行
- (void)noDataBeginRefresh {
    [self lq_endLoading];
    [self loadData];
}
- (void)changeList{
    
    self.filterView.frame = CGRectMake(0, 0, kScreenWidth, 0);
    UIView *rootView = [[UIApplication sharedApplication] keyWindow];
    [rootView addSubview:self.filterView];
    self.filterView.frame = CGRectMake(0, ZM_StatusBarHeight, kScreenWidth, kScreenHeight-ZM_StatusBarHeight);
    _filterView.ary = filtrateAry;
}
- (DistributionFilterView *)filterView {
    if (!_filterView) {
        _filterView = [[DistributionFilterView alloc] initWithFrame:CGRectMake(0, ZM_StatusBarHeight, kScreenWidth, kScreenHeight-ZM_StatusBarHeight)];
        __weak typeof(self) weakSelf = self;
        _filterView.myBlock = ^(NSArray *ary) {
            
            filtrateAry = [NSArray arrayWithArray:ary];
            weakSelf.pageNO = 1;
            
            [weakSelf loadData];
            if ( ([filtrateAry[0] isEqualToString:@"-1"] || [filtrateAry[0] isEqualToString:@"0"]) && ([filtrateAry[1] isEqualToString:@"-1"] || [filtrateAry[1] isEqualToString:@"0"]) && ([filtrateAry[2] isEqualToString:@"-1"] || [filtrateAry[2] isEqualToString:@"0"] )) {
                [btn setImage:[UIImage imageNamed:@"筛选"] forState:(UIControlStateNormal)];
                [btn setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
            }else{
                [btn setImage:[UIImage imageNamed:@"筛选 -hong"] forState:(UIControlStateNormal)];
                [btn setTitleColor:CNavBgColor forState:(UIControlStateNormal)];
            }
        };
    }
    
    return _filterView;
}



#pragma mark —————     请求列表数据  --———

- (void)loadData{
    
    
    NSMutableDictionary *parmDic = [NSMutableDictionary dictionary];
    [parmDic setObject:tab forKey:@"tab"];
    [parmDic setObject:sort forKey:@"sort"];
    [parmDic setObject:[NSNumber numberWithInteger:self.pageNO] forKey:@"page"];
    if ([filtrateAry[0] length]==0 || [filtrateAry[0] isEqualToString:@"-1"]) {
        [parmDic setObject:@"" forKey:@"cate_id"];
    }else{
        [parmDic setObject:filtrateAry[0]  forKey:@"cate_id"];
    }
    if ([filtrateAry[1] length]==0 || [filtrateAry[1] isEqualToString:@"-1"]) {
        [parmDic setObject:@"" forKey:@"cate_son_id"];
    }else{
        [parmDic setObject:filtrateAry[1] forKey:@"cate_son_id"];
    }
    if ([filtrateAry[2] length]==0 || [filtrateAry[2] isEqualToString:@"-1"]) {
        [parmDic setObject:@"" forKey:@"subject_id"];
    }else{
        [parmDic setObject:filtrateAry[2] forKey:@"subject_id"];
    }
    
    BADataEntity *entity = [BADataEntity new];
    entity.urlString = @"/distribution/distribution_goods_list";
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
    DistributionSpreadGoodsListModel *model = [[DistributionSpreadGoodsListModel alloc]initWithDictionary:data error:nil];
    
    [self.dataSource addObjectsFromArray:model.data];
    [self setEmptyViewDelegeta];
    
    [self.tableView reloadData];
    
    
    
}
#pragma mark - UITableViewDataSource, UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 123;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DistributionGoodsListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DistributionGoodsListTableViewCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = self.dataSource[indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DistributionSpreadGoodsListData *model = self.dataSource[indexPath.row];
    CourseDetailViewController *vc = [[CourseDetailViewController alloc]init];
    vc.ID = model.goods_id;
    vc.titleIndex = model.goods_type;
    vc.coursePrice = model.goods_discount_price;
    vc.courseTitle = model.goods_title;
    vc.distribute  = @"1";
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)commissionAction:(UIButton *)sender {
    [button1 setImage:[UIImage imageNamed:@"灰色状态"] forState:(UIControlStateNormal)];
    tab = @"101";
    sender.selected = !sender.selected;
    if (sender.selected) {
        sort = @"0";
        [button setImage:[UIImage imageNamed:@"下箭头红色"] forState:(UIControlStateNormal)];
        button.selected = YES;
        
    }else{
        sort = @"1";
        [button setImage:[UIImage imageNamed:@"上箭头红色"] forState:(UIControlStateNormal)];
        button.selected = NO;
    }
    
    self.pageNO = 1;
    
    //进入刷新状态
    [self.tableView.tg_header beginRefreshing];
}

- (void)priceAction:(UIButton *)sender {
    tab = @"102";
    [button setImage:[UIImage imageNamed:@"灰色状态"] forState:(UIControlStateNormal)];
    sender.selected = !sender.selected;
    if (sender.selected) {
        sort = @"0";
        [button1 setImage:[UIImage imageNamed:@"下箭头红色"] forState:(UIControlStateNormal)];
        button1.selected = YES;
    }else{
        sort = @"1";
        [button1 setImage:[UIImage imageNamed:@"上箭头红色"] forState:(UIControlStateNormal)];
        button1.selected = NO;
        
    }
    
    self.pageNO = 1;
    //进入刷新状态
    [self.tableView.tg_header beginRefreshing];
}
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIImage imageNamed:@"无购买课程"];
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

