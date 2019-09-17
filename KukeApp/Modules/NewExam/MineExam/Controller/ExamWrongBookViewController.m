//
//  ExamWrongBookViewController.m
//  KukeApp
//
//  Created by 库课 on 2019/8/9.
//  Copyright © 2019 KukeZangMing. All rights reserved.
//

#import "ExamWrongBookViewController.h"
#import "ExamWrongBookTableViewCell.h"
#import "ExamListViewModel.h"
@interface ExamWrongBookViewController (){

}

@property (nonatomic,strong) ExamListViewModel *viewModel;
@property (nonatomic, strong) NSMutableArray *dataAry;
@end

@implementation ExamWrongBookViewController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO];
    
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataAry = [NSMutableArray array];
    if ([self.bookType isEqualToString:@"1"]) {
        self.title = @"错题本";
    }else{
        self.title = @"收藏本";
    }

    self.view.backgroundColor = [UIColor whiteColor];
    [self loadData];

    [self.tableView registerNib:[UINib nibWithNibName:@"ExamWrongBookTableViewCell" bundle:nil] forCellReuseIdentifier:@"ExamWrongBookTableViewCell"];
    
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
    [self.viewModel loadWrongBookorCollectionBookWtihCateId:self.cate_id bookType:self.bookType bookData:^(id  _Nonnull obj) {

        [self.dataAry addObjectsFromArray:obj[@"data"]];
        
        
        [self setEmptyViewDelegeta];
        
        [self.tableView reloadData];
    } fromController:self];
    
    
}

#pragma mark - UITableViewDataSource, UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataAry.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 88;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ExamWrongBookTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ExamWrongBookTableViewCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell configCellWithData:self.dataAry[indexPath.row] bookType:self.bookType];
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

