//
//  MyLearningRecordCatalogModel.h
//  KukeApp
//
//  Created by 库课 on 2018/12/20.
//  Copyright © 2018 zhangming. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MyLearningRecordCatalogModel : NSObject



@property (nonatomic , strong) NSString *parentId;//父节点的id，如果为-1表示该节点为根节点

@property (nonatomic , strong) NSString *nodeId;//本节点的id

@property (nonatomic , strong) NSString *name;//本节点的名称

@property (nonatomic , strong) NSString *depth;//该节点的深度

@property (nonatomic , assign) BOOL expand;//该节点是否处于展开状态

@property (nonatomic , strong) NSDictionary *dict;//该节点的深度

/**
 *快速实例化该对象模型
 */
- (instancetype)initWithParentId : (NSString *)parentId nodeId : (NSString *)nodeId name : (NSString *)name depth : (NSString *)depth expand : (BOOL )expand dict : (NSDictionary *)dict;

@end

NS_ASSUME_NONNULL_END
