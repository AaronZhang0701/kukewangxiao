//
//  MyLearningRecordViewController.m
//  KukeApp
//
//  Created by 库课 on 2018/12/20.
//  Copyright © 2018 zhangming. All rights reserved.
//

#import "MyLearningRecordViewController.h"
#import "MyLearningRecordCatalogModel.h"
#import "PLVVodSkinPlayerController.h"
#import "TIDeliveryView.h"
#import "PayMentViewController.h"
#import "ZMCusCommentView.h"
@interface MyLearningRecordViewController ()<YBPopupMenuDelegate>{
    UIImageView *pic;
    UILabel *titleLab;
    UIImageView *arrowPic;
    UILabel *timeLab;
    UILabel *progressLab;
    UILabel *isSeekLab;
    YLImageView* imageView;
    BOOL isClick;
    UIButton *downLoadBtn;
    UIButton *downLoadDocBtn;
    NSString *docUrl;

}
@property (strong, nonatomic) UIView *headerView;//header

@property (strong, nonatomic) UIViewController *viewC;

@property (nonatomic, strong) PLVVodSkinPlayerController *player;//播放器

@property (strong, nonatomic) UIView *playerPlaceholder;//播放器占位view

@property (nonatomic, strong) UIImageView *images;//未播放时播放器上的的占位图片

@property (nonatomic, strong) UIButton *playBtn;

@property (nonatomic, strong) UILabel *titleLabs;

@property (strong, nonatomic) NSMutableArray *countArray;

@property (nonatomic , strong) NSMutableArray *data;//传递过来已经组织好的数据（全量数据）

@property (nonatomic , strong) NSMutableArray *tempData;//用于存储数据源（部分数据）

@property (assign, nonatomic) NSIndexPath *selIndex;//单选，当前选中的行

@property (nonatomic,assign) BOOL isSel;

@property (nonatomic, strong) NSMutableArray *reloadArray;

@property (nonatomic, assign ,getter=isPreservation) BOOL preservation;

@property (strong, nonatomic) UIView *navView;//header
@property (nonatomic, copy) NSString *rootID;
@property (nonatomic, strong) NSString *nextLesson;
@property (nonatomic,assign) CGFloat offset;
@property (nonatomic, strong) NSDictionary *lessonInfo;

@property (nonatomic, strong) UIButton *menuBtn;
@property (nonatomic, strong) UIButton *backBtn;
@property (nonatomic, strong) UIButton *shareBtn;

@property (nonatomic, copy) NSString *clickLiveID;//点击时获取的id
@property (nonatomic, strong) NSString *play_id;//真正在播放的id
@property (nonatomic, strong) UIView *rootView1;

@property (nonatomic,assign) BOOL isLiving;
@end

@implementation MyLearningRecordViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
//    [self.rootView1 addSubview:self.shareBtn];
//    [self.rootView1 addSubview:self.menuBtn];
//    [self.rootView1 addSubview:self.backBtn];
//    [self.view insertSubview:self.shareBtn atIndex:100];
//    [self.view insertSubview:self.menuBtn atIndex:100];
//    [self.view insertSubview:self.backBtn atIndex:100];
//    _backBtn.hidden = NO;
//    _shareBtn.hidden = NO;
//    _menuBtn.hidden = NO;
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
//    [_backBtn removeFromSuperview];
//    [_shareBtn removeFromSuperview];
//    [_menuBtn removeFromSuperview];
    if (self.player) {
        [self postPlayTime];
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    isClick = NO;
    _rootID = @"";
//    AppDelegate * appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
//    //允许转成横屏
//    appDelegate.allowRotation = YES;
//    //调用横屏代码
//    [UIDevice switchNewOrientation:UIInterfaceOrientationLandscapeRight];
    
    self.view.backgroundColor = [UIColor blackColor];
    id traget = self.navigationController.interactivePopGestureRecognizer.delegate;
    UIPanGestureRecognizer * pan = [[UIPanGestureRecognizer alloc]initWithTarget:traget action:nil];
    [self.view addGestureRecognizer:pan];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hiddenBtn:) name:@"HiddenBackAndShareButton" object:nil];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(navUI) name:@"CloseLive" object:nil];
    self.countArray = [NSMutableArray array];
    _reloadArray = [NSMutableArray array];
    _tempData = [NSMutableArray array];
    self.preservation = YES;
    [self initPlayerPlaceholder];
    self.tableView.frame = CGRectMake(0, ZM_StatusBarHeight, KScreenWidth, screenHeight()-ZM_StatusBarHeight);
    [self loadData];
 
    if (self.continueLearningID.length != 0) {
        if ([self.living isEqualToString:@"2"]) {
            self.clickLiveID = @"";
            if (self.isLive) {
                self.isLiving = YES;
            }else{
                self.isLiving = NO;
            }
            [self playButtonClick];
        }else{
            self.clickLiveID = self.continueLearningID;
            [self playButtonClick];
        }
        
        

    }
    // 在合适的地方，放置此代码，注册监听
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(handleStatusBarOrientationChange:)
                                                name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
    
   
//    self.rootView1 = [[UIApplication sharedApplication] keyWindow];
//    [self.rootView1 addSubview:self.shareBtn];
//    [self.rootView1 addSubview:self.menuBtn];
//    [self.rootView1 addSubview:self.backBtn];
    [self.view insertSubview:self.shareBtn atIndex:100];
    [self.view insertSubview:self.menuBtn atIndex:100];
    [self.view insertSubview:self.backBtn atIndex:100];
    _backBtn.hidden = NO;
    _shareBtn.hidden = NO;
    _menuBtn.hidden = NO;
    
    
}

#pragma mark - 点击背景刷新时执行
- (void)noDataBeginRefresh {
    [self lq_endLoading];
    [self loadData];
}
- (void)navUI{
    [self.view insertSubview:self.shareBtn atIndex:100];
    [self.view insertSubview:self.menuBtn atIndex:100];
    [self.view insertSubview:self.backBtn atIndex:100];
//    [self.rootView1 addSubview:self.shareBtn];
//    [self.rootView1 addSubview:self.menuBtn];
//    [self.rootView1 addSubview:self.backBtn];

}

