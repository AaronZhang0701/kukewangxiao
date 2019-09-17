//
//  MyCollectionViewController.m
//  KukeApp
//
//  Created by iOSDeveloper on 2018/10/18.
//  Copyright © 2018年 zhangming. All rights reserved.
//

#import "MyCollectionViewController.h"
#import "CourseListModel.h"
#import "HomePageRecommendTableViewCell.h"
#import "CourseDetailViewController.h"
@interface MyCollectionViewController ()<UITableViewDelegate,UITableViewDataSource,ZMEmptyDataSetSource,ZMEmptyDataSetDelegate>{

    NSString *goods_type;
    NSString *goods_id;
    NSMutableArray *idAry;
}


@property (nonatomic, strong) NSMutableArray *dataAry;
@property (nonatomic, assign)NSInteger pageNO;
/** 选中的数据 */
@property (nonatomic , strong) NSMutableArray *selectedDatas;
/** 删除 */
@property (nonatomic , strong) UIButton *deleteBtn;
/** 全选按钮 */
@property (nonatomic , strong) UIButton *selectAllBtn;
/** 底部toolBar */
@property (nonatomic , strong) UIView *toolBarView;
/** rightBarButtonItem */
@property (nonatomic , strong) UIButton *rightBarButtonItem;
@end

@implementation MyCollectionViewController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO];

}
- (NSMutableArray *)selectedDatas
{
    if (_selectedDatas == nil) {
        _selectedDatas = [[NSMutableArray alloc] init];
    }
    return _selectedDatas;
}

