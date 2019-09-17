//
//  CourseListHeaderFiltrateView.m
//  YXYC
//
//  Created by ios hzjt on 2018/6/8.
//  Copyright © 2018年 hzjt. All rights reserved.
//

#import "CourseListHeaderFiltrateView.h"
#import "CourseListHeaderFiltrateHeaderView.h"
#import "CourseListHeaderFiltrateViewCell.h"



@interface CourseListHeaderFiltrateView()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout,ZMEmptyDataSetSource,ZMEmptyDataSetDelegate>{

    NSString *cate_idStr;
    NSString *goodsTypeStr;
    NSString *keyword;
    NSString *isChangeCate_id;
}

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) UIButton *resetButton;
@property (nonatomic, strong) UIButton *sureButton;

@property (nonatomic, strong) NSMutableArray *sectionArray;
@property (nonatomic, strong) NSMutableArray *itemArray;

@property (nonatomic, strong) NSMutableArray *filtrateIDArray;
@property (nonatomic, strong) UILabel *line;
@property (nonatomic, strong) UILabel *line1;
@property (nonatomic, strong) UILabel *titlelab;
@property (nonatomic, strong) UIView *bottomView;
@end

@implementation CourseListHeaderFiltrateView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.collectionView.loading = YES;
//        self.collectionView.loading = YES;
        [self configSelf];
         [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(closeView) name:@"CloseSortAndFiltrate" object:nil];
         [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(upLoad:) name:@"SwitchGoodsType" object:nil];//商品类型切换清空筛选项
    }
    return self;
}


- (void)upLoad:(NSNotification *)noti
{
    isChangeCate_id = [UserDefaultsUtils valueWithKey:[NSString stringWithFormat:@"GoodsType_Swith_%@",[UserDefaultsUtils valueWithKey:@"CateID"]]];
    if ([isChangeCate_id isEqualToString:@"1"]) {
       self.filtrateIDArray = [NSMutableArray arrayWithArray:@[@"-1", @"-1", @"-1"]];//商品类型切换清空筛选项
    }
//    if ([UserDefaultsUtils valueWithKey:[NSString stringWithFormat:@"%@_%@",[UserDefaultsUtils valueWithKey:@"CateID"],[UserDefaultsUtils valueWithKey:[NSString stringWithFormat:@"course_goods_type_%@",[UserDefaultsUtils valueWithKey:@"CateID"]]]]] == nil) {
//        self.filtrateIDArray = [NSMutableArray arrayWithArray:@[@"-1", @"-1", @"-1"]];//商品类型切换清空筛选项
//    }

//    if ([[UserDefaultsUtils valueWithKey:@"SwicthTab"] isEqualToString:@"1"]) {
//
//    }else{
//        self.filtrateIDArray = [NSMutableArray arrayWithArray:@[@"-1", @"-1", @"-1"]];//商品类型切换清空筛选项
//
//    }
    
//    if ([isChangeCate_id isEqualToString:@"1"]) {
//
//    }else{
//        self.filtrateIDArray = [NSMutableArray arrayWithArray:@[@"-1", @"-1", @"-1"]];//商品类型切换清空筛选项
//
//    }
    
//    self.filtrateIDArray = [NSMutableArray arrayWithArray:@[@"-1", @"-1", @"-1"]];//商品类型切换清空筛选项
}