- (UIButton *)shareBtn{
    if (!_shareBtn) {
        _shareBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        if (kIsiPhoneX) {
            _shareBtn.frame = CGRectMake(screenWidth()-80, 40, 30, 30);
        }else{
            _shareBtn.frame = CGRectMake(screenWidth()-80, 30, 30, 30);
        }
        
        [_shareBtn addTarget:self action:@selector(sharedButtonClick:) forControlEvents:(UIControlEventTouchUpInside)];
        [_shareBtn setImage:[UIImage imageNamed:@"详情页分享按钮"] forState:(UIControlStateNormal)];
    }
    return  _shareBtn;
}
- (UIButton *)backBtn{
    if (!_backBtn) {
        _backBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        if (kIsiPhoneX) {
            _backBtn.frame = CGRectMake(10, 40, 30, 30);
        }else{
            _backBtn.frame = CGRectMake(10, 30, 30, 30);
        }
        
        [_backBtn setImage:[UIImage imageNamed:@"详情页返回按钮"] forState:(UIControlStateNormal)];
        [_backBtn addTarget:self action:@selector(backView) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _backBtn;
}
- (UIButton *)menuBtn{
    if (!_menuBtn) {
        _menuBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        
        if (kIsiPhoneX) {
            _menuBtn.frame = CGRectMake(screenWidth()-40, 40, 30, 30);
        }else{
            _menuBtn.frame = CGRectMake(screenWidth()-40, 30, 30, 30);
        }
        [_menuBtn addTarget:self action:@selector(menuAction:) forControlEvents:(UIControlEventTouchUpInside)];
        [_menuBtn setImage:[UIImage imageNamed:@"菜单按钮"] forState:(UIControlStateNormal)];
    }
    return _menuBtn;
}
- (void)hiddenBtn:(NSNotification *)noti
{
    
    BOOL isHidden = [noti.object[@"isShowing"] boolValue];
    
    if (self.player.fullscreen) {
        
    }else{
        _backBtn.hidden = isHidden;
        _shareBtn.hidden = isHidden;
        _menuBtn.hidden = isHidden;
    }
    
}
- (void)backView{
    if (self.player) {
        [self postPlayTime];
    }
    [self.player destroyPlayer];
//    _shareBtn.hidden = YES;
//    _backBtn.hidden = YES;
//    _menuBtn.hidden = YES;
    [self.navigationController popViewControllerAnimated:YES];
//    [_backBtn removeFromSuperview];
//    [_shareBtn removeFromSuperview];
//    [_menuBtn removeFromSuperview];
}

#pragma mark - 创建tableview的头部
- (void)initPlayerPlaceholder{
    
    
    self.headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenWidth(), SCREEN_WIDTH/16*9+50)];
    self.headerView.backgroundColor = [UIColor whiteColor];
    
    self.navigationController.navigationBar.translucent = false;
    self.playerPlaceholder = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH/16*9)];
    [self.headerView addSubview:self.playerPlaceholder];
    
    
    UIViewController * viewC = [[UIViewController alloc]init];
    [self addChildViewController:viewC];
    [self.playerPlaceholder addSubview:viewC.view];
    viewC.view.frame = self.playerPlaceholder.bounds;
    self.viewC = viewC;
    
    self.images = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH/16*9)];
    [self.images sd_setImageWithURL:[NSURL URLWithString:self.imageUrl] placeholderImage:[UIImage imageNamed:@"coursesDedault"]];
    self.images.userInteractionEnabled = YES;
    self.images.contentMode=UIViewContentModeScaleAspectFill;
    self.images.clipsToBounds=YES;//  是否剪切掉超出 UIImageView 范围的图片
    [self.images setContentScaleFactor:[[UIScreen mainScreen] scale]];
    [self.playerPlaceholder addSubview:self.images];
    
    
    _playBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    _playBtn.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH/16*9);
    _playBtn.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    [_playBtn setImage:[UIImage imageNamed:@"播放(1)"] forState:(UIControlStateNormal)];
    [_playBtn addTarget:self action:@selector(playButtonClick) forControlEvents:(UIControlEventTouchUpInside)];
    [self.images addSubview:_playBtn];
    
    
    self.titleLabs = [[UILabel alloc]initWithFrame:CGRectMake(0, maxY(self.images), screenWidth(), 50)];
    self.titleLabs.text = @"大纲";
    self.titleLabs.backgroundColor = [UIColor whiteColor];
    self.titleLabs.textAlignment = NSTextAlignmentCenter;
    self.titleLabs.font = [UIFont systemFontOfSize:15];
    [self.headerView addSubview:self.titleLabs];
 
    [self downLoadDocAction];
    if (!self.isLive) {
        downLoadBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        downLoadBtn.frame = CGRectMake(screenWidth()-50, maxY(self.images), 50, 50);
        [downLoadBtn setImage:[UIImage imageNamed:@"xiazai (1)"] forState:(UIControlStateNormal)];
        [downLoadBtn addTarget:self action:@selector(downLoadAction) forControlEvents:(UIControlEventTouchUpInside)];
        [self.headerView addSubview:downLoadBtn];
        
        downLoadDocBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        downLoadDocBtn.frame = CGRectMake(32, maxY(self.images)+17, 60, 22);
        [downLoadDocBtn setImage:[UIImage imageNamed:@"下载讲义-icon"] forState:(UIControlStateNormal)];
        [downLoadDocBtn setTitle:@"讲义" forState:(UIControlStateNormal)];
        downLoadDocBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [downLoadDocBtn setTitleColor:CTitleColor forState:(UIControlStateNormal)];
        downLoadDocBtn.backgroundColor = [UIColor colorWithHexString:@"#F4F4F4"];
        downLoadDocBtn.layer.cornerRadius = 11;
        downLoadDocBtn.layer.masksToBounds = YES;
        downLoadDocBtn.hidden  = YES;
        [downLoadDocBtn br_layoutButtonWithEdgeInsetsStyle:(BRButtonEdgeInsetsStyleLeft) imageTitleSpace:5];
        [downLoadDocBtn addTarget:self action:@selector(downLoadDoc) forControlEvents:(UIControlEventTouchUpInside)];
        [self.headerView addSubview:downLoadDocBtn];
    }
    
   
    
    // 阴影颜色
    self.headerView.layer.shadowColor = [[UIColor blackColor] CGColor];
    // 阴影偏移，默认(0, -3)
    self.headerView.layer.shadowOffset = CGSizeMake(0,0);
    // 阴影透明度，默认0
    self.headerView.layer.shadowOpacity = 0.3;
    // 阴影半径，默认3
    self.headerView.layer.shadowRadius = 3;
    
 
}
- (void)downLoadAction{
    NSDictionary *newDictionary=@{@"img":self.imageUrl,@"lesson_num":self.course_lesson_num,@"id":_course_id,@"title":self.course_name};

    [[ZMCusCommentManager shareManager] showCommentWithVideoInfo:newDictionary];
}

#pragma mark - 初始化播放器
-(void)setUpPlayer{
    

    self.images.hidden = YES;
    PLVVodSkinPlayerController *player = [[PLVVodSkinPlayerController alloc] initWithNibName:nil bundle:nil];
    player.is_hideNav = @"1";

    NSDictionary *newDictionary=@{@"img":self.imageUrl,@"lesson_num":self.course_lesson_num,@"id":_course_id,@"title":self.course_name};
    player.videoInfo = newDictionary;
    [player addPlayerOnPlaceholderView:self.viewC.view rootViewController:self.viewC];
    player.rememberLastPosition = YES;
     __weak typeof(self) weakSelf = self;
    //播放完成监听
    player.reachEndHandler = ^(PLVVodPlayerViewController *player) {
        [weakSelf postPlayTime];
        if ([weakSelf.nextLesson isEqualToString:@"0"]) {
            if (self.isLive) {
                [BaseTools showErrorMessage:@"课程已播放完毕"];
            }else{
                [BaseTools showErrorMessage:@"免费课程已播放完毕"];
            }
            weakSelf.backBtn.hidden = NO;
            weakSelf.shareBtn.hidden = NO;
            weakSelf.menuBtn.hidden = NO;
        }else{
            weakSelf.clickLiveID = weakSelf.nextLesson;
         
            if (![CoreStatus isNetworkEnable]) {
                [BaseTools showErrorMessage:@"无法连接到网络"];
            }else{
                [weakSelf getVid];
            }
        }
        
    };
    // 为保证封面图正常回收，需调用一次该Block
    player.playbackStateHandler = ^(PLVVodPlayerViewController *player) {

        if (player.playbackState == PLVVodPlaybackStatePlaying) {
            weakSelf.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
            [weakSelf.tableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:NO];
            weakSelf.images.hidden = YES;
            weakSelf.navView.hidden = YES;
            [weakSelf.backBtn setImage:[UIImage imageNamed:@"详情页返回按钮"] forState:(UIControlStateNormal)];
            [weakSelf.shareBtn setImage:[UIImage imageNamed:@"详情页分享按钮"] forState:(UIControlStateNormal)];
            [weakSelf.menuBtn setImage:[UIImage imageNamed:@"菜单按钮"] forState:(UIControlStateNormal)];
           
        }
        [weakSelf.tableView reloadData];
    };
    self.player = player;
    self.navView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenWidth(),  SCREEN_WIDTH/16*9)];
    self.navView.backgroundColor = [UIColor whiteColor];
    self.navView.hidden = YES;
    [self.player.view addSubview:self.navView];
}

