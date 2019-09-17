//
//  HomePageBannerTableViewCell.m
//  KukeApp
//
//  Created by iOSDeveloper on 2018/9/25.
//  Copyright © 2018年 zhangming. All rights reserved.
//

#import "HomePageBannerTableViewCell.h"
#import "SDCycleScrollView.h"

@interface HomePageBannerTableViewCell()<SDCycleScrollViewDelegate>

@property (nonatomic, strong) SDCycleScrollView *cycleView;
@property (nonatomic, strong) UIButton *downLoadBtn;
@end

@implementation HomePageBannerTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    // 这里不是直接[super initWithStyle:style reuseIdentifier:reuseIdentifier]方法,而是if....
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self configSelf];
        [self configCycleView];
        [self createButton];
    }
    
    return self;
}

- (void)configSelf {
    
}
- (void)setImageAry:(NSArray *)imageAry{
    _cycleView.imageURLStringsGroup = imageAry;
}
- (void)configCycleView {

    _cycleView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, screenWidth(), screenHeight()/3.5) imageURLStringsGroup:self.imageAry];
    _cycleView.delegate = self;
    _cycleView.pageControlStyle = SDCycleScrollViewPageContolStyleAnimated;
    _cycleView.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    [self.contentView addSubview:_cycleView];
}
- (void)createButton{
    
    UIButton *cameraBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    cameraBtn.frame = CGRectMake(10, 30, 29, 29);
    [cameraBtn setImage:[UIImage imageNamed:@"扫一扫图标"] forState:(UIControlStateNormal)];
    [cameraBtn addTarget:self action:@selector(cameraAction) forControlEvents:(UIControlEventTouchUpInside)];
    [_cycleView addSubview:cameraBtn];
    _cycleView.userInteractionEnabled = YES;
    
    self.downLoadBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    self.downLoadBtn.frame = CGRectMake(screenWidth()-37, 30, 29, 29);
    [self.downLoadBtn setImage:[UIImage imageNamed:@"下载图标"] forState:(UIControlStateNormal)];
    [self.downLoadBtn addTarget:self action:@selector(downLoadAction) forControlEvents:(UIControlEventTouchUpInside)];
    [_cycleView addSubview:self.downLoadBtn];
    
    UIButton *recodeBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    recodeBtn.frame = CGRectMake(minX(self.downLoadBtn)-7-29, 30, 29, 29);
    [recodeBtn setImage:[UIImage imageNamed:@"历史记录图标"] forState:(UIControlStateNormal)];
    [recodeBtn addTarget:self action:@selector(recordAction) forControlEvents:(UIControlEventTouchUpInside)];
    [_cycleView addSubview:recodeBtn];

    
    
}
- (void)cameraAction{
    
    if (_myQRcodeBlock) {
        self.myQRcodeBlock();
    }
}
- (void)downLoadAction{
    if (_myDownLoadBlock) {
        self.myDownLoadBlock();
    }
}
- (void)recordAction{
    if (_myRecordBlock) {
        self.myRecordBlock();
    }
}
- (void)layoutSubviews {
    [super layoutSubviews];
    [self.cycleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top);
        make.bottom.equalTo(self.contentView.mas_bottom);
        make.left.equalTo(self.contentView.mas_left);
        make.right.equalTo(self.contentView.mas_right);
    }];
}

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    if (_myBannarBlock) {
        self.myBannarBlock(index);
    }
}
@end
