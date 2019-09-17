//
//  JoinGroupDetailViewController.m
//  KukeApp
//
//  Created by 库课 on 2019/1/11.
//  Copyright © 2019 zhangming. All rights reserved.
//

#import "JoinGroupDetailViewController.h"
#import "GroupDetailTableViewCell.h"
#import "GroupDetailHeaderTableViewCell.h"
#import "GroupBuyingListTableViewCell.h"
#import "GroupDetailModel.h"
#import "CourseDetailViewController.h"
@interface JoinGroupDetailViewController (){
    
    
}

@property (nonatomic, strong) NSMutableArray *dataAry;
@property (nonatomic, strong) GroupDetailModel *dataModel;
@end
@implementation JoinGroupDetailViewController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO];
    //    [self.tableView.mj_header beginRefreshing];
    //    [self loadData];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataAry = [NSMutableArray array];
    self.title = @"参团详情";
    [self loadData];
    [self.tableView registerNib:[UINib nibWithNibName:@"GroupDetailTableViewCell" bundle:nil] forCellReuseIdentifier:@"GroupDetailTableViewCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"GroupDetailHeaderTableViewCell" bundle:nil] forCellReuseIdentifier:@"GroupDetailHeaderTableViewCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"GroupBuyingListTableViewCell" bundle:nil] forCellReuseIdentifier:@"GroupBuyingListTableViewCell"];
    
}
#pragma mark - 点击背景刷新时执行
- (void)noDataBeginRefresh {
    [self lq_endLoading];
    [self loadData];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    if (self.dataAry.count == 0) {
        return 0;
    }else{
        return 3;
            
    }
    
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0: return 120; break;
        case 1: return 233; break;
        case 2: return 124; break;
        default: return 0; break;
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0: return 1; break;
        case 1: return 1; break;
        case 2: return self.dataAry.count; break;
        default: return 0; break;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   
    if (indexPath.section == 0){
        GroupDetailHeaderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GroupDetailHeaderTableViewCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.numBtn setTitle:[NSString stringWithFormat:@"%@人团",self.dataModel.data.goods.group_base_num] forState:(UIControlStateNormal)];
        cell.priceLab.text = self.dataModel.data.goods.group_buy_price;
        cell.discountPriceLab.text =self.dataModel.data.goods.goods_price;
        cell.goodsName.text = self.dataModel.data.goods.goods_name;
        [cell.goodsImage sd_setImageWithURL:[NSURL URLWithString:self.dataModel.data.goods.goods_img] placeholderImage:nil];

        return cell;
        
    }else if (indexPath.section == 1){
        GroupDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GroupDetailTableViewCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.model = self.dataModel.data;
        cell.numLab.text = [NSString stringWithFormat:@"还差%@人拼团成功",self.dataModel.data.goods.rest_num];
        [[ZMTimeCountDown ShareManager] zj_timeCountDownWithStartTimeStamp:0 endTimeStamp:[self.dataModel.data.goods.rest_time longLongValue]*1000 completeBlock:^(NSInteger day, NSInteger hour, NSInteger minute, NSInteger second) {
            cell.timeLab.text = [NSString stringWithFormat:@"剩余时间:%02ld:%02ld:%02ld",hour,minute,second];
        }];
    
        [cell.stuImage1 sd_setImageWithURL:[NSURL URLWithString:[self.dataModel.data.stu[0] photo]] placeholderImage:[UIImage imageNamed:@"个人中心未登录头像"]];
        cell.stuName1.text = [self.dataModel.data.stu[0] stu_name];
        
        
        if (self.dataModel.data.stu.count == 2) {
            [cell.stuImage2 sd_setImageWithURL:[NSURL URLWithString:[self.dataModel.data.stu[1] photo]] placeholderImage:[UIImage imageNamed:@"个人中心未登录头像"]];
            cell.stuName2.text = [self.dataModel.data.stu[1] stu_name];
            cell.stuImage3.hidden = YES;
            cell.stuName3.hidden = YES;
        }else if (self.dataModel.data.stu.count == 3){
           [cell.stuImage2 sd_setImageWithURL:[NSURL URLWithString:[self.dataModel.data.stu[1] photo]] placeholderImage:[UIImage imageNamed:@"个人中心未登录头像"]];
            [cell.stuImage3 sd_setImageWithURL:[NSURL URLWithString:[self.dataModel.data.stu[2] photo]] placeholderImage:[UIImage imageNamed:@"个人中心未登录头像"]];
            cell.stuName2.text =[self.dataModel.data.stu[1] stu_name];
            cell.stuName3.text =[self.dataModel.data.stu[2] stu_name];
        }

        return cell;
        
    }else{
        GroupBuyingListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GroupBuyingListTableViewCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.model = self.dataAry[indexPath.row];
        return cell;

    }
   
}
//头视图高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section ==2) {
    
        return 40;
    }else{
        return 0;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section ==2) {
        UIView *headerView = [[UIView alloc] init];
        headerView.backgroundColor = [UIColor whiteColor];
        UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(15, 5, 200, 30)];
        lab.text = @"更多拼团";
        lab.font = [UIFont systemFontOfSize:14];
        [headerView addSubview:lab];
        return headerView;
    }else{
        UIView *headerView = [[UIView alloc] init];
        headerView.backgroundColor = [UIColor clearColor];
        return headerView;
    }
    
}

//脚视图高度
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 8;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth(), 8)];
    footerView.backgroundColor = CBackgroundColor;
    return footerView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 2) {
        HomeGroupBuyingModel *model = self.dataAry[indexPath.row];
        CourseDetailViewController *vc = [[CourseDetailViewController alloc]init];
        vc.ID = model.goods_id;
        vc.titleIndex = model.goods_type;
        vc.coursePrice = model.group_buy_price;
        vc.courseTitle = model.goods_name;
        vc.ac_type = @"3";
        [self.navigationController pushViewController:vc animated:YES];
    }
}


- (void)loadData{
    
    NSMutableDictionary *parmDic = [NSMutableDictionary dictionary];
    [parmDic setObject:self.token forKey:@"token"];
    [parmDic setObject:self.group_buy_goods_rule_id forKey:@"group_buy_goods_rule_id"];
    BADataEntity *entity = [BADataEntity new];
    entity.urlString = @"/groupbuy/join_group_detail";
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
    
    self.dataModel = [[GroupDetailModel alloc]initWithDictionary:data error:nil];
    [self.dataAry addObjectsFromArray:self.dataModel.data.group];
    [self setEmptyViewDelegeta];
    
    //通知主线程刷新
    [self.tableView reloadData];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)dealloc{
    [[ZMTimeCountDown ShareManager]zj_timeDestoryTimer];
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

