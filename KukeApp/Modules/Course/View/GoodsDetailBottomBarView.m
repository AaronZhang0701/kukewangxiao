//
//  GoodsDetailBottomBarView.m
//  KukeApp
//
//  Created by 库课 on 2019/9/7.
//  Copyright © 2019 KukeZhangMing. All rights reserved.
//

#import "GoodsDetailBottomBarView.h"
#import "PayMentViewController.h"
#import "CourseDetailModel.h"
#import "DistributionBottomShareView.h"
#import "DistributionGoodsShareView.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import "MyLearningRecordViewController.h"
#import "MyAnswerViewController.h"
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif

@interface GoodsDetailBottomBarView (){
    
    NSString *clickAction;
    
}
@property (strong, nonatomic) DistributionBottomShareView *shareView;
@property (strong, nonatomic) CourseDetailModel *model;
@end

@implementation GoodsDetailBottomBarView

- (instancetype)initWithFrame:(CGRect)frame withData:(NSMutableDictionary *)data{
    if (self = [super init]) {
        [self setupUIWithData:data];
        self.backgroundColor = [UIColor whiteColor];
        self.frame = CGRectMake(0, screenHeight()-49, screenWidth(), 49);
    
        [self checkCurrentNotificationStatus];
        
        
    }
    return self;
}

