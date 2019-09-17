

//
//  CourseIntroduceView.m
//  KukeApp
//
//  Created by iOSDeveloper on 2018/10/1.
//  Copyright © 2018年 zhangming. All rights reserved.
//

#import "CourseIntroduceView.h"
#import "CourseTitleTableViewCell.h"
#import "PreferentialActivitiesCell.h"
#import "ValueAddedServiceCell.h"
#import "CourseAbstractCell.h"
#import "TeachersTableViewCell.h"
#import "TeachingMateriaCell.h"
#import "PriceDescriptionCell.h"
#import "GetCouponView.h"
#import "JoinGroupListViewController.h"
#import "ExplainTableViewCell.h"
#import "GoodDetailGroupTableViewCell.h"
#import "GroupBuyingListViewController.h"
#import "GoodsGroupOpenTableViewCell.h"
#import "PayMentViewController.h"
#import "ZMWebViewCell.h"
#import "BAKit_WebView.h"
#import "WebVIewModel.h"
@interface CourseIntroduceView (){

    CourseDetailModel *model;
    BOOL distribute;
    NSString *goods_type;

}
@property (nonatomic, strong) GetCouponView *couponView;
@property(nonatomic, strong) WebVIewModel *webModel;

@property(nonatomic, assign) CGFloat cell_h;
@end
@implementation CourseIntroduceView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

        [self.tableView registerNib:[UINib nibWithNibName:@"CourseTitleTableViewCell" bundle:nil] forCellReuseIdentifier:@"CourseTitleTableViewCell"];
        [self.tableView registerNib:[UINib nibWithNibName:@"PreferentialActivitiesCell" bundle:nil] forCellReuseIdentifier:@"PreferentialActivitiesCell"];
        [self.tableView registerNib:[UINib nibWithNibName:@"GoodDetailGroupTableViewCell" bundle:nil] forCellReuseIdentifier:@"GoodDetailGroupTableViewCell"];
        [self.tableView registerNib:[UINib nibWithNibName:@"GoodsGroupOpenTableViewCell" bundle:nil] forCellReuseIdentifier:@"GoodsGroupOpenTableViewCell"];
        [self.tableView registerClass:[CourseAbstractCell class] forCellReuseIdentifier:@"CourseAbstractCell"];
    }

    return self;
}

- (void)getCourseType:(NSString *)goodsType withDistribute:(NSString *)isDistribute{
    goods_type = goodsType;

    if (isDistribute.length !=0) {
        distribute = YES;
    }else{
        distribute = NO;
    }
}
- (GetCouponView *)couponView{
    if (!_couponView) {
        _couponView = [[GetCouponView alloc]init];

    }
    return _couponView;
}
- (void)getCouponAction{
    UIView *rootView = [[UIApplication sharedApplication] keyWindow];

    self.couponView.frame = CGRectMake(0, 0, kScreenWidth, screenHeight());
    [self.couponView getGoodsID:model.ID withGoodsType:goods_type];
    self.couponView.tag = 20000;
    self.couponView.myBlock = ^{
        [[[UIApplication sharedApplication].keyWindow viewWithTag:20000] removeFromSuperview];
    };

    [rootView addSubview:_couponView];


}

