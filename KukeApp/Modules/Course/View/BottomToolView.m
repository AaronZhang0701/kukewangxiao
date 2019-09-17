//
//  BottomToolView.m
//  KukeApp
//
//  Created by iOSDeveloper on 2018/10/1.
//  Copyright © 2018年 zhangming. All rights reserved.
//

#import "BottomToolView.h"
#import "UIButton+AICategory.h"

@interface BottomToolView (){
    UIButton *singleBuyBtn;
    UIButton *groupBuyBtn;
    NSDictionary *seckillDict;
    BOOL isSeckill;
    BOOL isDistribution;
    BOOL isLive;
}

@end

@implementation BottomToolView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {

    }
    return self;
}
- (void)setIsDistribute:(NSString *)isDistribute{
    if ([isDistribute isEqualToString:@"1"]) {
        isDistribution = YES;
    }else{
        isDistribution  = NO;
    }
}
- (void)initDistributionView{
    UILabel *lineLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, screenWidth(), 1)];
    lineLab.backgroundColor = CBackgroundColor;
    [self addSubview:lineLab];
    
    UIButton *consultationBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    consultationBtn.frame = CGRectMake(10, 0, 60, 49);
    [consultationBtn setImage:[UIImage imageNamed:@"咨询"] forState:(UIControlStateNormal)];
    [consultationBtn setTitle:@"咨询" forState:(UIControlStateNormal)];
    [consultationBtn addTarget:self action:@selector(HXAction) forControlEvents:(UIControlEventTouchUpInside)];
    consultationBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [consultationBtn setTitleColor:[UIColor lightGrayColor] forState:(UIControlStateNormal)];
    [consultationBtn br_layoutButtonWithEdgeInsetsStyle:(BRButtonEdgeInsetsStyleTop) imageTitleSpace:2];
    [self addSubview:consultationBtn];
    
    UIButton *callBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    callBtn.frame = CGRectMake(maxX(consultationBtn), 0, 60, 49);
    [callBtn setImage:[UIImage imageNamed:@"致电按钮"] forState:(UIControlStateNormal)];
    [callBtn setTitle:@"致电" forState:(UIControlStateNormal)];
    callBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [callBtn addTarget:self action:@selector(callAction) forControlEvents:(UIControlEventTouchUpInside)];
    [callBtn setTitleColor:[UIColor lightGrayColor] forState:(UIControlStateNormal)];
    [callBtn br_layoutButtonWithEdgeInsetsStyle:(BRButtonEdgeInsetsStyleTop) imageTitleSpace:2];
    [self addSubview:callBtn];
    
    UIButton *buyBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    buyBtn.backgroundColor = [UIColor colorWithRed:244/255.0 green:171/255.0 blue:14/255.0 alpha:1];
    buyBtn.frame = CGRectMake(maxX(callBtn), 0, (screenWidth()-120)/2, 49);
    [buyBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateSelected)];
    buyBtn.titleLabel.lineBreakMode = 0;//这句话很重要，不加这句话加上换行符也没
    buyBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    buyBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [buyBtn addTarget:self action:@selector(pay) forControlEvents:(UIControlEventTouchUpInside)];
    [buyBtn setTitle:@"立即购买" forState:(UIControlStateNormal)];
    [self addSubview:buyBtn];
    
    UIButton *distributionBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    distributionBtn.frame = CGRectMake(maxX(buyBtn), 0, (screenWidth()-120)/2, 49);
    distributionBtn.backgroundColor = CNavBgColor;
    distributionBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [distributionBtn addTarget:self action:@selector(shareAction) forControlEvents:(UIControlEventTouchUpInside)];
    [distributionBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    distributionBtn.titleLabel.lineBreakMode = 0;
    distributionBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [distributionBtn setTitle:@"立即赚钱" forState:(UIControlStateNormal)];
    [self addSubview:distributionBtn];
    
    
}
- (void)setGoodsType:(NSString *)goodsType{
    if ([goodsType isEqualToString:@"6"]) {
        isLive = YES;
    }
}

