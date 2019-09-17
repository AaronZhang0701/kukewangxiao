//
//  GroupBuyingTableViewCell.m
//  KukeApp
//
//  Created by 库课 on 2019/1/9.
//  Copyright © 2019 zhangming. All rights reserved.
//

#import "GroupBuyingTableViewCell.h"
#import "HorizontalPageFlowlayout.h"
#import "GroupBuyingCollectionViewCell.h"
#import "GroupBuyingListViewController.h"
#import "CourseDetailViewController.h"
@interface GroupBuyingTableViewCell()<UICollectionViewDelegate,UICollectionViewDataSource>{
    NSArray *listAry;
}

@property (nonatomic, strong) UICollectionView *collectionView;

@end
@implementation GroupBuyingTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (instancetype)initWithCoder:(NSCoder *)decoder {
    if (self = [super initWithCoder:decoder]) {
        [self createView];
    }
    return self;
}

- (void)setAry:(NSMutableArray *)ary{
    listAry = ary;
    [_collectionView reloadData];
}
- (void)createView{
    
    UICollectionViewFlowLayout * flowLayout = [[UICollectionViewFlowLayout alloc]init];
    
    CGFloat itemWidth = screenWidth() / 5*2;
    
    //设置单元格大小
    flowLayout.itemSize = CGSizeMake(itemWidth, 170);
    //最小行间距(默认为10)
    flowLayout.minimumLineSpacing = 10;
    //最小item间距（默认为10）
    flowLayout.minimumInteritemSpacing = 10;
    //设置senction的内边距
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 15, 0, 15);
    //设置UICollectionView的滑动方向
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;


    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 51, screenWidth(), 176) collectionViewLayout:flowLayout];
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.bounces = YES;
    _collectionView.pagingEnabled = NO;
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([GroupBuyingCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:@"GroupBuyingCollectionViewCell"];
    [self.contentView addSubview:_collectionView];

}


#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return listAry.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    GroupBuyingCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"GroupBuyingCollectionViewCell" forIndexPath:indexPath];
    cell.model = listAry[indexPath.item];

    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    HomeGroupBuyingModel *model = listAry[indexPath.item];
    CourseDetailViewController *vc = [[CourseDetailViewController alloc]init];
    vc.ID = model.goods_id;
    vc.titleIndex = model.goods_type;
    vc.coursePrice = model.group_buy_price;
    vc.courseTitle = model.goods_name;
    vc.ac_type = @"3";
    [[[AppDelegate shareAppDelegate] getCurrentUIVC].navigationController pushViewController:vc animated:YES];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
