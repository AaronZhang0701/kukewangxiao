//
//  MyOrderBaseViewController.m
//  KukeApp
//
//  Created by iOSDeveloper on 2018/10/22.
//  Copyright © 2018年 zhangming. All rights reserved.
//

#import "MyOrderBaseViewController.h"
#import "MyOrderModel.h"
#import "CourseSelectionModel.h"
#import "MyOrderTableViewCell.h"
#import "EvaluateViewController.h"

@interface MyOrderBaseViewController (){
    //考试动态0。 备考指导1
    NSInteger titleIndex;
   
    NSString *orderID;
    BOOL isFinish;
    UIButton *button;

}

//列表数组
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, assign) NSInteger pageNO;
@end

@implementation MyOrderBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    isFinish = YES;
    titleIndex = 0;
    self.pageNO = 1;
    self.view.backgroundColor = CBackgroundColor;
    


    [self.tableView registerNib:[UINib nibWithNibName:@"MyOrderTableViewCell" bundle:nil] forCellReuseIdentifier:@"MyOrderTableViewCell"];
    //初始化刷新控件
    [self initRefresh];
    __weak typeof(self) weakSelf = self;
    self.header_block = ^{
        weakSelf.pageNO = 1;
        [weakSelf loadData];
    };
    self.footre_block = ^{
        weakSelf.pageNO ++;
        [weakSelf loadData];
    };
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(upLoad) name:KNotificationLoginUpdata object:nil];
}
#pragma mark - 点击背景刷新时执行
- (void)noDataBeginRefresh {
    [self lq_endLoading];
    [self loadData];
}

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIImage imageNamed:@"无订单"];
}
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *title = @"还没有相关订单哦~";
    NSDictionary *attributes = @{
                                 NSFontAttributeName:[UIFont systemFontOfSize:13.0f],
                                 NSForegroundColorAttributeName:[UIColor colorWithHexString:@"8a8a8a"]
                                 };
    return [[NSAttributedString alloc] initWithString:title attributes:attributes];
}
- (void)upLoad{

    [self loadData];
}
#pragma mark —————     请求列表数据  --———
- (void)loadData:(NSInteger)index {
 
    isFinish = YES;
    self.dataSource = [NSMutableArray array];
    self.pageNO = 1;
    titleIndex = index;
    
    if (index == 0) {
        titleIndex = 101;
    }else if (index == 1){
        titleIndex = 0;
    }else if (index == 2){
        titleIndex = 1;
    }else if (index == 3){
        titleIndex = 2;
    }else if (index == 4){
        titleIndex = 4;
    }else if (index == 5){
        titleIndex = 5;
    }
    [self loadData];
    
}
-(void)loadData{

    if (isFinish) {
        NSMutableDictionary *parmDic = [NSMutableDictionary dictionary];
        [parmDic setObject:[NSNumber numberWithInteger:titleIndex] forKey:@"tab"];
        [parmDic setObject:@"10" forKey:@"limit"];
        [parmDic setObject:[NSNumber numberWithInteger:self.pageNO] forKey:@"page"];
        BADataEntity *entity = [BADataEntity new];
        entity.urlString = @"/ucenter/order_v2";
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
            if(self.pageNO >1) {
                [self endRefreshWithFooterHidden];
            }else{
                
                [self endWaterDropRefreshWithHeaderHidden];
            }
            if ([[response objectForKey:@"data"] count] < 10 && self.pageNO >1) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
        } failureBlock:^(NSError *error) {
            [self setEmptyViewDelegeta];
        } progressBlock:^(int64_t bytesProgress, int64_t totalBytesProgress) {
            /*! 封装方法里已经回到主线程，所有这里不用再调主线程了 */
            
        }];
    }
    

}
#pragma mark —————  请求到的数据进行解析  --———
- (void)dataAnalysis:(id)data{
    if (self.pageNO == 1) {
        [self.dataSource removeAllObjects];
    }
    MyOrderModel *model = [[MyOrderModel alloc]initWithDictionary:data error:nil];
    [self.dataSource addObjectsFromArray:model.data];
    [self setEmptyViewDelegeta];
    //通知主线程刷新
    if (isFinish) {
        [self.tableView reloadData];
        isFinish = NO;
    }
    
}


#pragma mark - UITableViewDataSource, UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataSource.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 230;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    // 通过indexPath创建cell实例 每一个cell都是单独的
    MyOrderTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    // 判断为空进行初始化  --（当拉动页面显示超过主页面内容的时候就会重用之前的cell，而不会再次初始化）
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"MyOrderTableViewCell" owner:self options:nil] lastObject];
    }
    
    // 对cell 进行简单地数据配置
    cell.model = self.dataSource[indexPath.section];

    if ([[self.dataSource[indexPath.section] order_status] integerValue] ==0 ) {
        cell.endTime.hidden = NO;
        cell.payAction.hidden = NO;
        cell.ohterBtn.hidden = NO;
    }
    NSString *time = nil;
    if ([[self.dataSource[indexPath.section] order_status] isEqualToString:@"100"]) {
         time = [BaseTools getDateStringWithTimeStr:[self.dataSource[indexPath.section] rest_time]];
    }else{
         time = [BaseTools getDateStringWithTimeStr:[self.dataSource[indexPath.section] auto_end_time]];
    }
   
    NSInteger str = [self getNowTimeWithString:time];
    [cell setConfigWithSecond:str];

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
    
    cell.deleteActionBlock = ^(NSString *order_sn) {

        orderID = order_sn;
        [self deleteOrder];

    };
    cell.cancelActionBlock = ^(NSString *order_sn) {
        orderID = order_sn;
        [self cancelOrder];
    };
    cell.receiptActionBlock = ^(NSString *order_sn) {
        orderID = order_sn;
        [self receiptOrder];
    };
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 8;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *allBgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenHeight(), 10)];
    allBgView.backgroundColor = CBackgroundColor;
    return allBgView;
    
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.0000001;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    NSDictionary *dict =[[NSDictionary alloc]initWithObjectsAndKeys:self.dataSource[indexPath.section],@"Order_data", nil];
    KPostNotification(@"MyOrderDetail",dict);

}
-(void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([indexPath row] == ((NSIndexPath*)[[tableView indexPathsForVisibleRows] lastObject]).row){

        isFinish = YES;
    }
}




