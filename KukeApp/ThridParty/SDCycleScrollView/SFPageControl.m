//
//  SFPageControl.m
//  AnXinTongTeacher
//
//  Created by WSF on 2017/11/16.
//  Copyright © 2017年 WSF. All rights reserved.
//

#import "SFPageControl.h"

@implementation SFPageControl
- (void) setCurrentPage:(NSInteger)page {
    
    [super setCurrentPage:page];
    
    for (NSUInteger subviewIndex = 0; subviewIndex < [self.subviews count]; subviewIndex++) {
        
        UIImageView* subview = [self.subviews objectAtIndex:subviewIndex];
        
        CGSize size;
        
        size.height = 12;
        
        size.width = 12;
        
        [subview setFrame:CGRectMake(subview.frame.origin.x, subview.frame.origin.y,
                                     
                                     size.width,size.height)];

    }
    
}

@end
