//
//  NewsHeaderView.m
//  KukeApp
//
//  Created by 库课 on 2019/5/13.
//  Copyright © 2019 KukeZangMing. All rights reserved.
//

#import "NewsHeaderView.h"
#import "HorizontalPageFlowlayout.h"
#import "NewsHeaderCollectionViewCell.h"

@interface NewsHeaderView()<UICollectionViewDelegate,UICollectionViewDataSource>{

    NSInteger index_id;
    NSInteger push_index_id;
    NSString *push_oidStr;
}

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *listAry;

@end
@implementation NewsHeaderView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushAction:) name:@"Push_News" object:nil];
        index_id = -1;
        [self createView];
        self.backgroundColor = CBackgroundColor;
        
    }
    return self;
}
- (void)setPush_oid:(NSString *)push_oid{
    push_oidStr = push_oid;
    [_collectionView reloadData];
    double delayInSeconds = 0.5f;
    
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void) {
        
        for (int i = 0; i<self.listAry.count; i++) {
            if ([self.listAry[i][@"id"]isEqualToString:push_oid] ) {
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
                [_collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:true];
            }
        }
        
    });
   
}
-(void)setNews_cate_id:(NSString *)news_cate_id{
    
    
    
    self.listAry = [NSMutableArray array];
    NSMutableDictionary *parmDic = [NSMutableDictionary dictionary];
    [parmDic setObject:news_cate_id forKey:@"id"];
    [ZMNetworkHelper POST:@"/news/news_type_v2" parameters:parmDic cache:YES responseCache:^(id responseCache) {
        
    } success:^(id responseObject) {
        if (responseObject == nil) {
            
        }else{
            if ([responseObject[@"code"] isEqualToString:@"0"]) {
                [self dataAnalysis:responseObject];
            }else{
                [BaseTools showErrorMessage:responseObject[@"msg"]];
            }
        }
        
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark —————  请求到的数据进行解析  --———
- (void)dataAnalysis:(id)data{
   
    [self.listAry addObjectsFromArray:data[@"data"]];

    //通知主线程刷新
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.collectionView reloadData];
    });
    
    


}


- (void)createView{
    
    UICollectionViewFlowLayout * flowLayout = [[UICollectionViewFlowLayout alloc]init];
    
    CGFloat itemWidth = 72;
    
    //设置单元格大小
    flowLayout.itemSize = CGSizeMake(itemWidth, 40);
    //最小行间距(默认为10)
    flowLayout.minimumLineSpacing = 10;
    //最小item间距（默认为10）
    flowLayout.minimumInteritemSpacing = 10;
    //设置senction的内边距
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 15, 0, 15);
    //设置UICollectionView的滑动方向
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, screenWidth()-60, 40) collectionViewLayout:flowLayout];
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.bounces = YES;
    _collectionView.pagingEnabled = NO;
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([NewsHeaderCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:@"NewsHeaderCollectionViewCell"];
    [self addSubview:_collectionView];
    
}


#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    return self.listAry.count;
    
//    return 10;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NewsHeaderCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"NewsHeaderCollectionViewCell" forIndexPath:indexPath];
    cell.titleLab.text = self.listAry[indexPath.item][@"name"];
    
    if (push_oidStr.length != 0) {
     
        if ([self.listAry[indexPath.item][@"id"] isEqualToString:push_oidStr]) {
            push_index_id = indexPath.item;
            cell.selected = YES;
            
            if (_newsTypeActionBlock) {
                self.newsTypeActionBlock(self.listAry[indexPath.item][@"id"]);
            }
        }
        
        
    }else{
        if (index_id == -1 && indexPath.item == 0) {
            cell.selected = YES;
            if (_newsTypeActionBlock) {
                self.newsTypeActionBlock(self.listAry[indexPath.item][@"id"]);
            }
            //        cell.titleLab.backgroundColor = CNavBgColor;
            //        cell.titleLab.layer.borderWidth = 0;
            //        cell.titleLab.layer.cornerRadius = 11;
            //        cell.titleLab.layer.masksToBounds = YES;
            //        //    cell.layer.borderColor = [CTitleColor CGColor];
            //        cell.titleLab.textColor = [UIColor whiteColor];
        }
    }
    

    
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{

    if (push_oidStr.length != 0 ) {
        NewsHeaderCollectionViewCell *cell = (NewsHeaderCollectionViewCell *)[collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:push_index_id inSection:0]];
        cell.titleLab.backgroundColor = [UIColor whiteColor];
        cell.titleLab.layer.borderWidth = 0.5f;
        cell.titleLab.layer.borderColor = [CTitleColor CGColor];
        cell.titleLab.textColor = CTitleColor;
        cell.titleLab.layer.cornerRadius = 11;
        cell.titleLab.layer.masksToBounds = YES;
        push_oidStr = @"";
    }else{
        if (index_id == -1 ) {
            NewsHeaderCollectionViewCell *cell = (NewsHeaderCollectionViewCell *)[collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
            cell.titleLab.backgroundColor = [UIColor whiteColor];
            cell.titleLab.layer.borderWidth = 0.5f;
            cell.titleLab.layer.borderColor = [CTitleColor CGColor];
            cell.titleLab.textColor = CTitleColor;
            cell.titleLab.layer.cornerRadius = 11;
            cell.titleLab.layer.masksToBounds = YES;
            
        }
    }
    
    
    if (_newsTypeActionBlock) {
        self.newsTypeActionBlock(self.listAry[indexPath.item][@"id"]);
    }
    index_id = indexPath.item;
//    NewsHeaderCollectionViewCell *cell = (NewsHeaderCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
//    cell.titleLab.backgroundColor = CNavBgColor;
//    cell.titleLab.layer.borderWidth = 0;
//    cell.titleLab.layer.cornerRadius = 11;
//    cell.titleLab.layer.masksToBounds = YES;
////    cell.layer.borderColor = [CTitleColor CGColor];
//    cell.titleLab.textColor = [UIColor whiteColor];
//
//    NSLog(@"第%ld区，第%ld个",(long)indexPath.section,(long)indexPath.row);
    
    
//
}

////取消选定
//
//-(void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath{
//
//    NewsHeaderCollectionViewCell *cell = (NewsHeaderCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
//    cell.titleLab.backgroundColor = [UIColor whiteColor];
//    cell.titleLab.layer.borderWidth = 0.5f;
//    cell.titleLab.layer.borderColor = [CTitleColor CGColor];
//    cell.titleLab.textColor = CTitleColor;
//    cell.titleLab.layer.cornerRadius = 11;
//    cell.titleLab.layer.masksToBounds = YES;
//    NSLog(@"第%ld区，第%ld个",(long)indexPath.section,(long)indexPath.row);
//
//}

@end