#pragma mark —————  请求到的数据进行解析  --———
- (void)dataAnalysis:(CourseDetailModel *)data{
    model = data;
    WebVIewModel *model1 = [[WebVIewModel alloc]init];
    model1.contentHtml = data.detail_url;
    model1.height = 100;
    _webModel = model1;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    //团购、秒杀、分销、应用审核中。都没有优惠券
    //团购有个开团栏。50高度；开团栏就是优惠券
    //    if ( [model.seckill_flag isEqualToString:@"1"] || ([UserDefaultsUtils boolValueWithKey:KIsAudit] && [model.group_sign isEqualToString:@"0"])|| distribute || ([goods_type integerValue] == 4 && [model.group_sign isEqualToString:@"0"]))
    if (([model.is_coupon isEqualToString:@"0"] || [UserDefaultsUtils boolValueWithKey:KIsAudit]) && [model.group_sign isEqualToString:@"0"])
    {//秒杀、分销、应用审核中、图书。都没有优惠券
        return 2;
    }else{//普通商品有优惠券    团购商品有开团栏
        if (model.group_recommend.count == 0) {
            return 3;
        }else{
            return 4;
        }

    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    //    if (([UserDefaultsUtils boolValueWithKey:KIsAudit] && [model.group_sign isEqualToString:@"0"])|| distribute || ([goods_type integerValue] == 4 && [model.group_sign isEqualToString:@"0"])) {//秒杀、分销、应用审核中、图书。都没有优惠券。 商品信息介绍高度160
    WebVIewModel *model1 = self.webModel;

    if (([model.is_coupon isEqualToString:@"0"] || [UserDefaultsUtils boolValueWithKey:KIsAudit]) && [model.group_sign isEqualToString:@"0"])
    {
        switch (indexPath.section) {
            case 0: return 160; break;
            case 1: return model1.height; break;
            default: return 0; break;
        }
    }else if ([model.seckill_flag isEqualToString:@"1"]){//秒杀商品商品信息介绍高度120
        switch (indexPath.section) {
            case 0: return 150; break;
            case 1: return model1.height; break;
            default: return 0; break;
        }
    }else{//普通商品有优惠券    团购商品有开团栏       商品信息介绍高度160

        if (model.group_recommend.count == 0) {
            switch (indexPath.section) {
                case 0: return 160; break;
                case 1: return [model.group_sign isEqualToString:@"1"]? 93:50; break;
                case 2: return model1.height; break;
                default: return 0; break;
            }
        }else{
            switch (indexPath.section) {
                case 0: return 160; break;
                case 1: return 60; break;
                case 2: return 93; break;
                case 3: return model1.height; break;
                default: return 0; break;
            }
        }
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (model.group_recommend.count != 0 ) {
        switch (section) {
            case 0: return 1; break;
            case 1: return model.group_recommend.count; break;
            case 2: return 1; break;
            case 3: return 1; break;
            default: return 0; break;
        }
    }else{
        return 1;
    }

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //团购、秒杀、分销、应用审核中。都没有优惠券
    //团购有个开团栏。50高度；开团栏就是优惠券
    //    if ( [model.seckill_flag isEqualToString:@"1"] || ([UserDefaultsUtils boolValueWithKey:KIsAudit] && [model.group_sign isEqualToString:@"0"]) || distribute || ([goods_type integerValue] == 4 && [model.group_sign isEqualToString:@"0"]) )
    if (([model.is_coupon isEqualToString:@"0"] || [UserDefaultsUtils boolValueWithKey:KIsAudit]) && [model.group_sign isEqualToString:@"0"])
    {//秒杀、分销、应用审核中、图书。都没有优惠券
        switch (indexPath.section) {
            case 0:{
                CourseTitleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CourseTitleTableViewCell" forIndexPath:indexPath];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.model = model;
                if ([goods_type intValue] == 4) {
                    cell.scrollBottomBtn.hidden = YES;
                }else{
                    cell.scrollBottomBtn.hidden = NO;
                }
                [cell.scrollBottomBtn addTarget:self action:@selector(scrollBottom:) forControlEvents:(UIControlEventTouchUpInside)];
                return cell;
            };break;
            case 1:{
                ZMWebViewCell *cell = [ZMWebViewCell ba_creatCellWithTableView:tableView];

                WebVIewModel *model = self.webModel;
                cell.model = model;
                cell.tab = self.tableView;

                cell.WebLoadFinish = ^(CGFloat cell_h) {

                    if (model.height != cell_h)
                    {
                        model.height = cell_h;
                        [self.tableView reloadData];
                    }
                };
                return cell;
            };break;
            default:{
                return 0;
            };break;
        }
    }else{//普通商品有优惠券    团购商品有开团栏
        if (model.group_recommend.count == 0) {
            switch (indexPath.section) {
                case 0:{
                    CourseTitleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CourseTitleTableViewCell" forIndexPath:indexPath];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    cell.model = model;
                    if ([goods_type intValue] == 4) {
                        cell.scrollBottomBtn.hidden = YES;
                    }else{
                        cell.scrollBottomBtn.hidden = NO;
                    }
                    [cell.scrollBottomBtn addTarget:self action:@selector(scrollBottom:) forControlEvents:(UIControlEventTouchUpInside)];
                    return cell;
                };break;
                case 1:{
                    if ([model.group_sign isEqualToString:@"1"]) {
                        GoodsGroupOpenTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GoodsGroupOpenTableViewCell" forIndexPath:indexPath];
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                        return cell;
                    }else{
                        PreferentialActivitiesCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PreferentialActivitiesCell" forIndexPath:indexPath];
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                        return cell;
                    }
                };break;
                case 2:{
                    ZMWebViewCell *cell = [ZMWebViewCell ba_creatCellWithTableView:tableView];

                    WebVIewModel *model = self.webModel;
                    cell.model = model;
                    cell.tab = self.tableView;
                    cell.WebLoadFinish = ^(CGFloat cell_h) {

                        if (model.height != cell_h)
                        {
                            model.height = cell_h;
                            [self.tableView reloadData];
                        }
                    };
                    return cell;
                };break;
                default:{
                    return 0;
                };break;
            }
        }else{
            switch (indexPath.section) {
                case 0:{
                    CourseTitleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CourseTitleTableViewCell" forIndexPath:indexPath];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    cell.model = model;
                    if ([goods_type intValue] == 4) {
                        cell.scrollBottomBtn.hidden = YES;
                    }else{
                        cell.scrollBottomBtn.hidden = NO;
                    }
                    [cell.scrollBottomBtn addTarget:self action:@selector(scrollBottom:) forControlEvents:(UIControlEventTouchUpInside)];
                    return cell;
                };break;
                case 1:{
                    CourseDetailGroupRecommendModel *groupModel = model.group_recommend[indexPath.row];
                    GoodDetailGroupTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GoodDetailGroupTableViewCell" forIndexPath:indexPath];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    cell.dict = groupModel;
                    [cell setConfigWithSecond:[groupModel.rest_time integerValue]];
                    cell.myBlock = ^{
                        if ([groupModel.is_online isEqualToString:@"1"] || [[UserDefaultsUtils valueWithKey:@"access_token"] length] !=0) {
                            if ([groupModel.is_include isEqualToString:@"1"]) {
                                [BaseTools showErrorMessage:@"你已经参与过该团了"];
                            }else{
                                PayMentViewController *vc = [[PayMentViewController alloc]init];
                                vc.goodID = model.ID;
                                vc.goodType =goods_type;
                                vc.group_buy_goods_rule_id = groupModel.group_buy_goods_rule_id;
                                vc.token = groupModel.token;
                                [[[AppDelegate shareAppDelegate] getCurrentUIVC].navigationController pushViewController:vc animated:YES];
                            }
                        }else{
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [BaseTools alertLoginWithVC:[[AppDelegate shareAppDelegate] getCurrentUIVC]];
                            });
                        }
                    };
                    return cell;
                };break;
                case 2:{
                    GoodsGroupOpenTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GoodsGroupOpenTableViewCell" forIndexPath:indexPath];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    return cell;
                };break;
                case 3:{
                    ZMWebViewCell *cell = [ZMWebViewCell ba_creatCellWithTableView:tableView];

                    WebVIewModel *model = self.webModel;
                    cell.model = model;
                    cell.tab = self.tableView;

                    cell.WebLoadFinish = ^(CGFloat cell_h) {

                        if (model.height != cell_h)
                        {
                            model.height = cell_h;
                            [self.tableView reloadData];
                        }
                    };
                    return cell;
                };break;
                default:{
                    return 0;
                };break;
            }
        }
    }
}

