//
//  DownLoadLessonListViewController.m
//  KukeApp
//
//  Created by iOSDeveloper on 2018/12/7.
//  Copyright © 2018年 zhangming. All rights reserved.
//

#import "DownLoadLessonListViewController.h"
#import <PLVVodSDK/PLVVodSDK.h>
#import "UIColor+PLVVod.h"
#import <PLVTimer/PLVTimer.h>
#import "PLVToolbar.h"
#import "PLVSimpleDetailController.h"
#import "PLVDownloadComleteCell.h"
#import "PLVDownloadCompleteInfoModel.h"
@interface DownLoadLessonListViewController ()<UITableViewDelegate,UITableViewDataSource,ZMEmptyDataSetSource,ZMEmptyDataSetDelegate>
@property (strong, nonatomic) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *downloadInfos;
@property (nonatomic, strong) NSMutableArray *downloadVid;
/** 选中的数据 */
@property (nonatomic , strong) NSMutableArray *selectedDatas;
/** 删除 */
@property (nonatomic , strong) UIButton *deleteBtn;
/** 全选按钮 */
@property (nonatomic , strong) UIButton *selectAllBtn;
/** 底部toolBar */
@property (nonatomic , strong) UIView *toolBarView;
/** rightBarButtonItem */
@property (nonatomic , strong) UIButton *rightBarButtonItem;
@end

@implementation DownLoadLessonListViewController

- (NSMutableArray *)downloadInfos{
    if (!_downloadInfos){
        _downloadInfos = [NSMutableArray arrayWithCapacity:0];
    }
    
    return _downloadInfos;
}
- (NSMutableArray *)downloadVid{
    if (!_downloadVid){
        _downloadVid = [NSMutableArray arrayWithCapacity:0];
    }
    
    return _downloadVid;
}
- (NSMutableArray *)selectedDatas
{
    if (_selectedDatas == nil) {
        _selectedDatas = [[NSMutableArray alloc] init];
    }
    return _selectedDatas;
}