- (void)setupUIWithData:(NSMutableDictionary *)data{
    self.model = [[CourseDetailModel alloc]initWithDictionary:data error:nil];
    
    [self addSubview:self.advisoryBtn];
    [self addSubview:self.collectionBtn];
    if ([self.model.is_collect isEqualToString:@"1"]) {
        [self.collectionBtn setTitle:@"已收藏" forState:(UIControlStateNormal)];
        [self.collectionBtn setImage:[UIImage imageNamed:@"已收藏"] forState:(UIControlStateNormal)];
        [self.collectionBtn br_layoutButtonWithEdgeInsetsStyle:(BRButtonEdgeInsetsStyleTop) imageTitleSpace:2];
    }else{
        [self.collectionBtn setTitle:@"收藏" forState:(UIControlStateNormal)];
        [self.collectionBtn setImage:[UIImage imageNamed:@"收藏"] forState:(UIControlStateNormal)];
        [self.collectionBtn br_layoutButtonWithEdgeInsetsStyle:(BRButtonEdgeInsetsStyleTop) imageTitleSpace:2];
    }
    if ([data[@"my_click_distribute"] isEqualToString:@"1"]) {//分销
        
        if ([data[@"is_sell"] isEqualToString:@"1"]) {//可售
            [self addSubview:self.rightBtn];
            self.rightBtn.backgroundColor = CNavBgColor;
            [self.rightBtn setTitle:@"立即赚钱" forState:(UIControlStateNormal)];
            clickAction = @"立即赚钱";
        }else{
            [self addSubview:self.rightBtn];
            self.rightBtn.backgroundColor = [UIColor colorWithHexString:@"#8A8A8A"];
            [self.rightBtn setTitle:@"暂不可购买" forState:(UIControlStateNormal)];
            clickAction = @"暂不支持购买";
        }
        
    }else{//不是分销
        if ([data[@"is_buy"] isEqualToString:@"1"]) {//已经购买

            switch ([data[@"my_goods_type"] integerValue]) {
                case 1:{//题库
                    
                    [self addSubview:self.rightBtn];
                    self.rightBtn.backgroundColor = CNavBgColor;
                    [self.rightBtn setTitle:@"已购买，开始做题" forState:(UIControlStateNormal)];
                    clickAction = @"开始做题";
                    
                };break;
                case 3:{//课程
                    [self addSubview:self.rightBtn];
                    self.rightBtn.backgroundColor = CNavBgColor;
                    [self.rightBtn setTitle:@"已购买，开始学习" forState:(UIControlStateNormal)];
                    clickAction = @"课程开始学习";
                    
                    
                };break;
                case 4:{//图书
                    if ([data[@"is_sell"] isEqualToString:@"1"]) {//可售
                        [self addSubview:self.rightBtn];
                        self.rightBtn.backgroundColor = CNavBgColor;
                        [self.rightBtn setTitle:@"立即购买" forState:(UIControlStateNormal)];
                        clickAction = @"立即购买";
                    }else{//不可售
                        [self addSubview:self.rightBtn];
                        self.rightBtn.backgroundColor = [UIColor colorWithHexString:@"#8A8A8A"];
                        [self.rightBtn setTitle:@"暂不可购买" forState:(UIControlStateNormal)];
                        clickAction = @"暂不支持购买";
                    }
                    
                    
                };break;
                case 5:{//套餐
                    
                    [self addSubview:self.rightBtn];
                    self.rightBtn.backgroundColor = CNavBgColor;
                    [self.rightBtn setTitle:@"已购买，开始学习" forState:(UIControlStateNormal)];
                    clickAction = @"套餐开始学习";
                    
                };break;
                case 6:{//直播
                    [self addSubview:self.rightBtn];
                    self.rightBtn.backgroundColor = CNavBgColor;
                    [self.rightBtn setTitle:@"已购买，开始学习" forState:(UIControlStateNormal)];
                    clickAction = @"直播开始学习";
                };break;
                default:
                    break;
            }
        }else{//未购买
            if ([data[@"my_ac_type"] isEqualToString:@"3"]) {//团购
     
                if ([data[@"is_sell"] isEqualToString:@"1"]) {//可售
                    if ([data[@"now_goods_group_status"] isEqualToString:@"1"]) {//0未参团 1参团中待分享
                        [self addSubview:self.rightBtn];
                        self.rightBtn.backgroundColor = CNavBgColor;
                        [self.rightBtn setTitle:@"已开团，立即分享" forState:(UIControlStateNormal)];
                        clickAction = @"已开团，立即分享";
                    }else{//拼团成功
                        [self addSubview:self.oneBtn];
                        [self addSubview:self.twoBtn];
                        NSMutableAttributedString * ma_price = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@\n单独购买",data[@"discount_price"]]];
                        [ma_price addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:18] range:NSMakeRange(0, [data[@"discount_price"] length])];
                        [ma_price addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, [data[@"discount_price"] length])];
                        
                        [ma_price addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange( [data[@"discount_price"] length], 5)];
                        [ma_price addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange( [data[@"discount_price"] length], 5)];
                        
                        [self.oneBtn setAttributedTitle:ma_price forState:(UIControlStateNormal)];
                        
                        NSMutableAttributedString * ma_price1 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@\n立即开团",data[@"group"][@"group_buy_price"]]];
                        [ma_price1 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:18] range:NSMakeRange(0, [data[@"group"][@"group_buy_price"] length])];
                        [ma_price1 addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, [data[@"group"][@"group_buy_price"] length])];
                        
                        [ma_price1 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange( [data[@"group"][@"group_buy_price"] length], 5)];
                        [ma_price1 addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange( [data[@"group"][@"group_buy_price"] length], 5)];
                        
                        [self.twoBtn setAttributedTitle:ma_price1 forState:(UIControlStateNormal)];
                    }
                }else{//不可售
                    [self addSubview:self.rightBtn];
                    self.rightBtn.backgroundColor = [UIColor colorWithHexString:@"#8A8A8A"];
                    [self.rightBtn setTitle:@"暂不可购买" forState:(UIControlStateNormal)];
                    clickAction = @"暂不支持购买";
                }
            }else if ([data[@"my_ac_type"] isEqualToString:@"2"]){//秒杀
                if ([data[@"is_sell"] isEqualToString:@"1"]) {//可售
                    if ([data[@"seckill_goods"][@"seckill_status"] isEqualToString:@"0"]) {//即将开抢
                        [self addSubview:self.rightBtn];
                        self.rightBtn.backgroundColor = [UIColor colorWithHexString:@"#F4AB0E"];
                        [self.rightBtn setTitle:@"即将开抢，开抢提醒我" forState:(UIControlStateNormal)];
                        clickAction = @"即将开抢，开抢提醒我";
                    }else{//已经可以抢购
                        [self addSubview:self.rightBtn];
                        self.rightBtn.backgroundColor = CNavBgColor;
                        [self.rightBtn setTitle:@"立即购买" forState:(UIControlStateNormal)];
                        clickAction = @"立即购买";
                    }
                }else{//不可售
                    [self addSubview:self.rightBtn];
                    self.rightBtn.backgroundColor = [UIColor colorWithHexString:@"#8A8A8A"];
                    [self.rightBtn setTitle:@"暂不可购买" forState:(UIControlStateNormal)];
                    clickAction = @"暂不支持购买";
                }
                
            }else{//普通
                if ([data[@"is_sell"] isEqualToString:@"1"]) {//可售
                    [self addSubview:self.rightBtn];
                    self.rightBtn.backgroundColor = CNavBgColor;
                    [self.rightBtn setTitle:@"立即购买" forState:(UIControlStateNormal)];
                    clickAction = @"立即购买";
                }else{//不可售
                    [self addSubview:self.rightBtn];
                    self.rightBtn.backgroundColor = [UIColor colorWithHexString:@"#8A8A8A"];
                    [self.rightBtn setTitle:@"暂不可购买" forState:(UIControlStateNormal)];
                    clickAction = @"暂不支持购买";
                }
            }
        }
    }
  
}