//脚视图高度
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    //团购、秒杀、分销、应用审核中。都没有优惠券
    //团购有个开团栏。50高度；开团栏就是优惠券
    //    if ( [model.seckill_flag isEqualToString:@"1"] || ([UserDefaultsUtils boolValueWithKey:KIsAudit] && [model.group_sign isEqualToString:@"0"])|| distribute || ([goods_type integerValue] == 4 && [model.group_sign isEqualToString:@"0"])) {//秒杀、分销、应用审核中、图书。都没有优惠券
    if (([model.is_coupon isEqualToString:@"0"] || [UserDefaultsUtils boolValueWithKey:KIsAudit]) && [model.group_sign isEqualToString:@"0"])
    {
        return 0;
    }else{//普通商品有优惠券    团购商品有开团栏


        if (model.group_recommend.count == 0) {
            if (section == 0) {
                return 8;
            }else{
                return 0;
            }
        }else{
            if (section == 0 ) {
                return 8;
            }else if (section == 1){
                return 8;
            }else {
                return 0;
            }
        }
    }

}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth(), 5)];
    footerView.backgroundColor = CBackgroundColor;
    return footerView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {


    //团购、秒杀、分销、应用审核中。都没有优惠券
    //团购有个开团栏。50高度；开团栏就是优惠券
    //    if ( [model.seckill_flag isEqualToString:@"1"] ||([UserDefaultsUtils boolValueWithKey:KIsAudit] && [model.group_sign isEqualToString:@"0"])|| distribute || ([goods_type integerValue] == 4 && [model.group_sign isEqualToString:@"0"])) {//秒杀、分销、应用审核中、图书。都没有优惠券
    if (([model.is_coupon isEqualToString:@"0"] || [UserDefaultsUtils boolValueWithKey:KIsAudit]) && [model.group_sign isEqualToString:@"0"])
    {

    }else{//普通商品有优惠券    团购商品有开团栏

        if (model.group_recommend.count == 0) {
            if (![model.group_sign isEqualToString:@"1"]) {
                if (indexPath.section == 1 ) {
                    [self getCouponAction];
                }
            }else{
                if (indexPath.section == 1 ) {
                    KefuViewController *vc = [[KefuViewController alloc]init];
                    vc.url = @"http://m.kukewang.com/group_rule";
                    vc.title = @"库拼团玩法";
                    [[[AppDelegate shareAppDelegate] getCurrentUIVC].navigationController pushViewController:vc animated:YES];
                }
            }
        }else{
            if (indexPath.section == 2 ) {
                KefuViewController *vc = [[KefuViewController alloc]init];
                vc.url = @"http://m.kukewang.com/group_rule";
                vc.title = @"库拼团玩法";
                [[[AppDelegate shareAppDelegate] getCurrentUIVC].navigationController pushViewController:vc animated:YES];
            }
        }
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (model.group_recommend.count != 0 ) {
        switch (section) {

            case 0: return 0.0001; break;

            case 1: return 40; break;

            case 2: return 0.0001; break;

            default: return 0; break;
        }
    }else{
        return 0.0001;
    }

}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *allBgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenWidth(), 40)];
    allBgView.backgroundColor = [UIColor whiteColor];

    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(15, 8, 25, 25)];
    imageView.image = [UIImage imageNamed:@"参团图标"];
    [allBgView addSubview:imageView];


    UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(maxX(imageView)+10, 8, 120, 25)];
    lab.text = [NSString stringWithFormat:@"%@人在拼团",model.group.open_num];
    lab.font = [UIFont systemFontOfSize:14];
    lab.textColor = CTitleColor;
    [allBgView addSubview:lab];

    UIButton *btn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    btn.frame = CGRectMake(screenWidth()-100, 5, 100, 30);
    [btn setTitle:@"查看更多" forState:(UIControlStateNormal)];
    [btn setTitleColor:CTitleColor forState:(UIControlStateNormal)];
    [btn setImage:[UIImage imageNamed:@"右"] forState:(UIControlStateNormal)];
    btn.titleLabel.textAlignment = NSTextAlignmentRight;
    btn.titleLabel.font = [UIFont systemFontOfSize:12];
    [btn br_layoutButtonWithEdgeInsetsStyle:(BRButtonEdgeInsetsStyleRight) imageTitleSpace:8];
    [btn addTarget:self  action:@selector(moreGroupAction) forControlEvents:(UIControlEventTouchUpInside)];
    [allBgView addSubview:btn];

    UILabel *lineLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 39, screenWidth(), 1)];
    lineLab.backgroundColor = CBackgroundColor;
    [allBgView addSubview:lineLab];

    if (model.group_recommend.count != 0 ) {
        switch (section) {
            case 0: return nil; break;
            case 1: return allBgView; break;
            case 2: return nil; break;
            default: return 0; break;
        }
    }else{
        return nil;
    }
}
- (void)moreGroupAction{
    JoinGroupListViewController *vc = [[JoinGroupListViewController alloc]init];
    vc.group_buy_goods_id = model.group.group_buy_goods_rule_id;
    [[[AppDelegate shareAppDelegate] getCurrentUIVC].navigationController pushViewController:vc animated:YES];

}
- (void)scrollBottom:(UIButton *)btn{
    HomePageBannerViewController *vc = [[HomePageBannerViewController alloc]init];
    vc.url = [NSString stringWithFormat:@"%@/app/goods_buy_explain",SERVER_HOSTM];
    vc.title = @"退课须知";
    [[[AppDelegate shareAppDelegate] getCurrentUIVC].navigationController pushViewController:vc animated:YES];
}

@end