- (UIView *)toolBarView{
    if (_toolBarView == nil) {
        _toolBarView = [[UIView alloc]initWithFrame:CGRectMake(0,screenHeight()-50-UI_navBar_Height, screenWidth(), 50)];
        _toolBarView.hidden = YES;
    }
    return _toolBarView;
}
#pragma mark - Getter
- (UIButton *)rightBarButtonItem
{
    if (_rightBarButtonItem == nil) {
        _rightBarButtonItem = [[UIButton alloc] init];
        _rightBarButtonItem.size = CGSizeMake(100, 30);
//        [_rightBarButtonItem setTitle:@"" forState:UIControlStateNormal];
        [_rightBarButtonItem setTitleColor:CTitleColor forState:(UIControlStateNormal)];
//        [_rightBarButtonItem setTitle:@"取消" forState:UIControlStateSelected];
//        [_rightBarButtonItem setTitleColor:MHGlobalBlackTextColor forState:UIControlStateNormal];
//        [_rightBarButtonItem setTitleColor:MHGlobalGrayTextColor forState:UIControlStateDisabled];
        [_rightBarButtonItem setImage:[UIImage imageNamed:@"已完成订单删除图标"] forState:(UIControlStateNormal)];
//        [_rightBarButtonItem setImage:[UIImage imageNamed:@""] forState:(UIControlStateSelected)];
        [_rightBarButtonItem addTarget:self action:@selector(rightBarButtonItemDidClicked:) forControlEvents:UIControlEventTouchUpInside];
//        _rightBarButtonItem.titleLabel.font = MHFont(MHPxConvertPt(14.0f), NO);
//        _rightBarButtonItem.mh_size = CGSizeMake(100, 44);
        _rightBarButtonItem.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    }
    return _rightBarButtonItem;
}
- (UIButton *)deleteBtn
{
    if (_deleteBtn == nil) {
        
        _deleteBtn = [[UIButton alloc] initWithFrame:CGRectMake(screenWidth()/2,0, screenWidth()/2, 50)];
        [_deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
        _deleteBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        _deleteBtn.adjustsImageWhenHighlighted = NO;
//        [_deleteBtn setBackgroundImage:MHImageNamed(@"collectionVideo_delete_nor") forState:UIControlStateNormal];
//        [_deleteBtn setBackgroundImage:MHImageNamed(@"collectionVideo_delete_high") forState:UIControlStateDisabled];
        [_deleteBtn setBackgroundColor:CNavBgColor];
        [_deleteBtn addTarget:self action:@selector(_deleteBtnDidClicked:) forControlEvents:UIControlEventTouchUpInside];
//        _deleteBtn.enabled = NO;
        
    }
    return _deleteBtn;
}
- (UIButton *)selectAllBtn
{
    if (_selectAllBtn == nil) {
        
        _selectAllBtn = [[UIButton alloc] initWithFrame:CGRectMake(0,0, screenWidth()/2, 50)];
        [_selectAllBtn setTitle:@"全选" forState:UIControlStateNormal];
        [_selectAllBtn setTitle:@"取消全选" forState:UIControlStateSelected];
        [_selectAllBtn setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
        _selectAllBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        _selectAllBtn.adjustsImageWhenHighlighted = NO;
        [_selectAllBtn setBackgroundColor:[UIColor whiteColor]];
        [_selectAllBtn addTarget:self action:@selector(leftBarButtonItemDidClicked:) forControlEvents:UIControlEventTouchUpInside];
//        _selectAllBtn.enabled = NO;
        
    }
    return _selectAllBtn;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"课时列表";
    [self.view addSubview:self.tableView];
    
    [self initVideoList];
    // 右侧
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.rightBarButtonItem];
    
    

    [self.view addSubview:self.toolBarView];
    [self.toolBarView addSubview:self.selectAllBtn];
    [self.toolBarView addSubview:self.deleteBtn];
    
//    self.navigationItem.rightBarButtonItem =  [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"删除（我的下载页面）"] style:UIBarButtonItemStyleDone target:self action:@selector(rightBarButtonItemDidClicked:)];
    // Do any additional setup after loading the view.
}
/**
 *  懒加载UITableView
 *
 *  @return UITableView
 */
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, self.view.frame.size.height-UI_navBar_Height) style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = CBackgroundColor;
        _tableView.estimatedRowHeight = 0;
        self.tableView.rowHeight = UITableViewAutomaticDimension;
