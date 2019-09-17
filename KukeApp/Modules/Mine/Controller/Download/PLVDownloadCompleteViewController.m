//
//  PLVDownloadCompleteViewController.m
//  PolyvVodSDKDemo
//
//  Created by mac on 2018/7/24.
//  Copyright © 2018年 POLYV. All rights reserved.
//

#import "PLVDownloadCompleteViewController.h"
#import <PLVVodSDK/PLVVodSDK.h>
#import "UIColor+PLVVod.h"
#import <PLVTimer/PLVTimer.h>
#import "PLVToolbar.h"
#import "PLVSimpleDetailController.h"
#import "PLVDownloadComleteCell.h"
#import "PLVDownloadCompleteInfoModel.h"
#import "DownLoadDataBaseModel.h"
#import "DownLoadCategoryCell.h"
#import "DownLoadLessonListViewController.h"
@interface PLVDownloadCompleteViewController ()<UITableViewDelegate,UITableViewDataSource,ZMEmptyDataSetSource,ZMEmptyDataSetDelegate>


@property (strong, nonatomic) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray<PLVDownloadCompleteInfoModel *> *downloadInfos;
@property (nonatomic, strong) NSMutableArray *cateAry;
@property (nonatomic, strong) NSMutableArray *dataAry;
@end

@implementation PLVDownloadCompleteViewController

- (NSMutableArray<PLVDownloadCompleteInfoModel *> *)downloadInfos{
    if (!_downloadInfos){
        _downloadInfos = [NSMutableArray arrayWithCapacity:0];
    }
    
    return _downloadInfos;
}
- (NSMutableArray *)cateAry{
    if (!_cateAry){
        _cateAry = [NSMutableArray arrayWithCapacity:0];
    }
    
    return _cateAry;
}
- (NSMutableArray *)dataAry{
    if (!_dataAry){
        _dataAry = [NSMutableArray arrayWithCapacity:0];
    }
    
    return _dataAry;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self initVideoList];
}
- (void)viewDidLoad {
    [super viewDidLoad];

   
    
    [self.view addSubview:self.tableView];


    //
    [PLVVodDownloadManager sharedManager].downloadCompleteBlock = ^(PLVVodDownloadInfo *info) {
        // 刷新列表
        dispatch_async(dispatch_get_main_queue(), ^{
            
//            PLVDownloadCompleteInfoModel *model = [[PLVDownloadCompleteInfoModel alloc] init];
//            model.downloadInfo = info;
//            model.localVideo = [PLVVodLocalVideo localVideoWithVideo:info.video dir:[PLVVodDownloadManager sharedManager].downloadDir];
//            [weakSelf.downloadInfos addObject:model];
//
            _cateAry = [NSMutableArray array];
            _dataAry = [NSMutableArray array];
            [self initVideoList];

        });
    };
}
/**
 *  懒加载UITableView
 *
 *  @return UITableView
 */
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, self.view.frame.size.height-UI_navBar_Height-75) style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = CBackgroundColor;
        _tableView.estimatedRowHeight = 0;
        self.tableView.rowHeight = UITableViewAutomaticDimension;
        self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 50, 0);
        _tableView.tableHeaderView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, CGFLOAT_MIN)];
        if (@available(iOS 11, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        [_tableView registerNib:[UINib nibWithNibName:@"DownLoadCategoryCell" bundle:nil] forCellReuseIdentifier:@"DownLoadCategoryCell"];
        // 删除单元格分隔线的一个小技巧
        self.tableView.tableFooterView = [UIView new];
        self.tableView.emptyDataSetSource = self;
        self.tableView.emptyDataSetDelegate = self;
        
    }
    return _tableView;
}

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIImage imageNamed:@"无下载"];
}
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *title = @"您还没有任何下载哦~";
    NSDictionary *attributes = @{
                                 NSFontAttributeName:[UIFont systemFontOfSize:13.0f],
                                 NSForegroundColorAttributeName:[UIColor colorWithHexString:@"8a8a8a"]
                                 };
    return [[NSAttributedString alloc] initWithString:title attributes:attributes];
}

- (void)initVideoList{

    // 从本地文件目录中读取已缓存视频列表
    NSArray<PLVVodLocalVideo *> *localArray = [[PLVVodDownloadManager sharedManager] localVideos];
    
    
    for (PLVVodLocalVideo *video in localArray) {
        [DownLoadVideoDataBaseTool updateVideoType:@"1" whenVid:video.vid];
    }
    
//    NSMutableArray *ary = [DownLoadVideoDataBaseTool getAllVideos];
    NSArray *result =[DownLoadVideoDataBaseTool selectType:@"1"];

    _cateAry = [result valueForKeyPath:@"@distinctUnionOfObjects.self"];
    
    
    if (_cateAry.count == 0) {
        [self.tableView reloadData];
    }else{
        if ([BaseTools getCurrentNetworkState] == 0 ) {
            
          self.dataAry = [UserDefaultsUtils valueWithKey:[NSString stringWithFormat:@"DownLoadCourseList_%@",[UserDefaultsUtils valueWithKey:@"access_token"]]];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
            
        }else{
            
            [self loadData];
        }
    }

}
#pragma mark —————     请求列表数据  --———
- (void)loadData{
    NSString *str = [_cateAry componentsJoinedByString:@","];
    NSMutableDictionary *parmDic = [NSMutableDictionary dictionary];
    [parmDic setObject:str forKey:@"course_ids"];
    [ZMNetworkHelper POST:@"/course/check_course_expired" parameters:parmDic cache:YES responseCache:^(id responseCache) {
        
    } success:^(id responseObject) {
        if (responseObject == nil) {
            
        }else{
            if ([responseObject[@"code"] isEqualToString:@"0"]) {
                [self dataAnalysis:responseObject];
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

#pragma mark —————  请求到的数据进行解析  --———
- (void)dataAnalysis:(id)data{
    
   
    [self.dataAry addObjectsFromArray:data[@"data"]];

    
    [UserDefaultsUtils saveValue:self.dataAry forKey:[NSString stringWithFormat:@"DownLoadCourseList_%@",[UserDefaultsUtils valueWithKey:@"access_token"]]];
    
    //通知主线程刷新
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
    
}
#pragma mark - property

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return _cateAry.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DownLoadCategoryCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DownLoadCategoryCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell upDataWithCategoryID:_cateAry[indexPath.row]];
    if ([_dataAry[indexPath.row][@"is_expired"] isEqualToString:@"0"]) {
        cell.isLook.hidden = YES;
    }else{
        cell.isLook.hidden = NO;
    }
    return cell;

}

#pragma mark -- UITableViewDelegate --
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 123;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    DownLoadLessonListViewController *vc = [[DownLoadLessonListViewController alloc]init];
    vc.categoryID = _cateAry[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
    
}


@end
