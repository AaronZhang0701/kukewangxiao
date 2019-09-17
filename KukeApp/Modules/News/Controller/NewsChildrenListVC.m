//
//  NewsChildrenListVC.m
//  KukeApp
//
//  Created by 库课 on 2019/5/13.
//  Copyright © 2019 KukeZangMing. All rights reserved.
//

#import "NewsChildrenListVC.h"
#import "NewsListTableViewCell.h"
#import "CourseListModel.h"
#import "NewsHeaderView.h"
#import "ZMTabPagerView.h"
#import "NewsListHeaderFiltrateView.h"
@interface NewsChildrenListVC (){

    NSString *cityId;
}
//列表数组
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, assign) NSInteger pageNO;
@property (nonatomic, strong) NewsHeaderView *headerView;
@property (nonatomic, strong) NSArray *datas;
@property (nonatomic, strong) NSString *oid;
@property (nonatomic, strong) UIButton *selectBtn;
@property (nonatomic, strong) NewsListHeaderFiltrateView *filtrateView;
@end

@implementation NewsChildrenListVC

- (void)viewDidLoad {
    [super viewDidLoad];

    self.pageNO = 1;
    self.dataSource = [NSMutableArray array];
    _headerView = [[NewsHeaderView alloc]initWithFrame:CGRectMake(0, 0, screenWidth(), 48)];
    [_headerView addSubview:self.selectBtn];
    [self.view addSubview:_headerView];
    if (![CoreStatus isNetworkEnable]) {
        [self loadData];
    }else{
        _headerView.news_cate_id = self.news_cate_id;
        [self loadHeaderData];
    }
    
    
    self.tableView.frame =CGRectMake(0, 48, KScreenWidth,screenHeight()-UI_navBar_Height-48);
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
    [self.tableView registerNib:[UINib nibWithNibName:@"NewsListTableViewCell" bundle:nil] forCellReuseIdentifier:@"NewsListTableViewCell"];
}
- (void)loadHeaderData{
    __weak typeof(self) weakSelf = self;
    _headerView.newsTypeActionBlock = ^(NSString *newsType) {
        weakSelf.oid = newsType;
        [weakSelf.dataSource removeAllObjects];
        [weakSelf.selectBtn setImage:[UIImage imageNamed:@"筛选"] forState:(UIControlStateNormal)];
        [weakSelf.selectBtn setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
        [weakSelf.tableView.mj_footer resetNoMoreData];
        [weakSelf.tableView reloadData];
        weakSelf.pageNO = 1;
        [weakSelf loadData];
        [weakSelf.tableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:NO];
        weakSelf.filtrateView.city_id = 0;
    };
}
#pragma mark - 点击背景刷新时执行
- (void)noDataBeginRefresh {
    [self lq_endLoading];
     _headerView.news_cate_id = self.news_cate_id;
    [self loadHeaderData];
    [self loadData];
}
- (UIButton *)selectBtn {
    if (!_selectBtn) {
        _selectBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        _selectBtn.backgroundColor = [UIColor whiteColor];
        _selectBtn.frame = CGRectMake(screenWidth()-60, 0,60, 40);
        [_selectBtn setTitle:@"筛选 " forState:(UIControlStateNormal)];
        [_selectBtn setImage:[UIImage imageNamed:@"筛选"] forState:(UIControlStateNormal)];
        _selectBtn.titleLabel.textAlignment = NSTextAlignmentRight;
        _selectBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [_selectBtn setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
        [_selectBtn LX_SetShadowPathWith:[UIColor blackColor] shadowOpacity:0.3 shadowRadius:2 shadowSide:LXShadowPathLeft shadowPathWidth:2];
        [_selectBtn br_layoutButtonWithEdgeInsetsStyle:(BRButtonEdgeInsetsStyleRight) imageTitleSpace:5];
        [_selectBtn addTarget:self action:@selector(changeList) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _selectBtn;
}

- (void)setPush_oid:(NSString *)push_oid{
    _headerView.push_oid = push_oid;
}
#pragma mark —————     请求列表数据  --———
-(void)loadData{

    NSMutableDictionary *parmDic = [NSMutableDictionary dictionary];
    [parmDic setObject:self.news_cate_id forKey:@"id"];
    [parmDic setObject:@"" forKey:@"tid"];
    [parmDic setObject:self.oid forKey:@"oid"];
    [parmDic setObject:@"10" forKey:@"limit"];
    [parmDic setObject:cityId forKey:@"city_id"];
    [parmDic setObject:[NSNumber numberWithInteger:self.pageNO] forKey:@"page"];
    BADataEntity *entity = [BADataEntity new];
    entity.urlString = @"/news/news_list";
    entity.needCache = NO;
    entity.parameters = parmDic;
    if (![CoreStatus isNetworkEnable]) {
        self.tableView.emptyDataSetSource = nil;
        self.tableView.emptyDataSetDelegate = nil;
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
    
    CourseListModel *model = [[CourseListModel alloc]initWithDictionary:data error:nil];
    [self.dataSource addObjectsFromArray:model.data];
    [self setEmptyViewDelegeta];
    
    [self.tableView reloadData];
    
    
}


#pragma mark - UITableViewDataSource, UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
//    return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 109;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NewsListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NewsListTableViewCell" forIndexPath:indexPath];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = self.dataSource[indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CourseDataAryModel *model = self.dataSource[indexPath.row];
//    RootWebViewController *vc = [[RootWebViewController alloc]initWithUrl:model.url];
//    [self.navigationController pushViewController:vc animated:YES];
//    CourseDataAryModel *model = self.dataSource[indexPath.row];
//
//
    if ([UserDefaultsUtils boolValueWithKey:KIsAudit]){
        
    }else{
        HomePageBannerViewController *vc = [[HomePageBannerViewController alloc]init];
        vc.url = model.url;
        vc.title = @"资讯详情";
        [self.navigationController pushViewController:vc animated:YES];
    }
   
}
- (void)changeList{
    
    self.filtrateView.frame = CGRectMake(0, 0, kScreenWidth, 0);
    UIView *rootView = [[UIApplication sharedApplication] keyWindow];
    self.filtrateView.tag = 10001;
    [rootView addSubview:self.filtrateView];
    self.filtrateView.frame = CGRectMake(0, ZM_StatusBarHeight, kScreenWidth, kScreenHeight-ZM_StatusBarHeight);
    [self.filtrateView loadDataWithNewsCateId:self.news_cate_id NewsOid:self.oid];
}
- (NewsListHeaderFiltrateView *)filtrateView {
    if (!_filtrateView) {
        _filtrateView = [[NewsListHeaderFiltrateView alloc] initWithFrame:CGRectMake(0, ZM_StatusBarHeight, kScreenWidth, kScreenHeight-ZM_StatusBarHeight)];
        __weak typeof(self) weakSelf = self;
        _filtrateView.myBlock = ^(NSInteger city_id) {

            cityId = [NSString stringWithFormat:@"%ld",city_id];
            weakSelf.pageNO = 1;
   
            [weakSelf loadData];
            if (city_id == 0) {
//                weakSelf.selectBtn.selected = NO;
                [weakSelf.selectBtn setImage:[UIImage imageNamed:@"筛选"] forState:(UIControlStateNormal)];
                [weakSelf.selectBtn setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
            }else{
                [weakSelf.selectBtn setImage:[UIImage imageNamed:@"筛选 -hong"] forState:(UIControlStateNormal)];
                [weakSelf.selectBtn setTitleColor:CNavBgColor forState:(UIControlStateNormal)];
//                weakSelf.selectBtn.selected = YES;
            }
        };
    }
    
    return _filtrateView;
}
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIImage imageNamed:@"无数据"];
}
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *title = @"暂无数据哦~";
    NSDictionary *attributes = @{
                                 NSFontAttributeName:[UIFont systemFontOfSize:13.0f],
                                 NSForegroundColorAttributeName:[UIColor colorWithHexString:@"8a8a8a"]
                                 };
    return [[NSAttributedString alloc] initWithString:title attributes:attributes];
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    NSDictionary *dict =[[NSDictionary alloc]initWithObjectsAndKeys:[NSString stringWithFormat:@"%f",self.tableView.contentOffset.y],@"CollectionOffSet", nil];
    KPostNotification(@"NewsListOffSet", dict);
    
}
@end
