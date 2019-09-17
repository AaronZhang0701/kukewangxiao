//
//  CourseMenuView.m
//  KukeApp
//
//  Created by iOSDeveloper on 2018/9/29.
//  Copyright © 2018年 zhangming. All rights reserved.
//

#import "CourseMenuView.h"

#import "HorizontalPageFlowlayout.h"
#import "MenuCollectionViewCell.h"
@interface CourseMenuView()<UICollectionViewDelegate,UICollectionViewDataSource>{
    NSInteger menuCount;
}

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSArray *dataAry;
@end

@implementation CourseMenuView

- (instancetype)initWithFrame:(CGRect)frame menuCount:(NSInteger)number{
    if (self = [super initWithFrame:frame]) {
        menuCount = number;
        self.dataAry = [MenuDataTool getAllMenu];
        self.backgroundColor = [UIColor clearColor];
        [self createView];
        
    }
    return self;
}
- (void)createView{
    /** -----1.使用苹果提供的的UICollectionViewFlowLayout布局----- */
    // UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    
    /** -----2.使用自定义的的HorizontalPageFlowlayout布局----- */
    NSInteger rowCount;
    if (menuCount<=4) {
        rowCount = 1;
    }else{
        rowCount = 2;
    }
    HorizontalPageFlowlayout *layout = [[HorizontalPageFlowlayout alloc] initWithRowCount:rowCount itemCountPerRow:4];
    [layout setColumnSpacing:0 rowSpacing:0 edgeInsets:UIEdgeInsetsMake(0, 0, 10, 0)];
    
    /** 注意,此处设置的item的尺寸是理论值，实际是由行列间距、collectionView的内边距和宽高决定 */
    //     layout.itemSize = CGSizeMake(screenWidth() / 4, 60);
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 0;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, screenWidth(), screenWidth()/4*rowCount+10) collectionViewLayout:layout];
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.bounces = YES;
    _collectionView.pagingEnabled = YES;
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([MenuCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:@"MenuCollectionViewCell"];
    [self addSubview:_collectionView];
    
    
    UIView *view  = [[UIView alloc]initWithFrame:CGRectMake(0, maxY(_collectionView), screenHeight(), screenHeight()-maxY(_collectionView))];
    view.backgroundColor = [UIColor colorWithRed:0.00f green:0.00f blue:0.00f alpha:0.75f];
//    view.alpha = 0.3;
    UITapGestureRecognizer *tapGesturRecognizer=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction)];
    [view addGestureRecognizer:tapGesturRecognizer];

    [self addSubview:view];
    
}


#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return menuCount;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MenuCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MenuCollectionViewCell" forIndexPath:indexPath];
    cell.model = self.dataAry[indexPath.item];
    
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
    if (menuCount<=4) {
        [UserDefaultsUtils saveValue:[self.dataAry[indexPath.item] name] forKey:@"NewsCateName"];
        [UserDefaultsUtils saveValue:[self.dataAry[indexPath.item] ID] forKey:@"NewsCateID"];
    }else{
        [UserDefaultsUtils saveValue:[self.dataAry[indexPath.item] name] forKey:@"CateName"];
        [UserDefaultsUtils saveValue:[self.dataAry[indexPath.item] ID] forKey:@"CateID"];
    }
    
    if (_myBlock) {
        _myBlock([[self.dataAry[indexPath.item] ID] integerValue]);
    }
}
- (void)tapAction{
    if (_myBlock) {
        _myBlock(-1);
    }
    
}
@end
