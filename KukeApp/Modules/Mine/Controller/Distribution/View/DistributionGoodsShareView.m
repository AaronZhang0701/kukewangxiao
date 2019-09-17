//
//  DistributionGoodsShareView.m
//  KukeApp
//
//  Created by 库课 on 2019/3/27.
//  Copyright © 2019 KukeZangMing. All rights reserved.
//

#import "DistributionGoodsShareView.h"

@interface DistributionGoodsShareView (){
    NSString *urlStr;
}

@end

@implementation DistributionGoodsShareView
- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    self = [[[NSBundle mainBundle] loadNibNamed:@"DistributionGoodsShareView" owner:self options:nil] firstObject];
    if (self) {
        self.frame = frame;
        
    }
    return self;
}
- (void)setUrl:(NSString *)url{
    urlStr = url;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (IBAction)closeAction:(id)sender {
    if (self.myCloseBlock) {
        self.myCloseBlock();
    }
}
- (IBAction)wxshareAction:(id)sender {
    [self shareImageAndTextToPlatformType:UMSocialPlatformType_WechatSession];
}
- (IBAction)qqShareAction:(id)sender {
    [self shareImageAndTextToPlatformType:UMSocialPlatformType_QQ];
}
- (IBAction)wbShareAction:(id)sender {
//    [self shareImageAndTextToPlatformType:UMSocialPlatformType_Sina];
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
- (IBAction)pyqShareAction:(id)sender {
    [self shareImageAndTextToPlatformType:UMSocialPlatformType_WechatTimeLine];
    
}
//分享图片和文字
- (void)shareImageAndTextToPlatformType:(UMSocialPlatformType)platformType
{
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    
    //设置文本
    messageObject.text = @"库课网校";
    
    //创建图片内容对象
    UMShareImageObject *shareObject = [[UMShareImageObject alloc] init];
    //如果有缩略图，则设置缩略图
//    if (platformType == UMSocialPlatformType_Linkedin) {
        // linkedin仅支持URL图片
//        shareObject.thumbImage = ;
        [shareObject setShareImage:urlStr];
//    }
//    else {
//        shareObject.thumbImage = [UIImage imageNamed:@"icon"];
//        shareObject.shareImage = [UIImage imageNamed:@"logo"];
//    }
    
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    
    //调用分享接口
#ifdef UM_Swift
    [UMShareSwiftInterface shareWithPlattype:platformType messageObject:messageObject viewController:[[AppDelegate shareAppDelegate] getCurrentUIVC] completion:^(UMSocialShareResponse * data, NSError * error) {
#else
        [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:[[AppDelegate shareAppDelegate] getCurrentUIVC] completion:^(id data, NSError *error) {
#endif
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