- (UIButton *)advisoryBtn{
    if (!_advisoryBtn) {
        _advisoryBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        _advisoryBtn.frame = CGRectMake(0, 0, 55, 49);
        [_advisoryBtn setImage:[UIImage imageNamed:@"咨询"] forState:(UIControlStateNormal)];
        [_advisoryBtn setTitle:@"咨询" forState:(UIControlStateNormal)];
        [_advisoryBtn addTarget:self action:@selector(kefuAction) forControlEvents:(UIControlEventTouchUpInside)];
        _advisoryBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [_advisoryBtn setTitleColor:[UIColor lightGrayColor] forState:(UIControlStateNormal)];
        [_advisoryBtn br_layoutButtonWithEdgeInsetsStyle:(BRButtonEdgeInsetsStyleTop) imageTitleSpace:2];
    }
    return _advisoryBtn;
}


- (UIButton *)collectionBtn{
    if (!_collectionBtn) {
        _collectionBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        _collectionBtn.frame = CGRectMake(maxX(self.advisoryBtn), 0, 55, 49);
        [_collectionBtn setImage:[UIImage imageNamed:@"收藏"] forState:(UIControlStateNormal)];
        [_collectionBtn setTitle:@"收藏" forState:(UIControlStateNormal)];
        [_collectionBtn setTitleColor:[UIColor lightGrayColor] forState:(UIControlStateNormal)];
        _collectionBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [_collectionBtn setTitleColor:CNavBgColor forState:(UIControlStateSelected)];
        [_collectionBtn addTarget:self action:@selector(collectionActoion) forControlEvents:(UIControlEventTouchUpInside)];
        [_collectionBtn br_layoutButtonWithEdgeInsetsStyle:(BRButtonEdgeInsetsStyleTop) imageTitleSpace:2];
    }
    return _collectionBtn;
}