- (UIView *)toolBarView{
    if (_toolBarView == nil) {
        _toolBarView = [[UIView alloc]initWithFrame:CGRectMake(0,screenHeight()-50-UI_navBar_Height, screenWidth(), 50)];
        _toolBarView.hidden = YES;
    }
    return _toolBarView;
}
#pragma mark - Getter
- (UIButton *)rightBarButtonItem
{
    if (_rightBarButtonItem == nil) {
        _rightBarButtonItem = [[UIButton alloc] init];
        _rightBarButtonItem.size = CGSizeMake(100, 30);
        //        [_rightBarButtonItem setTitle:@"" forState:UIControlStateNormal];
        [_rightBarButtonItem setTitleColor:CTitleColor forState:(UIControlStateNormal)];
        //        [_rightBarButtonItem setTitle:@"取消" forState:UIControlStateSelected];
        //        [_rightBarButtonItem setTitleColor:MHGlobalBlackTextColor forState:UIControlStateNormal];
        //        [_rightBarButtonItem setTitleColor:MHGlobalGrayTextColor forState:UIControlStateDisabled];
        [_rightBarButtonItem setImage:[UIImage imageNamed:@"已完成订单删除图标"] forState:(UIControlStateNormal)];
        //        [_rightBarButtonItem setImage:[UIImage imageNamed:@""] forState:(UIControlStateSelected)];
        [_rightBarButtonItem addTarget:self action:@selector(rightBarButtonItemDidClicked:) forControlEvents:UIControlEventTouchUpInside];
        //        _rightBarButtonItem.titleLabel.font = MHFont(MHPxConvertPt(14.0f), NO);
        //        _rightBarButtonItem.mh_size = CGSizeMake(100, 44);
        _rightBarButtonItem.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    }
    return _rightBarButtonItem;
}
- (UIButton *)deleteBtn
{
    if (_deleteBtn == nil) {
        
        _deleteBtn = [[UIButton alloc] initWithFrame:CGRectMake(screenWidth()/2,0, screenWidth()/2, 50)];
        [_deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
        _deleteBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        _deleteBtn.adjustsImageWhenHighlighted = NO;
        //        [_deleteBtn setBackgroundImage:MHImageNamed(@"collectionVideo_delete_nor") forState:UIControlStateNormal];
        //        [_deleteBtn setBackgroundImage:MHImageNamed(@"collectionVideo_delete_high") forState:UIControlStateDisabled];
        [_deleteBtn setBackgroundColor:CNavBgColor];
        [_deleteBtn addTarget:self action:@selector(_deleteBtnDidClicked:) forControlEvents:UIControlEventTouchUpInside];
        //        _deleteBtn.enabled = NO;
        
    }
    return _deleteBtn;
}
- (UIButton *)selectAllBtn
{
    if (_selectAllBtn == nil) {
        
        _selectAllBtn = [[UIButton alloc] initWithFrame:CGRectMake(0,0, screenWidth()/2, 50)];
        [_selectAllBtn setTitle:@"全选" forState:UIControlStateNormal];
        [_selectAllBtn setTitle:@"取消全选" forState:UIControlStateSelected];
        [_selectAllBtn setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
        _selectAllBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        _selectAllBtn.adjustsImageWhenHighlighted = NO;
        [_selectAllBtn setBackgroundColor:[UIColor whiteColor]];
        [_selectAllBtn addTarget:self action:@selector(leftBarButtonItemDidClicked:) forControlEvents:UIControlEventTouchUpInside];
        //        _selectAllBtn.enabled = NO;
        
    }
    return _selectAllBtn;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的收藏";
    // 右侧
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.rightBarButtonItem];
    self.dataAry = [NSMutableArray array];
    self.pageNO = 1;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadData) name:KNotificationLoginUpdata object:nil];
    [self loadData];
    [self.view addSubview:self.tableView];
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
    [self.tableView registerNib:[UINib nibWithNibName:@"HomePageRecommendTableViewCell" bundle:nil] forCellReuseIdentifier:@"HomePageRecommendTableViewCell"];
    [self.view addSubview:self.toolBarView];
    [self.toolBarView addSubview:self.selectAllBtn];
    [self.toolBarView addSubview:self.deleteBtn];
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
    [parmDic setObject:@"10" forKey:@"limit"];
    [parmDic setObject:[NSNumber numberWithInteger:self.pageNO] forKey:@"page"];
    BADataEntity *entity = [BADataEntity new];
    entity.urlString = @"/ucenter/favorite";
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
        [self.dataAry removeAllObjects];
    }
    CourseListModel *model = [[CourseListModel alloc]initWithDictionary:data error:nil];
    [self.dataAry addObjectsFromArray:model.data];
    [self setEmptyViewDelegeta];
    //通知主线程刷新
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });

}
#pragma mark - 点击事件处理
- (void)rightBarButtonItemDidClicked:(UIButton *)sender
{
    sender.selected = !sender.isSelected;
    
    if (sender.isSelected) {
        [_rightBarButtonItem setTitle:@"取消" forState:UIControlStateNormal];
        [_rightBarButtonItem setImage:[UIImage imageNamed:@""] forState:(UIControlStateNormal)];
        // 这个是fix掉:当你左滑删除的时候，再点击右上角编辑按钮， cell上的删除按钮不会消失掉的bug。且必须放在 设置tableView.editing = YES;的前面。
        [self.tableView reloadData];
        
        // 取消
        [self.tableView setEditing:YES animated:NO];
        
        
        // 全选
        //        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.leftBarButtonItem];
        //        self.leftBarButtonItem.selected = NO;
        
        // show
        self.toolBarView.hidden = NO;
        
    }else{
        [_rightBarButtonItem setTitle:@"" forState:UIControlStateNormal];
        [_rightBarButtonItem setImage:[UIImage imageNamed:@"已完成订单删除图标"] forState:(UIControlStateNormal)];
        // 清空选中栏
        [self.selectedDatas removeAllObjects];
        
        // 编辑
        [self.tableView setEditing:NO animated:NO];
        
        // 返回
        //        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.backBarButtonItem];
        
        // hide
        self.toolBarView.hidden = YES;
    }
}
- (void)leftBarButtonItemDidClicked:(UIButton *)sender
{
    sender.selected = !sender.isSelected;
    if (sender.isSelected) {
        
        // 全选
        NSInteger count = self.dataAry.count;
        for (NSInteger i = 0 ; i < count; i++)
        {
            NSIndexPath *indexPath = self.dataAry[i];
            if (![self.selectedDatas containsObject:indexPath]) {
                [self.selectedDatas addObject:indexPath];
            }
            [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0] animated:YES scrollPosition:UITableViewScrollPositionNone];
            
        }
        
    }else{
        // 取消全选
        NSInteger count = self.dataAry.count;
        for (NSInteger i = 0 ; i < count; i++)
        {
            NSIndexPath *indexPath = self.dataAry[i];
            if ([self.selectedDatas containsObject:indexPath]) {
                [self.selectedDatas removeObject:indexPath];
                
            }
            [self.tableView deselectRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0] animated:YES];
        }
    }
    
    // 设置状态
    [self _indexPathsForSelectedRowsCountDidChange:self.tableView.indexPathsForSelectedRows];
}

