//
//  MyCourseBaseTableViewController.m
//  KukeApp
//
//  Created by iOSDeveloper on 2018/10/18.
//  Copyright © 2018年 KukeZangMing. All rights reserved.
//

#import "MyCourseAndTestTableViewController.h"
#import "CourseListModel.h"
#import "CourseSelectionModel.h"
#import "CourseDetailViewController.h"
#import "MyLearningRecordViewController.h"
#import "MyAnswerViewController.h"
#import "MyBuyGoodsTableViewCell.h"
@interface MyCourseAndTestTableViewController (){
    //考试动态0。 备考指导1
    NSInteger titleIndex;

}
@property (nonatomic, assign) NSInteger pageNO;
//列表数组
@property (nonatomic, strong) NSMutableArray *dataSource;
@end

@implementation MyCourseAndTestTableViewController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO];
    //    [AppUtiles setTabBarHidden:YES];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];

    self.pageNO = 1;

    [self initData];
    
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
    [self initData];
}
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    
    
    
    switch (titleIndex) {
    case 0:{//已购课程
         return [UIImage imageNamed:@"无购买课程"];
    };break;
    case 1:{//听课记录
          return [UIImage imageNamed:@"无购买课程"];
    };break;
    case 2:{//已购题库
        return [UIImage imageNamed:@"无试卷"];
    };break;
    case 3:{//答题记录
         return [UIImage imageNamed:@"无试卷"];
    };break;
    default:{//答题记录
        return [UIImage imageNamed:@"无试卷"];
    };break;
    }
    
   
}
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *title = @"您还没有购买任何试卷哦~";
    NSDictionary *attributes = @{
                                 NSFontAttributeName:[UIFont systemFontOfSize:13.0f],
                                 NSForegroundColorAttributeName:[UIColor colorWithHexString:@"8a8a8a"]
                                 };
    return [[NSAttributedString alloc] initWithString:title attributes:attributes];
}
#pragma mark —————     请求列表数据  --———
- (void)initData{
    self.dataSource = [NSMutableArray array];
    self.pageNO = 1;
    titleIndex = self.type;
    [self loadData];
    
}
-(void)loadData{
    switch (titleIndex) {
        case 0:{//已购课程
            NSMutableDictionary *parmDic = [NSMutableDictionary dictionary];
 
            [parmDic setObject:@"10" forKey:@"limit"];
            [parmDic setObject:[NSNumber numberWithInteger:self.pageNO] forKey:@"page"];
            [ZMNetworkHelper POST:@"/ucenter/course" parameters:parmDic cache:YES responseCache:^(id responseCache) {
                
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
                if(self.pageNO >1) {
                    [self.tableView.mj_footer endRefreshing];
                }else{
                   
                            [self.tableView.tg_header endRefreshing];
                    
                }
                if ([[responseObject objectForKey:@"data"] count] < 10 && self.pageNO >1) {
                    [self.tableView.mj_footer endRefreshingWithNoMoreData];
                }
            } failure:^(NSError *error) {
                
            }];
            
            
        };break;
        case 1:{//听课记录
            NSMutableDictionary *parmDic = [NSMutableDictionary dictionary];
            [parmDic setObject:@"10" forKey:@"limit"];
            [parmDic setObject:[NSNumber numberWithInteger:self.pageNO] forKey:@"page"];
            [ZMNetworkHelper POST:@"/ucenter/course_log" parameters:parmDic cache:YES responseCache:^(id responseCache) {
                
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
                if(self.pageNO >1) {
                    [self.tableView.mj_footer endRefreshing];
                }else{
                            [self.tableView.tg_header endRefreshing];
                
                }
                if ([[responseObject objectForKey:@"data"] count] < 10 && self.pageNO >1) {
                    [self.tableView.mj_footer endRefreshingWithNoMoreData];
                }
            } failure:^(NSError *error) {
                
            }];
            
        };break;
        case 2:{//已购题库
            NSMutableDictionary *parmDic = [NSMutableDictionary dictionary];
            [parmDic setObject:@"10" forKey:@"limit"];
            [parmDic setObject:[NSNumber numberWithInteger:self.pageNO] forKey:@"page"];
            BADataEntity *entity = [BADataEntity new];
            entity.urlString = @"/ucenter/exam";
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
        };break;
        case 3:{//答题记录
            NSMutableDictionary *parmDic = [NSMutableDictionary dictionary];
            [parmDic setObject:@"10" forKey:@"limit"];
            [parmDic setObject:[NSNumber numberWithInteger:self.pageNO] forKey:@"page"];

            BADataEntity *entity = [BADataEntity new];
            entity.urlString = @"/ucenter/exam_log";
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
        };break;
        default:
            break;
    }
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
    if (self.type ==0) {
        MyLearningRecordViewController *vc = [[MyLearningRecordViewController alloc]init];
        vc.imageUrl = model.img;
        vc.course_name = model.title;
        vc.continueLearningID = @"";
        vc.course_lesson_num = model.lesson_num;
        vc.course_discount_price = model.discount_price;
        vc.course_id = model.ID;
        [self.navigationController pushViewController:vc animated:YES];
       
    }else if(self.type == 2){
        MyAnswerViewController *vc = [[MyAnswerViewController alloc]init];
        vc.imageUrl = model.img;
        vc.testPaper_id = model.ID;
        vc.testPaper_title = model.title;
        [self.navigationController pushViewController:vc animated:YES];
    }
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}





@end
