//
//  NewsListHeaderFiltrateView.m
//  KukeApp
//
//  Created by 库课 on 2019/7/8.
//  Copyright © 2019 KukeZangMing. All rights reserved.
//

#import "NewsListHeaderFiltrateView.h"
#import "CourseListHeaderFiltrateHeaderView.h"
#import "CourseListHeaderFiltrateViewCell.h"

@interface NewsListHeaderFiltrateView()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout,ZMEmptyDataSetSource,ZMEmptyDataSetDelegate>{
    
    NSString *cate_idStr;
    NSString *goodsTypeStr;

}

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) UIButton *resetButton;
@property (nonatomic, strong) UIButton *sureButton;

@property (nonatomic, strong) NSMutableArray *sectionArray;
@property (nonatomic, strong) NSMutableArray *itemArray;


@property (nonatomic, strong) UILabel *line;
@property (nonatomic, strong) UILabel *line1;
@property (nonatomic, strong) UILabel *titlelab;
@property (nonatomic, strong) UIView *bottomView;
@end

@implementation NewsListHeaderFiltrateView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.collectionView.loading = YES;
        [self configSelf];
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(closeView) name:@"CloseSortAndFiltrate" object:nil];
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(upLoad:) name:@"SwitchGoodsType" object:nil];//商品类型切换清空筛选项
    }
    return self;
}

- (void)configSelf {
    self.backgroundColor = [UIColor colorWithRed:0.00f green:0.00f blue:0.00f alpha:0.75f];
    
    self.city_id = 0;
    _bgView = [[UIView alloc] init];
    _bgView.backgroundColor = [UIColor clearColor];
    [self addSubview:_bgView];
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    flowLayout.minimumLineSpacing = 10;
    flowLayout.minimumInteritemSpacing = 10;
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;

    _collectionView.backgroundColor = [UIColor whiteColor];
    //    _collectionView.scrollEnabled = NO;
    [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"UICollectionViewCell"];
    [_collectionView registerClass:[CourseListHeaderFiltrateViewCell class] forCellWithReuseIdentifier:@"CourseListHeaderFiltrateViewCell"];
    [_collectionView registerClass:[CourseListHeaderFiltrateHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"CourseListHeaderFiltrateHeaderView"];
    [_bgView addSubview:_collectionView];
    
    
    
    _resetButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_resetButton setBackgroundColor:[UIColor whiteColor]];
    [_resetButton setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
    [_resetButton setTitle:@"重置" forState:UIControlStateNormal];
    _resetButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [_resetButton addTarget:self action:@selector(clickResetButton) forControlEvents:UIControlEventTouchUpInside];
    [_bgView addSubview:_resetButton];
    
    _sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_sureButton setBackgroundColor:CNavBgColor];
    [_sureButton setTintColor:[UIColor whiteColor]];
    [_sureButton setTitle:@"确定" forState:UIControlStateNormal];
    _sureButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [_sureButton addTarget:self action:@selector(clickSureButton) forControlEvents:UIControlEventTouchUpInside];
    [_bgView addSubview:_sureButton];
    
    _line = [[UILabel alloc]init];
    _line.backgroundColor = CBackgroundColor;
    [self.bgView addSubview:_line];
    
    _titlelab = [[UILabel alloc]init];
    _titlelab.backgroundColor = [UIColor whiteColor];
    _titlelab.font = [UIFont systemFontOfSize:15];
    _titlelab.textAlignment = NSTextAlignmentCenter;
    _titlelab.text = @"筛选";
    [self.bgView addSubview:_titlelab];
    
    _line1 = [[UILabel alloc]init];
    _line1.backgroundColor = CBackgroundColor;
    [self.titlelab addSubview:_line1];
    
    
    self.bottomView = [[UIView alloc]init];
    UITapGestureRecognizer *tapGesturRecognizer=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    [self.bgView addSubview:self.bottomView];
    self.bottomView.backgroundColor = [UIColor clearColor];
    [self.bottomView addGestureRecognizer:tapGesturRecognizer];
    
    
    
}
-(void)tapAction:(id)tap

