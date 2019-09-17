//
//  ExamRankingListViewController.m
//  KukeApp
//
//  Created by 库课 on 2019/8/9.
//  Copyright © 2019 KukeZangMing. All rights reserved.
//

#import "ExamRankingListViewController.h"
#import "ExamRanKingTableViewCell.h"
#import "ExamListViewModel.h"
@interface ExamRankingListViewController ()
@property (nonatomic,strong) ExamListViewModel *viewModel;
@property (nonatomic, strong) NSMutableArray *dataAry;
@end

@implementation ExamRankingListViewController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO];
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataAry = [NSMutableArray array];
    [self loadData];
    self.tableView.frame = CGRectMake(0, 0, screenWidth(), screenHeight()-59- UI_navBar_Height);
    [self.tableView registerNib:[UINib nibWithNibName:@"ExamRanKingTableViewCell" bundle:nil] forCellReuseIdentifier:@"ExamRanKingTableViewCell"];
    // Do any additional setup after loading the view.
}
#pragma mark - 点击背景刷新时执行
- (void)noDataBeginRefresh {
    [self lq_endLoading];
    [self loadData];
}
- (void)loadData{
    if (![CoreStatus isNetworkEnable]) {
        [self lq_showFailLoadWithType:(LQTableViewFailLoadViewTypeNoData) tipsString:@"无法连接到网络,点击页面刷新"];
        return;
    }else{

        self.tableView.loading = YES;
    }
    self.viewModel = [[ExamListViewModel alloc]init];
    [self.viewModel loadExamRankingDataWithCateID:self.exam_cate_id rankingType:self.rinkingType rankingData:^(id  _Nonnull obj) {
        [self.dataAry addObjectsFromArray:obj];
        
        [self setEmptyViewDelegeta];
        
        [self.tableView reloadData];
    } fromController:[[AppDelegate shareAppDelegate] getCurrentUIVC]];

}


#pragma mark - UITableViewDataSource, UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataAry.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 70;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ExamRanKingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ExamRanKingTableViewCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell configCellWithData:self.dataAry[indexPath.row] withType:self.rinkingType];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

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


@end
