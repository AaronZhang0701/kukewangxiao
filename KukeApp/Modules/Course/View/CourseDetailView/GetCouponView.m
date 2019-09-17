//
//  GetCouponView.m
//  KukeApp
//
//  Created by iOSDeveloper on 2018/12/11.
//  Copyright © 2018年 zhangming. All rights reserved.
//

#import "GetCouponView.h"
#import "GetCouponTableViewCell.h"
#import "GetCouponModel.h"
@interface GetCouponView ()<UITableViewDelegate,UITableViewDataSource,ZMEmptyDataSetSource,ZMEmptyDataSetDelegate>{
    

    NSString *coupon_goods_id;
    NSString *coupon_goods_type;
    
}
//列表数组
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation GetCouponView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.tableView.loading = YES;

        self.backgroundColor = [UIColor clearColor];
        
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenWidth(), screenHeight()/2-70)];
        view.backgroundColor = [UIColor colorWithRed:0.00f green:0.00f blue:0.00f alpha:0.75f];
        [self addSubview:view];
        
        UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(0, maxY(view), screenWidth(), 70)];
        lab.text = @"领取优惠券";
        lab.backgroundColor = [UIColor whiteColor];
        lab.textAlignment = NSTextAlignmentCenter;
        lab.textColor = [UIColor blackColor];
        lab.font = [UIFont systemFontOfSize:17];
        [self addSubview:lab];
        
        
        
        UIButton *button = [UIButton buttonWithType:(UIButtonTypeCustom)];
        button.frame = CGRectMake(screenWidth()-40, maxY(view)+10, 30, 30);
        [button setImage:[UIImage imageNamed:@"弹窗关闭按钮"] forState:(UIControlStateNormal)];
        [button addTarget:self action:@selector(closeView) forControlEvents:(UIControlEventTouchUpInside)];
        [self addSubview:button];

        [self addSubview:self.tableView];

        
    }
    return self;
}
/**
 *  懒加载UITableView
 *
 *  @return UITableView
 */
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, screenHeight()/2, KScreenWidth, screenHeight()/2) style:UITableViewStyleGrouped];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.estimatedRowHeight = 0;
        _tableView.tableHeaderView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, CGFLOAT_MIN)];
        if (@available(iOS 11, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        [_tableView registerNib:[UINib nibWithNibName:@"GetCouponTableViewCell" bundle:nil] forCellReuseIdentifier:@"GetCouponTableViewCell"];
        // 删除单元格分隔线的一个小技巧
        self.tableView.tableFooterView = [UIView new];
        
    }
    return _tableView;
}
- (void)closeView{
    if (self.myBlock) {
        self.myBlock();
    }
}
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIImage imageNamed:@"无优惠券"];
}
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *title = @"暂无可用优惠券哦～";
    NSDictionary *attributes = @{
                                 NSFontAttributeName:[UIFont systemFontOfSize:13.0f],
                                 NSForegroundColorAttributeName:[UIColor colorWithHexString:@"8a8a8a"]
                                 };
    return [[NSAttributedString alloc] initWithString:title attributes:attributes];
}

#pragma mark —————     请求列表数据  --———
- (void)getGoodsID:(NSString *)goods_id withGoodsType:(NSString *)goods_type{
    
    coupon_goods_id = goods_id;
    coupon_goods_type = goods_type;
    NSMutableDictionary *parmDic = [NSMutableDictionary dictionary];
    [parmDic setObject:goods_id forKey:@"goods_id"];
    [parmDic setObject:goods_type forKey:@"goods_type"];
    [ZMNetworkHelper POST:@"/coupon/coupon_list" parameters:parmDic cache:YES responseCache:^(id responseCache) {

    } success:^(id responseObject) {
        if (responseObject == nil) {

        }else{
            if ([responseObject[@"code"] isEqualToString:@"0"]) {
                [self dataAnalysis:responseObject];
            }else{
                [BaseTools showErrorMessage:responseObject[@"msg"]];
            }
        }

    } failure:^(NSError *error) {

    }];
    
}
#pragma mark —————  请求到的数据进行解析  --———
- (void)dataAnalysis:(id)data{
    self.dataSource = [NSMutableArray array];
    GetCouponModel *model = [[GetCouponModel alloc]initWithDictionary:data error:nil];
    [self.dataSource addObjectsFromArray:model.data];
    self.tableView.loading = NO;
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
    //通知主线程刷新
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
    
    
}
#pragma mark - UITableViewDataSource, UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataSource.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 100;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GetCouponTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GetCouponTableViewCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = self.dataSource[indexPath.section];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
   
 
    NSMutableDictionary *parmDic = [NSMutableDictionary dictionary];

    [parmDic setObject:[self.dataSource[indexPath.section] coupon_id] forKey:@"coupon_id"];
    [ZMNetworkHelper POST:@"/coupon/get_coupon" parameters:parmDic cache:YES responseCache:^(id responseCache) {
        
    } success:^(id responseObject) {
        if (responseObject == nil) {
            
        }else{
            if ([responseObject[@"code"] isEqualToString:@"0"]) {
                [BaseTools showErrorMessage:responseObject[@"msg"]];
            }else{
                [BaseTools showErrorMessage:responseObject[@"msg"]];
            }
        }
        
    } failure:^(NSError *error) {
        
    }];
    
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.0001;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *allBgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenWidth(), 0)];
    allBgView.backgroundColor = [UIColor whiteColor];
    return allBgView;
    
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *allBgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenWidth(), 15)];
    allBgView.backgroundColor = [UIColor whiteColor];
    return allBgView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 15;
    
}


@end
