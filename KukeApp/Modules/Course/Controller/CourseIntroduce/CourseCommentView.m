//
//  CourseCommentView.m
//  KukeApp
//
//  Created by iOSDeveloper on 2018/10/1.
//  Copyright © 2018年 zhangming. All rights reserved.
//

#import "CourseCommentView.h"

@interface CourseCommentView ()<ZMEmptyDataSetSource,ZMEmptyDataSetDelegate>{
    //无数据提示
    UILabel *footerLable;
    //列表的页数
    NSInteger pageNO;
    MJRefreshAutoNormalFooter *footer;
    MJRefreshNormalHeader *header;
    NSString *course_id;
    NSInteger class_id;
    UIButton *allBtn;
    UIButton *fiveStarBtn;
    CourseCommentModel *model;
    UIView *headerView;
    NSString *kuke_star;
    BOOL isRefresh;
}
@property (nonatomic ,strong) NSMutableArray *dataAry;
@end

@implementation CourseCommentView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        pageNO = 1;
        self.tableView.loading = YES;
        self.dataAry = [NSMutableArray array];
        kuke_star = 0;
        headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth(), 55)];
        headerView.backgroundColor = [UIColor whiteColor];
        
        allBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        allBtn.frame = CGRectMake(15, 15, 84, 25);
        [allBtn setTitleColor:CNavBgColor forState:(UIControlStateNormal)];
        allBtn.titleLabel.textAlignment = NSTextAlignmentRight;
        allBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        allBtn.layer.borderWidth = 1;
        allBtn.layer.borderColor = [CNavBgColor CGColor];
        allBtn.layer.cornerRadius = 3;
        allBtn.layer.masksToBounds = YES;
        [allBtn addTarget:self action:@selector(allEvalueAction) forControlEvents:(UIControlEventTouchUpInside)];
        [headerView addSubview:allBtn];
        
        fiveStarBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        fiveStarBtn.frame = CGRectMake(maxX(allBtn)+15, 15, 84, 25);
        [fiveStarBtn setTitleColor:[UIColor lightGrayColor] forState:(UIControlStateNormal)];
        fiveStarBtn.titleLabel.textAlignment = NSTextAlignmentRight;
        fiveStarBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        fiveStarBtn.layer.borderWidth = 1;
        fiveStarBtn.layer.borderColor = [[UIColor lightGrayColor] CGColor];
        fiveStarBtn.layer.cornerRadius = 3;
        fiveStarBtn.layer.masksToBounds = YES;
        [fiveStarBtn addTarget:self action:@selector(fiveEvalueAction) forControlEvents:(UIControlEventTouchUpInside)];
        [headerView addSubview:fiveStarBtn];
        
        [self.tableView registerClass:[CourseCommentTableCell class] forCellReuseIdentifier:@"CourseCommentTableCell"];
        [self initRefresh];
        self.tableView.backgroundColor = CBackgroundColor;

    }
    return self;
}
//- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
//    return [UIImage imageNamed:@"无购买课程"];
//}
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *title = @"暂无评论";
    NSDictionary *attributes = @{
                                 NSFontAttributeName:[UIFont systemFontOfSize:13.0f],
                                 NSForegroundColorAttributeName:[UIColor colorWithHexString:@"8a8a8a"]
                                 };
    return [[NSAttributedString alloc] initWithString:title attributes:attributes];
}
- (void)getCourseID:(NSString *)ID withClass:(NSInteger)classID{
    course_id = ID;
    class_id = classID;
    NSMutableDictionary *parmDic = [NSMutableDictionary dictionary];
    [parmDic setObject:[NSNumber numberWithInteger:classID] forKey:@"goods_type"];
    [parmDic setObject:ID forKey:@"goods_id"];
    [parmDic setObject:kuke_star forKey:@"kuke_star"];
    [parmDic setObject:@"10" forKey:@"limit"];
    [parmDic setObject:[NSNumber numberWithInteger:pageNO] forKey:@"page"];
    [ZMNetworkHelper POST:@"/Stucommon/stu_discuss_v2" parameters:parmDic cache:YES responseCache:^(id responseCache) {
        
    } success:^(id responseObject) {
        if (responseObject == nil) {
            
        }else{
            if ([responseObject[@"code"] isEqualToString:@"0"]) {
                [self dataAnalysis:responseObject];
                
            }else{
                
                [BaseTools showErrorMessage:responseObject[@"msg"]];
            }
        }
        if(pageNO >1) {
            [self.tableView.mj_footer endRefreshing];
        }else{
            if (isRefresh) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    //                            self.tableView.tg_header.refreshResultStr = @"数据刷新成功";
                    [self.tableView.tg_header endRefreshing];
                });
            }
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
        [self.dataAry removeAllObjects];
    }
    
    model = [[CourseCommentModel alloc]initWithDictionary:data error:nil];
    [self.dataAry addObjectsFromArray:model.data.data];
    self.tableView.loading = NO;
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
    //通知主线程刷新
    dispatch_async(dispatch_get_main_queue(), ^{
        [allBtn setTitle:[NSString stringWithFormat:@"全部(%@)",data[@"data"][@"all_num"]] forState:(UIControlStateNormal)];
        [fiveStarBtn setTitle:[NSString stringWithFormat:@"五星(%@)",data[@"data"][@"five_num"]] forState:(UIControlStateNormal)];
        [self.tableView reloadData];
    });
   
    
    
    
}
#pragma mark - UITableViewDataSource, UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataAry.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CourseCommentTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CourseCommentTableCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = self.dataAry[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CourseCommentListModel *model = self.dataAry[indexPath.row];
    return [model.content zm_getTextHeight:[UIFont systemFontOfSize:15] width:screenWidth()-60] + [model.reply zm_getTextHeight:[UIFont systemFontOfSize:15] width:screenWidth()-90]+40  + 40 +30;
}
//头视图高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 55;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {

    
    
    UILabel *lineLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 54, screenWidth(), 1)];
    lineLab.backgroundColor = CBackgroundColor;
    [headerView addSubview:lineLab];
    
    return headerView;
    

}
- (void)fiveEvalueAction{
    [self.dataAry removeAllObjects];
    [fiveStarBtn setTitleColor:CNavBgColor forState:(UIControlStateNormal)];
    fiveStarBtn.layer.borderColor = [CNavBgColor CGColor];
    
    [allBtn setTitleColor:[UIColor lightGrayColor] forState:(UIControlStateNormal)];
    allBtn.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    
    kuke_star = @"5";
    [self getCourseID:course_id withClass:class_id];
    
    
}
- (void)allEvalueAction{
    [self.dataAry removeAllObjects];
    [allBtn setTitleColor:CNavBgColor forState:(UIControlStateNormal)];
    allBtn.layer.borderColor = [CNavBgColor CGColor];
    kuke_star = @"0";
    [fiveStarBtn setTitleColor:[UIColor lightGrayColor] forState:(UIControlStateNormal)];
    fiveStarBtn.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    [self getCourseID:course_id withClass:class_id];
}
#pragma mark - 刷新方法的初始化
//*********************刷新及网络请求********************
-(void)initRefresh{
    //设置下拉
    self.tableView.tg_header = [TGRefreshOC  refreshWithTarget:self action:@selector(headerRefresh) config:nil];
    
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
    isRefresh = YES;
    pageNO =1;
    
    [self getCourseID:course_id withClass:class_id];
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
    [self getCourseID:course_id withClass:class_id];
    
}

@end