#pragma mark - 获取目录数据
- (void)loadData{
    
    if (self.isLive) {
        NSMutableDictionary *parmDic = [NSMutableDictionary dictionary];
        [parmDic setObject:self.course_id forKey:@"live_id"];
        BADataEntity *entity = [BADataEntity new];
        entity.urlString = @"/live/nodes";
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
        } failureBlock:^(NSError *error) {
            [self setEmptyViewDelegeta];
        } progressBlock:^(int64_t bytesProgress, int64_t totalBytesProgress) {
            /*! 封装方法里已经回到主线程，所有这里不用再调主线程了 */
            
        }];
    }else{
        NSMutableDictionary *parmDic = [NSMutableDictionary dictionary];
        
        [parmDic setObject:self.course_id forKey:@"course_id"];
        BADataEntity *entity = [BADataEntity new];
        entity.urlString = @"/course/nodes";
        entity.needCache = NO;
        entity.parameters = parmDic;
        if (![CoreStatus isNetworkEnable]) {
            [self lq_showFailLoadWithType:(LQTableViewFailLoadViewTypeNoData) tipsString:@"无法连接到网络,点击页面刷新"];
            return;
        }else{

//            self.tableView.loading = YES;
        }
//
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
        } failureBlock:^(NSError *error) {
            [self setEmptyViewDelegeta];
        } progressBlock:^(int64_t bytesProgress, int64_t totalBytesProgress) {
            /*! 封装方法里已经回到主线程，所有这里不用再调主线程了 */
            
        }];
    }
    
    
}
#pragma mark - 开始播放

- (void)playButtonClick{

    if ([BaseTools getCurrentNetworkState] == 1 ) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"当前为非wifi环境，播放将消耗流量，确定播放吗？" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *actionOne = [UIAlertAction actionWithTitle:@"继续播放" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            if (![CoreStatus isNetworkEnable]) {
                [BaseTools showErrorMessage:@"无法连接到网络"];
            }else{
                [self getVid];
            }
            
        }];
        UIAlertAction *actionTwo = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
 
        }];
        [alertController addAction:actionOne];
        [alertController addAction:actionTwo];
        
        [self presentViewController:alertController animated:YES completion:nil];
        
    }else{
        if (![CoreStatus isNetworkEnable]) {
            [BaseTools showErrorMessage:@"无法连接到网络"];
        }else{
            [self getVid];
        }
    }
    
}
- (void)getVid{
    
    if (self.isLive) {

        NSMutableDictionary *parmDic = [NSMutableDictionary dictionary];
        [parmDic setObject:self.clickLiveID forKey:@"id"];
        [parmDic setObject:self.course_id forKey:@"live_id"];//只传课程返回第一节，课程和课时都传是学习记录，用于没播放过的课程
        [ZMNetworkHelper POST:@"/live/lesson" parameters:parmDic cache:YES responseCache:^(id responseCache) {
            
        } success:^(id responseObject) {
            if (responseObject == nil) {
                
            }else{
                if ([responseObject[@"code"] isEqualToString:@"0"]) {
                    
                    if ([responseObject[@"data"][@"view_type"] isEqualToString:@"1"]) {//点播
                        self.nextLesson = responseObject[@"data"][@"next_node"];
                        
                        dispatch_async(dispatch_get_main_queue(), ^{

                            if (self.isLiving) {//直播中
                                self.play_id = responseObject[@"data"][@"id"];
                                [self.tableView reloadData];
                            }else{
                                if (self.player) {
                                    
                                }else{
                                    self.course_lesson_num = responseObject[@"data"][@"course_lesson_num"];
                                    [self setUpPlayer];
                                }
                                self.player.lessonInfo = responseObject[@"data"];
                                [PLVVodVideo requestVideoWithVid:responseObject[@"data"][@"video_id"] completion:^(PLVVodVideo *video, NSError *error) {
                                    if (video) {
                                        self.player.video = video;
                                        
                                    }
                                }];
                                self.play_id = responseObject[@"data"][@"id"];
                            }
                            
                            
                            isClick = NO;
//                            [self.tableView reloadData];
                        });
                    }else{//直播
                         dispatch_async(dispatch_get_main_queue(), ^{
                             [self.player pause];
                       
                             if (self.isLiving) {
                                 self.play_id = responseObject[@"data"][@"id"];
                                 [self.tableView reloadData];
                             }else{
//                                 [_backBtn removeFromSuperview];
//                                 [_shareBtn removeFromSuperview];
//                                 [_menuBtn removeFromSuperview];
                                 [PolyvLiveOrVodPlayerManager zm_verifyPermissionWithChannelId:responseObject[@"data"][@"live_channel_id"] vid:@"" playerType:@"Live" ToPlayerFromViewController:[[AppDelegate shareAppDelegate] getCurrentUIVC] dataSource:responseObject[@"data"]];
                                 self.play_id = responseObject[@"data"][@"id"];
                                 self.isLiving = NO;
                                 [self.tableView reloadData];
                             }
                         });
                    }
                }else if ([responseObject[@"code"] isEqualToString:@"-10000"]){
                    [BaseTools showErrorMessage:@"请登录后再操作"];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        [BaseTools alertLoginWithVC:self];
                    });
                }else{
                    
                    [BaseTools showErrorMessage:responseObject[@"msg"]];
//                    self.play_id = @"-1010";
//                    [self.tableView reloadData];
                }
            }
        } failure:^(NSError *error) {
            
        }];
    }else{
        NSMutableDictionary *parmDic = [NSMutableDictionary dictionary];
        [parmDic setObject:self.clickLiveID forKey:@"id"];
        [parmDic setObject:self.course_id forKey:@"course_id"];
        [ZMNetworkHelper POST:@"/course/lesson" parameters:parmDic cache:YES responseCache:^(id responseCache) {
            
        } success:^(id responseObject) {
            if (responseObject == nil) {
                
            }else{
                if ([responseObject[@"code"] isEqualToString:@"0"]) {
                    self.nextLesson = responseObject[@"data"][@"next_node"];
    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (self.player) {
                            
                        }else{
                            self.course_lesson_num = responseObject[@"data"][@"course_lesson_num"];
                            [self setUpPlayer];
                        }
                        self.player.lessonInfo = responseObject[@"data"];
//                        self.lessonInfo = responseObject[@"data"];
                        
//                        if (self.play_id.length == 0) {
                            self.play_id = responseObject[@"data"][@"id"];
//                        }
                        [PLVVodVideo requestVideoWithVid:responseObject[@"data"][@"video_id"] completion:^(PLVVodVideo *video, NSError *error) {
                            if (video) {
                                self.player.video = video;
                                
                            }
                        }];
                        isClick = NO;
//                        [self.tableView reloadData];
                    });
                    
                }else if ([responseObject[@"code"] isEqualToString:@"-10000"]){
                    [BaseTools showErrorMessage:@"请登录后再操作"];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        [BaseTools alertLoginWithVC:self];
                    });
                }else{
                    [BaseTools showErrorMessage:responseObject[@"msg"]];
//                    self.play_id = @"-1010";
//                    [self.tableView reloadData];
                }
            }
        } failure:^(NSError *error) {
            
        }];
    }

}


