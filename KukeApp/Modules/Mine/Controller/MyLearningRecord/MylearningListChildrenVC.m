//
//  MylearningViewController.m
//  KukeApp
//
//  Created by 库课 on 2019/7/18.
//  Copyright © 2019 KukeZangMing. All rights reserved.
//

#import "MylearningListChildrenVC.h"
#import "MylearningRecordListModel.h"
#import "MyCourseListTableViewCell.h"
#import "MyLearningRecordViewController.h"
@interface MylearningListChildrenVC (){

    MyLearningListDataModel *continueLearningData;

    NSString *cateID;
}
//列表数组
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, assign) NSInteger pageNO;

@end

@implementation MylearningListChildrenVC

- (void)viewDidLoad {
    [super viewDidLoad];

    self.pageNO = 1;
    self.dataSource = [NSMutableArray array];
    
    self.tableView.frame = CGRectMake(0, 0, KScreenWidth, screenHeight()-UI_navBar_Height-50);
    [self.tableView registerNib:[UINib nibWithNibName:@"MyCourseListTableViewCell" bundle:nil] forCellReuseIdentifier:@"MyCourseListTableViewCell"];
//    [self loadData];

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
- (void)setCate_id:(NSString *)cate_id{
    cateID = cate_id;
    self.dataSource = [NSMutableArray array];
    self.pageNO = 1;
    [self loadData];
}
#pragma mark —————     请求列表数据  --———
- (void)loadData{

    
    if ([cateID isEqualToString:@"1"]) {
        NSMutableDictionary *parmDic = [NSMutableDictionary dictionary];
        [parmDic setObject:[NSNumber numberWithInteger:self.pageNO] forKey:@"page"];
        BADataEntity *entity = [BADataEntity new];
        entity.urlString = @"/ucenter/live_progress";
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
    }else{
        NSMutableDictionary *parmDic = [NSMutableDictionary dictionary];
        [parmDic setObject:cateID forKey:@"tab"];
        [parmDic setObject:[NSNumber numberWithInteger:self.pageNO] forKey:@"page"];
        BADataEntity *entity = [BADataEntity new];
        entity.urlString = @"/ucenter/course_progress";
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
    
    

}
#pragma mark —————  请求到的数据进行解析  --———
- (void)dataAnalysis:(id)data{
    if (self.pageNO == 1) {
        [self.dataSource removeAllObjects];
    }

    MylearningRecordListModel *model = [[MylearningRecordListModel alloc]initWithDictionary:data error:nil];
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
    MyCourseListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyCourseListTableViewCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if ([cateID isEqualToString:@"1"]) {
        cell.liveModel = self.dataSource[indexPath.row];
    }else{
        cell.models = self.dataSource[indexPath.row];
    }
    
//    if ([cell.startBtn.currentTitle isEqualToString:@"继续学习"]) {
//        continueLearningData = self.dataSource[indexPath.row];
//        [cell.startBtn addTarget:self action:@selector(continueLearningAction) forControlEvents:(UIControlEventTouchUpInside)];
//    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MyLearningListDataModel *models = self.dataSource[indexPath.row];
//    MyCourseListTableViewCell * cell = (MyCourseListTableViewCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
    if ([models.learn_status isEqualToString:@"1"] ) {
        MyLearningRecordViewController *vc = [[MyLearningRecordViewController alloc]init];
       
        if ([cateID isEqualToString:@"1"]) {
            vc.continueLearningID = models.last_node_id;
            vc.isLive = YES;
            vc.imageUrl = models.img;
            vc.course_name = models.title;
            vc.course_lesson_num = models.lesson_num;
            vc.course_id = models.live_id;
            vc.living = models.live_status;
            vc.course_discount_price = models.discount_price;
        }else
        {
            vc.continueLearningID = models.last_node_id;
            vc.isLive = NO;
            vc.imageUrl = models.course_img;
            vc.course_name = models.course_title;
            vc.course_lesson_num = models.course_lesson_num;
            vc.course_id = models.course_id;
            vc.course_discount_price = models.course_discount_price;
        }
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        MyLearningRecordViewController *vc = [[MyLearningRecordViewController alloc]init];
        
        if ([cateID isEqualToString:@"1"]) {
            vc.continueLearningID = @"";
            vc.isLive = YES;
            vc.imageUrl = models.img;
            vc.course_name = models.title;
            vc.course_lesson_num = models.lesson_num;
            vc.course_id = models.live_id;
            vc.course_discount_price = models.discount_price;
        }else
        {
            
            vc.continueLearningID = models.last_node_id;
            vc.isLive = NO;
            vc.imageUrl = models.course_img;
            vc.course_name = models.course_title;
            vc.course_lesson_num = models.course_lesson_num;
            vc.course_id = models.course_id;
            vc.course_discount_price = models.course_discount_price;
        }
        [self.navigationController pushViewController:vc animated:YES];
    }




}
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIImage imageNamed:@"无购买课程"];
}
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *title = @"暂无听课记录哦～";
    NSDictionary *attributes = @{
                                 NSFontAttributeName:[UIFont systemFontOfSize:13.0f],
                                 NSForegroundColorAttributeName:[UIColor colorWithHexString:@"8a8a8a"]
                                 };
    return [[NSAttributedString alloc] initWithString:title attributes:attributes];
}
@end