- (void)setGoodsDict:(NSDictionary *)goodsDict{
    if (isDistribution) {
        [self initDistributionView];
    }else{
        if ([goodsDict[@"seckill_flag"] isEqualToString:@"0"]) {
            
            isSeckill = NO;
        }else if([goodsDict[@"seckill_flag"] isEqualToString:@"1"]){
            isSeckill = YES;
            seckillDict = goodsDict[@"seckill_goods"];
        }
        if ([goodsDict[@"group_sign"] isEqualToString:@"1"]) {
            
            [self createGroupView];
            [singleBuyBtn setTitle:[NSString stringWithFormat:@"%@\n单独购买",goodsDict[@"discount_price"]] forState:(UIControlStateNormal)];
            singleBuyBtn.titleLabel.font = [UIFont systemFontOfSize:14];
            
            [groupBuyBtn setTitle:[NSString stringWithFormat:@"%@\n立即开团",goodsDict[@"group"][@"group_buy_price"]] forState:(UIControlStateNormal)];
            groupBuyBtn.titleLabel.font = [UIFont systemFontOfSize:14];
            
        }else{
            [self createView];
           
            if ([goodsDict[@"is_buy"] isEqualToString:@"1"]  && isLive) {
                self.buyBtn.userInteractionEnabled = NO;
                [self.buyBtn setTitle:@"已购买" forState:(UIControlStateNormal)];
                self.buyBtn.backgroundColor = [UIColor colorWithRed:138/255.0 green:138/255.0 blue:138/255.0 alpha:1];;
            }
            if ([goodsDict[@"status"] isEqualToString:@"2"]) {
                self.buyBtn.userInteractionEnabled = NO;
                [self.buyBtn setTitle:@"已下架" forState:(UIControlStateNormal)];
                self.buyBtn.backgroundColor = [UIColor colorWithRed:138/255.0 green:138/255.0 blue:138/255.0 alpha:1];;
                
            }
        }
    }
    
   
}
- (void)createView{
    UILabel *lineLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, screenWidth(), 1)];
    lineLab.backgroundColor = CBackgroundColor;
    [self addSubview:lineLab];
    
    UIButton *consultationBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    consultationBtn.frame = CGRectMake(10, 0, 60, 49);
    [consultationBtn setImage:[UIImage imageNamed:@"咨询"] forState:(UIControlStateNormal)];
    [consultationBtn setTitle:@"咨询" forState:(UIControlStateNormal)];
    [consultationBtn addTarget:self action:@selector(HXAction) forControlEvents:(UIControlEventTouchUpInside)];
    consultationBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [consultationBtn setTitleColor:[UIColor lightGrayColor] forState:(UIControlStateNormal)];
    [consultationBtn br_layoutButtonWithEdgeInsetsStyle:(BRButtonEdgeInsetsStyleTop) imageTitleSpace:2];
    [self addSubview:consultationBtn];
    
    UIButton *callBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    callBtn.frame = CGRectMake(maxX(consultationBtn), 0, 60, 49);
    [callBtn setImage:[UIImage imageNamed:@"致电按钮"] forState:(UIControlStateNormal)];
    [callBtn setTitle:@"致电" forState:(UIControlStateNormal)];
    callBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [callBtn addTarget:self action:@selector(callAction) forControlEvents:(UIControlEventTouchUpInside)];
    [callBtn setTitleColor:[UIColor lightGrayColor] forState:(UIControlStateNormal)];
    [callBtn br_layoutButtonWithEdgeInsetsStyle:(BRButtonEdgeInsetsStyleTop) imageTitleSpace:2];
    [self addSubview:callBtn];
    
    
    _collectionBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    _collectionBtn.frame = CGRectMake(maxX(callBtn), 0, 60, 49);
    [_collectionBtn setImage:[UIImage imageNamed:@"收藏"] forState:(UIControlStateNormal)];
    [_collectionBtn setTitle:@"收藏" forState:(UIControlStateNormal)];
    [_collectionBtn setTitleColor:[UIColor lightGrayColor] forState:(UIControlStateNormal)];
    _collectionBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [_collectionBtn setTitleColor:CNavBgColor forState:(UIControlStateSelected)];
    [_collectionBtn br_layoutButtonWithEdgeInsetsStyle:(BRButtonEdgeInsetsStyleTop) imageTitleSpace:2];
    [self addSubview:_collectionBtn];
    
    if (isSeckill) {//秒杀商品

        if ([seckillDict[@"seckill_status"] isEqualToString:@"1"]) {
            self.buyBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
            self.buyBtn.frame = CGRectMake(maxX(_collectionBtn), 0, screenWidth()-maxX(_collectionBtn), 49);
            self.buyBtn.backgroundColor = CNavBgColor;
            [self.buyBtn addTarget:self action:@selector(pay) forControlEvents:(UIControlEventTouchUpInside)];
            self.buyBtn.titleLabel.font = [UIFont systemFontOfSize:15];
            [self.buyBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
            [self addSubview:self.buyBtn];
            //倒计时
            
            [self beginCountDown: ^(id receiver, NSInteger leftTime, BOOL *isStop) {
                if (leftTime > 0) {
           
                    if ([self.buyBtn.currentTitle isEqualToString:@"已下架"]) {
                        
                    }else{
                        [self.buyBtn setTitle:@"立即购买" forState:(UIControlStateNormal)];
                    }
                    
                    
                } else {
                    if ([self.buyBtn.currentTitle isEqualToString:@"已下架"]) {
                        
                    }else{
                         [self.buyBtn setTitle:@"立即抢购" forState:(UIControlStateNormal)];
                    }
                   
                }
            } WithStartTimeStamp:[[BaseTools currentTimeStr] longLongValue] endTimeStamp:[seckillDict[@"end_time"] longLongValue]*1000];

        }else if ([seckillDict[@"seckill_status"] isEqualToString:@"0"]){
            self.buyBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
            self.buyBtn.frame = CGRectMake(maxX(_collectionBtn), 0, screenWidth()-maxX(_collectionBtn), 49);
            self.buyBtn.titleLabel.font = [UIFont systemFontOfSize:15];
            [self.buyBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
            [self addSubview:self.buyBtn];
 
            [self beginCountDown: ^(id receiver, NSInteger leftTime, BOOL *isStop) {
                if (leftTime > 0) {
                    NSInteger hours   = (NSInteger)((leftTime)/3600);
                    NSInteger minute  = (NSInteger)(leftTime- hours*3600)/60;
                    NSInteger second  = (NSInteger)leftTime- hours*3600 - minute*60;
                    [self.buyBtn setTitle:[NSString stringWithFormat:@"即将开抢 %02ld:%02ld:%02ld",hours,minute,second] forState:(UIControlStateNormal)];
                    self.buyBtn.backgroundColor = [UIColor colorWithRed:243/255.0 green:144/255.0 blue:148/255.0 alpha:1];
                } else {
                    [self.buyBtn setTitle:@"立即抢购" forState:(UIControlStateNormal)];
                    self.buyBtn.backgroundColor = CNavBgColor;
                    [self.buyBtn addTarget:self action:@selector(pay) forControlEvents:(UIControlEventTouchUpInside)];
                }
            } WithStartTimeStamp:[[BaseTools currentTimeStr] longLongValue] endTimeStamp:[seckillDict[@"start_time"] longLongValue]*1000];

        }
        
    }else{//普通商品
        self.buyBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        self.buyBtn.frame = CGRectMake(maxX(_collectionBtn), 0, screenWidth()-maxX(_collectionBtn), 49);
        
        if ([self.buyBtn.currentTitle isEqualToString:@"已下架"]) {
            
        }else{
            [self.buyBtn setTitle:@"立即购买" forState:(UIControlStateNormal)];
        }
        self.buyBtn.backgroundColor = CNavBgColor;
        [self.buyBtn addTarget:self action:@selector(pay) forControlEvents:(UIControlEventTouchUpInside)];
        self.buyBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [self.buyBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        [self addSubview:self.buyBtn];
        
    }
  
}

- (void)createGroupView{
    UILabel *lineLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, screenWidth(), 1)];
    lineLab.backgroundColor = CBackgroundColor;
    [self addSubview:lineLab];
    
    UIButton *consultationBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    consultationBtn.frame = CGRectMake(0, 0, 70, 49);
    [consultationBtn setImage:[UIImage imageNamed:@"咨询"] forState:(UIControlStateNormal)];
    [consultationBtn setTitle:@"咨询" forState:(UIControlStateNormal)];
    [consultationBtn addTarget:self action:@selector(HXAction) forControlEvents:(UIControlEventTouchUpInside)];
    consultationBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [consultationBtn setTitleColor:[UIColor lightGrayColor] forState:(UIControlStateNormal)];
    [consultationBtn br_layoutButtonWithEdgeInsetsStyle:(BRButtonEdgeInsetsStyleTop) imageTitleSpace:2];
    [self addSubview:consultationBtn];
    
    
    singleBuyBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    singleBuyBtn.backgroundColor = [UIColor colorWithRed:138/255.0 green:138/255.0 blue:138/255.0 alpha:1];
    singleBuyBtn.frame = CGRectMake(maxX(consultationBtn), 0, (screenWidth()-60)/2, 49);
    [singleBuyBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateSelected)];
    singleBuyBtn.titleLabel.lineBreakMode = 0;//这句话很重要，不加这句话加上换行符也没
    singleBuyBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [singleBuyBtn addTarget:self action:@selector(pay) forControlEvents:(UIControlEventTouchUpInside)];
    [self addSubview:singleBuyBtn];
    
    groupBuyBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    groupBuyBtn.frame = CGRectMake(maxX(singleBuyBtn), 0, (screenWidth()-60)/2, 49);
    groupBuyBtn.backgroundColor = CNavBgColor;
    groupBuyBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [groupBuyBtn addTarget:self action:@selector(groupPayAction) forControlEvents:(UIControlEventTouchUpInside)];
    [groupBuyBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    groupBuyBtn.titleLabel.lineBreakMode = 0;
    [self addSubview:groupBuyBtn];
}
- (void)pay{
    if (_myBlock) {
        self.myBlock(false);
    }
}
- (void)groupPayAction{
    if (_myBlock) {
        self.myBlock(true);
    }
}
- (void)HXAction{
    if (_myHXBlock) {
        self.myHXBlock();
    }
}
- (void)shareAction{
    if (_myShareBlock) {
        self.myShareBlock();
    }
}
- (void)callAction{
    
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",@"400-6529-888"];
    UIWebView * callWebview = [[UIWebView alloc] init];
    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
    [self addSubview:callWebview];

}
- (void)dealloc{
    [[ZMTimeCountDown ShareManager] zj_timeDestoryTimer];
}

@end