#pragma mark —————  请求到的数据进行解析  --———
- (void)dataAnalysis:(id)data{

    self.data= [NSMutableArray array];
    [self.countArray addObjectsFromArray:data[@"data"]];
    for (int i = 0 ; i<self.countArray.count; i++) {
        NSDictionary  *dict = self.countArray[i];
        BOOL isExpand = [dict[@"node"][@"is_open"] boolValue];
        MyLearningRecordCatalogModel *chapter = [[MyLearningRecordCatalogModel alloc] initWithParentId:@"" nodeId:[NSString stringWithFormat:@"%d",i] name:dict[@"node"][@"title"] depth:@"1" expand:isExpand dict:dict[@"node"]];
        [self.data addObject:chapter];
        
        for (int j = 0; j<[dict[@"children"] count]; j++) {
            
            NSDictionary  *dict1 = dict[@"children"][j];
            
            if ([dict1[@"children"] count] !=0) {
                MyLearningRecordCatalogModel *part= [[MyLearningRecordCatalogModel alloc] initWithParentId:[NSString stringWithFormat:@"%d",i] nodeId:[NSString stringWithFormat:@"%d",(i+1) * 1000+j] name:dict1[@"node"][@"title"] depth:@"2"expand:isExpand dict:dict1[@"node"]];
                [self.data addObject:part];
            }else
            {
                MyLearningRecordCatalogModel *part= [[MyLearningRecordCatalogModel alloc] initWithParentId:[NSString stringWithFormat:@"%d",i] nodeId:[NSString stringWithFormat:@"%d",(i+1) * 1000+j] name:dict1[@"node"][@"title"] depth:@"3" expand:isExpand dict:dict1[@"node"]];
                [self.data addObject:part];
            }
           
            
            for (int k = 0; k<[dict1[@"children"] count]; k++) {
                NSDictionary  *dict2 = dict1[@"children"][k];
                MyLearningRecordCatalogModel *part= [[MyLearningRecordCatalogModel alloc] initWithParentId:[NSString stringWithFormat:@"%d",(i+1) * 1000+j] nodeId:[NSString stringWithFormat:@"%d",(i+1) * 1000+(j+1)*10000+k] name:dict2[@"node"][@"title"] depth:@"3"expand:isExpand dict:dict2[@"node"]];
                
                if ([part.dict[@"learn_status"] isEqualToString:@"1"]) {
                    self.play_id = part.dict[@"id"];
                }
                [self.data addObject:part];
            }
        }
    }

    [self updateNodesLevel];
    
    [self addFirstLoadNodes];
    
    [self setEmptyViewDelegeta];
    
    [self.tableView reloadData];
    
}
- (void)addFirstLoadNodes{
    // add parent nodes on the upper level
    for (int i = 0 ; i<_data.count;i++) {
        
        MyLearningRecordCatalogModel *node = _data[i];
        if ([node.depth isEqualToString:@"1"]) {
            [_tempData addObject:node];
            
            if (node.expand) {
                [self expandNodesForParentID:node.nodeId insertIndex:[_tempData indexOfObject:node]];
            }
        }
    }
    [_reloadArray removeAllObjects];
}

//set depath for all nodes
- (void)updateNodesLevel{
    [self setDepth:1 parentIDs:@[_rootID] childrenNodes:_data];
}

- (void)setDepth:(NSUInteger)level parentIDs:(NSArray*)parentIDs childrenNodes:(NSMutableArray*)childrenNodes{
    
    NSMutableArray *newParentIDs = [NSMutableArray array];
    NSMutableArray *leftNodes = [childrenNodes  mutableCopy];

    for (MyLearningRecordCatalogModel *node in childrenNodes) {
        if ([parentIDs containsObject:node.parentId]) {
//            node.depth = [NSString stringWithFormat:@"%ld",level];
            
            [leftNodes removeObject:node];
            [newParentIDs addObject:node.nodeId];
        }
    }
    
    if (leftNodes.count>0) {
//        level += 1;
        [self setDepth:level parentIDs:[newParentIDs copy] childrenNodes:leftNodes];
    }
}

#pragma mark - UITableViewDataSource

