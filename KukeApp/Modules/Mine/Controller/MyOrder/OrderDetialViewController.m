//
//  OrderDetialViewController.m
//  KukeApp
//
//  Created by iOSDeveloper on 2018/10/22.
//  Copyright © 2018年 zhangming. All rights reserved.
//

#import "OrderDetialViewController.h"
#import "OrderHeaderTableViewCell.h"
#import "OrderDetailTableViewCell.h"
#import "OrderAdressTableViewCell.h"
#import "OrederPayDetailTableViewCell.h"
#import "OrderFooterTableViewCell.h"
#import "OrderPayWayAndTimeTableViewCell.h"
@interface OrderDetialViewController ()<UITableViewDataSource, UITableViewDelegate>{
 

}
@property (nonatomic, strong) NSDictionary *data;

@end

@implementation OrderDetialViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];

}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"订单详情";
   
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadData) name:KNotificationLoginUpdata object:nil];
    [self loadData];
    [self.tableView registerNib:[UINib nibWithNibName:@"OrderFooterTableViewCell" bundle:nil] forCellReuseIdentifier:@"OrderFooterTableViewCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"OrderHeaderTableViewCell" bundle:nil] forCellReuseIdentifier:@"OrderHeaderTableViewCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"OrderDetailTableViewCell" bundle:nil] forCellReuseIdentifier:@"OrderDetailTableViewCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"OrderAdressTableViewCell" bundle:nil] forCellReuseIdentifier:@"OrderAdressTableViewCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"OrederPayDetailTableViewCell" bundle:nil] forCellReuseIdentifier:@"OrederPayDetailTableViewCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"OrderPayWayAndTimeTableViewCell" bundle:nil] forCellReuseIdentifier:@"OrderPayWayAndTimeTableViewCell"];
    
}
#pragma mark - 点击背景刷新时执行
- (void)noDataBeginRefresh {
    [self lq_endLoading];
    [self loadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    if (self.data == nil) {
        return 0;
    }else{
        if ([self.data[@"order_status"] integerValue] == 3 ||[self.data[@"order_status"] integerValue] == 0) {
            if ([self.data[@"kinds"] isEqualToString:@"1"]) {
                return 4;
            }else{
                return 5;
            }
            
        }else{
            if ([self.data[@"kinds"] isEqualToString:@"1"]) {
                return 5;
            }else{
                return 6;
            }
        }
    }
    
    
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([self.data[@"order_status"] integerValue] == 3 || [self.data[@"order_status"] integerValue] == 0) {
        if ([self.data[@"kinds"] isEqualToString:@"1"]) {
            switch (indexPath.section) {
                case 0: return 100; break;
                case 1: return 302; break;
                case 2: return 100; break;
                case 3: return 80; break;
                default: return 0; break;
            }
        }else{
            switch (indexPath.section) {
                case 0: return 100; break;
                case 1: return 302; break;
                case 2: return 86; break;
                case 3: return 100; break;
                case 4: return 80; break;
                default: return 0; break;
            }
        }
        
    }else{
        if ([self.data[@"kinds"] isEqualToString:@"1"]) {
            switch (indexPath.section) {
                case 0: return 100; break;
                case 1: return 302; break;
                case 2: return 100; break;
                case 3: return 100; break;
                case 4: return 80; break;
                    
                default: return 0; break;
            }
        }else{
            switch (indexPath.section) {
                case 0: return 100; break;
                case 1: return 302; break;
                case 2: return 86; break;
                case 3: return 100; break;
                case 4: return 100; break;
                case 5: return 80; break;
                    
                default: return 0; break;
            }
        }
        
    }
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    NSLog(@"=======%@-----------%@",self.data[@"order_status"],self.data[@"order_status"]);
    if ([self.data[@"order_status"] integerValue] == 3 || [self.data[@"order_status"] integerValue] == 0) {
        if ([self.data[@"kinds"] isEqualToString:@"1"]) {
            if (indexPath.section == 0) {
                OrderHeaderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OrderHeaderTableViewCell" forIndexPath:indexPath];
                cell.payBtn.hidden = YES;
                cell.afterSaleBtn.hidden = YES;
                cell.afterSale_right.hidden = YES;
                cell.evaluationBtn.hidden = YES;
                cell.cancelBtn.hidden = YES;
                cell.ReceivingBtn.hidden = YES;
                cell.statusLab.text = self.data[@"status_name"];
                
                cell.model = self.data;
                cell.shareBlock = ^(NSString *url, NSString *goodsName) {
                    [UMSocialShareUIConfig shareInstance].sharePageGroupViewConfig.sharePageGroupViewPostionType = UMSocialSharePageGroupViewPositionType_Bottom;
                    [UMSocialShareUIConfig shareInstance].sharePageScrollViewConfig.shareScrollViewPageItemStyleType = UMSocialPlatformItemViewBackgroudType_None;
                    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
                        if (platformType == UMSocialPlatformType_UserDefine_Begin+2) {
                            //自定义图标的点击事件
                        }
                        else{
                            [self shareWebPageToPlatformType:platformType shareURLString:url title:goodsName descr:@"库课网校"];
                        }
                    }];
                };
                switch ([self.data[@"order_status"] integerValue]) {
                    case 0:
                    {
                        cell.payBtn.hidden = NO;
                        cell.cancelBtn.hidden = NO;
                        cell.statusLab.textColor = CNavBgColor;
                    };
                        break;
                    case 1:
                    {
                        cell.afterSaleBtn.frame = CGRectMake(screenWidth()-95, 59, 80, 30);
                        if ([self.data[@"allow_apply"] isEqualToString:@"0"]) {
                            cell.afterSaleBtn.hidden = YES;
                        }else{
                            cell.afterSaleBtn.hidden = NO;
                        }
                    };
                        break;
                    case 2:
                    {
                        cell.ReceivingBtn.hidden = NO;
                    };
                        break;
                    case 3:
                    {
                    };
                        break;
                    case 4:
                    {
                        
                        if ([self.data[@"is_discuss"] isEqualToString:@"0"]) {
                            cell.statusLab.textColor =[UIColor colorWithHexString:@"41a45f"];
                            cell.statusLab.text = @"未评价";
                            cell.evaluationBtn.hidden = NO;
                            if ([self.data[@"allow_apply"] isEqualToString:@"0"]) {
                                cell.afterSaleBtn.hidden = YES;
                            }else{
                                cell.afterSaleBtn.hidden = NO;
                            }
                        }else{
                            cell.statusLab.text = @"已评价";
                            if ([self.data[@"allow_apply"] isEqualToString:@"0"]) {
                                cell.afterSaleBtn.hidden = YES;
                            }else{
                                cell.afterSaleBtn.hidden = NO;
                            }
                        }
                        
                        
                    };
                        break;
                    case 5:
                    {
                        cell.statusLab.textColor = CNavBgColor;
                    };
                        break;
                    case 6:
                    {
                        cell.statusLab.textColor = CNavBgColor;
                    };
                        break;
                    case 7:
                    {
                        cell.statusLab.textColor = CNavBgColor;
                    };
                        break;
                    case 8:
                    {
                         cell.statusLab.textColor =[UIColor colorWithHexString:@"41a45f"];
                    };
                        break;
                    case 100:
                    {
                        cell.statusLab.textColor = CNavBgColor;
                        cell.statusLab.text = @"拼团中";
                        cell.shareBtn.hidden = NO;
                    };
                        
                        break;
                    default:
                        break;
                }
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                return cell ;
            }else if (indexPath.section == 1){
                OrderDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OrderDetailTableViewCell" forIndexPath:indexPath];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                [cell.pic sd_setImageWithURL:[NSURL URLWithString:self.data[@"goods"][@"goods_image"]] placeholderImage:[UIImage imageNamed:@"goodsImage"]];
                cell.goods_nameLab.text = self.data[@"goods"][@"goods_name"];
                cell.moneyLab.text = [NSString stringWithFormat:@"%@",self.data[@"order_price"]];
                cell.goodsMoney.text = [NSString stringWithFormat:@"%@",self.data[@"order_price"]];
                cell.distributionFeeLab.text = @"免配送费";
                cell.actualCostLab.text = [NSString stringWithFormat:@"%@",self.data[@"third_pay"]];

                NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"实付:%@",self.data[@"third_pay"]]];
                [attributeStr addAttribute:NSForegroundColorAttributeName value:CNavBgColor range:NSMakeRange(3,attributeStr.length-3)];
                cell.totalMoney.attributedText = attributeStr;
                __weak typeof(self) weakSelf = self;
                cell.seeBlock = ^{
                    CourseDetailViewController *vc = [[CourseDetailViewController alloc]init];
                    vc.ID = weakSelf.data[@"goods"][@"goods_id"];
                    vc.titleIndex =  weakSelf.data[@"goods"][@"goods_type"];
                    [weakSelf.navigationController pushViewController:vc animated:YES];
                };
                return cell;
            }else if (indexPath.section == 2){
                OrederPayDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OrederPayDetailTableViewCell" forIndexPath:indexPath];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.order_sn.text = self.data[@"order_sn"];
                cell.orderTime.text = [BaseTools getDateStringWithTimeStr:self.data[@"order_time"]];
                return cell;
            }else{
                
                OrderFooterTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OrderFooterTableViewCell" forIndexPath:indexPath];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.backgroundColor = CBackgroundColor;
                cell.contentView.backgroundColor = CBackgroundColor;
                return cell;
            }
        }else{
            if (indexPath.section == 0) {

               OrderHeaderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OrderHeaderTableViewCell" forIndexPath:indexPath];
                cell.payBtn.hidden = YES;
                cell.afterSaleBtn.hidden = YES;
                cell.afterSale_right.hidden = YES;
                cell.evaluationBtn.hidden = YES;
                cell.cancelBtn.hidden = YES;
                cell.ReceivingBtn.hidden = YES;
                cell.statusLab.text = self.data[@"status_name"];
                cell.shareBlock = ^(NSString *url, NSString *goodsName) {
                    [UMSocialShareUIConfig shareInstance].sharePageGroupViewConfig.sharePageGroupViewPostionType = UMSocialSharePageGroupViewPositionType_Bottom;
                    [UMSocialShareUIConfig shareInstance].sharePageScrollViewConfig.shareScrollViewPageItemStyleType = UMSocialPlatformItemViewBackgroudType_None;
                    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
                        if (platformType == UMSocialPlatformType_UserDefine_Begin+2) {
                            //自定义图标的点击事件
                        }
                        else{
                            [self shareWebPageToPlatformType:platformType shareURLString:url title:goodsName descr:@"库课网校"];
                        }
                    }];
                };
                cell.model = self.data;
                switch ([self.data[@"order_status"] integerValue]) {
                    case 0:
                    {
                        cell.payBtn.hidden = NO;
                        cell.cancelBtn.hidden = NO;
                        cell.statusLab.textColor = CNavBgColor;
                    };
                        break;
                    case 1:
                    {
                        cell.afterSaleBtn.frame = CGRectMake(screenWidth()-95, 59, 80, 30);
                        if ([self.data[@"allow_apply"] isEqualToString:@"0"]) {
                            cell.afterSaleBtn.hidden = YES;
                        }else{
                            cell.afterSaleBtn.hidden = NO;
                        }
                    };
                        break;
                    case 2:
                    {
                        cell.ReceivingBtn.hidden = NO;
                    };
                        break;
                    case 3:
                    {
                    };
                        break;
                    case 4:
                    {
                        
                        if ([self.data[@"is_discuss"] isEqualToString:@"0"]) {
                            cell.statusLab.textColor =[UIColor colorWithHexString:@"41a45f"];
                            cell.statusLab.text = @"未评价";
                            cell.evaluationBtn.hidden = NO;
                            if ([self.data[@"allow_apply"] isEqualToString:@"0"]) {
                                cell.afterSaleBtn.hidden = YES;
                            }else{
                                cell.afterSaleBtn.hidden = NO;
                            }
                        }else{
                            cell.statusLab.text = @"已评价";
                            if ([self.data[@"allow_apply"] isEqualToString:@"0"]) {
                                cell.afterSaleBtn.hidden = YES;
                            }else{
                                cell.afterSaleBtn.hidden = NO;
                            }
                        }
                        
                        
                    };
                        break;
                    case 5:
                    {
                        cell.statusLab.textColor = CNavBgColor;
                    };
                        break;
                    case 6:
                    {
                        cell.statusLab.textColor = CNavBgColor;
                    };
                        break;
                    case 7:
                    {
                        cell.statusLab.textColor = CNavBgColor;
                    };
                        break;
                    case 8:
                    {
                        cell.statusLab.textColor =[UIColor colorWithHexString:@"41a45f"];
                    };
                         break;
                    case 100:
                    {
                        cell.statusLab.textColor = CNavBgColor;
                        cell.statusLab.text = @"拼团中";
                        cell.shareBtn.hidden = NO;
                    };
                        
                        break;
                    default:
                        break;
                }
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                return cell ;
            }else if (indexPath.section == 1){
                OrderDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OrderDetailTableViewCell" forIndexPath:indexPath];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                [cell.pic sd_setImageWithURL:[NSURL URLWithString:self.data[@"goods"][@"goods_image"]] placeholderImage:[UIImage imageNamed:@"goodsImage"]];
                cell.goods_nameLab.text = self.data[@"goods"][@"goods_name"];
                cell.moneyLab.text = [NSString stringWithFormat:@"%@",self.data[@"order_price"]];
                cell.goodsMoney.text = [NSString stringWithFormat:@"%@",self.data[@"order_price"]];
                cell.distributionFeeLab.text = @"免配送费";
                cell.actualCostLab.text = [NSString stringWithFormat:@"%@",self.data[@"third_pay"]];
                NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"实付:%@",self.data[@"third_pay"]]];
                [attributeStr addAttribute:NSForegroundColorAttributeName value:CNavBgColor range:NSMakeRange(3,attributeStr.length-3)];
                cell.totalMoney.attributedText = attributeStr;
                __weak typeof(self) weakSelf = self;
                cell.seeBlock = ^{
                    CourseDetailViewController *vc = [[CourseDetailViewController alloc]init];
                    vc.ID = weakSelf.data[@"goods"][@"goods_id"];
                    vc.titleIndex =  weakSelf.data[@"goods"][@"goods_type"];
                    [weakSelf.navigationController pushViewController:vc animated:YES];
                };
                return cell;
            }else if (indexPath.section == 2){
                OrderAdressTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OrderAdressTableViewCell" forIndexPath:indexPath];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.nameLab.text = self.data[@"receiver"];
                cell.telLab.text = self.data[@"receive_mobile"];
                cell.addressLab.text = self.data[@"address"];
                return cell;
            }else if (indexPath.section == 3){
                OrederPayDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OrederPayDetailTableViewCell" forIndexPath:indexPath];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.order_sn.text = self.data[@"order_sn"];
                cell.orderTime.text = [BaseTools getDateStringWithTimeStr:self.data[@"order_time"]];
                return cell;
            }else{
                
                OrderFooterTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OrderFooterTableViewCell" forIndexPath:indexPath];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.backgroundColor = CBackgroundColor;
                cell.contentView.backgroundColor = CBackgroundColor;
                return cell;
            }
        }
        
    }else{
        if ([self.data[@"kinds"] isEqualToString:@"1"]) {
            if (indexPath.section == 0) {
                OrderHeaderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OrderHeaderTableViewCell" forIndexPath:indexPath];
                cell.payBtn.hidden = YES;
                cell.afterSaleBtn.hidden = YES;
                cell.afterSale_right.hidden = YES;
                cell.evaluationBtn.hidden = YES;
                cell.cancelBtn.hidden = YES;
                cell.ReceivingBtn.hidden = YES;
                cell.statusLab.text = self.data[@"status_name"];
                cell.shareBlock = ^(NSString *url, NSString *goodsName) {
                    [UMSocialShareUIConfig shareInstance].sharePageGroupViewConfig.sharePageGroupViewPostionType = UMSocialSharePageGroupViewPositionType_Bottom;
                    [UMSocialShareUIConfig shareInstance].sharePageScrollViewConfig.shareScrollViewPageItemStyleType = UMSocialPlatformItemViewBackgroudType_None;
                    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
                        if (platformType == UMSocialPlatformType_UserDefine_Begin+2) {
                            //自定义图标的点击事件
                        }
                        else{
                            [self shareWebPageToPlatformType:platformType shareURLString:url title:goodsName descr:@"库课网校"];
                        }
                    }];
                };
                cell.model = self.data;
                switch ([self.data[@"order_status"] integerValue]) {
                    case 0:
                    {
                        cell.payBtn.hidden = NO;
                        cell.cancelBtn.hidden = NO;
                        cell.statusLab.textColor = CNavBgColor;
                    };
                        break;
                    case 1:
                    {
                        cell.afterSaleBtn.frame = CGRectMake(screenWidth()-95, 59, 80, 30);
                        if ([self.data[@"allow_apply"] isEqualToString:@"0"]) {
                            cell.afterSaleBtn.hidden = YES;
                        }else{
                            cell.afterSaleBtn.hidden = NO;
                        }
                    };
                        break;
                    case 2:
                    {
                        cell.ReceivingBtn.hidden = NO;
                    };
                        break;
                    case 3:
                    {
                    };
                        break;
                    case 4:
                    {
                        
                        if ([self.data[@"is_discuss"] isEqualToString:@"0"]) {
                            cell.statusLab.textColor =[UIColor colorWithHexString:@"41a45f"];
                            cell.statusLab.text = @"未评价";
                            cell.evaluationBtn.hidden = NO;
                            if ([self.data[@"allow_apply"] isEqualToString:@"0"]) {
                                cell.afterSaleBtn.hidden = YES;
                            }else{
                                cell.afterSaleBtn.hidden = NO;
                            }
                        }else{
                            cell.statusLab.text = @"已评价";
                            if ([self.data[@"allow_apply"] isEqualToString:@"0"]) {
                                cell.afterSaleBtn.hidden = YES;
                            }else{
                                cell.afterSaleBtn.hidden = NO;
                            }
                        }
                        
                        
                    };
                        break;
                    case 5:
                    {
                        cell.statusLab.textColor = CNavBgColor;
                    };
                        break;
                    case 6:
                    {
                        cell.statusLab.textColor = CNavBgColor;
                    };
                        break;
                    case 7:
                    {
                        cell.statusLab.textColor = CNavBgColor;
                    };
                        break;
                    case 8:
                    {
                        cell.statusLab.textColor =[UIColor colorWithHexString:@"41a45f"];
                    };
                        break;
                    case 100:
                    {
                        cell.statusLab.textColor = CNavBgColor;
                        cell.statusLab.text = @"拼团中";
                        cell.shareBtn.hidden = NO;
                    };
                        
                        break;
                    default:
                        break;
                }
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                return cell ;
            }else if (indexPath.section == 1){
                OrderDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OrderDetailTableViewCell" forIndexPath:indexPath];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                [cell.pic sd_setImageWithURL:[NSURL URLWithString:self.data[@"goods"][@"goods_image"]] placeholderImage:[UIImage imageNamed:@"goodsImage"]];
                cell.goods_nameLab.text = self.data[@"goods"][@"goods_name"];
                cell.moneyLab.text = [NSString stringWithFormat:@"%@",self.data[@"order_price"]];
                cell.goodsMoney.text = [NSString stringWithFormat:@"%@",self.data[@"order_price"]];
                cell.distributionFeeLab.text = @"免配送费";
                cell.actualCostLab.text = [NSString stringWithFormat:@"%@",self.data[@"third_pay"]];
                NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"实付:%@",self.data[@"third_pay"]]];
                [attributeStr addAttribute:NSForegroundColorAttributeName value:CNavBgColor range:NSMakeRange(3,attributeStr.length-3)];
                cell.totalMoney.attributedText = attributeStr;
                __weak typeof(self) weakSelf = self;
                cell.seeBlock = ^{
                    CourseDetailViewController *vc = [[CourseDetailViewController alloc]init];
                    vc.ID = weakSelf.data[@"goods"][@"goods_id"];
                    vc.titleIndex =  weakSelf.data[@"goods"][@"goods_type"];
                    [weakSelf.navigationController pushViewController:vc animated:YES];
                };
                return cell;
            }else if (indexPath.section == 2){
                OrederPayDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OrederPayDetailTableViewCell" forIndexPath:indexPath];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.order_sn.text = self.data[@"order_sn"];
                cell.orderTime.text = [BaseTools getDateStringWithTimeStr:self.data[@"order_time"]];
                return cell;
            }
            else if (indexPath.section == 3){
                OrderPayWayAndTimeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OrderPayWayAndTimeTableViewCell" forIndexPath:indexPath];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.payTime.text = [BaseTools getDateStringWithTimeStr:self.data[@"pay_time"]];
                cell.payWay.text =self.data[@"pay_way"];
                return cell;
            }else{
                
                OrderFooterTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OrderFooterTableViewCell" forIndexPath:indexPath];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.backgroundColor = CBackgroundColor;
                cell.contentView.backgroundColor = CBackgroundColor;
                return cell;
            }
        }else{
            if (indexPath.section == 0) {
                OrderHeaderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OrderHeaderTableViewCell" forIndexPath:indexPath];
                cell.payBtn.hidden = YES;
                cell.afterSaleBtn.hidden = YES;
                cell.afterSale_right.hidden = YES;
                cell.evaluationBtn.hidden = YES;
                cell.cancelBtn.hidden = YES;
                cell.ReceivingBtn.hidden = YES;
                cell.statusLab.text = self.data[@"status_name"];
                cell.shareBlock = ^(NSString *url, NSString *goodsName) {
                    [UMSocialShareUIConfig shareInstance].sharePageGroupViewConfig.sharePageGroupViewPostionType = UMSocialSharePageGroupViewPositionType_Bottom;
                    [UMSocialShareUIConfig shareInstance].sharePageScrollViewConfig.shareScrollViewPageItemStyleType = UMSocialPlatformItemViewBackgroudType_None;
                    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
                        if (platformType == UMSocialPlatformType_UserDefine_Begin+2) {
                            //自定义图标的点击事件
                        }
                        else{
                            [self shareWebPageToPlatformType:platformType shareURLString:url title:goodsName descr:@"库课网校"];
                        }
                    }];
                };
                cell.model = self.data;
                switch ([self.data[@"order_status"] integerValue]) {
                    case 0:
                    {
                        cell.payBtn.hidden = NO;
                        cell.cancelBtn.hidden = NO;
                        cell.statusLab.textColor = CNavBgColor;
                    };
                        break;
                    case 1:
                    {
                        cell.afterSaleBtn.frame = CGRectMake(screenWidth()-95, 59, 80, 30);
                        if ([self.data[@"allow_apply"] isEqualToString:@"0"]) {
                            cell.afterSaleBtn.hidden = YES;
                        }else{
                            cell.afterSaleBtn.hidden = NO;
                        }
                    };
                        break;
                    case 2:
                    {
                        cell.ReceivingBtn.hidden = NO;
                    };
                        break;
                    case 3:
                    {
                    };
                        break;
                    case 4:
                    {
                        
                        if ([self.data[@"is_discuss"] isEqualToString:@"0"]) {
                            cell.statusLab.textColor =[UIColor colorWithHexString:@"41a45f"];
                            cell.statusLab.text = @"未评价";
                            cell.evaluationBtn.hidden = NO;
                            if ([self.data[@"allow_apply"] isEqualToString:@"0"]) {
                                cell.afterSaleBtn.hidden = YES;
                            }else{
                                cell.afterSaleBtn.hidden = NO;
                            }
                        }else{
                            cell.statusLab.text = @"已评价";
                            if ([self.data[@"allow_apply"] isEqualToString:@"0"]) {
                                cell.afterSaleBtn.hidden = YES;
                            }else{
                                cell.afterSaleBtn.hidden = NO;
                            }
                        }
                        
                        
                    };
                        break;
                    case 5:
                    {
                        cell.statusLab.textColor = CNavBgColor;
                    };
                        break;
                    case 6:
                    {
                        cell.statusLab.textColor = CNavBgColor;
                    };
                        break;
                    case 7:
                    {
                        cell.statusLab.textColor = CNavBgColor;
                    };
                        break;
                    case 8:
                    {
                        cell.statusLab.textColor =[UIColor colorWithHexString:@"41a45f"];
                    };
                        break;
                    case 100:
                    {
                        cell.statusLab.textColor = CNavBgColor;
                        cell.statusLab.text = @"拼团中";
                        cell.shareBtn.hidden = NO;
                    };
                        
                    default:
                        break;
                }
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                return cell ;
            }else if (indexPath.section == 1){
                OrderDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OrderDetailTableViewCell" forIndexPath:indexPath];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                [cell.pic sd_setImageWithURL:[NSURL URLWithString:self.data[@"goods"][@"goods_image"]] placeholderImage:[UIImage imageNamed:@"goodsImage"]];
                cell.goods_nameLab.text = self.data[@"goods"][@"goods_name"];
                cell.moneyLab.text = [NSString stringWithFormat:@"%@",self.data[@"order_price"]];
                cell.goodsMoney.text = [NSString stringWithFormat:@"%@",self.data[@"order_price"]];
                cell.distributionFeeLab.text = @"免配送费";
                cell.actualCostLab.text = [NSString stringWithFormat:@"%@",self.data[@"third_pay"]];
                NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"实付:%@",self.data[@"third_pay"]]];
                [attributeStr addAttribute:NSForegroundColorAttributeName value:CNavBgColor range:NSMakeRange(3,attributeStr.length-3)];
                cell.totalMoney.attributedText = attributeStr;
                __weak typeof(self) weakSelf = self;
                cell.seeBlock = ^{
                    CourseDetailViewController *vc = [[CourseDetailViewController alloc]init];
                    vc.ID = weakSelf.data[@"goods"][@"goods_id"];
                    vc.titleIndex =  weakSelf.data[@"goods"][@"goods_type"];
                    [weakSelf.navigationController pushViewController:vc animated:YES];
                };
                return cell;
            }else if (indexPath.section == 2){
                OrderAdressTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OrderAdressTableViewCell" forIndexPath:indexPath];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.nameLab.text = self.data[@"receiver"];
                cell.telLab.text = self.data[@"receive_mobile"];
                cell.addressLab.text = self.data[@"address"];
                return cell;
            }else if (indexPath.section == 3){
                OrederPayDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OrederPayDetailTableViewCell" forIndexPath:indexPath];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.order_sn.text = self.data[@"order_sn"];
                cell.orderTime.text = [BaseTools getDateStringWithTimeStr:self.data[@"order_time"]];
                return cell;
            }
            else if (indexPath.section == 4){
                OrderPayWayAndTimeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OrderPayWayAndTimeTableViewCell" forIndexPath:indexPath];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.payTime.text = [BaseTools getDateStringWithTimeStr:self.data[@"pay_time"]];
                cell.payWay.text =self.data[@"pay_way"];
                return cell;
            }else{
                
                OrderFooterTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OrderFooterTableViewCell" forIndexPath:indexPath];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.backgroundColor = CBackgroundColor;
                cell.contentView.backgroundColor = CBackgroundColor;
                return cell;
            }
        }
    }
 
}
//头视图高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = [UIColor clearColor];
    return headerView;
}