- (UIButton *)oneBtn{
    if (!_oneBtn) {
        _oneBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        _oneBtn.backgroundColor = [UIColor colorWithHexString:@"#F4AB0E"];
        _oneBtn.frame = CGRectMake(maxX(self.collectionBtn), 0, (screenWidth()-110)/2, 49);
        _oneBtn.titleLabel.lineBreakMode = 0;//这句话很重要，不加这句话加上换行符也没
        _oneBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        _oneBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [_oneBtn addTarget:self action:@selector(pay) forControlEvents:(UIControlEventTouchUpInside)];
    }
    
    return _oneBtn;
}
- (UIButton *)twoBtn{
    if (!_twoBtn) {
        _twoBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        _twoBtn.frame = CGRectMake(maxX(self.oneBtn), 0, (screenWidth()-110)/2, 49);
        _twoBtn.backgroundColor = CNavBgColor;
        _twoBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        [_twoBtn addTarget:self action:@selector(groupPay) forControlEvents:(UIControlEventTouchUpInside)];
        [_twoBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        _twoBtn.titleLabel.lineBreakMode = 0;
    }
    return _twoBtn;
}
- (UIButton *)rightBtn{
    if (!_rightBtn) {
        _rightBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        _rightBtn.backgroundColor = [UIColor colorWithRed:244/255.0 green:171/255.0 blue:14/255.0 alpha:1];
        _rightBtn.frame = CGRectMake(maxX(self.collectionBtn), 0, (screenWidth()-110), 49);
        [_rightBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateSelected)];
        _rightBtn.titleLabel.lineBreakMode = 0;//这句话很重要，不加这句话加上换行符也没
        _rightBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        _rightBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [_rightBtn addTarget:self action:@selector(rightBtnAction) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _rightBtn;
}
- (void)pay{
    PayMentViewController *vc = [[PayMentViewController alloc]init];
    vc.goodID = self.model.ID;
    vc.goodType = self.model.my_goods_type;
    if ([self.model.my_goods_type isEqualToString:@"6"]) {
        vc.dist_id = @"0";
    }else{
        vc.dist_id = self.model.distribution.dist_id;
    }
    if ([self.model.seckill_flag isEqualToString:@"1"]) {
        vc.seckill_id = self.model.seckill_goods.seckill_goods_id;
    }
    [[[AppDelegate shareAppDelegate] getCurrentUIVC].navigationController pushViewController:vc animated:YES];
}
- (void)groupPay{
    PayMentViewController *vc = [[PayMentViewController alloc]init];
    vc.goodID = self.model.ID;
    vc.goodType = self.model.my_goods_type;
    if ([self.model.my_goods_type isEqualToString:@"6"]) {
        vc.dist_id = @"0";
    }else{
        vc.dist_id = self.model.distribution.dist_id;
    }
    if ([self.model.seckill_flag isEqualToString:@"1"]) {
        vc.seckill_id = self.model.seckill_goods.seckill_goods_id;
    }

    vc.group_buy_goods_rule_id = self.model.group.group_buy_goods_rule_id;

    
    [[[AppDelegate shareAppDelegate] getCurrentUIVC].navigationController pushViewController:vc animated:YES];
}
- (void)rightBtnAction{
    if ([clickAction isEqualToString:@"暂不支持购买"]) {
        [BaseTools showErrorMessage:@"暂不支持购买"];
    }else if ([clickAction isEqualToString:@"立即购买"]){
        
        
        [self pay];
    }else if ([clickAction isEqualToString:@"即将开抢，开抢提醒我"]){
        if ([self openMessageNotificationService]) {
            [self skillBuyWarn];
        }else{
            [self showAlrtToSetting];
        }
        
    }else if ([clickAction isEqualToString:@"立即赚钱"]){
        [self distrubteAction];
    }else if ([clickAction isEqualToString:@"课程开始学习"]){
        MyLearningRecordViewController *vc = [[MyLearningRecordViewController alloc]init];
        vc.continueLearningID = self.model.default_play_node;
        vc.isLive = NO;
        vc.imageUrl = self.model.img;
        vc.course_name = self.model.title;
        vc.course_lesson_num = self.model.lesson_num;
        vc.course_id = self.model.ID;
        vc.course_discount_price = self.model.discount_price;
        [[[AppDelegate shareAppDelegate] getCurrentUIVC].navigationController pushViewController:vc animated:YES];
    }else if ([clickAction isEqualToString:@"已开团，立即分享"]){
        NSString *urlString = [NSString stringWithFormat:@"%@/join_group_detail/%@/%@", SERVER_HOSTPC,self.model.group.token,self.model.group.group_buy_goods_rule_id];
        
        [UMSocialShareUIConfig shareInstance].sharePageGroupViewConfig.sharePageGroupViewPostionType = UMSocialSharePageGroupViewPositionType_Bottom;
        [UMSocialShareUIConfig shareInstance].sharePageScrollViewConfig.shareScrollViewPageItemStyleType = UMSocialPlatformItemViewBackgroudType_None;
        [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
            if (platformType == UMSocialPlatformType_UserDefine_Begin+2) {
                //自定义图标的点击事件
            }
            else{
                [self shareWebPageToPlatformType:platformType shareURLString:urlString title:self.model.title descr:@"库课网校"];
            }
        }];
    }else if ([clickAction isEqualToString:@"开始做题"]){
        MyAnswerViewController *vc = [[MyAnswerViewController alloc]init];
        vc.imageUrl = self.model.img;
        vc.testPaper_id = self.model.ID;
        vc.testPaper_title =self.model.title;
        [[[AppDelegate shareAppDelegate] getCurrentUIVC].navigationController pushViewController:vc animated:YES];
    }else if ([clickAction isEqualToString:@"直播开始学习"]){
        MyLearningRecordViewController *vc = [[MyLearningRecordViewController alloc]init];
        vc.continueLearningID = @"";
        vc.isLive = YES;
        vc.imageUrl = self.model.img;
        vc.course_name = self.model.title;
        vc.course_lesson_num = self.model.lesson_num;
        vc.course_id = self.model.ID;
//        vc.living = self.model.live_status;
        vc.course_discount_price = self.model.discount_price;
        [[[AppDelegate shareAppDelegate] getCurrentUIVC].navigationController pushViewController:vc animated:YES];
    }else if ([clickAction isEqualToString:@"套餐开始学习"]){
        KPostNotification(@"ClassRoomStartLearning", nil);
    }
}

- (void)skillBuyWarn{
    NSMutableDictionary *parmDic = [NSMutableDictionary dictionary];
    [parmDic setObject:self.model.ID forKey:@"goods_id"];
    [parmDic setObject:self.model.my_goods_type forKey:@"goods_type"];
    [parmDic setObject:self.model.seckill_goods.seckill_goods_id forKey:@"seckill_goods_id"];
    BADataEntity *entity = [BADataEntity new];
    entity.urlString = @"/push_notice/seckill_notice";
    entity.needCache = NO;
    entity.parameters = parmDic;
    // 如果打印数据不完整，是因为 Xcode 8 版本问题，请下断点打印数据
    [BANetManager ba_request_POSTWithEntity:entity successBlock:^(id response) {
        
        if (response == nil) {
            
        }else{
            if ([response[@"code"] isEqualToString:@"0"]) {
                
                
                [BaseTools showErrorMessage:response[@"msg"]];
            }else{
                
                [BaseTools showErrorMessage:response[@"msg"]];
            }
        }
        
        
    } failureBlock:^(NSError *error) {
        
    } progressBlock:^(int64_t bytesProgress, int64_t totalBytesProgress) {
        /*! 封装方法里已经回到主线程，所有这里不用再调主线程了 */
        
    }];

}
- (void)distrubteAction{
    self.shareView = [[DistributionBottomShareView alloc]initWithFrame:CGRectMake(0, screenHeight()-150, screenWidth(), 150)];
    self.shareView.titleLab.text = @"立即分享";
    
    self.shareView.wbImage.image = [UIImage imageNamed:@"复制链接"];
    self.shareView.threeLab.text = @"复制链接";
    
    self.shareView.pyqImage.image = [UIImage imageNamed:@"图文二维码"];
    self.shareView.fourLab.text = @"图文二维码";
    NSString *urlString = nil;
    if ([self.model.my_goods_type isEqualToString:@"1"]) {
        urlString = [NSString stringWithFormat:@"%@/exam/%@.html?distribute=%@", SERVER_HOSTPC,self.model.ID,self.model.distribution.dist_id];
    }else if ([self.model.my_goods_type isEqualToString:@"3"]){
        urlString = [NSString stringWithFormat:@"%@/course/%@.html?distribute=%@", SERVER_HOSTPC,self.model.ID,self.model.distribution.dist_id];
    }else if ([self.model.my_goods_type isEqualToString:@"4"]){
        urlString = [NSString stringWithFormat:@"%@/book/%@.html?distribute=%@", SERVER_HOSTPC,self.model.ID,self.model.distribution.dist_id];
    }else if ([self.model.my_goods_type isEqualToString:@"5"]){
        urlString = [NSString stringWithFormat:@"%@/classroom/%@.html?distribute=%@", SERVER_HOSTPC,self.model.ID,self.model.distribution.dist_id];
    }else if ([self.model.my_goods_type isEqualToString:@"6"]){
        urlString = [NSString stringWithFormat:@"%@/live/%@.html?distribute=%@", SERVER_HOSTPC,self.model.ID,self.model.distribution.dist_id];
    }
    
    CGPoint showCenter = CGPointMake(SCREEN_WIDTH/2,SCREEN_HEIGHT-self.shareView.height/2);
    [SGBrowserView showMoveView:self.shareView moveToCenter:showCenter];
    __weak typeof(self) weakSelf = self;
    self.shareView.myCloseBlock = ^{
        [SGBrowserView hide];
    };
    self.shareView.myWXShareBlock = ^{
        [weakSelf shareWebPageToPlatformType:UMSocialPlatformType_WechatSession shareURLString:urlString title:weakSelf.model.title descr:@"库课网校"];
    };
    self.shareView.myQQShareBlock = ^{
        [weakSelf shareWebPageToPlatformType:UMSocialPlatformType_QQ shareURLString:urlString title:weakSelf.model.title descr:@"库课网校"];
    };
    self.shareView.myCopyBlock = ^{
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = urlString;
        [BaseTools showErrorMessage:@"分销链接已复制到您的粘贴板"];
    };
    self.shareView.myPicBlock = ^{
        [SGBrowserView hide];
        [weakSelf showShareImageView:urlString];
    };


}
- (void)kefuAction{
    if ([[UserDefaultsUtils valueWithKey:@"access_token"] length] !=0 ) {
        //        [BaseTools openKefuWithObj:self];
        NSString *urlString = nil;
        if ([self.model.my_goods_type isEqualToString:@"1"]) {
            urlString = [NSString stringWithFormat:@"%@/exam/%@.html", SERVER_HOSTPC,self.model.ID];
        }else if ([self.model.my_goods_type isEqualToString:@"3"]){
            urlString = [NSString stringWithFormat:@"%@/course/%@.html", SERVER_HOSTPC,self.model.ID];
        }else if ([self.model.my_goods_type isEqualToString:@"4"]){
            urlString = [NSString stringWithFormat:@"%@/book/%@.html", SERVER_HOSTPC,self.model.ID];
        }else if ([self.model.my_goods_type isEqualToString:@"5"]){
            urlString = [NSString stringWithFormat:@"%@/classroom/%@.html", SERVER_HOSTPC,self.model.ID];
        }else if ([self.model.my_goods_type isEqualToString:@"6"]){
            urlString = [NSString stringWithFormat:@"%@/live/%@.html", SERVER_HOSTPC,self.model.ID];
        }
        QYSource *source = [[QYSource alloc] init];
        source.title =  @"库课网校";
        source.urlString = @"https://www.kuke99.com/";
        QYCommodityInfo *commodityInfo = [[QYCommodityInfo alloc] init];
        commodityInfo.title = self.model.title;
        commodityInfo.desc = self.model.subtitle;
        commodityInfo.sendByUser = YES;
        commodityInfo.actionTextColor =CNavBgColor;
        commodityInfo.actionText = @"发送商品";
        commodityInfo.pictureUrlString = self.model.img;
        commodityInfo.urlString = urlString;
        commodityInfo.note =self.model.discount_price;
        commodityInfo.show = YES;
        
        
        QYSessionViewController *sessionViewController = [[QYSDK sharedSDK] sessionViewController];
        sessionViewController.sessionTitle = @"库课网校";
        sessionViewController.source = source;
        sessionViewController.commodityInfo = commodityInfo;
        if (IS_PAD) {
            UINavigationController* navi = [[UINavigationController alloc]initWithRootViewController:sessionViewController];
            navi.modalPresentationStyle = UIModalPresentationFormSheet;
            [[[AppDelegate shareAppDelegate] getCurrentUIVC] presentViewController:navi animated:YES completion:nil];
        }
        else{
            sessionViewController.hidesBottomBarWhenPushed = YES;
            [[[AppDelegate shareAppDelegate] getCurrentUIVC].navigationController pushViewController:sessionViewController animated:YES];
        }
        
        [[QYSDK sharedSDK] customUIConfig].bottomMargin = 0;
        [[[QYSDK sharedSDK] customActionConfig] setLinkClickBlock:^(NSString *linkAddress) {
            HomePageBannerViewController *vc = [[HomePageBannerViewController alloc]init];
            vc.url = linkAddress;
            vc.title = @"商品详情";
            [[[AppDelegate shareAppDelegate] getCurrentUIVC].navigationController pushViewController:vc animated:YES];
        }];
        
    }else{
        [BaseTools showErrorMessage:@"请登录后再操作"];
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [BaseTools alertLoginWithVC:[[AppDelegate shareAppDelegate] getCurrentUIVC]];
        });
    }
}
- (void)collectionActoion{
    NSMutableDictionary *parmDic = [NSMutableDictionary dictionary];
    [parmDic setObject:self.model.my_goods_type forKey:@"goods_type"];
    [parmDic setObject:self.model.ID  forKey:@"goods_id"];
    [ZMNetworkHelper POST:@"/stucommon/stu_collect" parameters:parmDic cache:YES responseCache:^(id responseCache) {
        
    } success:^(id responseObject) {
        if (responseObject == nil) {
            
        }else{
            if ([responseObject[@"code"] isEqualToString:@"0"]) {
                
                if ([responseObject[@"msg"] isEqualToString:@"收藏成功"]) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        [self.collectionBtn setTitle:@"已收藏" forState:(UIControlStateNormal)];
                        [self.collectionBtn setImage:[UIImage imageNamed:@"已收藏"] forState:(UIControlStateNormal)];
                        [self.collectionBtn br_layoutButtonWithEdgeInsetsStyle:(BRButtonEdgeInsetsStyleTop) imageTitleSpace:2];
                    });
                }else{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        [self.collectionBtn setTitle:@"收藏" forState:(UIControlStateNormal)];
                        [self.collectionBtn setImage:[UIImage imageNamed:@"收藏"] forState:(UIControlStateNormal)];
                        [self.collectionBtn br_layoutButtonWithEdgeInsetsStyle:(BRButtonEdgeInsetsStyleTop) imageTitleSpace:2];
                    });
                    
                }
            }else if ([responseObject[@"code"] isEqualToString:@"-10000"]){
                [BaseTools showErrorMessage:@"请登录后再操作"];
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [BaseTools alertLoginWithVC:[[AppDelegate shareAppDelegate] getCurrentUIVC]];
                });
            }else{
                [BaseTools showErrorMessage:responseObject[@"msg"]];
            }
        }
    } failure:^(NSError *error) {
        
    }];
}

