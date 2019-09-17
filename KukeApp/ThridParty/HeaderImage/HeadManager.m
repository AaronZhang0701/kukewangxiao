//
//  HeadManager.m
//  蓝媒智能家居系统
//
//  Created by 英赛智能 on 16/6/9.
//  Copyright © 2016年 BlueMedia. All rights reserved.
//

#import "HeadManager.h"

@implementation HeadManager

- (void)dealloc
{
    NSLog(@"headmanager dealloc");
}

- (instancetype)initWithTarget:(UIViewController *)target
{
    self = [super init];
    if (self) {
        self.currentViewController = target;
    }
    return self;
}



- (void)checkCameraAvailability:(void (^)(BOOL auth))block {
    BOOL status = NO;
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if(authStatus == AVAuthorizationStatusAuthorized) {
        status = YES;
    } else if (authStatus == AVAuthorizationStatusDenied) {
        status = NO;
    } else if (authStatus == AVAuthorizationStatusRestricted) {
        status = NO;
    } else if (authStatus == AVAuthorizationStatusNotDetermined) {
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            if(granted){
                if (block) {
                    block(granted);
                }
            } else {
                if (block) {
                    block(granted);
                }
            }
        }];
        return;
    }
    if (block) {
        block(status);
    }
}


- (void)openTakePhoto {
    AvatarPictureViewController *avatar = [[AvatarPictureViewController alloc]init];
    avatar.delegate = self;
    [self.currentViewController presentViewController:avatar animated:YES completion:nil];
}

- (void)openPhotoalbums {
    AJPhotoPickerViewController *picker = [[AJPhotoPickerViewController alloc] init];
    picker.assetsFilter = [ALAssetsFilter allPhotos];
    picker.showEmptyGroups = YES;
    picker.delegate=self;
    picker.selectionFilter = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        return YES;
    }];
    [self.currentViewController presentViewController:picker animated:YES completion:nil];
}



#pragma mark - BoPhotoPickerProtocol
- (void)photoPickerDidCancel:(AJPhotoPickerViewController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)photoPicker:(AJPhotoPickerViewController *)picker didSelectAssets:(NSArray *)assets {
    
}

- (void)photoPicker:(AJPhotoPickerViewController *)picker didSelectAsset:(ALAsset *)asset {
    NSLog(@"%s",__func__);
    
    AJPhotoBrowserViewController *photoBrowserViewController = [[AJPhotoBrowserViewController alloc] initWithPhotos:@[asset]];
    photoBrowserViewController.delegate = self;
    NSLog(@"presentedViewController  %@",self.currentViewController.presentedViewController);
    [self.currentViewController.presentedViewController presentViewController:photoBrowserViewController animated:YES completion:nil];
    
}

- (void)photoPicker:(AJPhotoPickerViewController *)picker didDeselectAsset:(ALAsset *)asset {
    NSLog(@"%s",__func__);
    AJPhotoBrowserViewController *photoBrowserViewController = [[AJPhotoBrowserViewController alloc] initWithPhotos:@[asset]];
    photoBrowserViewController.delegate = self;
    NSLog(@"presentedViewController  %@",self.currentViewController.presentedViewController);
    [self.currentViewController.presentedViewController presentViewController:photoBrowserViewController animated:YES completion:nil];
    
}

//超过最大选择项时
- (void)photoPickerDidMaximum:(AJPhotoPickerViewController *)picker {
    NSLog(@"%s",__func__);
}

//低于最低选择项时
- (void)photoPickerDidMinimum:(AJPhotoPickerViewController *)picker {
    NSLog(@"%s",__func__);
}


#pragma mark - AJPhotoBrowserDelegate

- (void)photoBrowser:(AJPhotoBrowserViewController *)vc deleteWithIndex:(NSInteger)index {
    NSLog(@"%s",__func__);
    //    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)photoBrowser:(AJPhotoBrowserViewController *)vc didDonePhotos:(NSArray *)photos {
    if (!(photos.count > 0)) {
        return;
    }
    UIImage *photo = nil;
    id photoObj = photos.firstObject;
    if ([photoObj isKindOfClass:[UIImage class]]) {
        photo = photoObj;
    } else if ([photoObj isKindOfClass:[ALAsset class]]) {
        CGImageRef fullScreenImageRef = ((ALAsset *)photoObj).defaultRepresentation.fullScreenImage;
        photo = [UIImage imageWithCGImage:fullScreenImageRef];
    }
    
    RSKImageCropViewController *imageCropVC = [[RSKImageCropViewController alloc] initWithImage:photo cropMode:RSKImageCropModeCircle];
    imageCropVC.delegate = self;
    [self.currentViewController.presentedViewController.presentedViewController presentViewController:imageCropVC animated:YES completion:nil];
    
    
    NSLog(@" %@ 、、  %s",photo,__func__);
    //    [self.presentedViewController dismissViewControllerAnimated:YES completion:nil];
}


