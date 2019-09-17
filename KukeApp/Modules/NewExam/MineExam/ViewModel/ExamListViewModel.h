//
//  ExamListViewModel.h
//  KukeApp
//
//  Created by 库课 on 2019/8/7.
//  Copyright © 2019 KukeZangMing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MineExamListModel.h"
typedef void(^titleDataBlock)(id _Nonnull obj);
typedef void(^listDataBlock)(MineExamListModel * _Nonnull model);
typedef void(^bookDataBlock)(id _Nonnull obj);
typedef void(^rinkingDataBlock)(id _Nonnull obj);
typedef void(^proposeDataBlock)(id _Nonnull obj);
NS_ASSUME_NONNULL_BEGIN

@interface ExamListViewModel : NSObject

- (void)loadTitleDataWithTitleBack:(titleDataBlock)titleBack fromController:(UIViewController *)vc;
- (void)loadListDataWithCateID:(NSString *)cate_id page:(NSInteger)page titleBack:(listDataBlock)listBack fromController:(UIViewController *)vc;
- (void)loadWrongBookorCollectionBookWtihCateId:(NSString *)cateid bookType:(NSString *)type bookData:(bookDataBlock)bookData fromController:(UIViewController *)vc;
- (void)loadExamRankingDataWithCateID:(NSString *)cate_id rankingType:(NSString *)type rankingData:(rinkingDataBlock)rankingData fromController:(UIViewController *)vc;

- (void)loadProposeDataWithCateID:(NSString *)cate_id proposeData:(proposeDataBlock)proposeData fromController:(UIViewController *)vc;
@end

NS_ASSUME_NONNULL_END