//        self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 50, 0);
        _tableView.tableHeaderView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, CGFLOAT_MIN)];
        if (@available(iOS 11, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        [_tableView registerNib:[UINib nibWithNibName:@"PLVDownloadComleteCell" bundle:nil] forCellReuseIdentifier:@"PLVDownloadComleteCell"];
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
    NSMutableArray *arys = [NSMutableArray array];
    // 从本地文件目录中读取已缓存视频列表
    NSArray<PLVVodLocalVideo *> *localArray = [[PLVVodDownloadManager sharedManager] localVideos];
//    for (PLVVodLocalVideo *video in localArray) {
//        [DownLoadVideoDataBaseTool updateVideoType:@"1" whenVid:video.vid];
//    }
    NSMutableArray<PLVVodLocalVideo *> *localArray1 = [NSMutableArray array];
    NSMutableArray *ary = [DownLoadVideoDataBaseTool selectVidWithCategoryID:self.categoryID andVideoType:@"1"];
    for (PLVVodLocalVideo *videos in localArray) {
        if ([ary containsObject:videos.vid]) {
            [localArray1 addObject:videos];
        }
    }

    // 从数据库中读取已缓存视频详细信息
    // TODO:也可以从开发者自定义数据库中读取数据,方便扩展
    NSArray<PLVVodDownloadInfo *> *dbInfos = [[PLVVodDownloadManager sharedManager] requestDownloadCompleteList];
    NSMutableDictionary *dbCachedDics = [[NSMutableDictionary alloc] init];
    [dbInfos enumerateObjectsUsingBlock:^(PLVVodDownloadInfo * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [dbCachedDics setObject:obj forKey:obj.vid];
    }];
    
    // 组装数据
    // 以本地目录数据为准，因为数据库存在损坏的情形，会丢失数据，造成用户已缓存视频无法读取
    [localArray1 enumerateObjectsUsingBlock:^(PLVVodLocalVideo * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        PLVDownloadCompleteInfoModel *model = [[PLVDownloadCompleteInfoModel alloc] init];
        model.localVideo = obj;
        model.downloadInfo = dbCachedDics[obj.vid];
        DownLoadDataBaseModel *data = [DownLoadVideoDataBaseTool selectModeWithVid:obj.vid];
        model.lessonNo = data.lessonNO;
        [arys addObject:model];
//        [self.downloadInfos addObject:model];
        
    }];
    NSSortDescriptor *lessonNO = [NSSortDescriptor sortDescriptorWithKey:@"lessonNo" ascending:YES];
   
    
    self.downloadInfos = [[arys sortedArrayUsingDescriptors:@[lessonNO]] mutableCopy];
 
    if ([BaseTools getCurrentNetworkState] == 0 ) {
        self.downloadVid = [UserDefaultsUtils valueWithKey:[NSString stringWithFormat:@"DownLoadNodeList_%@",[UserDefaultsUtils valueWithKey:@"access_token"]]];
        [self.tableView reloadData];
    }else{
        NSMutableArray *vidAry = [NSMutableArray array];
        for (PLVDownloadCompleteInfoModel *model in self.downloadInfos) {
            [vidAry addObject:model.downloadInfo.vid];
        }
        
        NSMutableDictionary *parmDic = [NSMutableDictionary dictionary];
        [parmDic setObject:self.categoryID forKey:@"course_id"];
        [parmDic setObject:[vidAry componentsJoinedByString:@","] forKey:@"video_id"];
        [ZMNetworkHelper POST:@"/course/check_node_expired" parameters:parmDic cache:YES responseCache:^(id responseCache) {
            
        } success:^(id responseObject) {
            if (responseObject == nil) {
                
            }else{
                if ([responseObject[@"code"] isEqualToString:@"0"]) {
                    
                  
                    [self.downloadVid addObjectsFromArray:responseObject[@"data"]];
                    [UserDefaultsUtils saveValue:self.downloadVid forKey:[NSString stringWithFormat:@"DownLoadNodeList_%@",[UserDefaultsUtils valueWithKey:@"access_token"]]];
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.tableView reloadData];
                        
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



#pragma mark - 点击事件处理
- (void)rightBarButtonItemDidClicked:(UIButton *)sender
{
    sender.selected = !sender.isSelected;
    
    if (sender.isSelected) {
        [_rightBarButtonItem setTitle:@"取消" forState:UIControlStateNormal];
        [_rightBarButtonItem setImage:[UIImage imageNamed:@""] forState:(UIControlStateNormal)];
        // 这个是fix掉:当你左滑删除的时候，再点击右上角编辑按钮， cell上的删除按钮不会消失掉的bug。且必须放在 设置tableView.editing = YES;的前面。
        [self.tableView reloadData];
        
        // 取消
        [self.tableView setEditing:YES animated:NO];
        
        
        // 全选
//        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.leftBarButtonItem];
//        self.leftBarButtonItem.selected = NO;
        
        // show
        self.toolBarView.hidden = NO;
        
    }else{
        [_rightBarButtonItem setTitle:@"" forState:UIControlStateNormal];
        [_rightBarButtonItem setImage:[UIImage imageNamed:@"已完成订单删除图标"] forState:(UIControlStateNormal)];
        // 清空选中栏
        [self.selectedDatas removeAllObjects];
        
        // 编辑
        [self.tableView setEditing:NO animated:NO];
        
        // 返回
//        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.backBarButtonItem];
        
        // hide
        self.toolBarView.hidden = YES;
    }
}
- (void)leftBarButtonItemDidClicked:(UIButton *)sender
{
    sender.selected = !sender.isSelected;
    if (sender.isSelected) {
        
        // 全选
        NSInteger count = self.downloadInfos.count;
        for (NSInteger i = 0 ; i < count; i++)
        {
            NSIndexPath *indexPath = self.downloadInfos[i];
            if (![self.selectedDatas containsObject:indexPath]) {
                [self.selectedDatas addObject:indexPath];
            }
            [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0] animated:YES scrollPosition:UITableViewScrollPositionNone];
            
        }
        
    }else{
        // 取消全选
        NSInteger count = self.downloadInfos.count;
        for (NSInteger i = 0 ; i < count; i++)
        {
            NSIndexPath *indexPath = self.downloadInfos[i];
            if ([self.selectedDatas containsObject:indexPath]) {
                [self.selectedDatas removeObject:indexPath];
                
            }
            [self.tableView deselectRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0] animated:YES];
        }
    }
    
    // 设置状态
    [self _indexPathsForSelectedRowsCountDidChange:self.tableView.indexPathsForSelectedRows];
}

// 弹出框点击确认
- (void)_alertControllerDidConfirmComplete:(void(^)())complete
{
    // 弹出框
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"删除后不可恢复，确定删除吗？" preferredStyle:UIAlertControllerStyleAlert];
    
    // action
    UIAlertAction *leftAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];

    UIAlertAction *rightAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        !complete ? :complete();
        
    }];
    
    
    [alertController addAction:leftAction];
    [alertController addAction:rightAction];
    [self presentViewController:alertController animated:YES completion:nil];
}
- (void)_indexPathsForSelectedRowsCountDidChange:(NSArray *)selectedRows
{
    NSInteger currentCount = [selectedRows count];
    NSInteger allCount = self.downloadInfos.count;
    self.selectAllBtn.selected = (currentCount==allCount);
    NSString *title = (currentCount>0)?[NSString stringWithFormat:@"删除(%zd)",currentCount]:@"删除";
    [self.deleteBtn setTitle:title forState:UIControlStateNormal];
    self.deleteBtn.enabled = currentCount>0;
}
// delete收藏视频
- (void)_deleteSelectIndexPaths:(NSArray *)indexPaths
{
    [self _alertControllerDidConfirmComplete:^{
        for (PLVDownloadCompleteInfoModel *model in self.selectedDatas) {
            PLVVodDownloadManager *downloadManager = [PLVVodDownloadManager sharedManager];
            PLVDownloadCompleteInfoModel *localVideo = model;
            
            [downloadManager removeDownloadWithVid:localVideo.localVideo.vid error:nil];
            [self.downloadInfos removeObject:localVideo];
            
            [DownLoadVideoDataBaseTool deleteVideoWithVid:localVideo.localVideo.vid];
            
            //        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
        // 删除数据源
        [self.downloadInfos removeObjectsInArray:self.selectedDatas];
        [self.selectedDatas removeAllObjects];

        // 删除选中项
        [self.tableView beginUpdates];
        [self.tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
        [self.tableView endUpdates];
        
        // 验证数据源
        [self _indexPathsForSelectedRowsCountDidChange:self.tableView.indexPathsForSelectedRows];
        
        // 验证
        // 没有
        if (self.downloadInfos.count == 0)
        {
            //没有收藏数据
            
            if(self.rightBarButtonItem.selected)
            {
                // 编辑状态 -- 取消编辑状态
                [self rightBarButtonItemDidClicked:self.rightBarButtonItem];
            }
            
            self.rightBarButtonItem.enabled = NO;
            
        }
    }];
}
/** 删除 */
- (void)_deleteBtnDidClicked:(UIButton *)sender
{
    // 删除
    /**
     *  这里删除操作交给自己处理
     */
    [self _deleteSelectIndexPaths:self.tableView.indexPathsForSelectedRows];
    
}
#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger number = self.downloadInfos.count;
    
    return number;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    PLVDownloadComleteCell *cell = [tableView dequeueReusableCellWithIdentifier:[PLVDownloadComleteCell identifier]];
    
    PLVVodDownloadInfo *info = [[self.downloadInfos objectAtIndex:indexPath.row] downloadInfo];
    [DownLoadVideoDataBaseTool initialize];
    DownLoadDataBaseModel *model = [DownLoadVideoDataBaseTool selectModeWithVid:info.vid];
    cell.thumbnailUrl = info.snapshot;
    cell.titleLabel.text = model.title;
    NSInteger filesize = info.filesize;
    
    cell.videoSizeLabel.text = [self.class formatFilesize:filesize];
    cell.videoDurationTime.text = [self.class timeFormatStringWithTime:info.duration];
    
    cell.downloadStateImgView.image = [UIImage imageNamed:@"plv_icon_download_will"];
    
    
    if (self.downloadVid.count == 0) {
        
    }else{
        if ([[self.downloadVid[indexPath.row] valueForKey:@"is_expired"] isEqualToString:@"0"]) {
            cell.isLook.hidden = YES;
        }else{
            cell.isLook.hidden = NO;
        }
    }
    
    
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
}

#pragma mark -- UITableViewDelegate --
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 123;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.isEditing) {
        
        // 获取cell编辑状态选中情况下的所有子控件
        //        NSArray *subViews = [[tableView cellForRowAtIndexPath:indexPath] subviews];
        
        
        NSIndexPath *indexPathM = self.downloadInfos[indexPath.row];
        if (![self.selectedDatas containsObject:indexPathM]) {
            [self.selectedDatas addObject:indexPathM];
        }
        [self _indexPathsForSelectedRowsCountDidChange:tableView.indexPathsForSelectedRows];
        return;
    }
    
    if ([[self.downloadVid[indexPath.row] valueForKey:@"is_expired"] isEqualToString:@"0"]) {
        // 播放本地缓存视频
        PLVVodLocalVideo *localModel = [self.downloadInfos[indexPath.row] localVideo];
        PLVVodDownloadInfo *info = [[self.downloadInfos objectAtIndex:indexPath.row] downloadInfo];
        [DownLoadVideoDataBaseTool initialize];
        DownLoadDataBaseModel *model = [DownLoadVideoDataBaseTool selectModeWithVid:info.vid];
        // 播放本地加密/非加密视频
        PLVSimpleDetailController *detailVC = [[PLVSimpleDetailController alloc] init];
        detailVC.localVideo = localModel;
        detailVC.title = model.title;
        [self.navigationController pushViewController:detailVC animated:YES];
    }else{
        [BaseTools showErrorMessage:@"该课时已失效，请购买后再观看"];
    }

    
    
}