#pragma mark - Required

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _tempData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    MyLearningRecordCatalogModel *node = [_tempData objectAtIndex:indexPath.row];
    
    static NSString *CellIdentifier = @"Cell";
    // 通过indexPath创建cell实例 每一个cell都是单独的
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        pic = [[UIImageView alloc]initWithFrame:CGRectMake(30, 15, 20, 20)];
        [cell.contentView addSubview:pic];
        titleLab = [[UILabel alloc]initWithFrame:CGRectMake(maxX(pic)+5, 15, screenWidth()-110, 20)];
        titleLab.font = [UIFont systemFontOfSize:13];
        [cell.contentView addSubview:titleLab];
        arrowPic = [[UIImageView alloc]initWithFrame:CGRectMake(screenWidth()-30, 22, 12, 6)];
        [cell.contentView addSubview:arrowPic];
        
        timeLab = [[UILabel alloc]initWithFrame:CGRectMake(maxX(pic)+30,maxY(titleLab)+5, 200, 20)];
        timeLab.font = [UIFont systemFontOfSize:12];
        timeLab.textColor = [UIColor lightGrayColor];
        [cell.contentView addSubview:timeLab];
        
        progressLab = [[UILabel alloc]initWithFrame:CGRectMake(maxX(timeLab),maxY(titleLab)+5, 70, 20)];
        progressLab.font = [UIFont systemFontOfSize:12];
        progressLab.textColor = [UIColor lightGrayColor];
        [cell.contentView addSubview:progressLab];
        
        isSeekLab = [[UILabel alloc]initWithFrame:CGRectMake(maxX(progressLab)+5,maxY(titleLab)+5, 80, 20)];
        isSeekLab.font = [UIFont systemFontOfSize:12];
        isSeekLab.textColor = [UIColor colorWithHexString:@"41a45f"];
        [cell.contentView addSubview:isSeekLab];
        
        imageView = [[YLImageView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        imageView.hidden = YES;
        [cell.contentView addSubview:imageView];
        
    }

        if ([node.depth isEqualToString:@"2"]) {//节▽△
            cell.backgroundColor = CBackgroundColor;
            NSString *titleStr = node.name;
            NSString *str = node.dict[@"cn_number"];
            titleLab.text = [NSString stringWithFormat:@"第%@节·%@",str,titleStr];
            pic.hidden = YES;
            
            timeLab.hidden = YES;
            progressLab.hidden = YES;
            isSeekLab.hidden = YES;
            if (node.expand) {
                arrowPic.image = [UIImage imageNamed:@"向上图标"];
            }else{
                arrowPic.image = [UIImage imageNamed:@"向下图标"];
            }
            return cell;
        }else if ([node.depth isEqualToString:@"3"]){//课时

            
            cell.backgroundColor = CBackgroundColor;
  
            NSString *titleStr = node.name;
            NSString *str = node.dict[@"number"];
            titleLab.text = [NSString stringWithFormat:@"课时%@·%@",str,titleStr];
            titleLab.frame = CGRectMake(maxX(pic)+30, 15, screenWidth()-100, 20);
            pic.hidden = NO;
            
            timeLab.hidden = NO;
            
            isSeekLab.hidden = YES;
            
           
            isSeekLab.text = @"123";
            
            if (self.isLive) {
                if ([node.dict[@"node_status"] isEqualToString:@"0"]) {
                    progressLab.hidden = YES;
                    timeLab.text = [NSString stringWithFormat:@"%@",node.dict[@"live_time_text"]];
                    
                }else if ([node.dict[@"node_status"] isEqualToString:@"2"]){
                    progressLab.hidden = YES;
                    timeLab.text = [NSString stringWithFormat:@"%@",node.dict[@"live_time_text"]];
                }else if ([node.dict[@"node_status"] isEqualToString:@"3"]){
                    progressLab.hidden = NO;
                    timeLab.text = [NSString stringWithFormat:@"时长 %@",node.dict[@"media_count"]];
                }
            }else{
                progressLab.hidden = NO;
                timeLab.text = [NSString stringWithFormat:@"时长 %@",node.dict[@"media_count"]];
            }
            if (timeLab.text.length < 7) {
                timeLab.hidden = YES;
                progressLab.frame = CGRectMake(maxX(pic)+30,maxY(titleLab)+5, 120, 20);
            }else{
                progressLab.frame = CGRectMake(maxX(timeLab)+10,maxY(titleLab)+5, 100, 20);
                timeLab.hidden = NO;
            }
            if ([node.dict[@"is_free"] isEqualToString:@"1"]) {//1免费
                 arrowPic.image = [UIImage imageNamed:@"灰色播放按钮"];
            }else{//0收费
                if ([node.dict[@"is_buy"] isEqualToString:@"1"]) {//已经购买
                    arrowPic.image = [UIImage imageNamed:@"灰色播放按钮"];
                }else{//未购买
                    arrowPic.image = [UIImage imageNamed:@"iOS购买"];
                }
                
            }
            
             if ([node.dict[@"learn_status"] isEqualToString:@"1"] ) {//学习状态 0未开始 1学习中 2已学完
//                 titleLab.textColor = CNavBgColor;
                 progressLab.text = [NSString stringWithFormat:@"已学习%@%%",node.dict[@"learned_ratio"]];
                 titleLab.textColor = [UIColor blackColor];
                 
                 if (self.isLive) {
                     imageView.hidden = YES;
                     pic.hidden = NO;
                     pic.frame =  CGRectMake(55, 17.5, 15, 15);
                     if ([node.dict[@"node_status"] isEqualToString:@"0"]) {
                         pic.image = [UIImage imageNamed:@"课程大纲列表-未开始"];
                     }else if ([node.dict[@"node_status"] isEqualToString:@"2"]){
                         pic.image = [UIImage imageNamed:@"课程大纲列表-直播中"];
                     }else if ([node.dict[@"node_status"] isEqualToString:@"3"]){
                         pic.image = [UIImage imageNamed:@"直播大纲1-回放"];
                     }
                 }else{
                     imageView.hidden = YES;
                     pic.hidden = NO;
                     pic.frame = CGRectMake(67, 22, 7, 7);
                     pic.image = [UIImage imageNamed:@"椭圆5"];
                 }
//                 imageView.hidden = YES;
//                 pic.hidden = NO;
//                 pic.frame = CGRectMake(67, 22, 7, 7);
//                 pic.image = [UIImage imageNamed:@"椭圆5"];
             }else if([node.dict[@"learn_status"] isEqualToString:@"2"]){
                 pic.hidden = NO;
                 imageView.hidden = YES;
//                 arrowPic.image = [UIImage imageNamed:@"灰色播放按钮"];
                 pic.frame = CGRectMake(55, 17.5, 15, 15);
                 pic.image = [UIImage imageNamed:@"学完绿色对勾图标"];
                 titleLab.textColor = [UIColor blackColor];
                 progressLab.text = @"已学完";
                 progressLab.textColor = [UIColor colorWithHexString:@"41a45f"];
                 
             }else{
                 titleLab.textColor = [UIColor blackColor];
                 if (self.isLive) {
                     imageView.hidden = YES;
                     pic.hidden = NO;
                     pic.frame =  CGRectMake(55, 17.5, 15, 15);
                     if ([node.dict[@"node_status"] isEqualToString:@"0"]) {
                         pic.image = [UIImage imageNamed:@"课程大纲列表-未开始"];
                     }else if ([node.dict[@"node_status"] isEqualToString:@"2"]){
                         pic.image = [UIImage imageNamed:@"课程大纲列表-直播中"];
                     }else if ([node.dict[@"node_status"] isEqualToString:@"3"]){
                         pic.image = [UIImage imageNamed:@"直播大纲1-回放"];
                     }
                 }else{
                     imageView.hidden = YES;
                     pic.hidden = NO;
                     pic.frame = CGRectMake(67, 22, 7, 7);
                     pic.image = [UIImage imageNamed:@"椭圆5"];
                 }
//                 arrowPic.image = [UIImage imageNamed:@"灰色播放按钮"];
                 progressLab.text = @"未开始";
             }
            if ( [node.dict[@"id"] isEqualToString:self.play_id]) {
                titleLab.textColor = CNavBgColor;
                
                if (self.isLive) {
                    imageView.hidden = YES;
                    pic.hidden = NO;
                    pic.frame =  CGRectMake(55, 17.5, 15, 15);
                    if ([node.dict[@"node_status"] isEqualToString:@"0"]) {
                        
                        if(self.player.playbackState == PLVVodPlaybackStatePlaying ) {
                            imageView.frame = CGRectMake(55, 17.5, 15, 15);
                            imageView.hidden = NO;
                            imageView.image = [YLGIFImage imageNamed:@"播放中动图.gif"];
                            pic.hidden = YES;
                            arrowPic.image = [UIImage imageNamed:@"暂停按钮"];
                        }else{
                            pic.hidden = NO;
                            pic.frame = CGRectMake(55, 17.5, 15, 15);;
                            pic.image = [UIImage imageNamed:@"上次播放图标"];
                            arrowPic.image = [UIImage imageNamed:@"课程详情页大纲播放(1)"];
                        }
                        
                    }else if ([node.dict[@"node_status"] isEqualToString:@"2"]){
                        pic.image = [UIImage imageNamed:@"课程大纲列表-直播中"];
                        
                    }else if ([node.dict[@"node_status"] isEqualToString:@"3"]){
                        if(self.player.playbackState == PLVVodPlaybackStatePlaying ) {
                            imageView.frame = CGRectMake(55, 17.5, 15, 15);
                            imageView.hidden = NO;
                            imageView.image = [YLGIFImage imageNamed:@"播放中动图.gif"];
                            pic.hidden = YES;
                            arrowPic.image = [UIImage imageNamed:@"暂停按钮"];
                        }else{
                            pic.hidden = NO;
                            pic.frame = CGRectMake(55, 17.5, 15, 15);;
                            pic.image = [UIImage imageNamed:@"上次播放图标"];
                            arrowPic.image = [UIImage imageNamed:@"课程详情页大纲播放(1)"];
                        }
                        
                    }
                }else{
                    if(self.player.playbackState == PLVVodPlaybackStatePlaying ) {
                        imageView.frame = CGRectMake(55, 17.5, 15, 15);
                        imageView.hidden = NO;
                        imageView.image = [YLGIFImage imageNamed:@"播放中动图.gif"];
                        pic.hidden = YES;
                        arrowPic.image = [UIImage imageNamed:@"暂停按钮"];
                    }else{
                        pic.hidden = NO;
                        pic.frame = CGRectMake(55, 17.5, 15, 15);;
                        pic.image = [UIImage imageNamed:@"上次播放图标"];
                        arrowPic.image = [UIImage imageNamed:@"课程详情页大纲播放(1)"];
                    }
                }
            }
            arrowPic.frame = CGRectMake(screenWidth()-30, 27.5f, 15, 15);

            if ([node.dict[@"is_free"] isEqualToString:@"0"] && [node.dict[@"is_buy"] isEqualToString:@"0"]) {
                arrowPic.image = [UIImage imageNamed:@"iOS购买"];
            }
            return cell;
        }else{//章
            cell.backgroundColor = [UIColor whiteColor];
            NSString *titleStr = node.name;
            NSString *str =  node.dict[@"cn_number"];
            titleLab.text = [NSString stringWithFormat:@"第%@章·%@",str,titleStr];
            pic.image = [UIImage imageNamed:@"课程大纲章节图标"];
            timeLab.hidden = YES;
            progressLab.hidden = YES;
            isSeekLab.hidden = YES;
            if (node.expand) {
                arrowPic.image = [UIImage imageNamed:@"向上图标"];
            }else{
                arrowPic.image = [UIImage imageNamed:@"向下图标"];
            }
            return cell;
        }

}


