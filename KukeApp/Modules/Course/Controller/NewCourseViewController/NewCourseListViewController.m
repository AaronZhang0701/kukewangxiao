//
//  NewCourseListViewController.m
//  KukeApp
//
//  Created by 库课 on 2019/4/15.
//  Copyright © 2019 KukeZangMing. All rights reserved.
//

#import "NewCourseListViewController.h"
#import "PYSearchConst.h"
#import "NewCourseListCell.h"
#import "NewCourseListHeaderView.h"
#import "NewCourseCollectionHeaderReusableView.h"
#import "UICollectionViewFlowLayout+Add.h"
#import "CourseListHeaderFiltrateView.h"
#import "NewCourseListModel.h"
#import "CourseDetailViewController.h"
#import "UIScrollView+EmptyDataSet.h"
@interface NewCourseListViewController (){
    BOOL _isGrid;
    NSArray *filtrateAry;
    NSString *isChangeCate_id;
    BOOL isPush;

}

@property (nonatomic, strong) NSMutableArray *dataSource;
@property (strong, nonatomic) UIButton *swithBtn;
@property (nonatomic, strong) NewCourseCollectionHeaderReusableView *headerView;
@property (nonatomic, strong) CourseListHeaderFiltrateView *filtrateView;
//@property (nonatomic, strong) NSString *goodsType;
@property (nonatomic, strong) NSString *sort_id;
@property (nonatomic, assign) NSInteger pageNO;
@end

@implementation NewCourseListViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];

    // 默认列表视图
    _isGrid = NO;

    isPush = NO;
    
    self.pageNO = 1;

    self.sort_id = @"0";

    [self upLoadData];
    
    self.collectionView.frame = CGRectMake(0 , 0 , self.view.bounds.size.width, self.view.bounds.size.height-ZM_StatusBarHeight-UI_tabBar_Height);
    self.collectionView.backgroundColor = CBackgroundColor;
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
}
#pragma mark - 点击背景刷新时执行
- (void)noDataBeginRefresh {
    [self lq_endLoading];
    [self upLoadData];
}
//- (void)upLoad:(NSNotification *)noti
//{
//    filtrateAry = @[@"-1", @"-1", @"-1"];//商品类型切换清空筛选项
//    self.headerView.isSelect = NO;
//    [self upLoadData];
//}

- (void)upLoadData1{
    isPush = NO;
    isChangeCate_id = [UserDefaultsUtils valueWithKey:[NSString stringWithFormat:@"GoodsType_Swith_%@",[UserDefaultsUtils valueWithKey:@"CateID"]]];
    [self upLoadData];
}
- (void)pushUpLoadData{
 
    self.collectionView.loading = YES;
    isPush = YES;
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
    
    NSString *cate_id = [UserDefaultsUtils valueWithKey:@"CateID"];
    
    NSString *goodsType = [UserDefaultsUtils valueWithKey:[NSString stringWithFormat:@"course_goods_type_%@",cate_id]];
    
    NSArray *ary = [UserDefaultsUtils valueWithKey:[NSString stringWithFormat:@"Pick_Conditions_%@_%@",cate_id,goodsType]];

    if (isPush) {
        
    }else{
        if ([isChangeCate_id isEqualToString:@"1"]) {
            ary = @[@"-1", @"-1", @"-1"];//商品类型切换清空筛选项
            
        }
    }
    
    filtrateAry = ary;
    if ( ([filtrateAry[0] isEqualToString:@"-1"] || [filtrateAry[0] isEqualToString:@"0"]) && ([filtrateAry[1] isEqualToString:@"-1"] || [filtrateAry[1] isEqualToString:@"0"]) && ([filtrateAry[2] isEqualToString:@"-1"] || [filtrateAry[2] isEqualToString:@"0"] )) {
        self.headerView.isSelect = NO;
    }else{
        self.headerView.isSelect = YES;
    }
    

    NSMutableDictionary *parmDic = [NSMutableDictionary dictionary];

    [parmDic setObject:[NSNumber numberWithInteger:self.cate_id+1] forKey:@"cate_id"];

    if (goodsType == nil ) {
        [parmDic setObject:@"3" forKey:@"resource_type"];
    }else{
        [parmDic setObject:goodsType forKey:@"resource_type"];
    }
    
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

    [parmDic setObject:@"" forKey:@"keyword"];
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
//    return 30;
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

            _filtrateView.ary = filtrateAry;
            [_filtrateView loadDataWithCateId:[NSString stringWithFormat:@"%ld",self.cate_id+1] ];
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
    self.filtrateView.frame = CGRectMake(0, ZM_StatusBarHeight, kScreenWidth, kScreenHeight-ZM_StatusBarHeight);
    
}
- (CourseListHeaderFiltrateView *)filtrateView {
    if (!_filtrateView) {
        _filtrateView = [[CourseListHeaderFiltrateView alloc] initWithFrame:CGRectMake(0, ZM_StatusBarHeight, kScreenWidth, kScreenHeight-ZM_StatusBarHeight)];
        __weak typeof(self) weakSelf = self;
        _filtrateView.myBlock = ^(NSArray *ary) {

            isChangeCate_id = nil;
            filtrateAry = [NSArray arrayWithArray:ary];
            weakSelf.pageNO = 1;
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

- (void) dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
