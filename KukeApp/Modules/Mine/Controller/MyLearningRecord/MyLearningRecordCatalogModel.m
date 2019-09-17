//
//  MyLearningRecordCatalogModel.m
//  KukeApp
//
//  Created by 库课 on 2018/12/20.
//  Copyright © 2018 zhangming. All rights reserved.
//

#import "MyLearningRecordCatalogModel.h"

@implementation MyLearningRecordCatalogModel

- (instancetype)initWithParentId : (NSString *)parentId nodeId : (NSString *)nodeId name : (NSString *)name depth : (NSString *)depth expand : (BOOL)expand dict : (NSDictionary *)dict{
    self = [self init];
    if (self) {
        self.parentId = parentId;
        self.nodeId = nodeId;
        self.name = name;
        self.depth = depth;
        self.expand = expand;
        self.dict = dict;
  
    }
    return self;
}
@end