#pragma mark - Optional
//头视图高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return SCREEN_WIDTH/16*9+50;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {

    return self.headerView;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

         MyLearningRecordCatalogModel *node = [_tempData objectAtIndex:indexPath.row];
        if ([node.depth isEqualToString:@"3"]){//课时
            return 70;
        }else{
            return 50;
        }

}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.isLiving = NO;
    MyLearningRecordCatalogModel *currentNode = [_tempData objectAtIndex:indexPath.row];
    if ([currentNode.depth isEqualToString:@"3"]) {
        isClick = YES;
        if ([self.play_id isEqualToString:currentNode.dict[@"id"]]  && ![currentNode.dict[@"node_status"] isEqualToString:@"2"]) {
            self.player.playbackState == PLVVodPlaybackStatePaused ? [self.player play]:[self.player pause];
          
        }else{
            if ([currentNode.dict[@"is_free"] isEqualToString:@"1"]) {

                if (self.player) {
                    [self postPlayTime];
                }

                self.clickLiveID = currentNode.dict[@"id"];
                if (self.tableView.contentInset.top > 0) {
                    self.tableView.contentInset = UIEdgeInsetsMake(ZM_StatusBarHeight, 0, 0, 0);
                }else{
                    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
                }
                [self.tableView  scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:NO];
                
                self.navView.hidden= YES;
                [self playButtonClick];
                
            }else{
                
                if ([currentNode.dict[@"is_buy"] isEqualToString:@"1"]) {

                    if (self.player) {
                        [self postPlayTime];
                    }

                    self.clickLiveID = currentNode.dict[@"id"];
                    self.navView.hidden= YES;
                    if (self.tableView.contentInset.top >0) {
                        self.tableView.contentInset = UIEdgeInsetsMake(ZM_StatusBarHeight, 0, 0, 0);
                    }else{
                        self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
                    }
                    [self.tableView  scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:NO];

                    [self playButtonClick];
                    
                }else{

                    if (self.isLive) {
                        NSMutableDictionary *parmDic = [NSMutableDictionary dictionary];
                        [parmDic setObject:self.course_id forKey:@"id"];
                        BADataEntity *entity = [BADataEntity new];
                        entity.urlString = @"/live/detail";
                        entity.needCache = NO;
                        entity.parameters = parmDic;
                        // 如果打印数据不完整，是因为 Xcode 8 版本问题，请下断点打印数据
                        [BANetManager ba_request_POSTWithEntity:entity successBlock:^(id response) {
                            
                
                            
                            if (response == nil) {
                                
                            }else{
                                if ([response[@"code"] isEqualToString:@"0"]) {
                                    
                                    if ([response[@"data"][@"is_sell"] isEqualToString:@"0"]) {
                                        [BaseTools showErrorMessage:@"暂不支持购买"];
                                    }else{
                                        [self.player pause];
                                        TIDeliveryView *deliveryView = [[TIDeliveryView alloc]initWithFrame:CGRectMake(30, 100, screenWidth()-60, 160) title:self.course_name  price:[NSString stringWithFormat:@"课程价格：%@",self.course_discount_price]];
                                        [deliveryView.allPrice addTarget:self action:@selector(allCoursePay) forControlEvents:(UIControlEventTouchUpInside)];
                                        [deliveryView.onePrice addTarget:self action:@selector(oneCoursePay) forControlEvents:(UIControlEventTouchUpInside)];
                                        [SGBrowserView showZoomView:deliveryView yDistance:20];
                                    }
                                    
                                }else{
                                    
                                    [BaseTools showErrorMessage:response[@"msg"]];
                                }
                            }
                   
                            
                        } failureBlock:^(NSError *error) {
                            
                        } progressBlock:^(int64_t bytesProgress, int64_t totalBytesProgress) {
                            /*! 封装方法里已经回到主线程，所有这里不用再调主线程了 */
                            
                        }];
                    }else{
                        NSMutableDictionary *parmDic = [NSMutableDictionary dictionary];
                        [parmDic setObject:self.course_id forKey:@"id"];
                        BADataEntity *entity = [BADataEntity new];
                        entity.urlString = @"/course/detail";
                        entity.needCache = NO;
                        entity.parameters = parmDic;
                        // 如果打印数据不完整，是因为 Xcode 8 版本问题，请下断点打印数据
                        [BANetManager ba_request_POSTWithEntity:entity successBlock:^(id response) {
     
                            if (response == nil) {
                                
                            }else{
                                if ([response[@"code"] isEqualToString:@"0"]) {
                                    
                                    if ([response[@"data"][@"is_sell"] isEqualToString:@"0"]) {
                                        [BaseTools showErrorMessage:@"暂不支持购买"];
                                    }else{
                                        [self.player pause];
                                        TIDeliveryView *deliveryView = [[TIDeliveryView alloc]initWithFrame:CGRectMake(30, 100, screenWidth()-60, 160) title:self.course_name  price:[NSString stringWithFormat:@"课程价格：%@",self.course_discount_price]];
                                        [deliveryView.allPrice addTarget:self action:@selector(allCoursePay) forControlEvents:(UIControlEventTouchUpInside)];
                                        [deliveryView.onePrice addTarget:self action:@selector(oneCoursePay) forControlEvents:(UIControlEventTouchUpInside)];
                                        [SGBrowserView showZoomView:deliveryView yDistance:20];
                                    }
                                    
                                }else{
                                    
                                    [BaseTools showErrorMessage:response[@"msg"]];
                                }
                            }
                        } failureBlock:^(NSError *error) {
                            
                        } progressBlock:^(int64_t bytesProgress, int64_t totalBytesProgress) {
                            /*! 封装方法里已经回到主线程，所有这里不用再调主线程了 */
                            
                        }];
                    }
                    
                    
                    
                    
       
                }
            }
            return;
        }
        
        
    }else{
        
        currentNode.expand = !currentNode.expand;
    }
    
    
    [_reloadArray removeAllObjects];
    if (currentNode.expand) {
        //expand
        [self expandNodesForParentID:currentNode.nodeId insertIndex:indexPath.row];
    }else{
        //fold
        [self foldNodesForLevel:[currentNode.depth integerValue] currentIndex:indexPath.row];
    }
    [self.tableView reloadData];
}
- (void)oneCoursePay{
    [SGBrowserView hide];

    
}
- (void)allCoursePay{
    [SGBrowserView hide];
    PayMentViewController *vc = [[PayMentViewController alloc]init];
    vc.goodID = self.course_id;
    if (self.isLive) {
        vc.goodType = @"6";
    }else{
        vc.goodType = @"3";
    }
     vc.dist_id = @"0";
    [self.navigationController pushViewController:vc animated:YES];
    
}
#pragma mark
#pragma mark fold and expand
- (void)foldNodesForLevel:(NSUInteger)level currentIndex:(NSUInteger)currentIndex{
    
    if (currentIndex+1<_tempData.count) {
        NSMutableArray *tempArr = [_tempData copy];
        for (NSUInteger i = currentIndex+1 ; i<tempArr.count;i++) {
            MyLearningRecordCatalogModel *node = tempArr[i];
            if ([node.depth integerValue] <= level) {
                break;
            }else{
                [_tempData removeObject:node];
                [_reloadArray addObject:[NSIndexPath indexPathForRow:i inSection:0]];//need reload nodes
            }
        }
    }
}

