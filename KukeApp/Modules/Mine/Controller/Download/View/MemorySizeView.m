//
//  MemorySizeView.m
//  KukeApp
//
//  Created by iOSDeveloper on 2018/12/7.
//  Copyright © 2018年 zhangming. All rights reserved.
//

#import "MemorySizeView.h"

@interface MemorySizeView (){
    NSString *totalString;
    NSString *freeString;
}

@end

@implementation MemorySizeView


- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self getFreeDiskspaceRate];
    }
    return self;
}

- (void)commonInit {

    UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(0,0, screenWidth(), 25)];
    lab.backgroundColor = [UIColor whiteColor];
    lab.font = [UIFont systemFontOfSize:13];
    lab.textColor = [UIColor colorWithHexString:@"8a8a8a"];
    lab.textAlignment = NSTextAlignmentCenter;
    lab.text = [NSString stringWithFormat:@"手机存储:总空间%@/剩余%@",totalString,freeString];
    [self addSubview:lab];

}
//返回存储内存占用比例
- (NSString *)getFreeDiskspaceRate{
    
    float totalSpace = 0.0;
    float totalFreeSpace=0.f;
    
    NSError *error = nil;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSDictionary *dictionary = [[NSFileManager defaultManager] attributesOfFileSystemForPath:[paths lastObject] error: &error];
    if (dictionary) {
        NSNumber *fileSystemSizeInBytes = [dictionary objectForKey: NSFileSystemSize];
        NSNumber *freeFileSystemSizeInBytes = [dictionary objectForKey:NSFileSystemFreeSize];
        totalSpace = [fileSystemSizeInBytes floatValue]/1024.0f/1024.0f/1024.0f;
        totalFreeSpace = [freeFileSystemSizeInBytes floatValue]/1024.0f/1024.0f/1024.0f;
        
        //totalString、freeString是定义两个全局变量 进度条上显示大小数据用
        totalString = [self getFileSizeString:[fileSystemSizeInBytes floatValue]];
        freeString = [self getFileSizeString:[freeFileSystemSizeInBytes floatValue]];
        NSLog(@"打印totalString：%@,freeString:%@",totalString,freeString);
        
        NSLog(@"Memory Capacity of %.2f GB with %.2f GB Free memory available.", totalSpace, totalFreeSpace);
        
    } else {
        NSLog(@"Error Obtaining System Memory Info: Domain = %@, Code = %ld", [error domain], (long)[error code]);
        
    }
    [self commonInit];
    NSString *freeStr = [NSString stringWithFormat:@"%.3f",(totalSpace-totalFreeSpace)/totalSpace];//进度条比例
    return freeStr;
}

-(NSString *)getFileSizeString:(CGFloat)size
{
    if (size>1024*1024*1024){
        return [NSString stringWithFormat:@"%.1fG",size/1024/1024/1024];//大于1G，则转化成G单位的字符串
    }
    else if(size<1024*1024*1024&&size>=1024*1024)//大于1M，则转化成M单位的字符串
    {
        return [NSString stringWithFormat:@"%.1fM",size/1024/1024];
    }
    else if(size>=1024&&size<1024*1024) //不到1M,但是超过了1KB，则转化成KB单位
    {
        return [NSString stringWithFormat:@"%.1fK",size/1024];
    }
    else//剩下的都是小于1K的，则转化成B单位
    {
        return [NSString stringWithFormat:@"%.1fB",size];
    }
}
@end