// 取消选中
- (void) tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.isEditing)
    {
        NSIndexPath *indexPathM = self.downloadInfos[indexPath.row];
        if ([self.selectedDatas containsObject:indexPathM]) {
            [self.selectedDatas removeObject:indexPathM];
        }
        
        [self _indexPathsForSelectedRowsCountDidChange:tableView.indexPathsForSelectedRows];
    }
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.isEditing) {
        // 多选
        return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert;
    }else{
        // 删除
        return UITableViewCellEditingStyleDelete;
    }
}

#pragma mark 提交编辑操作
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    //只要实现这个方法，就实现了默认滑动删除！！！！！
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        NSIndexPath *indexPathM = self.downloadInfos[indexPath.row];
        if (![self.selectedDatas containsObject:indexPathM]) {
            [self.selectedDatas addObject:indexPathM];
        }
        [self _deleteSelectIndexPaths:@[indexPath]];
    }
}

#pragma mark 删除按钮中文
-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}


#pragma mark - util

+ (NSString *)formatFilesize:(NSInteger)filesize {
    return [NSByteCountFormatter stringFromByteCount:filesize countStyle:NSByteCountFormatterCountStyleFile];
}

+ (NSString *)timeFormatStringWithTime:(NSTimeInterval )time{

    NSInteger hour = time/60/60;
    NSInteger minite = (time - hour*60*60)/60;
    NSInteger second = (time - hour*60*60 - minite*60);

    NSString *timeStr =[NSString stringWithFormat:@"%02d:%02d:%02d", (int)hour, (int)minite,(int)second];

    return timeStr;
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