- (NSUInteger)expandNodesForParentID:(NSString*)parentID insertIndex:(NSUInteger)insertIndex{
    
    for (int i = 0 ; i<_data.count;i++) {
        MyLearningRecordCatalogModel *node = _data[i];

        if ([node.parentId isEqualToString:parentID]) {
            if (!self.isPreservation) {
                node.expand = NO;
            }
            insertIndex++;
            [_tempData insertObject:node atIndex:insertIndex];
            [_reloadArray addObject:[NSIndexPath indexPathForRow:insertIndex inSection:0]];//need reload nodes
            
            if (node.expand) {
                insertIndex = [self expandNodesForParentID:node.nodeId insertIndex:insertIndex];
            }
        }
    }
    
    return insertIndex;
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{

    _backBtn.hidden = NO;
    _shareBtn.hidden = NO;
    _menuBtn.hidden = NO;
    if(scrollView == self.tableView && (self.player.playbackState == PLVVodPlaybackStateStopped ||self.player.playbackState == PLVVodPlaybackStatePaused) && self.player.loadState != PLVVodLoadStatePlayable ) {
        self.offset = scrollView.contentOffset.y;
        [self setNeedsStatusBarAppearanceUpdate];
        CGFloat sectionHeaderHeight = SCREEN_WIDTH/16*9-(kIsiPhoneX ? 0:20); //headerView高度
 
        if (scrollView.contentOffset.y <= sectionHeaderHeight && scrollView.contentOffset.y >=0) {
            self.view.backgroundColor = [UIColor blackColor];
            [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;//黑色
//             self.headerView.backgroundColor = [UIColor redColor];
            self.images.hidden = NO;
            downLoadBtn.hidden = NO;
            self.navView.hidden = YES;
       
            _shareBtn.hidden = NO;
      
            [_backBtn setImage:[UIImage imageNamed:@"详情页返回按钮"] forState:(UIControlStateNormal)];
            [_shareBtn setImage:[UIImage imageNamed:@"详情页分享按钮"] forState:(UIControlStateNormal)];
            if (downLoadDocBtn.hidden) {
                downLoadDocBtn.hidden = YES;
            }else{
                downLoadDocBtn.hidden = NO;
            }
            
            [_menuBtn setImage:[UIImage imageNamed:@"菜单按钮"] forState:(UIControlStateNormal)];
//            shareBtn.hidden = NO;
            scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
        }
        else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
            self.images.hidden = YES;
            downLoadBtn.hidden = YES;
            self.headerView.backgroundColor = [UIColor whiteColor];
            self.view.backgroundColor = [UIColor whiteColor];
            self.navView.hidden = NO;
            if (downLoadDocBtn.hidden) {
                downLoadDocBtn.hidden = YES;
            }else{
                downLoadDocBtn.hidden = NO;
            }
            if (self.isLive) {
                _shareBtn.hidden = YES;
            }else{
                _shareBtn.hidden = NO;
            }
            [_backBtn setImage:[UIImage imageNamed:@"导航栏返回"] forState:(UIControlStateNormal)];
            [_shareBtn setImage:[UIImage imageNamed:@"xiazai (1)"] forState:(UIControlStateNormal)];
            [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;//亮白
            [_menuBtn setImage:[UIImage imageNamed:@"caidan-hei"] forState:(UIControlStateNormal)];

            scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
        }

    }
}
- (BOOL)prefersStatusBarHidden {
    return self.player.prefersStatusBarHidden;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    CGFloat sectionHeaderHeight = SCREEN_WIDTH/16*9-(kIsiPhoneX ? 0:20); //headerView高度
    if (self.offset <= sectionHeaderHeight && self.offset >=0) {
       return UIStatusBarStyleLightContent;
    }
    else if (self.offset>=sectionHeaderHeight) {
        return UIStatusBarStyleDefault;
    }
    return UIStatusBarStyleLightContent;
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation {
    
    return UIStatusBarAnimationFade;
}
//- (UIStatusBarStyle)preferredStatusBarStyle {
//    return self.player.preferredStatusBarStyle;
//}

#pragma mark —————  记录播放时间上传到服务器  --———
- (void)postPlayTime{
    
    if (self.isLive) {
        NSMutableDictionary *parmDic = [NSMutableDictionary dictionary];
        [parmDic setObject:self.play_id forKey:@"node_id"];
        [parmDic setObject:[NSString stringWithFormat:@"%lf",self.player.currentPlaybackTime] forKey:@"time_point"];
        if (self.player.currentPlaybackTime<self.player.duration) {
            [parmDic setObject:@"0" forKey:@"play_over"];
        }else{
            [parmDic setObject:@"1" forKey:@"play_over"];
        }
        
        [ZMNetworkHelper POST:@"/live/progress" parameters:parmDic cache:YES responseCache:^(id responseCache) {
            
        } success:^(id responseObject) {
            if (responseObject == nil) {
                
            }else{
                if ([responseObject[@"code"] isEqualToString:@"0"]) {
                    KPostNotification(@"uploadHomePageCourseRecord", nil);
                    
                }else{
                    
                    [BaseTools showErrorMessage:responseObject[@"msg"]];
                }
            }
            
        } failure:^(NSError *error) {
            
        }];
    }else{
        NSMutableDictionary *parmDic = [NSMutableDictionary dictionary];
        [parmDic setObject:self.play_id forKey:@"node_id"];
        [parmDic setObject:[NSString stringWithFormat:@"%lf",self.player.currentPlaybackTime] forKey:@"time_point"];
        if (self.player.currentPlaybackTime<self.player.duration) {
            [parmDic setObject:@"0" forKey:@"play_over"];
        }else{
            [parmDic setObject:@"1" forKey:@"play_over"];
        }
        
        [ZMNetworkHelper POST:@"/course/progress" parameters:parmDic cache:YES responseCache:^(id responseCache) {
            
        } success:^(id responseObject) {
            if (responseObject == nil) {
                
            }else{
                if ([responseObject[@"code"] isEqualToString:@"0"]) {
                    KPostNotification(@"uploadHomePageCourseRecord", nil);
                    
                }else{
                    
                    [BaseTools showErrorMessage:responseObject[@"msg"]];
                }
            }
            
        } failure:^(NSError *error) {
            
        }];
    }
    
    
}

- (void)downLoadDocAction{
    NSMutableDictionary *parmDic = [NSMutableDictionary dictionary];
    [parmDic setObject:self.course_id forKey:@"course_id"];
    [ZMNetworkHelper POST:@"/course/has_handout" parameters:parmDic cache:YES responseCache:^(id responseCache) {
        
    } success:^(id responseObject) {
        if (responseObject == nil) {
            
        }else{
            if ([responseObject[@"code"] isEqualToString:@"0"]) {
               
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    downLoadDocBtn.hidden = NO;
                });
                
                
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    downLoadDocBtn.hidden = YES;
                });
                
            }
        }
        
    } failure:^(NSError *error) {
        
    }];
    
    
    
}

