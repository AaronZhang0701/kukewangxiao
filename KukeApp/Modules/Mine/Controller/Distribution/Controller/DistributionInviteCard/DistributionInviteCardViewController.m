//
//  DistributionInviteCardViewController.m
//  KukeApp
//
//  Created by 库课 on 2019/3/20.
//  Copyright © 2019 KukeZangMing. All rights reserved.
//

#import "DistributionInviteCardViewController.h"
#import "DistributionBottomShareView.h"
@interface DistributionInviteCardViewController (){
    NSString *urlStr;
}

@end

@implementation DistributionInviteCardViewController
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (kIsiPhoneX) {
        self.shareImage.frame = CGRectMake(0, 0, screenWidth(), screenHeight()-UI_navBar_Height-90);
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"库课网校邀请卡";
    self.btn.layer.cornerRadius = 5;
    self.btn.layer.masksToBounds = YES;


    UIButton *shareBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    shareBtn.frame = CGRectMake(screenWidth()-40, 20, 30, 30);
    [shareBtn addTarget:self action:@selector(share) forControlEvents:(UIControlEventTouchUpInside)];
    [shareBtn setImage:[UIImage imageNamed:@"分享(1)"] forState:(UIControlStateNormal)];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:shareBtn];
    self.navigationItem.rightBarButtonItem=item;
    

    [ZMNetworkHelper POST:@"/distribution/draw_card_poster" parameters:nil cache:YES responseCache:^(id responseCache) {
        
    } success:^(id responseObject) {
        if (responseObject == nil) {
            
        }else{
            if ([responseObject[@"code"] isEqualToString:@"0"]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    urlStr =responseObject[@"data"];
                    [self.shareImage sd_setImageWithURL:[NSURL URLWithString:urlStr]];
//                    [self.shareImage sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:nil options:(SDWebImageOptions)]
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
    // Do any additional setup after loading the view from its nib.
}
- (void)share{
    DistributionBottomShareView *shareView = [[DistributionBottomShareView alloc]initWithFrame:CGRectMake(0, screenHeight()-150, screenWidth(), 150)];

    CGPoint showCenter = CGPointMake(SCREEN_WIDTH/2,SCREEN_HEIGHT-shareView.height/2);
    [SGBrowserView showMoveView:shareView moveToCenter:showCenter];
    
    shareView.myCloseBlock = ^{
        [SGBrowserView hide];
    };
    shareView.myWXShareBlock = ^{
        [self shareImageAndTextToPlatformType:UMSocialPlatformType_WechatSession];
        
    };
    shareView.myQQShareBlock = ^{
        [self shareImageAndTextToPlatformType:UMSocialPlatformType_QQ];
        
    };
    shareView.myCopyBlock = ^{
        [self shareImageAndTextToPlatformType:UMSocialPlatformType_Sina];
        
    };
    shareView.myPicBlock = ^{
        
        [self shareImageAndTextToPlatformType:UMSocialPlatformType_WechatTimeLine];
    };
}
- (IBAction)shareAction:(id)sender {
    
    UIImageWriteToSavedPhotosAlbum(self.shareImage.image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    
}
#pragma mark -- <保存到相册>
-(void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    NSString *msg = nil ;
    if(error){
        msg = @"保存图片失败" ;
        [BaseTools showErrorMessage:msg];
    }else{
        msg = @"保存图片成功" ;
        [BaseTools showErrorMessage:msg];
    }
}

//分享图片和文字
- (void)shareImageAndTextToPlatformType:(UMSocialPlatformType)platformType
{
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    
    //设置文本
    messageObject.text = @"库课网校";
    
//    //创建图片内容对象
//    UMShareImageObject *shareObject = [[UMShareImageObject alloc] init];
//    //如果有缩略图，则设置缩略图
//    //    if (platformType == UMSocialPlatformType_Linkedin) {
//    // linkedin仅支持URL图片
//            shareObject.thumbImage = ;
//    [shareObject setShareImage:urlStr];
//    //    }
//    //    else {
//    //        shareObject.thumbImage = [UIImage imageNamed:@"icon"];
//    //        shareObject.shareImage = [UIImage imageNamed:@"logo"];
//    //    }
//
//    //分享消息对象设置分享内容对象
//    messageObject.shareObject = shareObject;
    //创建图片内容对象
    UMShareImageObject *shareObject = [[UMShareImageObject alloc] init];
    //如果有缩略图，则设置缩略图
    shareObject.thumbImage = [UIImage imageNamed:@"icon"];
    [shareObject setShareImage:urlStr];
    
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
        if (error) {
            NSLog(@"************Share fail with error %@*********",error);
        }else{
            
            [[OpenInstallSDK defaultManager] reportEffectPoint:@"goodshare" effectValue:1];
            NSLog(@"response data is %@",data);
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