- (void)deleteOrder{
    NSMutableDictionary *parmDic = [NSMutableDictionary dictionary];
    [parmDic setObject:orderID forKey:@"order_sn"];

    [ZMNetworkHelper POST:@"/order_handler/delete" parameters:parmDic cache:YES responseCache:^(id responseCache) {
        
    } success:^(id responseObject) {
        if (responseObject == nil) {
            
        }else{
            if ([responseObject[@"code"] isEqualToString:@"0"]) {
                [self loadData:titleIndex];
            }else if ([responseObject[@"code"] isEqualToString:@"-10000"]){
                [BaseTools showErrorMessage:@"请登录后再操作"];
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [BaseTools alertLoginWithVC:[[AppDelegate shareAppDelegate]getCurrentUIVC]];
                });
            }else{
                [BaseTools showErrorMessage:responseObject[@"msg"]];
            }
        }
    } failure:^(NSError *error) {
        
    }];
}
- (void)cancelOrder{
    NSMutableDictionary *parmDic = [NSMutableDictionary dictionary];
    [parmDic setObject:orderID forKey:@"order_sn"];
    
    [ZMNetworkHelper POST:@"/order_handler/cancel" parameters:parmDic cache:YES responseCache:^(id responseCache) {
        
    } success:^(id responseObject) {
        
        [[OpenInstallSDK defaultManager] reportEffectPoint:@"cancelorder" effectValue:1];
        if (responseObject == nil) {
            
        }else{
            if ([responseObject[@"code"] isEqualToString:@"0"]) {
                [self loadData];
            }else if ([responseObject[@"code"] isEqualToString:@"-10000"]){
                [BaseTools showErrorMessage:@"请登录后再操作"];
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [BaseTools alertLoginWithVC:[[AppDelegate shareAppDelegate]getCurrentUIVC]];
                });
            }else{
                [BaseTools showErrorMessage:responseObject[@"msg"]];
            }
        }
    } failure:^(NSError *error) {
        
    }];
    
}
- (void)receiptOrder{
    NSMutableDictionary *parmDic = [NSMutableDictionary dictionary];
    [parmDic setObject:orderID forKey:@"order_sn"];
    
    [ZMNetworkHelper POST:@"/order_handler/confirm" parameters:parmDic cache:YES responseCache:^(id responseCache) {
        
    } success:^(id responseObject) {
        if (responseObject == nil) {
            
        }else{
            if ([responseObject[@"code"] isEqualToString:@"0"]) {
                [self loadData:titleIndex];
            }else if ([responseObject[@"code"] isEqualToString:@"-10000"]){
                [BaseTools showErrorMessage:@"请登录后再操作"];
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [BaseTools alertLoginWithVC:[[AppDelegate shareAppDelegate]getCurrentUIVC]];
                });
            }else{
                [BaseTools showErrorMessage:responseObject[@"msg"]];
            }
        }
    } failure:^(NSError *error) {
        
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




-(NSInteger *)getNowTimeWithString:(NSString *)aTimeString{
    NSDateFormatter* formater = [[NSDateFormatter alloc] init];
    [formater setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    // 截止时间date格式
    NSDate  *expireDate = [formater dateFromString:aTimeString];
    NSDate  *nowDate = [NSDate date];
    // 当前时间字符串格式
    NSString *nowDateStr = [formater stringFromDate:nowDate];
    // 当前时间date格式
    nowDate = [formater dateFromString:nowDateStr];
    
    NSTimeInterval timeInterval =[expireDate timeIntervalSinceDate:nowDate];
    
    return (int)timeInterval;
//    int days = (int)(timeInterval/(3600*24));
//    int hours = (int)((timeInterval-days*24*3600)/3600);
//    int minutes = (int)(timeInterval-days*24*3600-hours*3600)/60;
//    int seconds = timeInterval-days*24*3600-hours*3600-minutes*60;
//
//    NSString *dayStr;NSString *hoursStr;NSString *minutesStr;NSString *secondsStr;
//    //天
//    dayStr = [NSString stringWithFormat:@"%d",days];
//    //小时
//    hoursStr = [NSString stringWithFormat:@"%d",hours];
//    //分钟
//    if(minutes<10)
//        minutesStr = [NSString stringWithFormat:@"0%d",minutes];
//    else
//        minutesStr = [NSString stringWithFormat:@"%d",minutes];
//    //秒
//    if(seconds < 10)
//        secondsStr = [NSString stringWithFormat:@"0%d", seconds];
//    else
//        secondsStr = [NSString stringWithFormat:@"%d",seconds];
//    if (hours<=0&&minutes<=0&&seconds<=0) {
//        return @"订单已过期";
//    }
//    if (days) {
//        return [NSString stringWithFormat:@"%@天 %@小时 %@分 %@秒", dayStr,hoursStr, minutesStr,secondsStr];
//    }
//    return [NSString stringWithFormat:@"%@小时 %@分 %@秒",hoursStr , minutesStr,secondsStr];
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
@end