//脚视图高度
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 5;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth(), 5)];
    footerView.backgroundColor = CBackgroundColor;
    return footerView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}


- (void)loadData{
    
    
    NSMutableDictionary *parmDic = [NSMutableDictionary dictionary];
    [parmDic setObject:self.model.order_sn forKey:@"order_sn"];
    BADataEntity *entity = [BADataEntity new];
    entity.urlString = @"/order_handler/detail_v2";
    entity.needCache = NO;
    entity.parameters = parmDic;
    if (![CoreStatus isNetworkEnable]) {
        [self lq_showFailLoadWithType:(LQTableViewFailLoadViewTypeNoData) tipsString:@"无法连接到网络,点击页面刷新"];
        return;
    }else{
        
        self.tableView.loading = YES;
    }
    
    // 如果打印数据不完整，是因为 Xcode 8 版本问题，请下断点打印数据
    [BANetManager ba_request_POSTWithEntity:entity successBlock:^(id response) {
        
        if (response == nil) {
            
        }else{
            if ([response[@"code"] isEqualToString:@"0"]) {
                [self dataAnalysis:response];
            }else if ([response[@"code"] isEqualToString:@"-10000"]){
                [BaseTools showErrorMessage:@"请登录后再操作"];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [BaseTools alertLoginWithVC:self];
                });
            }else{
                [BaseTools showErrorMessage:response[@"msg"]];
            }
        }
       
    } failureBlock:^(NSError *error) {
        [self setEmptyViewDelegeta];
    } progressBlock:^(int64_t bytesProgress, int64_t totalBytesProgress) {
        /*! 封装方法里已经回到主线程，所有这里不用再调主线程了 */
        
    }];

}
#pragma mark —————  请求到的数据进行解析  --———
- (void)dataAnalysis:(id)data{
    
    self.data = data[@"data"];
    [self setEmptyViewDelegeta];
    
    //通知主线程刷新
    [self.tableView reloadData];
  
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
