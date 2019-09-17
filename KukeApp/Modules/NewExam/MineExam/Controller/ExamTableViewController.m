//
//  ExamTableViewController.m
//  KukeApp
//
//  Created by 库课 on 2019/8/7.
//  Copyright © 2019 KukeZangMing. All rights reserved.
//

#import "ExamTableViewController.h"
#import "ExamListHeaderView.h"
#import "MyCourseListTableViewCell.h"
#import "ExamListViewModel.h"
#import "MyAnswerViewController.h"
#import "ExamWrongBookViewController.h"
#import "ExamProposeViewController.h"
@interface ExamTableViewController (){

}

@property (nonatomic,strong) ExamListHeaderView *headerView;
@property (nonatomic,strong) ExamListViewModel *viewModel;
@property (nonatomic, assign) NSInteger pageNO;
@property (nonatomic, strong) NSMutableArray *dataAry;
@end

@implementation ExamTableViewController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO];
    
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataAry = [NSMutableArray array];
    self.pageNO = 1;
    
    [self loadData];

    if (self.number == 1) {
        self.tableView.frame = CGRectMake(0, 0, screenWidth(), screenHeight()- UI_navBar_Height);
    }else{
        self.tableView.frame = CGRectMake(0, 0, screenWidth(), screenHeight()-50- UI_navBar_Height);
    }
    
    [self.tableView registerNib:[UINib nibWithNibName:@"MyCourseListTableViewCell" bundle:nil] forCellReuseIdentifier:@"MyCourseListTableViewCell"];
    

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
    [self.headerView.btn1 addTarget:self action:@selector(wrongAction) forControlEvents:(UIControlEventTouchUpInside)];
    [self.headerView.btn2 addTarget:self action:@selector(collectionAction) forControlEvents:(UIControlEventTouchUpInside)];
    [self.headerView.btn3 addTarget:self action:@selector(proposeAction) forControlEvents:(UIControlEventTouchUpInside)];
}
#pragma mark - 点击背景刷新时执行
- (void)noDataBeginRefresh {
    [self lq_endLoading];
    [self loadData];
}

- (void)loadData{
    
    self.viewModel = [[ExamListViewModel alloc]init];
    if (![CoreStatus isNetworkEnable]) {
        [self lq_showFailLoadWithType:(LQTableViewFailLoadViewTypeNoData) tipsString:@"无法连接到网络,点击页面刷新"];
        self.tableView.tableHeaderView = nil;
        return;
    }else{
        self.tableView.tableHeaderView = self.headerView;
        self.tableView.loading = YES;
    }
    [self.viewModel loadListDataWithCateID:self.exam_cate_id page:self.pageNO titleBack:^(MineExamListModel * _Nonnull model) {
 
        if(self.pageNO >1) {
            [self endRefreshWithFooterHidden];
        }else{
            
            [self endWaterDropRefreshWithHeaderHidden];
        }
        if (model.data.record.count< 10 && self.pageNO >1) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
        
        if (self.pageNO == 1) {
            self.headerView.model = model.data.report;
            [self.dataAry removeAllObjects];
        }
        
        [self.dataAry addObjectsFromArray:model.data.record];
        
        
        [self setEmptyViewDelegeta];
        
        [self.tableView reloadData];
    } fromController:[[AppDelegate shareAppDelegate] getCurrentUIVC]];
}


- (ExamListHeaderView *)headerView{
    if (!_headerView) {
        _headerView = [[ExamListHeaderView alloc]initWithFrame:CGRectMake(0, 0, screenWidth(), (screenWidth()-90)/3 +107)];
     
    }
    return _headerView;
}

#pragma mark - UITableViewDataSource, UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataAry.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 123;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MyCourseListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyCourseListTableViewCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell configCellData:self.dataAry[indexPath.row]];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MyAnswerViewController *vc = [[MyAnswerViewController alloc]init];
    vc.imageUrl = [self.dataAry[indexPath.row] img];
    vc.testPaper_id = [self.dataAry[indexPath.row] exam_id];
    vc.testPaper_title =[self.dataAry[indexPath.row] title];
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)wrongAction{
    ExamWrongBookViewController *vc = [[ExamWrongBookViewController alloc]init];
    vc.cate_id = self.exam_cate_id;
    vc.bookType = @"1";
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)collectionAction{
    ExamWrongBookViewController *vc = [[ExamWrongBookViewController alloc]init];
    vc.cate_id = self.exam_cate_id;
    vc.bookType = @"2";
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)proposeAction{
    ExamProposeViewController *vc = [[ExamProposeViewController alloc]init];
    vc.cate_id = self.exam_cate_id;
    [self.navigationController pushViewController:vc animated:YES];
}

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIImage imageNamed:@"无试卷"];
}
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *title = @"暂无数据哦~";
    NSDictionary *attributes = @{
                                 NSFontAttributeName:[UIFont systemFontOfSize:13.0f],
                                 NSForegroundColorAttributeName:[UIColor colorWithHexString:@"8a8a8a"]
                                 };
    return [[NSAttributedString alloc] initWithString:title attributes:attributes];
}

@end
//- (void)layout{
//    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(42);
//        make.width.left.right.equalTo(self);
//        make.bottom.equalTo(self);
//    }];
//    [_headerView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(42);
//        make.width.left.right.equalTo(self);
//        make.height.mas_equalTo(184);
//    }];
//}