- (void)photoPickerTapCameraAction:(AJPhotoPickerViewController *)picker {
    [self checkCameraAvailability:^(BOOL auth) {
        if (!auth) {
            NSLog(@"没有访问相机权限");
            return;
        }
    }];
    
    AvatarPictureViewController *avatar = [[AvatarPictureViewController alloc]init];
    avatar.delegate = self;
    [self.currentViewController.presentedViewController presentViewController:avatar animated:YES completion:nil];
    
}


#pragma mark - RSKImageCropViewControllerDelegate

- (void)imageCropViewControllerDidCancelCrop:(RSKImageCropViewController *)controller
{
    [self.currentViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)imageCropViewController:(RSKImageCropViewController *)controller didCropImage:(UIImage *)croppedImage usingCropRect:(CGRect)cropRect
{

    [self.currentViewController dismissViewControllerAnimated:YES completion:nil];
    if (self.cropImageBlock) {
        self.cropImageBlock(croppedImage);
    }
    [self postImage:croppedImage];
    [self saveToPlistFile:croppedImage];
}
- (void)postImage:(UIImage *)image{
//    [BaseTools showProgressMessage:@"上传中..."];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    //接收类型不一致请替换一致text/html或别的
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",
                                                         @"text/html",
                                                         @"image/jpeg",
                                                         @"image/png",
                                                         @"application/octet-stream",
                                                         @"text/json",
                                                         nil];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager.requestSerializer setValue:[UserDefaultsUtils valueWithKey:@"access_token"] forHTTPHeaderField:@"accessToken"];
    NSString *oldVersion = [[[NSBundle mainBundle]infoDictionary]objectForKey:@"CFBundleShortVersionString"];
    [manager.requestSerializer setValue:oldVersion forHTTPHeaderField:@"version"];
    [manager.requestSerializer setValue:@"3" forHTTPHeaderField:@"clientType"];
    NSURLSessionDataTask *task = [manager POST:[NSString stringWithFormat:@"%@/user/avatar_upload",SERVER_HOST] parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        NSData *imageData = UIImageJPEGRepresentation(image, 0.5);
        NSTimeInterval interval = [[NSDate date] timeIntervalSince1970];
        long long totalMilliseconds = interval * 1000 ;
        NSString *fileName = [NSString stringWithFormat:@"%lld.png", totalMilliseconds];
        NSString *name1 =  @"avatar";
        [formData appendPartWithFileData:imageData name:name1 fileName:fileName mimeType:@"image/jpeg"];
  
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        //打印下上传进度
        NSLog(@"%@",uploadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        // 查看 data 是否是 JSON 数据.
        // JSON 解析.
        id obj = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:NULL];
        
        if ([obj[@"code"] isEqualToString:@"0"]) {
            [BaseTools showErrorMessage:obj[@"msg"]];
//            
//            NSArray *dirArray = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
//            NSString *path = [dirArray firstObject];
//            path = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"IDCARD%d",0]];
//            NSData *imageData = UIImageJPEGRepresentation(image, 1.0);
//            [imageData writeToFile:path atomically:YES];
//            
//            KPostNotification(@"UpDataImage", nil);
            
        }else{
            [BaseTools showErrorMessage:obj[@"msg"]];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //上传失败
        NSLog(@"上传失败");
    }];

}
- (void)saveToPlistFile:(UIImage *)image{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@HeadImage.png",[[NSUserDefaults standardUserDefaults] stringForKey:@"123"]]];   // 保存文件的名称
    [UIImagePNGRepresentation(image)writeToFile: filePath    atomically:YES];
}
#pragma mark - AvatarPictureDelegate


- (void)avatarPictureViewController:(AvatarPictureViewController *)avatarPictureVC captureImage:(UIImage *)captureImage {
    
    
    // save photos
    UIImageWriteToSavedPhotosAlbum(captureImage, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
    
    RSKImageCropViewController *imageCropVC = [[RSKImageCropViewController alloc] initWithImage:captureImage cropMode:RSKImageCropModeCircle];
    imageCropVC.delegate = self;
    [avatarPictureVC presentViewController:imageCropVC animated:YES completion:nil];
    
}

// 指定回调方法
- (void)image: (UIImage *) image didFinishSavingWithError: (NSError *) error contextInfo: (void *) contextInfo{
    
    
}
@end
