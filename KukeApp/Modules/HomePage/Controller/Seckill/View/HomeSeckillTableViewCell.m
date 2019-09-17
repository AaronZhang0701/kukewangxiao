//
//  HomeSeckillTableViewCell.m
//  KukeApp
//
//  Created by 库课 on 2019/2/18.
//  Copyright © 2019 KukeZangMing. All rights reserved.
//

#import "HomeSeckillTableViewCell.h"
#import "HomeSeckillCollectionViewCell.h"
#import "SeckillListModel.h"
#import "CourseDetailViewController.h"
@interface HomeSeckillTableViewCell()<UICollectionViewDelegate,UICollectionViewDataSource>{
    NSArray *listAry;
}

@property (nonatomic, strong) UICollectionView *collectionView;

@end
@implementation HomeSeckillTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.hourLab.layer.cornerRadius = 5;
    self.hourLab.layer.masksToBounds = YES;
    self.minuteLab.layer.cornerRadius = 3;
    self.minuteLab.layer.masksToBounds = YES;
    self.secondLab.layer.cornerRadius = 3;
    self.secondLab.layer.masksToBounds = YES;
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
    flowLayout.itemSize = CGSizeMake(itemWidth, 185);
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
    [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([HomeSeckillCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:@"HomeSeckillCollectionViewCell"];
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
    HomeSeckillCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HomeSeckillCollectionViewCell" forIndexPath:indexPath];
    cell.model = listAry[indexPath.item];
    
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    SeckillListDataModel *model = listAry[indexPath.row];
    CourseDetailViewController *vc = [[CourseDetailViewController alloc]init];
    vc.ID = model.goods_id;
    vc.titleIndex = model.goods_type;
    vc.coursePrice = model.seckill_price;
    vc.courseTitle = model.goods_title;
    vc.ac_type = @"2";
    [[[AppDelegate shareAppDelegate] getCurrentUIVC].navigationController pushViewController:vc animated:YES];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
