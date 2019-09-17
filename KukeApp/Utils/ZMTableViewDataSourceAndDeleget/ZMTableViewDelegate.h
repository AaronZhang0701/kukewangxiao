//  KukeApp
//
//  Created by iOSDeveloper on 2018/8/23.
//  Copyright © 2018年 zhangming. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void (^didSelectRowAtIndexPath)(id cell, NSIndexPath *indexPath);
typedef void (^didDeselectRowAtIndexPath)(id cell, NSIndexPath *indexPath);
typedef void (^willDisplayCell)(id cell, NSIndexPath *indexPath);

typedef CGFloat (^heightForRowAtIndexPath)(NSIndexPath *indexPath);


@interface ZMTableViewDelegate : NSObject<UITableViewDelegate>
{
    didSelectRowAtIndexPath _didSelectRowAtIndexPath;
    didDeselectRowAtIndexPath _didDeselectRowAtIndexPath;
    willDisplayCell _willDisplayCell;
    heightForRowAtIndexPath _heightForRowAtIndexPath;
}

-(void)didSelectRowAtIndexPath:(void (^)(id cell, NSIndexPath *indexPath))didSelectRowAtIndexPath;
-(void)didDeselectRowAtIndexPath:(void (^)(id cell, NSIndexPath *indexPath))didDeselectRowAtIndexPath;
-(void)willDisplayCell:(void (^)(id cell, NSIndexPath *indexPath))willDisplayCell;

-(void)heightForRowAtIndexPath:(CGFloat (^)( NSIndexPath *indexPath))heightForRowAtIndexPath;

@end
