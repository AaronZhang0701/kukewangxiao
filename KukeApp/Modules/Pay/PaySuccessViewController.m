//
//  PaySuccessViewController.m
//  KukeApp
//
//  Created by 库课 on 2019/1/5.
//  Copyright © 2019 zhangming. All rights reserved.
//

#import "PaySuccessViewController.h"
#import "MyOrderViewController.h"
#import "MyAnswerViewController.h"
#import "MyLearningRecordViewController.h"
#import "CourseDetailViewController.h"
#import "MyOrderViewController.h"
#import "MyLearningListViewController.h"
#import "GroupBuyingListViewController.h"
@interface PaySuccessViewController (){
    NSString *goods_type;
    NSString *goods_id;
    NSString *goods_image;
    NSString *goods_name;
    
}

@end

@implementation PaySuccessViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"支付成功";
    
    self.seeOrder.layer.borderWidth = 0.5;
    self.seeOrder.layer.borderColor = [[UIColor blackColor] CGColor];
    self.seeOrder.layer.cornerRadius = 3;
    self.seeOrder.layer.masksToBounds = YES;

    self.startLearning.layer.borderWidth = 0.5;
    self.startLearning.layer.borderColor = [CNavBgColor CGColor];
    self.startLearning.layer.cornerRadius = 3;
    self.startLearning.layer.masksToBounds = YES;

    self.continueBtn.layer.borderWidth = 0.5;
    self.continueBtn.layer.borderColor = [CNavBgColor CGColor];
    self.continueBtn.layer.cornerRadius = 3;
    self.continueBtn.layer.masksToBounds = YES;
    
    self.continueGroupBtn.layer.borderWidth = 0.5;
    self.continueGroupBtn.layer.borderColor = [CNavBgColor CGColor];
    self.continueGroupBtn.layer.cornerRadius = 3;
    self.continueGroupBtn.layer.masksToBounds = YES;
    
    if ([self.dataDict[@"type"] length]==0) {
        goods_type =self.dataDict[@"goods_type"];
        goods_id =self.dataDict[@"goods_id"];
        goods_image =self.dataDict[@"goods_image"];
        goods_name =self.dataDict[@"goods_name"];
    }else if ([self.dataDict[@"goods_type"] length]==0){
        goods_type =self.dataDict[@"type"];
        goods_id =self.dataDict[@"goods_id"];
        goods_image =self.dataDict[@"img"];
        goods_name =self.dataDict[@"title"];
    }

    if ([self.type isEqualToString:@"0"]) {
        if ([goods_type isEqualToString:@"4"]) {
            self.seeOrder.hidden = NO;
            self.continueBtn.hidden = NO;
        }else{

            self.seeOrder.hidden = NO;
            self.startLearning.hidden = NO;
        }
    }else if ([self.type isEqualToString:@"2"]){//参团
        if ([goods_type isEqualToString:@"4"]) {
            self.seeOrder.hidden = NO;
            if ([self.dataDict[@"rest_num"] isEqualToString:@"1"]) {//参团成功（还差一个人，再加上自己就是成功）
                self.continueGroupBtn.hidden = NO;
                self.messageLab.text = @"拼团成功，等待发货";
            }else{//参团失败
                self.continueBtn.hidden = NO;
                self.messageLab.text = [NSString stringWithFormat:@"支付成功，还差%@人即拼团成功",self.dataDict[@"rest_num"]];
            }
            
        }else{
            
            self.seeOrder.hidden = NO;
            if ([self.dataDict[@"rest_num"] isEqualToString:@"1"]) {//参团成功（还差一个人，再加上自己就是成功）
                self.startLearning.hidden = NO;
                self.messageLab.text = @"拼团成功，现在可以开始学习啦";
            }else{//参团失败
                self.continueBtn.hidden = NO;
                self.messageLab.text = [NSString stringWithFormat:@"支付成功，还差%@人即拼团成功",self.dataDict[@"rest_num"]];
            }

        }
        
    }else if ([self.type isEqualToString:@"1"]){//开团
       
        self.seeOrder.hidden = NO;
        self.continueBtn.hidden = NO;
        self.messageLab.text = [NSString stringWithFormat:@"支付成功，还差%@人即拼团成功",self.dataDict[@"rest_num"]];
    }

    // Do any additional setup after loading the view from its nib.
}
- (IBAction)seeOrderAction:(id)sender {
    MyOrderViewController *vc = [[MyOrderViewController alloc]init];
    vc.index_id = 0;
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)startLearningAction:(id)sender {
    if ([goods_type isEqualToString:@"3"] || [goods_type isEqualToString:@"2"] || [goods_type isEqualToString:@"6"]) {
//        MyLearningRecordViewController *vc = [[MyLearningRecordViewController alloc]init];
//        vc.imageUrl = goods_image;
//        vc.course_name = goods_name;
//        vc.course_id = goods_id;
//        [self.navigationController pushViewController:vc animated:YES];
        MyLearningListViewController *vc = [[MyLearningListViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }else if([self.dataDict[@"type"] isEqualToString:@"1"]){
        MyAnswerViewController *vc = [[MyAnswerViewController alloc]init];
        vc.imageUrl = goods_image;
        vc.testPaper_id = goods_id;
        vc.testPaper_title = goods_name;
        [self.navigationController pushViewController:vc animated:YES];
    }else if([self.dataDict[@"type"] isEqualToString:@"5"]){
        MyLearningListViewController *vc = [[MyLearningListViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}
- (IBAction)continueGroupAction:(id)sender {
    GroupBuyingListViewController *vc = [[GroupBuyingListViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)continueAction:(id)sender {
    if ([self.type isEqualToString:@"0"]) {
 
        NSString *urlString;
            
        urlString = [NSString stringWithFormat:@"%@/exam/%@.html",  SERVER_HOSTPC,goods_id];

        [UMSocialShareUIConfig shareInstance].sharePageGroupViewConfig.sharePageGroupViewPostionType = UMSocialSharePageGroupViewPositionType_Bottom;
        [UMSocialShareUIConfig shareInstance].sharePageScrollViewConfig.shareScrollViewPageItemStyleType = UMSocialPlatformItemViewBackgroudType_None;
        [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
            if (platformType == UMSocialPlatformType_UserDefine_Begin+2) {
                //自定义图标的点击事件
            }
            else{
                [self shareWebPageToPlatformType:platformType shareURLString:urlString title:goods_name descr:@"库课网校"];
            }
        }];
    }else{

        NSString *urlString = [NSString stringWithFormat:@"%@/join_group_detail/%@/%@", SERVER_HOSTPC,self.token,self.group_buy_goods_rule_id];
        
        [UMSocialShareUIConfig shareInstance].sharePageGroupViewConfig.sharePageGroupViewPostionType = UMSocialSharePageGroupViewPositionType_Bottom;
        [UMSocialShareUIConfig shareInstance].sharePageScrollViewConfig.shareScrollViewPageItemStyleType = UMSocialPlatformItemViewBackgroudType_None;
        [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
            if (platformType == UMSocialPlatformType_UserDefine_Begin+2) {
                //自定义图标的点击事件
            }
            else{
                [self shareWebPageToPlatformType:platformType shareURLString:urlString title:goods_name descr:@"库课网校"];
            }
        }];
    }
    
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
- (BOOL)navigationShouldPopOnBackButton{
    //    [self.navigationController popToRootViewControllerAnimated:YES];
    // 返回到任意界面
    for (UIViewController *temp in self.navigationController.viewControllers) {
        if ([temp isKindOfClass:[CourseDetailViewController class]] || [temp isKindOfClass:[MyOrderViewController class]]|| [temp isKindOfClass:[MyLearningRecordViewController class]]) {
            [self.navigationController popToViewController:temp animated:YES];
        }
    }

    
    return NO;
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
