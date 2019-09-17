//
//  YFMPaymentView.m
//  YFMBottomPayView
//
//  Created by YFM on 2018/8/7.
//  Copyright © 2018年 iOS. All rights reserved.
//

#import "CancelOrderView.h"

#import "OrderCancelTableViewCell.h"

//#import <Masonry.h>

// 动态获取屏幕宽高
#define KScreenHeight ([UIScreen mainScreen].bounds.size.height)
#define KScreenWidth  ([UIScreen mainScreen].bounds.size.width)

#define KColorFromRGB(rgbValue) \
[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define LineColor                KColorFromRGB(0xefefef)
#define CColor                   KColorFromRGB(0x666666)
#define DColor                   KColorFromRGB(0x999999)
#define RemindRedColor           KColorFromRGB(0xF05F50)

@interface CancelOrderView ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic ,strong) NSArray *dataArr;
@property (nonatomic ,strong) UITableView *tableView;
@property (nonatomic ,assign) NSInteger currentIndex;
@property (nonatomic ,strong) UIButton *sureBtn;
@property (nonatomic ,strong) UIViewController *vc;

@property (nonatomic ,copy) NSString *totalBalance;

@end

@implementation CancelOrderView
- (instancetype)initTovc:(UIViewController *)vc dataSource:(NSArray *)dataSource{
    if (self = [super init]) {
        self.vc = vc;
        self.dataArr = dataSource;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.currentIndex = -1;
    [self initPop];
    [self setUpUI];
}

- (void)initPop {
    self.view.backgroundColor = [UIColor whiteColor];
    CGFloat height = 150;
    height += self.dataArr.count * 50;
    self.contentSizeInPopup = CGSizeMake(self.view.frame.size.width, height);
    self.popupController.navigationBarHidden = YES;
    [self.popupController.backgroundView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backgroundTap)]];
}

- (void)setUpUI {
    [self.view addSubview:self.tableView];
    [self creatSureBtn];
}

-(void)closeBlockView {
    [self backgroundTap];
}

- (void)backgroundTap  {
    [self.popupController dismiss];
}

-(UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.tableFooterView = [UIView new];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.view addSubview:_tableView];
        
        UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 74)];
        v.backgroundColor = [UIColor whiteColor];
        
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, KScreenWidth-30, 50)];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = [NSString stringWithFormat:@"取消订单"];
        label.textColor = [UIColor colorWithRed:70/255.0 green:70/255.0 blue:70/255.0 alpha:1];
        label.font = [UIFont systemFontOfSize:18];
        [v addSubview:label];
        
        
        UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(15, 50, KScreenWidth-30, 24)];
        lab.textAlignment = NSTextAlignmentLeft;
        lab.text = [NSString stringWithFormat:@"请选择取消订单的原因"];
        lab.font = [UIFont systemFontOfSize:12];
        lab.textColor = [UIColor colorWithRed:138/255.0 green:138/255.0 blue:138/255.0 alpha:1];
        [v addSubview:lab];
        
        UIButton *xButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [xButton setImage:[UIImage imageNamed:@"弹窗关闭按钮"] forState:UIControlStateNormal];
        xButton.frame = CGRectMake(KScreenWidth - 35, 9, 22, 22);
        [v addSubview:xButton];
        [xButton addTarget:self action:@selector(backgroundTap) forControlEvents:UIControlEventTouchUpInside];
        
        _tableView.tableHeaderView = v;
    }
    return _tableView;
}

#pragma mark === 富文本设置字体
- (NSMutableAttributedString *)setPriceAttreWithStr:(NSString *)str
{
    NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:str];
    [attri addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"PingFangSC-Medium" size:12] range:NSMakeRange(0, 7)];
    [attri addAttribute:NSForegroundColorAttributeName value:DColor range:NSMakeRange(0, 5)];
    [attri addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"PingFangSC-Medium" size:18] range:NSMakeRange(7, str.length - 7)];
    [attri addAttribute:NSForegroundColorAttributeName value:RemindRedColor range:NSMakeRange(5, str.length - 5)];
    return attri;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellId = [NSString stringWithFormat:@"PayTopTableViewCell%ld",indexPath.row];
    OrderCancelTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[OrderCancelTableViewCell alloc]initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:cellId];
    }
    [self configCell:cell data:[self.dataArr objectAtIndex:indexPath.row] indexPath:indexPath];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return nil;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.001;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.001;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.sureBtn setBackgroundColor:CNavBgColor];
    self.sureBtn.userInteractionEnabled = YES;
    self.currentIndex = indexPath.row;
    [self.tableView reloadData];
}


- (void)configCell:(OrderCancelTableViewCell *)cell data:(NSDictionary *)data indexPath:(NSIndexPath *)indexPath{
    NSString *str = data[@"title"];
    cell.titleLabel.text = str;
    if (self.currentIndex == indexPath.row) {
        cell.stateView.image =  [UIImage imageNamed:@"支付方式下载选择-选中"];
    }else{
        cell.stateView.image =  [UIImage imageNamed:@"支付方式下载选择-未选中"];
    }
   
}


-(void)creatSureBtn
{
    
    UIView *footer = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 90)];
    self.sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.sureBtn setTitle:@"确定取消" forState:UIControlStateNormal];
    self.sureBtn.layer.cornerRadius = 4.0;
    self.sureBtn.layer.masksToBounds = YES;
    [self.sureBtn addTarget:self action:@selector(handleSurePay) forControlEvents:UIControlEventTouchUpInside];
    [self.sureBtn setBackgroundColor:[UIColor colorWithHexString:@"f39094"]];
    self.sureBtn.userInteractionEnabled = NO;
    self.sureBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [footer addSubview:self.sureBtn];
    [self.sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(footer);
        make.size.mas_equalTo(CGSizeMake(KScreenWidth-30, 49));
    }];
    self.tableView.tableFooterView = footer;
}

#pragma mark === 确认支付
-(void)handleSurePay
{
    
    if (self.currentIndex != -1) {
        if (self.payType) {
            self.payType([[self.dataArr objectAtIndex:self.currentIndex] objectForKey:@"title"],self.totalBalance);
            [self backgroundTap];
        }
    }else{
        [BaseTools showErrorMessage:@"请选择取消订单的原因"];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
