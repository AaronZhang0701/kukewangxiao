//
//  ExamProposeGoodsListViewController.m
//  KukeApp
//
//  Created by 库课 on 2019/8/9.
//  Copyright © 2019 KukeZangMing. All rights reserved.
//

#import "ExamProposeGoodsListViewController.h"
#import "ExamProgoseCollectionCell.h"
#import "UIScrollView+EmptyDataSet.h"
#import "ExamListViewModel.h"
@interface ExamProposeGoodsListViewController (){
    
}

@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic,strong) ExamListViewModel *viewModel;
@end

@implementation ExamProposeGoodsListViewController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO];
    
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadData];
    self.collectionView.frame = CGRectMake(0 , 0 ,self.view.bounds.size.width, self.view.bounds.size.height-59-UI_navBar_Height);
    [self.collectionView registerClass:[ExamProgoseCollectionCell class] forCellWithReuseIdentifier:@"ExamProgoseCollectionCell"];
    
    // Do any additional setup after loading the view.
}
- (void)loadData{
    self.viewModel = [[ExamListViewModel alloc]init];
    self.dataSource= [NSMutableArray array];
    if (![CoreStatus isNetworkEnable]) {
        [self lq_showFailLoadWithType:(LQCollectionViewFailLoadViewTypeNoData) tipsString:@"无法连接到网络,点击页面刷新"];
        return;
    }else{
        self.collectionView.loading = YES;
    }
    [self.viewModel loadProposeDataWithCateID:self.exam_cate_id proposeData:^(id  _Nonnull obj) {
      
        self.dataSource = obj[@"data"];
        [self setEmptyViewDelegeta];
        
        [self.collectionView reloadData];
    } fromController:[[AppDelegate shareAppDelegate] getCurrentUIVC]];
}
#pragma mark - 点击背景刷新时执行
- (void)noDataBeginRefresh {
    [self lq_endLoading];
    [self loadData];
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataSource.count;
//        return 30;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ExamProgoseCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ExamProgoseCollectionCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    [cell configData:self.dataSource[indexPath.row]];
//    cell.model = self.dataSource[indexPath.row];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((screenWidth()-40)/2, (screenWidth()-40)/2/3*2 +45);

}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{

    return UIEdgeInsetsMake(15, 15, 0, 15);
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    CourseDetailViewController *vc = [[CourseDetailViewController alloc]init];
    NSDictionary *model= self.dataSource[indexPath.row];
    vc.ID = model[@"id"];
    vc.titleIndex = model[@"goods_type"];
    [self.navigationController pushViewController:vc animated:YES];
}


@end