// 弹出框点击确认
- (void)_alertControllerDidConfirmComplete:(void(^)())complete
{
    // 弹出框
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"确定要删除所选商品吗？" preferredStyle:UIAlertControllerStyleAlert];
    
    // action
    UIAlertAction *leftAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    
    
    UIAlertAction *rightAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        !complete ? :complete();
        
    }];
    
    
    [alertController addAction:leftAction];
    [alertController addAction:rightAction];
    [self presentViewController:alertController animated:YES completion:nil];
}
- (void)_indexPathsForSelectedRowsCountDidChange:(NSArray *)selectedRows
{
    NSInteger currentCount = [selectedRows count];
    NSInteger allCount = self.dataAry.count;
    self.selectAllBtn.selected = (currentCount==allCount);
    NSString *title = (currentCount>0)?[NSString stringWithFormat:@"删除(%zd)",currentCount]:@"删除";
    [self.deleteBtn setTitle:title forState:UIControlStateNormal];
    self.deleteBtn.enabled = currentCount>0;
}
// delete收藏视频
- (void)_deleteSelectIndexPaths:(NSArray *)indexPaths
{
    idAry = [NSMutableArray array];
    [self _alertControllerDidConfirmComplete:^{

        
        for (CourseDataAryModel *model in self.selectedDatas) {
            [idAry addObject:model.ID];
            [self deleteData];
        }
        
        // 删除数据源
        [self.dataAry removeObjectsInArray:self.selectedDatas];
        [self.selectedDatas removeAllObjects];
   
        // 删除选中项
        [self.tableView beginUpdates];
        [self.tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
        [self.tableView endUpdates];
        
        // 验证数据源
        [self _indexPathsForSelectedRowsCountDidChange:self.tableView.indexPathsForSelectedRows];
        
        // 验证
        // 没有
        if (self.dataAry.count == 0)
        {
            //没有收藏数据
            
            if(self.rightBarButtonItem.selected)
            {
                // 编辑状态 -- 取消编辑状态
                [self rightBarButtonItemDidClicked:self.rightBarButtonItem];
            }
            
            self.rightBarButtonItem.enabled = NO;
            
        }
    }];
    
    
    
}
/** 删除 */
- (void)_deleteBtnDidClicked:(UIButton *)sender
{
    // 删除
    /**
     *  这里删除操作交给自己处理
     */
    [self _deleteSelectIndexPaths:self.tableView.indexPathsForSelectedRows];
    
}

#pragma mark - UITableViewDataSource, UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataAry.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 123;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HomePageRecommendTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HomePageRecommendTableViewCell" forIndexPath:indexPath];
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = self.dataAry[indexPath.row];
    cell.isCollection = YES;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.isEditing) {
        
        // 获取cell编辑状态选中情况下的所有子控件
        //        NSArray *subViews = [[tableView cellForRowAtIndexPath:indexPath] subviews];
        NSIndexPath *indexPathM = self.dataAry[indexPath.row];
        if (![self.selectedDatas containsObject:indexPathM]) {
            [self.selectedDatas addObject:indexPathM];
        }
        [self _indexPathsForSelectedRowsCountDidChange:tableView.indexPathsForSelectedRows];
        return;
    }
    CourseDataAryModel *model = self.dataAry[indexPath.row];
    CourseDetailViewController *vc = [[CourseDetailViewController alloc]init];
    vc.ID = model.goods_id;
    vc.titleIndex = model.goods_type;
    [self.navigationController pushViewController:vc animated:YES];
    
}

// 取消选中
- (void) tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.isEditing)
    {
        NSIndexPath *indexPathM = self.dataAry[indexPath.row];
        if ([self.selectedDatas containsObject:indexPathM]) {
            [self.selectedDatas removeObject:indexPathM];
        }
        
        [self _indexPathsForSelectedRowsCountDidChange:tableView.indexPathsForSelectedRows];
    }
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.isEditing) {
        // 多选
        return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert;
    }else{
        // 删除
        return UITableViewCellEditingStyleDelete;
    }
}

#pragma mark 提交编辑操作
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    //只要实现这个方法，就实现了默认滑动删除！！！！！
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        NSIndexPath *indexPathM = self.dataAry[indexPath.row];
        if (![self.selectedDatas containsObject:indexPathM]) {
            [self.selectedDatas addObject:indexPathM];
        }
        [self _deleteSelectIndexPaths:@[indexPath]];
    }
}

#pragma mark 删除按钮中文
-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除收藏";
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}


- (void)deleteData{
    NSMutableDictionary *parmDic = [NSMutableDictionary dictionary];

    [parmDic setObject:idAry forKey:@"fav_ids"];
    [ZMNetworkHelper POST:@"/stucommon/batchCancel" parameters:parmDic cache:NO responseCache:^(id responseCache) {
        
    } success:^(id responseObject) {
        if ([responseObject[@"code"] isEqualToString:@"0"]) {
            [BaseTools showErrorMessage:responseObject[@"msg"]];
        }else if ([responseObject[@"code"] isEqualToString:@"-10000"]){
            [BaseTools showErrorMessage:@"请登录后再操作"];
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [BaseTools alertLoginWithVC:self];
            });
        }else{
            [BaseTools showErrorMessage:responseObject[@"msg"]];
        }
        
    } failure:^(NSError *error) {
        
    }];
    
    
    
    
}
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIImage imageNamed:@"无收藏"];
}
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *title = @"您还没有任何收藏哦~";
    NSDictionary *attributes = @{
                                 NSFontAttributeName:[UIFont systemFontOfSize:13.0f],
                                 NSForegroundColorAttributeName:[UIColor colorWithHexString:@"8a8a8a"]
                                 };
    return [[NSAttributedString alloc] initWithString:title attributes:attributes];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
