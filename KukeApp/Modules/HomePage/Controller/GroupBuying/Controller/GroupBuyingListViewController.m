//
//  GroupBuyingListViewController.m
//  KukeApp
//
//  Created by 库课 on 2019/1/10.
//  Copyright © 2019 zhangming. All rights reserved.
//

#import "GroupBuyingListViewController.h"
#import "GroupBuyingListTableViewCell.h"
#import "CourseDetailViewController.h"
@interface GroupBuyingListViewController (){
    

    HomePageAdModel *dict;

}
//列表数组
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, assign) NSInteger pageNO;
@end

@implementation GroupBuyingListViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO];
    //    [self.tableView.mj_header beginRefreshing];
//    [self loadData];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.dataSource = [NSMutableArray array];


    [self loadData];

    self.pageNO = 1;
    self.title = @"库拼团";
    [self.tableView registerNib:[UINib nibWithNibName:@"GroupBuyingListTableViewCell" bundle:nil] forCellReuseIdentifier:@"GroupBuyingListTableViewCell"];
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
    entity.urlString = @"/groupbuy/group_list";
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
        if ([[response [@"data"] objectForKey:@"group"] count] < 10 && self.pageNO >1) {
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
    
    HomePageMenuModel *model = [[HomePageMenuModel alloc]initWithDictionary:data error:nil];
    dict = model.data.ad;
    [self.dataSource addObjectsFromArray:model.data.group];
    
    
    [self setEmptyViewDelegeta];
    
    [self.tableView reloadData];
 
    
    
}
#pragma mark - UITableViewDataSource, UITableViewDelegate


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 124;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GroupBuyingListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GroupBuyingListTableViewCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = self.dataSource[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    HomeGroupBuyingModel *model = self.dataSource[indexPath.row];
    CourseDetailViewController *vc = [[CourseDetailViewController alloc]init];
    vc.ID = model.goods_id;
    vc.titleIndex = model.goods_type;
    vc.coursePrice = model.group_buy_price;
    vc.courseTitle = model.goods_name;
    vc.ac_type = @"3";
    [self.navigationController pushViewController:vc animated:YES];
    
}
//头视图高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (dict.image.length == 0) {
        return 0;
    }else{
        return 190;
    }
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if (dict.image.length == 0) {
        return [[UIView alloc]init];
    }else{
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth(), 190)];
        
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, screenWidth(), 190)];
        [headerView addSubview:imageView];
        [imageView sd_setImageWithURL:[NSURL URLWithString:dict.image] placeholderImage:[UIImage imageNamed:@"goodsImage"]];
        imageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(adAction)];
        tap1.cancelsTouchesInView = NO;
        [imageView addGestureRecognizer:tap1];
        return headerView;
    }
   

}
- (void)adAction{
    if (dict.url.length != 0) {
        HomePageBannerViewController *vc = [[HomePageBannerViewController alloc]init];
        vc.url = dict.url;
        vc.title = @"详情";
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    
}
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIImage imageNamed:@"无购买课程"];
}
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *title = @"暂无团购商品哦～";
    NSDictionary *attributes = @{
                                 NSFontAttributeName:[UIFont systemFontOfSize:13.0f],
                                 NSForegroundColorAttributeName:[UIColor colorWithHexString:@"8a8a8a"]
                                 };
    return [[NSAttributedString alloc] initWithString:title attributes:attributes];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat sectionHeaderHeight = 190;
    if (scrollView.contentOffset.y <= sectionHeaderHeight && scrollView.contentOffset.y >= 0)
    {
        scrollView.contentInset = UIEdgeInsetsMake(- scrollView.contentOffset.y, 0, 0, 0);
    }
    else if (scrollView.contentOffset.y >= sectionHeaderHeight)
    {
        scrollView.contentInset = UIEdgeInsetsMake(- sectionHeaderHeight, 0, 0, 0);
    }
}

@end
