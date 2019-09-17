
//  KukeApp
//
//  Created by iOSDeveloper on 2018/8/23.
//  Copyright © 2018年 zhangming. All rights reserved.
//

#import "ZMTableViewDataSource.h"

@implementation ZMTableViewDataSource

- (id)init
{
    return nil;
}

- (id)initWithCellIdentifier:(NSString *)aCellIdentifier
                   cellClass:(Class)aCellClass
          configureCellBlock:(void (^)(id cell, id item))aConfigureCellBlock
{
    self = [super init];
    if (self) {
        _cellIdentifier = aCellIdentifier;
        _configureCellBlock = [aConfigureCellBlock copy];
        _cellClass = aCellClass;
        _cellNibName = nil;
    }
    return self;
}

- (id)initWithCellIdentifier:(NSString *)aCellIdentifier
        cellNibName:(NSString*)nibname
 configureCellBlock:(void (^)(id cell, id item))aConfigureCellBlock{

    self = [super init];
    if (self) {
        _cellIdentifier = aCellIdentifier;
        _configureCellBlock = [aConfigureCellBlock copy];
        _cellClass = nil;
        _cellNibName = nibname;
    }
    return self;

}

#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_cellClass!=nil) {
        [tableView registerClass:_cellClass forCellReuseIdentifier:_cellIdentifier];
        if ([UINib nibWithNibName:[_cellClass description] bundle:nil]!= nil) {
            NSLog(@"存在同名xib 未使用");
        }
    }
    if (_cellNibName!=nil) {
        [tableView registerNib:[UINib nibWithNibName:[_cellNibName description] bundle:nil]forCellReuseIdentifier:_cellIdentifier];
    }
    

    //[tableView registerClass:_cellClass forCellReuseIdentifier:_cellIdentifier];

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:_cellIdentifier
                                                            forIndexPath:indexPath];
    id item = _items[indexPath.row];
    if (_configureCellBlock) {
        _configureCellBlock(cell, item);
    }
    return cell;
}

@end
