//
//  HomePageMenuTableViewCell.m
//  KukeApp
//
//  Created by iOSDeveloper on 2018/9/25.
//  Copyright © 2018年 zhangming. All rights reserved.
//

#import "HomePageMenuTableViewCell.h"
#import "HorizontalPageFlowlayout.h"
#import "MenuCollectionViewCell.h"
@interface HomePageMenuTableViewCell()<UICollectionViewDelegate,UICollectionViewDataSource>{
    NSArray *ary;
}

@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation HomePageMenuTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    // 这里不是直接[super initWithStyle:style reuseIdentifier:reuseIdentifier]方法,而是if....
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {

        [self createView];
    }
    
    return self;
}
- (void)createView{
    /** -----1.使用苹果提供的的UICollectionViewFlowLayout布局----- */
    // UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    
    /** -----2.使用自定义的的HorizontalPageFlowlayout布局----- */
    HorizontalPageFlowlayout *layout = [[HorizontalPageFlowlayout alloc] initWithRowCount:2 itemCountPerRow:4];
    [layout setColumnSpacing:0 rowSpacing:0 edgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    
    /** 注意,此处设置的item的尺寸是理论值，实际是由行列间距、collectionView的内边距和宽高决定 */
//     layout.itemSize = CGSizeMake(screenWidth() / 4, 60);
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 0;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, screenWidth(), screenWidth()/4*2) collectionViewLayout:layout];
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.bounces = YES;
    _collectionView.pagingEnabled = YES;
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([MenuCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:@"MenuCollectionViewCell"];
    [self.contentView addSubview:_collectionView];
    
}
- (void)setMenuAry:(NSArray *)menuAry{
    ary = menuAry;
    [_collectionView reloadData];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return ary.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MenuCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MenuCollectionViewCell" forIndexPath:indexPath];
    cell.model = ary[indexPath.item];
    
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    //添加 字典，将label的值通过key值设置传递
    
    NSDictionary *dict =[[NSDictionary alloc]initWithObjectsAndKeys:[NSString stringWithFormat:@"%@",[ary[indexPath.item] ID]],@"ID", [ary[indexPath.item] name],@"Name",nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SwitchToCourseViewController" object:dict];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
