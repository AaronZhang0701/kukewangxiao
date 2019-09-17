//
//  MyPurchasedCourseChildrenVC.m
//  KukeApp
//
//  Created by 库课 on 2019/7/18.
//  Copyright © 2019 KukeZangMing. All rights reserved.
//

#import "MyPurchasedCourseChildrenVC.h"
#import "CourseListModel.h"
#import "CourseSelectionModel.h"
#import "CourseDetailViewController.h"
#import "MyLearningRecordViewController.h"
#import "MyBuyGoodsTableViewCell.h"
@interface MyPurchasedCourseChildrenVC (){
    //考试动态0。 备考指导1
    NSInteger titleIndex;

    NSString *cateID;
}
//列表数组
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, assign) NSInteger pageNO;
@end

@implementation MyPurchasedCourseChildrenVC
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO];
    //    [AppUtiles setTabBarHidden:YES];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];

    self.pageNO = 1;
    self.tableView.frame = CGRectMake(0, 0, screenWidth(), screenHeight()-50-UI_navBar_Height);
    self.dataSource = [NSMutableArray array];
    [self.tableView registerNib:[UINib nibWithNibName:@"MyBuyGoodsTableViewCell" bundle:nil] forCellReuseIdentifier:@"MyBuyGoodsTableViewCell"];
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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadData) name:KNotificationLoginUpdata object:nil];
    // Do any additional setup after loading the view.
}
#pragma mark - 点击背景刷新时执行
- (void)noDataBeginRefresh {
    [self lq_endLoading];
    [self loadData];
}

#pragma mark —————     请求列表数据  --———

- (void)setCate_id:(NSString *)cate_id{
    cateID = cate_id;
    self.dataSource = [NSMutableArray array];
    self.pageNO = 1;
    [self loadData];
}

-(void)loadData{
    NSMutableDictionary *parmDic = [NSMutableDictionary dictionary];
    [parmDic setObject:cateID forKey:@"tab"];
    [parmDic setObject:@"10" forKey:@"limit"];
    [parmDic setObject:[NSNumber numberWithInteger:self.pageNO] forKey:@"page"];
    
    BADataEntity *entity = [BADataEntity new];
    entity.urlString = @"/ucenter/course";
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
    
    CourseListModel *model = [[CourseListModel alloc]initWithDictionary:data error:nil];
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
    MyBuyGoodsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyBuyGoodsTableViewCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.cateID = cateID;
    cell.model = self.dataSource[indexPath.row];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
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

    CourseDataAryModel *model= self.dataSource[indexPath.row];
    MyLearningRecordViewController *vc = [[MyLearningRecordViewController alloc]init];
    if ([cateID isEqualToString:@"1"]) {
        vc.isLive = YES;
    }else
    {
        vc.isLive = NO;
    }
    vc.imageUrl = model.img;
    vc.course_name = model.title;
    vc.continueLearningID = @"";//1、已购课程需要传入课程信息，进行点击购买时使用，学习记录不用传是因为l学习记录q获取vid时会获取到课程信息  2、已购里面没有记录播放信息，这个值为空，学习记录里进播放页面有是为学习过的，所有有值
    vc.course_lesson_num = model.lesson_num;
    vc.course_discount_price = model.discount_price;
    vc.course_id = model.ID;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    
    return [UIImage imageNamed:@"无购买课程"];
    
}
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *title = @"您还没有购买任何课程哦~";
    NSDictionary *attributes = @{
                                 NSFontAttributeName:[UIFont systemFontOfSize:13.0f],
                                 NSForegroundColorAttributeName:[UIColor colorWithHexString:@"8a8a8a"]
                                 };
    return [[NSAttributedString alloc] initWithString:title attributes:attributes];
}

@end