//网页分享
- (void)shareWebPageToPlatformType:(UMSocialPlatformType)platformType shareURLString:(NSString *)string title:(NSString *)title descr:(NSString *)descr{
    /*
     创建网页内容对象
     根据不同需求设置不同分享内容，一般为图片，标题，描述，url
     */
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:title descr:descr thumImage:[UIImage imageNamed:@"1024"]];
    
    //设置网页地址
    shareObject.webpageUrl = string;
    
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:[[AppDelegate shareAppDelegate] getCurrentUIVC] completion:^(id data, NSError *error) {
        if (error) {
            UMSocialLogInfo(@"************Share fail with error %@*********",error);
        }else{
            [[OpenInstallSDK defaultManager] reportEffectPoint:@"goodshare" effectValue:1];
            if ([data isKindOfClass:[UMSocialShareResponse class]]) {
                UMSocialShareResponse *resp = data;
                //分享结果消息
                UMSocialLogInfo(@"response message is %@",resp.message);
                //第三方原始返回的数据
                UMSocialLogInfo(@"response originalResponse data is %@",resp.originalResponse);
            }else{
                UMSocialLogInfo(@"response data is %@",data);
            }
        }
    }];
}

- (void)showShareImageView:(NSString *)url coalition_id:(NSString *)coalition_id{
    NSMutableDictionary *parmDic = [NSMutableDictionary dictionary];
    [parmDic setObject:coalition_id forKey:@"coalition_id"];
    [ZMNetworkHelper POST:@"/distribution/draw_goods_poster" parameters:parmDic cache:YES responseCache:^(id responseCache) {
        
    } success:^(id responseObject) {
        if (responseObject == nil) {
            
        }else{
            if ([responseObject[@"code"] isEqualToString:@"0"]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    DistributionGoodsShareView *shareview = [[DistributionGoodsShareView alloc]initWithFrame:[[AppDelegate shareAppDelegate] getCurrentUIVC].view.bounds];
                    UIColor *color = [UIColor blackColor];
                    shareview.url = responseObject[@"data"];
                    shareview.backgroundColor = [color colorWithAlphaComponent:0.8];
                    CGPoint showCenter = CGPointMake(SCREEN_WIDTH/2,SCREEN_HEIGHT-shareview.height/2);
                    [SGBrowserView showMoveView:shareview moveToCenter:showCenter];
                    [shareview.shareImage sd_setImageWithURL:[NSURL URLWithString:responseObject[@"data"]]];
                    shareview.myCloseBlock = ^{
                        [SGBrowserView hide];
                    };
                    
                });
            }else if ([responseObject[@"code"] isEqualToString:@"-10000"]){
                [BaseTools showErrorMessage:@"请登录后再操作"];
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [BaseTools alertLoginWithVC:[[AppDelegate shareAppDelegate] getCurrentUIVC]];
                });
            }else{
                [BaseTools showErrorMessage:responseObject[@"msg"]];
            }
        }
        
    } failure:^(NSError *error) {
        
    }];
    
    
}