- (void)configSelf {
    self.backgroundColor = [UIColor colorWithRed:0.00f green:0.00f blue:0.00f alpha:0.75f];

    self.filtrateIDArray = [NSMutableArray arrayWithArray:@[@"-1", @"-1", @"-1"]];
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
    [UserDefaultsUtils saveValue:self.filtrateIDArray forKey:[NSString stringWithFormat:@"Pick_Conditions_%@_%@",cate_idStr,goodsTypeStr]];
    if (_myBlock) {
        self.myBlock(self.filtrateIDArray);
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
    self.filtrateIDArray = [NSMutableArray arrayWithArray:@[@"-1", @"-1", @"-1"]];
    [UserDefaultsUtils saveValue:self.filtrateIDArray forKey:[NSString stringWithFormat:@"Pick_Conditions_%@_%@",cate_idStr,goodsTypeStr]];
    if (_myBlock) {
        self.myBlock(self.filtrateIDArray);
    }
    [self loadDataWithCateId:cate_idStr];
}
- (void)clickSureButton {
    
   [UserDefaultsUtils saveValue:self.filtrateIDArray forKey:[NSString stringWithFormat:@"Pick_Conditions_%@_%@",cate_idStr,goodsTypeStr]];
    
    if (_myBlock) {
        self.myBlock(self.filtrateIDArray);
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
    return self.sectionArray.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CourseListHeaderFiltrateViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CourseListHeaderFiltrateViewCell" forIndexPath:indexPath];
    
    NSArray *titleArray = self.itemArray[indexPath.section];
    NSString *title = [titleArray[indexPath.item] objectForKey:@"name"];
    [cell configWithTitle:title selected:[[titleArray[indexPath.item] objectForKey:@"is_checked"] boolValue]];
    
    
    return cell;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    switch (section) {
        case 0: return [self.itemArray[section] count]; break;
        case 1: return [self.itemArray[section] count]; break;
        case 2: return [self.itemArray[section] count]; break;
            
        default: return 1; break;
    }
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(kScreenWidth-60, 45);
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if (kind==UICollectionElementKindSectionHeader) {
        CourseListHeaderFiltrateHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"CourseListHeaderFiltrateHeaderView" forIndexPath:indexPath];
        [headerView configTitle:self.sectionArray[indexPath.section]];
        return headerView;
    }
    return [[UICollectionReusableView alloc] init];
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

    NSString *strID =self.itemArray[indexPath.section][indexPath.item][@"value"];
//    [self.filtrateIDArray replaceObjectAtIndex:indexPath.section withObject:strID];
    if ([self.sectionArray[indexPath.section] isEqualToString:@"地区"]) {
        [self.filtrateIDArray replaceObjectAtIndex:0 withObject:strID];
    }else if ([self.sectionArray[indexPath.section] isEqualToString:@"学科"]){
        [self.filtrateIDArray replaceObjectAtIndex:1 withObject:strID];
    }else if ([self.sectionArray[indexPath.section] isEqualToString:@"类型"]){
        [self.filtrateIDArray replaceObjectAtIndex:2 withObject:strID];
    }
    [self loadDataWithCateId:cate_idStr];
    
    

    
//    NSString *itemStr = [NSString stringWithFormat:@"%ld", indexPath.item];
//    [self.selectedArray replaceObjectAtIndex:indexPath.section withObject:itemStr];
//
//    [self.collectionView reloadData];
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake((kScreenWidth-120)/3, 32);
}
- (void)layoutSubviews {
    [super layoutSubviews];
//    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.mas_top);
//        make.width.equalTo(self.mas_width);
//        make.right.equalTo(self.mas_right);
//        make.bottom.equalTo(self.mas_bottom);
//    }];
//    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.bgView.mas_top);
//        make.left.equalTo(@60);
//        make.right.equalTo(self.bgView.mas_right);
//        make.height.equalTo(@(screenHeight()));
//    }];
//
//    [self.resetButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.width.equalTo(self.collectionView).multipliedBy(0.5);
//        make.height.equalTo(@50);
//        make.left.equalTo(self.collectionView.mas_left);
//        make.top.equalTo(self.collectionView.mas_bottom);
//    }];
//    [self.sureButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.width.equalTo(self.collectionView).multipliedBy(0.5);
//        make.height.equalTo(@50);
//        make.right.equalTo(self.mas_right);
//        make.top.equalTo(self.collectionView.mas_bottom);
//    }];
//    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.sureButton.mas_bottom);
//        make.left.equalTo(@60);
//        make.right.equalTo(self.bgView.mas_right);
//        make.bottom.equalTo(self.mas_bottom);
//    }];
    self.bgView.frame = self.bounds;
    self.titlelab.frame = CGRectMake(60, -1, screenWidth()-60, 61);
//    self.line1.frame = CGRectMake(60, 59, screenWidth()-60, 1);
    self.collectionView.frame = CGRectMake(60, 60.5f, screenWidth()-60, self.height-100-10);
    self.bottomView.frame = CGRectMake(0,0, 60, self.height-100);
    self.line.frame = CGRectMake(60, maxY(self.collectionView), screenWidth()-60, 1);
    self.resetButton.frame = CGRectMake(60, maxY(self.collectionView)+1,(self.bgView.size.width-60)/2, 49);
    self.sureButton.frame = CGRectMake(maxX(self.resetButton), maxY(self.collectionView)+1, (self.bgView.size.width-60)/2, 49);
}
- (void)setKeyWord:(NSString *)keyWord{
    keyword = keyWord;
}

//-(void)setIsChangeCateID:(NSString *)isChangeCateID{
//    NSString *cate_id = [UserDefaultsUtils valueWithKey:@"CateID"];
//
//    NSString *goodsType = [UserDefaultsUtils valueWithKey:[NSString stringWithFormat:@"course_goods_type_%@",cate_id]];
//
//    NSArray *ary = [UserDefaultsUtils valueWithKey:[NSString stringWithFormat:@"Pick_Conditions_%@_%@",cate_id,goodsType]];
//    NSLog(@"******************************%@",ary);
//    if ([isChangeCate_id isEqualToString:@"1"]) {
//        ary = @[@"-1", @"-1", @"-1"];//商品类型切换清空筛选项
//    }
//    if (ary == nil) {
//        _filtrateIDArray = [NSMutableArray arrayWithArray:@[@"-1", @"-1", @"-1"]];//商品类型切换清空筛选项
//    }else{
//        _filtrateIDArray = [NSMutableArray arrayWithArray:ary];
//    }
//}

- (void)setAry:(NSArray *)ary{
    if (ary == nil) {
        _filtrateIDArray = [NSMutableArray arrayWithArray:@[@"-1", @"-1", @"-1"]];//商品类型切换清空筛选项
    }else{
        _filtrateIDArray = [NSMutableArray arrayWithArray:ary];
    }
}
- (void)loadDataWithCateId:(NSString *)cate_id{
    self.sectionArray = [NSMutableArray array];
    self.itemArray = [NSMutableArray array];
    
    cate_idStr = cate_id;
    goodsTypeStr = [UserDefaultsUtils valueWithKey:[NSString stringWithFormat:@"course_goods_type_%@",cate_id]];
//
//    NSArray *ary = [UserDefaultsUtils valueWithKey:[NSString stringWithFormat:@"Pick_Conditions_%@_%@",cate_id,goodsTypeStr]];
//
//    NSLog(@"******************************%@",ary);
//    if ([isChangeCate_id isEqualToString:@"1"]) {
//        ary = @[@"-1", @"-1", @"-1"];//商品类型切换清空筛选项
//    }
//    if (ary == nil) {
//        _filtrateIDArray = [NSMutableArray arrayWithArray:@[@"-1", @"-1", @"-1"]];//商品类型切换清空筛选项
//    }else{
//        _filtrateIDArray = [NSMutableArray arrayWithArray:ary];
//    }
 
   
   
    
    NSMutableDictionary *parmDic = [NSMutableDictionary dictionary];
    
    [parmDic setObject:cate_id forKey:@"cate_id"];
    
    [parmDic setObject:goodsTypeStr forKey:@"resource_type"];

    if ([_filtrateIDArray[0] length]==0 || [_filtrateIDArray[0] isEqualToString:@"-1"]) {
        [parmDic setObject:@"" forKey:@"cate_son_id"];
    }else{
        [parmDic setObject:_filtrateIDArray[0] forKey:@"cate_son_id"];
    }
    if ([_filtrateIDArray[1] length]==0 || [_filtrateIDArray[1] isEqualToString:@"-1"]) {
        [parmDic setObject:@"" forKey:@"subject_id"];
    }else{
        [parmDic setObject:_filtrateIDArray[1] forKey:@"subject_id"];
    }
    if ([_filtrateIDArray[2] length]==0 || [_filtrateIDArray[2] isEqualToString:@"-1"]) {
        [parmDic setObject:@"" forKey:@"exam_type"];
    }else{
        [parmDic setObject:_filtrateIDArray[2] forKey:@"exam_type"];
    }
    [parmDic setObject:keyword forKey:@"keyword"];
    [BaseTools showProgressMessage:@"努力加载中"];
    [ZMNetworkHelper POST:@"/goods_coalition/filters" parameters:parmDic cache:YES responseCache:^(id responseCache) {
        
    } success:^(id responseObject) {
        self.collectionView.loading = NO;
        self.collectionView.emptyDataSetSource = self;
        self.collectionView.emptyDataSetDelegate = self;
        if (responseObject == nil) {
            
        }else{
            if ([responseObject[@"code"] isEqualToString:@"0"]) {
                
                for (NSDictionary *dict in responseObject[@"data"]) {
                    [self.sectionArray addObject:dict[@"filter_name"]];
                    [self.itemArray addObject:dict[@"filter_items"]];
                }
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
//-(void)setIndex:(NSString *)index{
//    self.selectedArray = [NSMutableArray arrayWithArray:@[@"0", @"0", @"0"]];
//    self.sectionArray = [NSMutableArray array];
//    self.itemArray = [NSMutableArray array];
//    self.filtrateIDArray = [NSMutableArray arrayWithArray:@[@"-1", @"-1", @"-1"]];
//    if ([index isEqualToString:@"0"]) {
//        NSMutableDictionary *parmDic = [NSMutableDictionary dictionary];
//        [parmDic setObject:[UserDefaultsUtils valueWithKey:@"CateID"] forKey:@"cate_id"];
//        [ZMNetworkHelper POST:@"/course/filters" parameters:parmDic cache:YES responseCache:^(id responseCache) {
//
//        } success:^(id responseObject) {
//            if (responseObject == nil) {
//
//            }else{
//                if ([responseObject[@"code"] isEqualToString:@"0"]) {
//                    if ([responseObject[@"data"][@"cate_son"] count]==0) {
//
//                    }else{
//                        [self.sectionArray addObject:@"区域选择"];
//                        NSMutableArray *ary = [NSMutableArray array];
//
//                        NSDictionary *dic = @{@"name":@"不限",@"id":@"-1"};
//                        [ary addObject:dic];
//                        [ary addObjectsFromArray:responseObject[@"data"][@"cate_son"]];
//                        [self.itemArray addObject:ary];
//                    }
//                    if ([responseObject[@"data"][@"subject"] count]==0) {
//
//                    }else{
//
//                        [self.sectionArray addObject:@"学科选择"];
//                        NSMutableArray *ary = [NSMutableArray array];
//                        NSDictionary *dic = @{@"name":@"不限",@"id":@"-1"};
//                        [ary addObject:dic];
//                        [ary addObjectsFromArray:responseObject[@"data"][@"subject"]];
//                        [self.itemArray addObject:ary];
//
//                    }
//                    //通知主线程刷新
//                    dispatch_async(dispatch_get_main_queue(), ^{
//                        [_collectionView reloadData];
//                    });
//
//
//                }else{
//                    [BaseTools showErrorMessage:responseObject[@"msg"]];
//                }
//
//            }
//
//        } failure:^(NSError *error) {
//
//        }];
//    }else if ([index isEqualToString:@"1"]){
//        NSMutableDictionary *parmDic = [NSMutableDictionary dictionary];
//        [parmDic setObject:[UserDefaultsUtils valueWithKey:@"CateID"] forKey:@"cate_id"];
//        [ZMNetworkHelper POST:@"/exam/exam_list_cate" parameters:parmDic cache:YES responseCache:^(id responseCache) {
//
//        } success:^(id responseObject) {
//            if (responseObject == nil) {
//
//            }else{
//                if ([responseObject[@"code"] isEqualToString:@"0"]) {
//                    if ([responseObject[@"data"][@"cate_son"] count]==0) {
//
//                    }else{
//                        [self.sectionArray addObject:@"区域选择"];
//                        NSMutableArray *ary = [NSMutableArray array];
//
//                        NSDictionary *dic = @{@"name":@"不限",@"id":@"-1"};
//                        [ary addObject:dic];
//                        [ary addObjectsFromArray:responseObject[@"data"][@"cate_son"]];
//                        [self.itemArray addObject:ary];
//                    }
//                    if ([responseObject[@"data"][@"subject"] count]==0) {
//
//                    }else{
//
//                        [self.sectionArray addObject:@"学科选择"];
//                        NSMutableArray *ary = [NSMutableArray array];
//                        NSDictionary *dic = @{@"name":@"不限",@"id":@"-1"};
//                        [ary addObject:dic];
//                        [ary addObjectsFromArray:responseObject[@"data"][@"subject"]];
//                        [self.itemArray addObject:ary];
//
//                    }
//                    [self.sectionArray addObject:@"类型选择"];
//                    NSArray *ary1 = @[@{@"name":@"不限",@"id":@"-1"},@{@"name":@"练习专场",@"id":@"1"},@{@"name":@"押题专场",@"id":@"2"},@{@"name":@"模拟专场",@"id":@"3"},@{@"name":@"真题考场",@"id":@"4"}];
//                    [self.itemArray addObject:ary1];
//                    //通知主线程刷新
//                    dispatch_async(dispatch_get_main_queue(), ^{
//                        [_collectionView reloadData];
//                    });
//
//
//                }else{
//                    [BaseTools showErrorMessage:responseObject[@"msg"]];
//                }
//
//            }
//
//        } failure:^(NSError *error) {
//
//        }];
//    }else if ([index isEqualToString:@"2"]){
//        NSMutableDictionary *parmDic = [NSMutableDictionary dictionary];
//        [parmDic setObject:[UserDefaultsUtils valueWithKey:@"CateID"] forKey:@"cate_id"];
//        [ZMNetworkHelper POST:@"/book/book_type" parameters:parmDic cache:YES responseCache:^(id responseCache) {
//
//        } success:^(id responseObject) {
//            if (responseObject == nil) {
//
//            }else{
//                if ([responseObject[@"code"] isEqualToString:@"0"]) {
//                    if ([responseObject[@"data"][@"cate_son"] count]==0) {
//
//                    }else{
//                        [self.sectionArray addObject:@"区域选择"];
//                        NSMutableArray *ary = [NSMutableArray array];
//
//                        NSDictionary *dic = @{@"name":@"不限",@"id":@"-1"};
//                        [ary addObject:dic];
//                        [ary addObjectsFromArray:responseObject[@"data"][@"cate_son"]];
//                        [self.itemArray addObject:ary];
//                    }
//                    if ([responseObject[@"data"][@"subject"] count]==0) {
//
//                    }else{
//
//                        [self.sectionArray addObject:@"学科选择"];
//                        NSMutableArray *ary = [NSMutableArray array];
//                        NSDictionary *dic = @{@"name":@"不限",@"id":@"-1"};
//                        [ary addObject:dic];
//                        [ary addObjectsFromArray:responseObject[@"data"][@"subject"]];
//                        [self.itemArray addObject:ary];
//
//                    }
//                    //通知主线程刷新
//                    dispatch_async(dispatch_get_main_queue(), ^{
//                        [_collectionView reloadData];
//                    });
//
//
//                }else{
//                    [BaseTools showErrorMessage:responseObject[@"msg"]];
//                }
//
//            }
//
//
//        } failure:^(NSError *error) {
//
//        }];
//    }
//}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end












