//
//  ZMCusCommentListView.m
//  ZMZX
//
//  Created by Kennith.Zeng on 2018/8/29.
//  Copyright © 2018年 齐家网. All rights reserved.
//

#import "ZMCusCommentListView.h"
#import "PromptCell.h"
#import "ZMCusCommentListTableHeaderView.h"
#import "UIAlertController+TapGesAlertController.h"
#import "SelectDownLoadTypeView.h"
@interface ZMCusCommentListView()<UITableViewDelegate,UITableViewDataSource,promptCellDelegate>{}

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) ZMCusCommentListTableHeaderView *headerView;
@property (assign, nonatomic) NSIndexPath *selectedIndexPath;//单选，当前选中的行
@property (nonatomic , strong) NSMutableArray *dataAry;
/** 选中的数据 */
@property (nonatomic , strong) NSMutableArray *selectedDatas;
/** 删除 */
@property (nonatomic , strong) UIButton *downLoadBtn;
/** 全选按钮 */
@property (nonatomic , strong) UIButton *selectAllBtn;
/** 底部toolBar */
@property (nonatomic , strong) UIView *toolBarView;
@property (nonatomic , strong) NSString *type;
@end


@implementation ZMCusCommentListView

- (instancetype)initWithFrame:(CGRect)frame{
    
    if ([super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 15;

        [self layoutUI];
       
        
    }
    return self;
}
-(void)setVideoInfo:(NSDictionary *)videoInfo{
    _videoInfo = videoInfo;
    NSMutableDictionary *parmDic = [NSMutableDictionary dictionary];
    [parmDic setObject:videoInfo[@"id"] forKey:@"course_id"];
    [ZMNetworkHelper POST:@"/course/download_lesson_list" parameters:parmDic cache:YES responseCache:^(id responseCache) {
        
    } success:^(id responseObject) {
        if (responseObject == nil) {
            
        }else{
            if ([responseObject[@"code"] isEqualToString:@"0"]) {
                [self dataAnalysis:responseObject];
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


#pragma mark —————  请求到的数据进行解析  --———
- (void)dataAnalysis:(id)data{
    
//    MyOrderModel *model = [[MyOrderModel alloc]initWithDictionary:data error:nil];
    [self.dataAry addObjectsFromArray:data[@"data"]];
    
    //通知主线程刷新
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
    
    
}
- (NSMutableArray *)selectedDatas
{
    if (_selectedDatas == nil) {
        _selectedDatas = [[NSMutableArray alloc] init];
    }
    return _selectedDatas;
}
- (NSMutableArray *)dataAry
{
    if (_dataAry == nil) {
        _dataAry = [[NSMutableArray alloc] init];
    }
    return _dataAry;
}



- (UIButton *)downLoadBtn
{
    if (_downLoadBtn == nil) {
        
        _downLoadBtn = [[UIButton alloc] initWithFrame:CGRectMake(screenWidth()/2,1, screenWidth()/2, 49)];
        [_downLoadBtn setTitle:@"下载" forState:UIControlStateNormal];
        _downLoadBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        _downLoadBtn.adjustsImageWhenHighlighted = NO;
        [_downLoadBtn setBackgroundColor:[UIColor colorWithHexString:@"#F39094"]];
        [_downLoadBtn addTarget:self action:@selector(_downloadBtnDidClicked:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _downLoadBtn;
}
- (UIButton *)selectAllBtn
{
    if (_selectAllBtn == nil) {
        
        _selectAllBtn = [[UIButton alloc] initWithFrame:CGRectMake(0,1, screenWidth()/2, 49)];
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
- (void)layoutUI{
    
    if (!_headerView) {
        _headerView = [[ZMCusCommentListTableHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
       
        @weakify(self)
        _headerView.closeBtnBlock = ^{
            @strongify(self)
            if (self.closeBtnBlock) {
                self.closeBtnBlock();
            }
        };
        [self addSubview:_headerView];
        self.headerView.type = @"高清";
        self.type =@"高清";
        __weak typeof(self) weakSelf = self;
        _headerView.selectTypeBtnBlock = ^{
            __strong typeof(self) strongSelf = weakSelf;//第一层
            NSArray *payTypeArr = @[@{@"pic":@"pic_alipay",
                                      @"title":@"标清",
                                      @"type":@"alipay"},
                                    @{@"pic":@"pic_wxpay",
                                      @"title":@"高清",
                                      @"type":@"wxpay"},
                                    @{@"pic":@"pic_blance",
                                      @"title":@"超清",
                                      @"type":@"balance"}];
            
            SelectDownLoadTypeView *pop = [[SelectDownLoadTypeView alloc]initTovc:[[AppDelegate shareAppDelegate] getCurrentUIVC] dataSource:payTypeArr downLoadType:weakSelf.type];
//            pop.downLoadType = weakSelf.type;
            STPopupController *popVericodeController = [[STPopupController alloc] initWithRootViewController:pop];
            popVericodeController.style = STPopupStyleBottomSheet;
            [popVericodeController presentInViewController:[[AppDelegate shareAppDelegate] getCurrentUIVC]];
            
            __weak typeof(self) weakSelf2 = strongSelf;
            pop.payType = ^(NSString *type,NSString *balance) {
                 __strong typeof(self) strongSelf2 = weakSelf2;//第二层
                strongSelf2.headerView.type = type;
                strongSelf2.type = type;
            };
            
        };
        [_headerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(0);
            make.left.and.right.mas_equalTo(0);
            make.height.mas_offset(50);
        }];
    }


    
    
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator=NO;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.tableFooterView = [UIView new];
        _tableView.estimatedRowHeight = 10000;
        [self.tableView setEditing:YES animated:NO];
        // 编辑模式下多选
        _tableView.allowsMultipleSelectionDuringEditing = true;
        
        [_tableView registerNib:[UINib nibWithNibName:@"PromptCell" bundle:nil] forCellReuseIdentifier:@"PromptCell"];
        [self addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsMake(50,0, 50, 0));
        }];
    }
     _toolBarView.frame = CGRectMake(0,self.frame.size.height-50, screenWidth(), 50);
    [self addSubview:self.toolBarView];

    if (_toolBarView == nil) {
        _toolBarView = [[UIView alloc]initWithFrame:CGRectMake(0,self.frame.size.height-50, screenWidth(), 50)];
        [self.toolBarView addSubview:self.selectAllBtn];
        [self.toolBarView addSubview:self.downLoadBtn];
        [self addSubview:_toolBarView];
        
        UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, screenWidth(), 1)];
        line.backgroundColor = CBackgroundColor;
        [self.toolBarView addSubview:line];
        
        
        [_toolBarView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(0);
            make.left.and.right.mas_equalTo(0);
            make.height.mas_offset(50);
        }];
        
    }

    
//    [self.toolBarView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.mas_equalTo(0);
//        make.left.and.right.mas_equalTo(0);
//        make.height.mas_offset(50);
//    }];
//    NSLog(@"%@",self.toolBarView);
}



#pragma mark -
#pragma mark UITableViewDataSource, UITableViewDelegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataAry.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PromptCell * cell = [tableView dequeueReusableCellWithIdentifier:@"PromptCell"];
    if (!cell) {
        cell = [[PromptCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"PromptCell"];
        
    }
    
//    cell.selectionStyle=UITableViewCellSelectionStyleNone;  这个多选状态下必须注释掉，否则不现实选中样式
    cell.delegate=self;
    cell.titleLab.text = [NSString stringWithFormat:@"课时%@·%@",self.dataAry[indexPath.row][@"number"],self.dataAry[indexPath.row][@"title"]];
    
    return cell;

}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{

        // 多选
        return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert;

}

- (void)_indexPathsForSelectedRowsCountDidChange:(NSArray *)selectedRows
{
    NSInteger currentCount = [selectedRows count];
    NSInteger allCount = self.dataAry.count;
    self.selectAllBtn.selected = (currentCount==allCount);
    NSString *title = (currentCount>0)?[NSString stringWithFormat:@"下载(%zd)",currentCount]:@"下载";
    [self.downLoadBtn setTitle:title forState:UIControlStateNormal];
    UIColor *color =(currentCount>0)? CNavBgColor:[UIColor colorWithHexString:@"#F39094"];
    self.downLoadBtn.backgroundColor = color;
    self.downLoadBtn.enabled = currentCount>0;
}
- (void)leftBarButtonItemDidClicked:(UIButton *)sender
{
    sender.selected = !sender.isSelected;
    if (sender.isSelected) {
        
        // 全选
        NSInteger count = self.dataAry.count;
        for (NSInteger i = 0 ; i < count; i++)
        {
            NSIndexPath *indexPath = self.dataAry[i];
            if (![self.selectedDatas containsObject:indexPath]) {
                [self.selectedDatas addObject:indexPath];
            }
            [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0] animated:YES scrollPosition:UITableViewScrollPositionNone];
            
        }
        
    }else{
        // 取消全选
        NSInteger count = self.dataAry.count;
        for (NSInteger i = 0 ; i < count; i++)
        {
            NSIndexPath *indexPath = self.dataAry[i];
            if ([self.selectedDatas containsObject:indexPath]) {
                [self.selectedDatas removeObject:indexPath];
                
            }
            [self.tableView deselectRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0] animated:YES];
        }
    }
    
    // 设置状态
    [self _indexPathsForSelectedRowsCountDidChange:self.tableView.indexPathsForSelectedRows];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.isEditing) {
        
        // 获取cell编辑状态选中情况下的所有子控件
        //        NSArray *subViews = [[tableView cellForRowAtIndexPath:indexPath] subviews];
        
        
        NSIndexPath *indexPathM = self.dataAry[indexPath.row];
        if (![self.selectedDatas containsObject:indexPathM]) {
            [self.selectedDatas addObject:indexPathM];
        }
        [self _indexPathsForSelectedRowsCountDidChange:tableView.indexPathsForSelectedRows];
        return;
    }
    
}
// 取消选中
- (void) tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.isEditing)
    {
        NSIndexPath *indexPathM = self.dataAry[indexPath.row];
        if ([self.selectedDatas containsObject:indexPathM]) {
            [self.selectedDatas removeObject:indexPathM];
        }
        
        [self _indexPathsForSelectedRowsCountDidChange:tableView.indexPathsForSelectedRows];
    }
}
// delete收藏视频
- (void)_downLoadSelectIndexPaths:(NSArray *)indexPaths
{
   
    if ([[UserDefaultsUtils valueWithKey:@"access_token"] length] != 0) {
        if ([BaseTools getCurrentNetworkState] == 1 ) {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"当前为非wifi环境，播放将消耗流量，确定下载吗？" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *actionOne = [UIAlertAction actionWithTitle:@"继续下载" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                [self downloadVideo];
                
            }];
            UIAlertAction *actionTwo = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            [alertController addAction:actionOne];
            [alertController addAction:actionTwo];
            
            [[[AppDelegate shareAppDelegate] getCurrentUIVC].navigationController presentViewController:alertController animated:YES completion:nil];
            
        }else{
            [self downloadVideo];
        }
    }else{
        [BaseTools showErrorMessage:@"请登录后再操作"];
        
    }
//
//        for (NSDictionary *model in self.selectedDatas) {
//
//        }
//        // 删除数据源
//
//        [self.selectedDatas removeAllObjects];
//
//        // 删除选中项
//        [self.tableView beginUpdates];
//        [self.tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
//        [self.tableView endUpdates];
//
//        // 验证数据源
//        [self _indexPathsForSelectedRowsCountDidChange:self.tableView.indexPathsForSelectedRows];

}
-(void)downloadVideo{
    
   
    [BaseTools showErrorMessage:@"视频已经加入下载队列"];
    for (NSDictionary *dic in self.selectedDatas) {
        PLVVodDownloadManager *downloadManager = [PLVVodDownloadManager sharedManager];
        [PLVVodVideo requestVideoWithVid:dic[@"video_id"] completion:^(PLVVodVideo *video, NSError *error) {
            if (video) {
          
                if ([self.type isEqualToString:@"标清"]) {
                    PLVVodDownloadInfo *info = [downloadManager downloadVideo:video quality:(PLVVodQualityStandard)];
                }else if ([self.type isEqualToString:@"超清"]){
                    PLVVodDownloadInfo *info = [downloadManager downloadVideo:video quality:(PLVVodQualityUltra)];
                }else if ([self.type isEqualToString:@"高清"]){
                    PLVVodDownloadInfo *info = [downloadManager downloadVideo:video quality:(PLVVodQualityHigh)];
                }
                
                
                [downloadManager startDownload];
                [DownLoadVideoDataBaseTool initialize];
                if ([DownLoadVideoDataBaseTool selectVideoWithCategoryID:self.videoInfo[@"id"] andVid:dic[@"video_id"]].count !=0 ) {
                    
                }else{
                    DownLoadDataBaseModel *video = [[DownLoadDataBaseModel alloc]init];
                    video.vid = dic[@"video_id"];
                    video.title = [NSString stringWithFormat:@"课时%@·%@",dic[@"number"],dic[@"title"]];
                    video.videoImage = self.videoInfo[@"img"];
                    video.videoCount = self.videoInfo[@"lesson_num"];
                    video.categoryId =  self.videoInfo[@"id"];
                    video.categoryName = self.videoInfo[@"title"];
                    video.lessonNO = dic[@"number"];
                    [DownLoadVideoDataBaseTool addVideo:video];
                }
                
            }
        }];

    }

//    if ([PLVVodDownloadManager videoExist:self.videoInfo.vid] != 0) {
//        [BaseTools showErrorMessage:@"该课程已存在"];
//    }else{
//        PLVVodDownloadManager *downloadManager = [PLVVodDownloadManager sharedManager];
//
//        PLVVodDownloadInfo *info = [downloadManager downloadVideo:self.videos quality:type];
//
//        [BaseTools showErrorMessage:@"视频已经加入下载队列"];
//
//        [downloadManager startDownload];
//        [DownLoadVideoDataBaseTool initialize];
//        if ([DownLoadVideoDataBaseTool selectVideoWithCategoryID:self.videoInfo[@"id"] andVid:self.videos.vid].count !=0 ) {
//
//        }else{
//            DownLoadDataBaseModel *video = [[DownLoadDataBaseModel alloc]init];
//            video.vid = self.videos.vid;
//            video.title = [NSString stringWithFormat:@"课时%@·%@",self.lessonInfo[@"number"],self.lessonInfo[@"title"]];
//            video.videoImage = self.videoInfo[@"img"];
//            video.videoCount = self.videoInfo[@"lesson_num"];
//            video.categoryId =  self.videoInfo[@"id"];
//            video.categoryName = self.videoInfo[@"title"];
//            video.lessonNO = self.lessonInfo[@"number"];
//            [DownLoadVideoDataBaseTool addVideo:video];
//        }
//    }
}



/** 下载 */
- (void)_downloadBtnDidClicked:(UIButton *)sender
{
    // 下载
    /**
     *  这里下载操作交给自己处理
     */
    [self _downLoadSelectIndexPaths:self.tableView.indexPathsForSelectedRows];
    
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

@end