- (void)downLoadDoc{
    
    NSMutableDictionary *parmDic = [NSMutableDictionary dictionary];
    [parmDic setObject:self.course_id forKey:@"course_id"];
    [ZMNetworkHelper POST:@"/course/download_handout" parameters:parmDic cache:YES responseCache:^(id responseCache) {
        
    } success:^(id responseObject) {
        if (responseObject == nil) {
            
        }else{
            if ([responseObject[@"code"] isEqualToString:@"0"]) {
                docUrl = responseObject[@"data"][@"url"];
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [self starDownDoc];
                });
                
                
            }else{
                [BaseTools showErrorMessage:responseObject[@"msg"]];

            }
        }
        
    } failure:^(NSError *error) {
        
    }];
    
   
}
- (void)starDownDoc{
    [BaseTools showErrorMessage:@"开始下载"];
    [ZMNetworkHelper downloadWithURL:docUrl fileDir:nil progress:^(NSProgress *progress) {
        NSLog(@"%@",progress);
    } success:^(NSString *filePath) {
        NSLog(@"%@",filePath);
        [BaseTools showErrorMessage:@"讲义下载成功"];
    } failure:^(NSError *error) {
        [BaseTools showErrorMessage:@"讲义下载失败"];
        NSLog(@"%@",error);
    }];
}
- (IBAction)sharedButtonClick:(id)sender {
    [self.player pause];
    if ([_shareBtn.currentImage isEqual:[UIImage imageNamed:@"xiazai (1)"]]) {
        NSDictionary *newDictionary=@{@"img":self.imageUrl,@"lesson_num":self.course_lesson_num,@"id":_course_id,@"title":self.course_name};
        
        [[ZMCusCommentManager shareManager] showCommentWithVideoInfo:newDictionary];
    }else{
        NSString *urlString;
        
        if (self.isLive) {
            urlString = [NSString stringWithFormat:@"%@/live/%@.html", SERVER_HOSTPC,_course_id];
        }else{
            urlString = [NSString stringWithFormat:@"%@/course/%@.html", SERVER_HOSTPC,_course_id];
        }
        
        
        [UMSocialShareUIConfig shareInstance].sharePageGroupViewConfig.sharePageGroupViewPostionType = UMSocialSharePageGroupViewPositionType_Bottom;
        [UMSocialShareUIConfig shareInstance].sharePageScrollViewConfig.shareScrollViewPageItemStyleType = UMSocialPlatformItemViewBackgroudType_None;
        [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
            if (platformType == UMSocialPlatformType_UserDefine_Begin+2) {
                //自定义图标的点击事件
            }
            else{
                [self shareWebPageToPlatformType:platformType shareURLString:urlString title:self.course_name descr:@"库课网校"];
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
#pragma mark - 转屏设置相关
- (BOOL)shouldAutorotate {
    return YES;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    if (self.player.fullscreen) {
        _backBtn.hidden = YES;
        _shareBtn.hidden = YES;
        _menuBtn.hidden = YES;
    }else{
        _backBtn.hidden = NO;
        _shareBtn.hidden = NO;
        _menuBtn.hidden = NO;
    }
    return UIInterfaceOrientationPortrait;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    if (self.player.fullscreen) {
        _backBtn.hidden = YES;
        _shareBtn.hidden = YES;
        _menuBtn.hidden = YES;
    }else{
        _backBtn.hidden = NO;
        _shareBtn.hidden = NO;
        _menuBtn.hidden = NO;
    }
    return UIInterfaceOrientationMaskAllButUpsideDown;
}

- (void)handleStatusBarOrientationChange: (NSNotification *)notification{
    UIInterfaceOrientation interfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
    switch (interfaceOrientation) {
        case UIInterfaceOrientationUnknown:
        case UIInterfaceOrientationPortraitUpsideDown:
        case UIInterfaceOrientationPortrait:
            [self.player addPlayerOnPlaceholderView:self.viewC.view rootViewController:self.viewC]; // 竖屏状态
            break;
        case UIInterfaceOrientationLandscapeLeft:
        case UIInterfaceOrientationLandscapeRight:
            [self.player addPlayerOnPlaceholderView:self.viewC.view rootViewController:self];      // 横屏时全屏
            break;
        default:
            break;
    }
}
- (void)menuAction:(UIButton *)sender{
    [YBPopupMenu showRelyOnView:sender titles:TITLES icons:ICONS menuWidth:120 otherSettings:^(YBPopupMenu *popupMenu) {
        popupMenu.fontSize = 13;
        popupMenu.textColor = CTitleColor;
        popupMenu.delegate = self;
    }];
}
#pragma mark - YBPopupMenuDelegate
- (void)ybPopupMenu:(YBPopupMenu *)ybPopupMenu didSelectedAtIndex:(NSInteger)index
{
    [self.player pause];
    [self.player destroyPlayer];
    NSInteger tabbarIndex =  [self.tabBarController selectedIndex];
    //    //拿到tabbar的当前分栏的NavigationController
    //    UINavigationController *nav = [self.tabBarController.viewControllers objectAtIndex:self.tabBarController.selectedIndex];
//    [_backBtn removeFromSuperview];
//    [_shareBtn removeFromSuperview];
//    [_menuBtn removeFromSuperview];
    //    shareBtn.hidden = YES;
    //    menuBtn.hidden = YES;
    if (index == tabbarIndex) {
        
        [[[AppDelegate shareAppDelegate] getCurrentUIVC].navigationController popToRootViewControllerAnimated:YES];
    }else{
        // 这是从一个模态出来的页面跳到tabbar的某一个页面
        [[[AppDelegate shareAppDelegate] getCurrentUIVC].navigationController popToRootViewControllerAnimated:NO];
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        
        UITabBarController *tabViewController = (UITabBarController *) appDelegate.window.rootViewController;
        
        [tabViewController setSelectedIndex:index];
    }
    
    
}

// 在dealloc时注销
- (void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
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