- (void)showShareImageView:(NSString *)url{
    NSMutableDictionary *parmDic = [NSMutableDictionary dictionary];
    [parmDic setObject:self.model.distribution.coalition_id forKey:@"coalition_id"];
    [ZMNetworkHelper POST:@"/distribution/draw_goods_poster" parameters:parmDic cache:YES responseCache:^(id responseCache) {
        
    } success:^(id responseObject) {
        if (responseObject == nil) {
            
        }else{
            if ([responseObject[@"code"] isEqualToString:@"0"]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    DistributionGoodsShareView *shareview = [[DistributionGoodsShareView alloc]initWithFrame:[[AppDelegate shareAppDelegate] getCurrentUIVC].view.bounds];
                    UIColor *color = [UIColor blackColor];
                    shareview.url = responseObject[@"data"];
                    shareview.backgroundColor = [color colorWithAlphaComponent:0.8];
                    CGPoint showCenter = CGPointMake(SCREEN_WIDTH/2,SCREEN_HEIGHT-shareview.height/2);
                    [SGBrowserView showMoveView:shareview moveToCenter:showCenter];
                    [shareview.shareImage sd_setImageWithURL:[NSURL URLWithString:responseObject[@"data"]]];
                    shareview.myCloseBlock = ^{
                        [SGBrowserView hide];
                    };
                    
                });
            }else if ([responseObject[@"code"] isEqualToString:@"-10000"]){
                [BaseTools showErrorMessage:@"请登录后再操作"];
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [BaseTools alertLoginWithVC:[[AppDelegate shareAppDelegate] getCurrentUIVC]];
                });
            }else{
                [BaseTools showErrorMessage:responseObject[@"msg"]];
            }
        }
        
    } failure:^(NSError *error) {
        
    }];
    
    
}
-(void) checkCurrentNotificationStatus
{
    if (@available(iOS 10 , *))
    {
        [[UNUserNotificationCenter currentNotificationCenter] getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
            
            if (settings.authorizationStatus == UNAuthorizationStatusDenied)
            {
                // 没权限
                 NSLog(@"123");
            }
            
        }];
    }
    else if (@available(iOS 8 , *))
    {
        UIUserNotificationSettings * setting = [[UIApplication sharedApplication] currentUserNotificationSettings];
        
        if (setting.types == UIUserNotificationTypeNone) {
            // 没权限
             NSLog(@"123");
        }
    }
    else
    {
        UIRemoteNotificationType type = [[UIApplication sharedApplication] enabledRemoteNotificationTypes];
        if (type == UIUserNotificationTypeNone)
        {
            // 没权限
            
            NSLog(@"123");
        }
    }
}

- (BOOL)openMessageNotificationService
{
    BOOL isOpen = NO;
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_8_0
    UIUserNotificationSettings *setting = [[UIApplication sharedApplication] currentUserNotificationSettings];
    if (setting.types != UIUserNotificationTypeNone) {
        isOpen = YES;
        return YES;
    }
#else
    UIRemoteNotificationType type = [[UIApplication sharedApplication] enabledRemoteNotificationTypes];
    if (type != UIRemoteNotificationTypeNone) {
        isOpen = YES;
        return YES;
    }
#endif
    return isOpen;
}
#pragma mark 没权限的弹窗
-(void) showAlrtToSetting
{
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"该功的使用需要您打开推送权限" message:@"去设置一下吧" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction * setAction = [UIAlertAction actionWithTitle:@"去设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSURL * url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([[UIApplication sharedApplication] canOpenURL:url]) {
                [[UIApplication sharedApplication] openURL:url];
            }
        });
        
    }];
    
    [alert addAction:cancelAction];
    [alert addAction:setAction];
    
    [[[AppDelegate shareAppDelegate] getCurrentUIVC] presentViewController:alert animated:YES completion:nil];
}
@end
