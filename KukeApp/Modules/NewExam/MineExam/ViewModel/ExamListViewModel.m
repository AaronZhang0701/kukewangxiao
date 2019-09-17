//
//  ExamListViewModel.m
//  KukeApp
//
//  Created by 库课 on 2019/8/7.
//  Copyright © 2019 KukeZangMing. All rights reserved.
//

#import "ExamListViewModel.h"

@implementation ExamListViewModel

- (void)loadTitleDataWithTitleBack:(titleDataBlock)titleBack fromController:(UIViewController *)vc{


    BADataEntity *entity = [BADataEntity new];
    entity.urlString = @"/ucenter/exam_cate";
    entity.needCache = NO;
    entity.parameters = nil;
    
    // 如果打印数据不完整，是因为 Xcode 8 版本问题，请下断点打印数据
    [BANetManager ba_request_POSTWithEntity:entity successBlock:^(id response) {
        
        if (response == nil) {
            
        }else{
            if ([response[@"code"] isEqualToString:@"0"]) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (titleBack) {
                        titleBack(response);
                    }
                    
                });
            }else if ([response[@"code"] isEqualToString:@"-10000"]){
                [BaseTools showErrorMessage:@"请登录后再操作"];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [BaseTools alertLoginWithVC:vc];
                });
                
            }else{
                if (titleBack) {
                    titleBack(response);
                }
                [BaseTools showErrorMessage:response[@"msg"]];
            }
        }
    } failureBlock:^(NSError *error) {
 
    } progressBlock:^(int64_t bytesProgress, int64_t totalBytesProgress) {
        /*! 封装方法里已经回到主线程，所有这里不用再调主线程了 */
        
    }];
 
}


- (void)loadListDataWithCateID:(NSString *)cate_id page:(NSInteger)page titleBack:(listDataBlock)listBack fromController:(UIViewController *)vc{
    NSMutableDictionary *parmDic = [NSMutableDictionary dictionary];
    [parmDic setObject:cate_id forKey:@"cate_id"];
    [parmDic setObject:[NSNumber numberWithInteger:page] forKey:@"page"];
    
    [ZMNetworkHelper POST:@"/ucenter/exam_log_v3" parameters:parmDic cache:YES responseCache:^(id responseCache) {
        
    } success:^(id responseObject) {
        if (responseObject == nil) {
            
        }else{
            if ([responseObject[@"code"] isEqualToString:@"0"]) {
                
                MineExamListModel *model = [[MineExamListModel alloc]initWithDictionary:responseObject error:nil];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (listBack) {
                        listBack(model);
                    }
                    
                });
            }else if ([responseObject[@"code"] isEqualToString:@"-10000"]){
                [BaseTools showErrorMessage:@"请登录后再操作"];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [BaseTools alertLoginWithVC:vc];
                });
                
            }else{
                [BaseTools showErrorMessage:responseObject[@"msg"]];
            }
        }
        
    } failure:^(NSError *error) {
        
    }];
}
- (void)loadWrongBookorCollectionBookWtihCateId:(NSString *)cateid bookType:(NSString *)type bookData:(bookDataBlock)bookData fromController:(UIViewController *)vc{
    NSMutableDictionary *parmDic = [NSMutableDictionary dictionary];
    [parmDic setObject:cateid forKey:@"cate_id"];
    [parmDic setObject:type forKey:@"flag"];
    [ZMNetworkHelper POST:@"/ucenter/exam_wrong_collection" parameters:parmDic cache:YES responseCache:^(id responseCache) {
        
    } success:^(id responseObject) {
        if (responseObject == nil) {
            
        }else{
            if ([responseObject[@"code"] isEqualToString:@"0"]) {

                dispatch_async(dispatch_get_main_queue(), ^{
                    if (bookData) {
                        bookData(responseObject);
                    }
                    
                });
            }else if ([responseObject[@"code"] isEqualToString:@"-10000"]){
                [BaseTools showErrorMessage:@"请登录后再操作"];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [BaseTools alertLoginWithVC:vc];
                });
                
            }else{
                [BaseTools showErrorMessage:responseObject[@"msg"]];
            }
        }
        
    } failure:^(NSError *error) {
        
    }];
}
- (void)loadExamRankingDataWithCateID:(NSString *)cate_id rankingType:(NSString *)type rankingData:(rinkingDataBlock)rankingData fromController:(UIViewController *)vc{
    NSMutableDictionary *parmDic = [NSMutableDictionary dictionary];
    [parmDic setObject:cate_id forKey:@"cate_id"];
    [parmDic setObject:type forKey:@"flag"];
    [ZMNetworkHelper POST:@"/ucenter/exam_ranking" parameters:parmDic cache:YES responseCache:^(id responseCache) {
        
    } success:^(id responseObject) {
        if (responseObject == nil) {
            
        }else{
            
            if ([responseObject[@"code"] isEqualToString:@"0"]) {
                NSMutableArray *ary = [NSMutableArray array];
                NSMutableDictionary *dit  = [NSMutableDictionary dictionary];
                
                [dit setObject:responseObject[@"data"][@"mine_do_count"] forKey:@"do_count"];
                [dit setObject:responseObject[@"data"][@"mine_ranking"] forKey:@"ranking"];
                [dit setObject:responseObject[@"data"][@"mine_mobile"] forKey:@"mobile"];
                [dit setObject:responseObject[@"data"][@"mine_photo"] forKey:@"photo"];
                [dit setObject:@"2" forKey:@"is_inside"];
                [ary addObject:dit];
                [ary addObjectsFromArray:responseObject[@"data"][@"ranking"]];
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    if (rankingData) {
                        rankingData(ary);
                    }
                    
                });
            }else if ([responseObject[@"code"] isEqualToString:@"-10000"]){
                [BaseTools showErrorMessage:@"请登录后再操作"];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [BaseTools alertLoginWithVC:vc];
                });
                
            }else{
                [BaseTools showErrorMessage:responseObject[@"msg"]];
            }
        }
        
    } failure:^(NSError *error) {
        
    }];
    
}

- (void)loadProposeDataWithCateID:(NSString *)cate_id proposeData:(proposeDataBlock)proposeData fromController:(UIViewController *)vc{
    NSMutableDictionary *parmDic = [NSMutableDictionary dictionary];
    [parmDic setObject:cate_id forKey:@"cate_id"];
    [ZMNetworkHelper POST:@"/ucenter/exam_recommend" parameters:parmDic cache:YES responseCache:^(id responseCache) {
        
    } success:^(id responseObject) {
        if (responseObject == nil) {
            
        }else{
            if ([responseObject[@"code"] isEqualToString:@"0"]) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (proposeData) {
                        proposeData(responseObject);
                    }
                    
                });
            }else if ([responseObject[@"code"] isEqualToString:@"-10000"]){
                [BaseTools showErrorMessage:@"请登录后再操作"];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [BaseTools alertLoginWithVC:vc];
                });
                
            }else{
                [BaseTools showErrorMessage:responseObject[@"msg"]];
            }
        }
        
    } failure:^(NSError *error) {
        
    }];
    
}
@end
