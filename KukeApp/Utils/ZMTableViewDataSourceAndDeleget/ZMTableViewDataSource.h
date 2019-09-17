//  KukeApp
//
//  Created by iOSDeveloper on 2018/8/23.
//  Copyright © 2018年 zhangming. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void (^TableViewCellConfigureBlock)(id cell, id item);
@interface ZMTableViewDataSource : NSObject <UITableViewDataSource>
{
    NSString *_cellIdentifier;
    Class _cellClass;
    NSString *_cellNibName;
    TableViewCellConfigureBlock _configureCellBlock;
}
@property (nonatomic, strong) NSMutableArray *items;


- (id)initWithCellIdentifier:(NSString *)aCellIdentifier
                   cellClass:(Class)aCellClass
          configureCellBlock:(void (^)(id cell, id item))aConfigureCellBlock;


- (id)initWithCellIdentifier:(NSString *)aCellIdentifier
                 cellNibName:(NSString*)nibname
          configureCellBlock:(void (^)(id cell, id item))aConfigureCellBlock;
@end
