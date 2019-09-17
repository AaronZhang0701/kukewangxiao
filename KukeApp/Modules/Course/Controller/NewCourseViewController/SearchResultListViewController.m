//
//  GitHub: https://github.com/iphone5solo/PYSearch
//  Created by CoderKo1o.
//  Copyright © 2016 iphone5solo. All rights reserved.
//

#import "SearchResultListViewController.h"
#import "PYSearchConst.h"
#import "NewCourseListCell.h"
#import "NewCourseListHeaderView.h"
#import "NewCourseCollectionHeaderReusableView.h"
#import "UICollectionViewFlowLayout+Add.h"
#import "CourseListHeaderFiltrateView.h"
#import "MADSearchBar.h"
#import "PYSearch.h"
#import "NewCourseListModel.h"
#import "CourseDetailViewController.h"
@interface SearchResultListViewController ()<UISearchBarDelegate>{
    BOOL _isGrid;
    
    NSArray *filtrateAry;

}
@property (nonatomic, strong) MADSearchBar *searchBar;
@property (nonatomic, assign) NSInteger pageNO;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (strong, nonatomic) UIButton *swithBtn;
@property (nonatomic, strong) NewCourseCollectionHeaderReusableView *headerView;
@property (nonatomic, strong) CourseListHeaderFiltrateView *filtrateView;
@property (nonatomic, strong) NSString *sort_id;
@end

@implementation SearchResultListViewController
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];

}

- (void)viewDidLoad {
    [super viewDidLoad];

     
    // 默认列表视图
    _isGrid = NO;
    self.pageNO = 1;
    self.view.backgroundColor = CBackgroundColor;
    [self upLoadData];
    self.navigationItem.titleView = self.searchBar;
    self.collectionView.frame = CGRectMake(0 , 8 , self.view.bounds.size.width, self.view.bounds.size.height-8);
    //设置滚动方向
    [self.flowlayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    
    self.flowlayout.sectionHeadersPinToVisibleBoundsAll = true;
#pragma mark -- 头尾部大小设置
    //设置头部并给定大小
    [self.flowlayout setHeaderReferenceSize:CGSizeMake(self.collectionView.frame.size.width,40)];
    
    //注册cell
    [self.collectionView registerClass:[NewCourseListCell class] forCellWithReuseIdentifier:kCellIdentifier_CollectionViewCell];
#pragma mark -- 注册头部视图
    [self.collectionView  registerNib:[UINib nibWithNibName:@"NewCourseCollectionHeaderReusableView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"NewCourseCollectionHeaderReusableView"];
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
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:self.navigationItem.backBarButtonItem.style target:nil action:nil];
    self.navigationController.navigationBar.topItem.title = @"";
}
#pragma mark - 点击背景刷新时执行
- (void)noDataBeginRefresh {
    [self lq_endLoading];
    [self upLoadData];
}
- (void)upLoadData{
    [self.dataSource removeAllObjects];
    [self.collectionView.mj_footer resetNoMoreData];
    [self.collectionView reloadData];
    self.pageNO = 1;
    [self loadData];
    [self.collectionView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:NO];
}
#pragma mark —————     请求列表数据  --———


- (void)loadData{
    
    NSMutableDictionary *parmDic = [NSMutableDictionary dictionary];
    
    [parmDic setObject:self.cate_id forKey:@"cate_id"];
    
    [parmDic setObject:[UserDefaultsUtils valueWithKey:[NSString stringWithFormat:@"course_goods_type_%@",self.cate_id]] forKey:@"resource_type"];
    if ([filtrateAry[0] length]==0 || [filtrateAry[0] isEqualToString:@"-1"]) {
        [parmDic setObject:@"" forKey:@"cate_son_id"];
    }else{
        [parmDic setObject:filtrateAry[0] forKey:@"cate_son_id"];
    }
    if ([filtrateAry[1] length]==0 || [filtrateAry[1] isEqualToString:@"-1"]) {
        [parmDic setObject:@"" forKey:@"subject_id"];
    }else{
        [parmDic setObject:filtrateAry[1] forKey:@"subject_id"];
    }
    if ([filtrateAry[2] length]==0 || [filtrateAry[2] isEqualToString:@"-1"]) {
        [parmDic setObject:@"" forKey:@"exam_type"];
    }else{
        [parmDic setObject:filtrateAry[2] forKey:@"exam_type"];
    }
    [parmDic setObject:self.searchText forKey:@"keyword"];
    [parmDic setObject:self.sort_id forKey:@"sort"];
    [parmDic setObject:[NSNumber numberWithInteger:self.pageNO] forKey:@"page"];
    BADataEntity *entity = [BADataEntity new];
    entity.urlString = @"/goods_coalition/goods_list";
    entity.needCache = NO;
    entity.parameters = parmDic;
    if (![CoreStatus isNetworkEnable]) {
        [self lq_showFailLoadWithType:(LQCollectionViewFailLoadViewTypeNoData) tipsString:@"无法连接到网络,点击页面刷新"];
        return;
    }else{
        
        self.collectionView.loading = YES;
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
            [self.collectionView.mj_footer endRefreshingWithNoMoreData];
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
    
    NewCourseListModel *model = [[NewCourseListModel alloc]initWithDictionary:data error:nil];
    [self.dataSource addObjectsFromArray:model.data];
    
    [self setEmptyViewDelegeta];
    
    [self.collectionView reloadData];
    
}
#pragma mark - Getter
- (MADSearchBar *)searchBar
{
    if (!_searchBar) {
        _searchBar = [[MADSearchBar alloc] initWithFrame:CGRectMake(30,0, screenWidth()-130,40)];
        _searchBar.text = self.searchText;
        _searchBar.delegate = self;

    }
    return _searchBar;
}

#pragma mark - Getters

- (NSMutableArray *)dataSource
{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataSource.count;

}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NewCourseListCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellIdentifier_CollectionViewCell forIndexPath:indexPath];
    cell.isGrid = _isGrid;
    cell.backgroundColor = [UIColor whiteColor];
    cell.model = self.dataSource[indexPath.row];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (_isGrid) {
        return CGSizeMake((screenWidth() - 27) / 2, (screenWidth() - 27) / 2*1.27);
    } else {
        return CGSizeMake(screenWidth() - 4, 124);
    }
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    if (_isGrid) {
        return UIEdgeInsetsMake(12, 9, 0, 9);
    } else {
        return UIEdgeInsetsMake(0, 0, 1, 0);
    }



}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    if (_isGrid) {
        return 12;
    } else {
        return 1;
    }
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    if (_isGrid) {
        return 9;
    } else {
        return 0;
    }
}

