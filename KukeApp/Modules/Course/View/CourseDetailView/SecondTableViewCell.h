//
//  SecondTableViewCell.h
//  cellWebView
//
//  Created by abc on 2018/5/28.
//  Copyright © 2018年 mike. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol webViewCellDelegate<NSObject>

- (void)webViewDidFinishLoad:(CGFloat)webHeight;

@end

@interface SecondTableViewCell : UITableViewCell

@property (nonatomic,weak) id<webViewCellDelegate>delegate;
@property (nonatomic, assign) NSInteger indexPath;
- (void)refreshWebView:(NSString *)url indexPath:(NSInteger)index;

@end
