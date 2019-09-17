//
//  EvaluateViewController.m
//  KukeApp
//
//  Created by iOSDeveloper on 2018/10/22.
//  Copyright © 2018年 zhangming. All rights reserved.
//

#import "EvaluateViewController.h"

#import "LEEStarRating.h"
@interface EvaluateViewController ()<UITextViewDelegate>{
    CGFloat starValue;
}

@end

@implementation EvaluateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:self.navigationItem.backBarButtonItem.style target:nil action:nil];

    self.pic.layer.cornerRadius = 5;
    self.pic.layer.masksToBounds = YES;
    self.title  = @"评价";
    self.myText.delegate = self;


    LEEStarRating *ratingView = [[LEEStarRating alloc] initWithFrame:CGRectMake(0, 10, 220, 30) Count:5]; //初始化并设置frame和个数
    
    ratingView.spacing = 15.0f; //间距
    
    ratingView.checkedImage = [UIImage imageNamed:@"我的订单评价黄色星星"]; //选中图片
    
    ratingView.uncheckedImage = [UIImage imageNamed:@"填写评价灰色星星"]; //未选中图片
    
    ratingView.type = RatingTypeWhole; //评分类型
    
    ratingView.touchEnabled = YES; //是否启用点击评分 如果纯为展示则不需要设置
    
    ratingView.slideEnabled = YES; //是否启用滑动评分 如果纯为展示则不需要设置
    
    ratingView.maximumScore = 5.0f; //最大分数
    
    ratingView.minimumScore = 0.0f; //最小分数
    
    [self.starView addSubview:ratingView];
    
    // 当前分数变更事件回调
    ratingView.currentScoreChangeBlock = ^(CGFloat score){

        starValue = score;

    };
    
    // 请在设置完成最大最小的分数后再设置当前分数 并确保当前分数在最大和最小分数之间
    ratingView.currentScore = 5.0f;

    
    if (self.data) {
        self.goodName.text = self.data[@"goods"][@"goods_name"];
        [self.pic sd_setImageWithURL:[NSURL URLWithString:self.data[@"goods"][@"goods_image"]] placeholderImage:[UIImage imageNamed:@"goodsImage"]];
        self.price.text = [NSString stringWithFormat:@"%@",self.data[@"order_price"]];
    }else{
        self.goodName.text = self.model.goods[@"goods_name"];
        [self.pic sd_setImageWithURL:[NSURL URLWithString:self.model.goods[@"goods_image"]] placeholderImage:[UIImage imageNamed:@"goodsImage"]];
        self.price.text =[NSString stringWithFormat:@"%@",self.model.order_price];
    }
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)commitAction:(id)sender {

    
    if (_myText.text.length == 0) {
        [BaseTools showErrorMessage:@"内容不能为空"];
    }else{
        NSMutableDictionary *parmDic = [NSMutableDictionary dictionary];
        if (self.data) {
            [parmDic setObject:self.data[@"order_id"] forKey:@"order_id"];
            [parmDic setObject:self.data[@"goods"][@"goods_type"] forKey:@"goods_type"];
            [parmDic setObject:self.data[@"goods"][@"goods_id"] forKey:@"goods_id"];
        }else{
            [parmDic setObject:self.model.order_id forKey:@"order_id"];
            [parmDic setObject:self.model.goods[@"goods_type"] forKey:@"goods_type"];
            [parmDic setObject:self.model.goods[@"goods_id"] forKey:@"goods_id"];
        }

        [parmDic setObject:_myText.text forKey:@"content"];
        [parmDic setObject:@"4" forKey:@"mobile_type"];
        [parmDic setObject:[NSString stringWithFormat:@"%f",starValue] forKey:@"score"];
        [ZMNetworkHelper POST:@"/stucommon/new_add_discuss" parameters:parmDic cache:YES responseCache:^(id responseCache) {
            
        } success:^(id responseObject) {
            if (responseObject == nil) {
                
            }else{
                if ([responseObject[@"code"] isEqualToString:@"0"]) {
                    [BaseTools showErrorMessage:responseObject[@"msg"]];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.navigationController popViewControllerAnimated:YES];
                        KPostNotification(KNotificationLoginUpdata, nil);
                    });
                }else if ([responseObject[@"code"] isEqualToString:@"-10000"]){
                    [BaseTools showErrorMessage:@"请登录后再操作"];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                         [BaseTools alertLoginWithVC:self];
                    });
                   
                }else{
                    [BaseTools showErrorMessage:responseObject[@"msg"]];
                }
            }
        } failure:^(NSError *error) {
            
        }];
    }
   
}
- (void)textViewDidBeginEditing:(UITextView *)textView{
    
    self.lab.hidden = YES;
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES]; //实现该方法是需要注意view需要是继承UIControl而来的
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