//设置头尾部内容
-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableView =nil;
    if (kind ==UICollectionElementKindSectionHeader) {
        //定制头部视图的内容
        NewCourseCollectionHeaderReusableView *headerV = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"NewCourseCollectionHeaderReusableView" forIndexPath:indexPath];
        
        headerV.myStyleActionBlock = ^{
            _isGrid = !_isGrid;
            [self.collectionView reloadData];
        };
        headerV.myPickActionBlock = ^{
            [self changeList];
            
            [_filtrateView loadDataWithCateId:[NSString stringWithFormat:@"%@",self.cate_id]];
        };
        headerV.myZhongheActionBlock = ^{
            self.sort_id = @"0";
            [self upLoadData];
        };
        headerV.myXiaoliangActionBlock = ^{
            self.sort_id = @"1";
            [self upLoadData];
        };
        headerV.myPriceActionBlock = ^(NSString * _Nonnull sort_id) {
            self.sort_id = sort_id;
            [self upLoadData];
        };
        
        reusableView = headerV;
        self.headerView = headerV;
    }
    
    return reusableView;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    CourseDetailViewController *vc = [[CourseDetailViewController alloc]init];
    NewCourseListDataAryModel *model= self.dataSource[indexPath.row];
    vc.ID = model.goods_id;
    vc.titleIndex = model.goods_type;
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{

     NSDictionary *dict =[[NSDictionary alloc]initWithObjectsAndKeys:[NSString stringWithFormat:@"%f",self.collectionView.contentOffset.y],@"CollectionOffSet", nil];
    KPostNotification(@"CourseOffSet", dict);
}
- (void)changeList{
    
    self.filtrateView.frame = CGRectMake(0, 0, kScreenWidth, 0);
    UIView *rootView = [[UIApplication sharedApplication] keyWindow];
    self.filtrateView.tag = 10001;
    [rootView addSubview:self.filtrateView];
    _filtrateView.index = @"0";
    _filtrateView.keyWord = self.searchText;
    self.filtrateView.frame = CGRectMake(0, ZM_StatusBarHeight, kScreenWidth, kScreenHeight-ZM_StatusBarHeight);
    
}
- (CourseListHeaderFiltrateView *)filtrateView {
    if (!_filtrateView) {
        _filtrateView = [[CourseListHeaderFiltrateView alloc] initWithFrame:CGRectMake(0, ZM_StatusBarHeight, kScreenWidth, kScreenHeight-ZM_StatusBarHeight)];
        __weak typeof(self) weakSelf = self;
        _filtrateView.myBlock = ^(NSArray *ary) {
            
            filtrateAry = [NSArray arrayWithArray:ary];
            self.pageNO = 1;
            [weakSelf upLoadData];
            if ( ([filtrateAry[0] isEqualToString:@"-1"] || [filtrateAry[0] isEqualToString:@"0"]) && ([filtrateAry[1] isEqualToString:@"-1"] || [filtrateAry[1] isEqualToString:@"0"]) && ([filtrateAry[2] isEqualToString:@"-1"] || [filtrateAry[2] isEqualToString:@"0"] )) {
                weakSelf.headerView.isSelect = NO;
            }else{
                weakSelf.headerView.isSelect = YES;
            }
        };
    }
    return _filtrateView;
}
#pragma mark - UISearchBarDelegate

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    
    [self.navigationController popViewControllerAnimated:NO];
    return YES;
}
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    searchBar.showsCancelButton = YES;
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    NSLog(@"SearchButton");
}
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [self.searchBar resignFirstResponder];
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    searchBar.showsCancelButton = YES;
}
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
//    NSString *inputStr = searchText;
//    [self.results removeAllObjects];
//    for (ElderModel *model in self.dataArray) {
//        if ([model.name.lowercaseString rangeOfString:inputStr.lowercaseString].location != NSNotFound) {
//            [self.results addObject:model];
//        }
//    }
//    [self.tableView reloadData];
}

- (void) dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