{
    [BaseTools dismissHUD];
//    [UserDefaultsUtils saveValue:self.filtrateIDArray forKey:[NSString stringWithFormat:@"Pick_Conditions_%@_%@",cate_idStr,goodsTypeStr]];
    if (_myBlock) {
        self.myBlock(self.city_id);
    }
    [self removeFromSuperview];
    //    self.filtrateIDArray = [NSMutableArray arrayWithArray:@[@"-1", @"-1", @"-1"]];
    
}
- (void)closeView{
    [BaseTools dismissHUD];
    [self removeFromSuperview];
}
- (void)clickResetButton {
    [BaseTools dismissHUD];
    self.city_id = 0;
//    [UserDefaultsUtils saveValue:self.filtrateIDArray forKey:[NSString stringWithFormat:@"Pick_Conditions_%@_%@",cate_idStr,goodsTypeStr]];
    if (_myBlock) {
        self.myBlock(self.city_id);
    }
    [self.collectionView reloadData];
}
- (void)clickSureButton {
    
//    [UserDefaultsUtils saveValue:self.filtrateIDArray forKey:[NSString stringWithFormat:@"Pick_Conditions_%@_%@",cate_idStr,goodsTypeStr]];
    
    if (_myBlock) {
        self.myBlock(self.city_id);
    }
    [self removeFromSuperview];
    //    self.filtrateIDArray = [NSMutableArray arrayWithArray:@[@"-1", @"-1", @"-1"]];
    
}
//- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
//    return [UIImage imageNamed:@"无购买课程"];
//}
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *title = @"暂无数据～";
    NSDictionary *attributes = @{
                                 NSFontAttributeName:[UIFont systemFontOfSize:13.0f],
                                 NSForegroundColorAttributeName:[UIColor colorWithHexString:@"8a8a8a"]
                                 };
    return [[NSAttributedString alloc] initWithString:title attributes:attributes];
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CourseListHeaderFiltrateViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CourseListHeaderFiltrateViewCell" forIndexPath:indexPath];
    

    NSString *title = [self.itemArray[indexPath.item] objectForKey:@"name"];
    if ([[self.itemArray[indexPath.item] objectForKey:@"city_id"] integerValue] == self.city_id) {
        [cell configWithTitle:title selected:YES];
    }else{
        [cell configWithTitle:title selected:NO];
    }
    
    
    
    return cell;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.itemArray.count;
//    switch (section) {
//        case 0: return [self.itemArray[section] count]; break;
//        case 1: return [self.itemArray[section] count]; break;
//        case 2: return [self.itemArray[section] count]; break;
//
//        default: return 1; break;
//    }
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(kScreenWidth-60, 45);
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if (kind==UICollectionElementKindSectionHeader) {
        CourseListHeaderFiltrateHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"CourseListHeaderFiltrateHeaderView" forIndexPath:indexPath];
        [headerView configTitle:@"地区"];
        return headerView;
    }
    return [[UICollectionReusableView alloc] init];
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    self.city_id = [self.itemArray[indexPath.item][@"city_id"] integerValue];
    [self.collectionView reloadData];
//    NSString *strID =self.itemArray[indexPath.section][indexPath.item][@"value"];
//    //    [self.filtrateIDArray replaceObjectAtIndex:indexPath.section withObject:strID];
//    if ([self.sectionArray[indexPath.section] isEqualToString:@"地区"]) {
//        [self.filtrateIDArray replaceObjectAtIndex:0 withObject:strID];
//    }else if ([self.sectionArray[indexPath.section] isEqualToString:@"学科"]){
//        [self.filtrateIDArray replaceObjectAtIndex:1 withObject:strID];
//    }else if ([self.sectionArray[indexPath.section] isEqualToString:@"类型"]){
//        [self.filtrateIDArray replaceObjectAtIndex:2 withObject:strID];
//    }
   
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake((kScreenWidth-120)/3, 32);
}
- (void)layoutSubviews {
    [super layoutSubviews];

    self.bgView.frame = self.bounds;
    self.titlelab.frame = CGRectMake(60, -1, screenWidth()-60, 61);
    //    self.line1.frame = CGRectMake(60, 59, screenWidth()-60, 1);
    self.collectionView.frame = CGRectMake(60, 60.5f, screenWidth()-60, self.height-100-10);
    self.bottomView.frame = CGRectMake(0,0, 60, self.height-100);
    self.line.frame = CGRectMake(60, maxY(self.collectionView), screenWidth()-60, 1);
    self.resetButton.frame = CGRectMake(60, maxY(self.collectionView)+1,(self.bgView.size.width-60)/2, 49);
    self.sureButton.frame = CGRectMake(maxX(self.resetButton), maxY(self.collectionView)+1, (self.bgView.size.width-60)/2, 49);
}

- (void)loadDataWithNewsCateId:(NSString *)news_cate_id NewsOid:(NSString *)news_oid{
    self.sectionArray = [NSMutableArray array];
    self.itemArray = [NSMutableArray array];
    
    cate_idStr = news_cate_id;
    goodsTypeStr = news_oid;
    NSMutableDictionary *parmDic = [NSMutableDictionary dictionary];
    [parmDic setObject:news_cate_id forKey:@"id"];
    [parmDic setObject:news_oid forKey:@"oid"];
    [BaseTools showProgressMessage:@"努力加载中"];
    [ZMNetworkHelper POST:@"/news/get_news_city" parameters:parmDic cache:YES responseCache:^(id responseCache) {
        
    } success:^(id responseObject) {
        self.collectionView.loading = NO;
        self.collectionView.emptyDataSetSource = self;
        self.collectionView.emptyDataSetDelegate = self;
        if (responseObject == nil) {
            
        }else{
            if ([responseObject[@"code"] isEqualToString:@"0"]) {
                
//                for (NSDictionary *dict in responseObject[@"data"]) {
//                    [self.sectionArray addObject:dict[@"filter_name"]];
                    [self.itemArray addObjectsFromArray:responseObject[@"data"]];
//                }
                //通知主线程刷新
                dispatch_async(dispatch_get_main_queue(), ^{
                    [_collectionView reloadData];
                    [BaseTools dismissHUD];
                });
                
                
            }else{
                [BaseTools showErrorMessage:responseObject[@"msg"]];
            }
            
        }
        
    } failure:^(NSError *error) {
        
    }];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
