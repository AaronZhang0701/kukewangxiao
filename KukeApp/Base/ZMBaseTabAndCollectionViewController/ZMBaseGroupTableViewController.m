//
//  ZMBaseGroupTableViewController.m
//  KukeApp
//
//  Created by 库课 on 2019/9/11.
//  Copyright © 2019 KukeZhangMing. All rights reserved.
//

#import "ZMBaseGroupTableViewController.h"
#import <MJRefresh/MJRefresh.h>
#import "PLVDownloadManagerViewController.h"
@interface ZMBaseGroupTableViewController ()<ZMEmptyDataSetSource,ZMEmptyDataSetDelegate,UITableViewDataSource,UITableViewDelegate>

@property (nonatomic , strong) NSArray *pullLoadingImages;

@property (nonatomic , strong) NSArray *moreLoadingImages;

@end

@implementation ZMBaseGroupTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.tableView];
    /**
     *  添加footView,去除多余分割线
     */
    if (!self.tableView.tableFooterView) {
        [self setExtraCellLineHidden];
    }
    
    //收起键盘设置
    [self setHideKeyBoardTap];
    
    _lq_loadingGifName = @"lq_loading.gif";
    _lq_loadingViewType  = LQTableViewLoadingViewTypeGif;
    //    _lq_loadingViewType  = LQTableViewLoadingViewTypeDefault;
    
    _lq_failLoadViewType = LQTableViewFailLoadViewTypeDefault;
    
}
- (void)setEmptyViewDelegeta{
    self.tableView.loading = NO;
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
}
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIImage imageNamed:@"无数据"];
}
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *title = @"暂无数据哦~";
    NSDictionary *attributes = @{
                                 NSFontAttributeName:[UIFont systemFontOfSize:13.0f],
                                 NSForegroundColorAttributeName:[UIColor colorWithHexString:@"8a8a8a"]
                                 };
    return [[NSAttributedString alloc] initWithString:title attributes:attributes];
}

//收起键盘
- (void)setHideKeyBoardTap {
    UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped)];
    tapGr.cancelsTouchesInView    = NO;
    [self.view addGestureRecognizer:tapGr];
}

- (void)viewTapped {
    [self.view endEditing:YES];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //开启友盟统计
    //    [MobClick beginLogPageView:NSStringFromClass(self.class)];
    
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    //关闭友盟统计
    //    [MobClick endLogPageView:NSStringFromClass(self.class)];
    
    //    [SVProgressHUD dismiss];
    
    [self.view endEditing:YES];
}
#pragma mark - 开始拖拽
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
}
/**
 *  懒加载UITableView
 *
 *  @return UITableView
 */
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth,screenHeight()-UI_navBar_Height) style:UITableViewStyleGrouped];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = CBackgroundColor;
        _tableView.estimatedRowHeight = 0;
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
    }
    return _tableView;
}
//#pragma mark - tableView将分割线从最左边开始
//- (void)viewDidLayoutSubviews {
//
//    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
//        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
//    }
//    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)])  {
//        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
//    }
//}
//- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPat{
//    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
//        [cell setLayoutMargins:UIEdgeInsetsZero];
//    }
//    if ([cell respondsToSelector:@selector(setSeparatorInset:)]){
//        [cell setSeparatorInset:UIEdgeInsetsZero];
//    }
//}
#pragma mark - 去掉多余分割线
- (void)setExtraCellLineHidden{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 0)];
    [view setBackgroundColor:[UIColor clearColor]];
    [self.tableView setTableFooterView:view];
}
#pragma mark - 点击某行
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - 下拉刷新图
- (NSArray *)pullLoadingImages {
    if (!_pullLoadingImages) {
        _pullLoadingImages = @[[UIImage imageNamed:@"pullLoading-1"],
                               [UIImage imageNamed:@"pullLoading-2"],
                               [UIImage imageNamed:@"pullLoading-3"],
                               [UIImage imageNamed:@"pullLoading-4"]];
    }
    return _pullLoadingImages;
}

- (NSArray *)moreLoadingImages {
    if (!_moreLoadingImages) {
        _moreLoadingImages = @[[UIImage imageNamed:@"pullLoading-1"],
                               [UIImage imageNamed:@"pullLoading-2"],
                               [UIImage imageNamed:@"pullLoading-3"],
                               [UIImage imageNamed:@"pullLoading-4"]];
    }
    return _moreLoadingImages;
}
#pragma mark - 刷新方法的初始化
//*********************刷新********************
-(void)initRefresh{
    //设置下拉
    
    self.tableView.tg_header = [TGRefreshOC  refreshWithTarget:self action:@selector(headerRefresh) config:nil];
    self.tableView.tg_header.fadeinTime = 2;
    self.tableView.tg_header.fadeoutTime = 5;
    //设置上拉
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRefresh)];
    [footer setTitle:@"" forState:MJRefreshStateIdle];
    // 设置文字
    //  [footer setTitle:NOMOREDATA forState:MJRefreshStateNoMoreData];
    self.tableView.mj_footer = footer;
    
    
}
/**
 *  下拉刷新
 */
-(void)headerRefresh{
    
    if (self.header_block) {
        self.header_block();
    }
}

/***
 *  上拉加载
 */
-(void)footerRefresh{
    if (self.footre_block) {
        self.footre_block();
    }
    
}
#pragma mark - 添加下拉刷新
/**
 *
 *  下拉刷新
 */
- (void)addWaterDropPullRefreshWithBlock:(nullable void(^)(void))block{
    
    //下拉刷新
    self.tableView.tg_header = [TGRefreshOC headerWithRefreshingBlock:^{
        self.tableView.mj_footer.hidden = NO;
        if (block) {
            block();
        }
    }];
    //    self.tableView.tg_header.fadeoutTime = ;
    self.tableView.tg_header.fadeinTime = 2;
    
}
//MJ下拉刷新
- (void)addPullRefreshWithBlock:(void(^)(void))block {
    
    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
        self.tableView.mj_footer.hidden = NO;
        if (block) {
            block();
        }
    }];
    
    [header setImages:self.pullLoadingImages forState:MJRefreshStateIdle];
    
    [header setImages:self.pullLoadingImages forState:MJRefreshStatePulling];
    
    [header setImages:self.pullLoadingImages forState:MJRefreshStateRefreshing];
    
    self.tableView.mj_header = header;
    
    header.lastUpdatedTimeLabel.hidden = YES;
    
    header.stateLabel.hidden = YES;
    
    header.lastUpdatedTimeLabel.hidden = YES;
}

#pragma mark - 上拉加载更多
- (void)addMoreLoadingWithBlock:(void(^)(void))block {
    //    MJRefreshBackGifFooter *footer = [MJRefreshBackGifFooter footerWithRefreshingBlock:^{
    //        if (block) {
    //            block();
    //        }
    //    }];
    //    [footer setImages:self.moreLoadingImages forState:MJRefreshStateIdle];
    //
    //    [footer setImages:self.moreLoadingImages forState:MJRefreshStatePulling];
    //
    //    [footer setImages:self.moreLoadingImages forState:MJRefreshStateRefreshing];
    //
    //    // Set footer
    //    self.tableView.mj_footer = footer;
    //
    //    footer.stateLabel.hidden = YES;
    //    footer.automaticallyHidden = YES;
    
    
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        if (block) {
            block();
        }
        
    }];
    [footer setTitle:@"" forState:MJRefreshStateIdle];
    // 设置文字
    //  [footer setTitle:NOMOREDATA forState:MJRefreshStateNoMoreData];
    self.tableView.mj_footer = footer;
    
}
- (void)endWaterDropRefreshWithHeaderHidden{
    [self.tableView.tg_header endRefreshing];
}
- (void)endRefreshWithFooterHidden {
    
    [self.tableView.mj_footer endRefreshing];
    //    self.tableView.mj_footer.hidden = YES;
}

#pragma mark - <NoDataTipsDelegate> - 刷新按钮点击
- (void)tipsRefreshBtnClicked{
    [self noDataBeginRefresh];
}

#pragma mark - <NoDataTipsDelegate> - 提示按钮点击
- (void)tipsNoDataBtnDid {
    if ([[UserDefaultsUtils valueWithKey:@"access_token"] length] !=0 ) {
        UIViewController *rootViewController = [[UIApplication sharedApplication] keyWindow].rootViewController;
        UIViewController *topViewController = [BaseTools topViewControllerWithRootViewController:rootViewController];
        PLVDownloadManagerViewController *vc = [[PLVDownloadManagerViewController alloc]init];
        [topViewController.navigationController pushViewController:vc animated:YES];
    }else{
        [BaseTools showErrorMessage:@"请登录后再操作"];
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [BaseTools alertLoginWithVC:self];
        });
    }
}

#pragma mark - 刷新界面数据
- (void)noDataBeginRefresh {
    
}

/************************ 加载中  ************************/
#pragma mark - 显示加载中的动画
- (void)lq_showLoading {
    if (self.tableView.mj_header.isRefreshing || self.tableView.mj_footer.isRefreshing) {
        return;
    }
    
    [self lq_hideFailLoad];
    
    switch (_lq_loadingViewType) {
        case LQTableViewLoadingViewTypeDefault: {
            [self lq_showLoadingDefault];
            break;
        }
        case LQTableViewLoadingViewTypeGif: {
            [self lq_showLoadingGif];
            break;
        }
        case LQTableViewLoadingViewTypeCustom: {
            [self lq_showLoadingCustomView];
            break;
        }
    }
}
#pragma mark - 隐藏加载中的动画
- (void)lq_hideLoading {
    [self lq_hideLoadingDefault];
    [self lq_hideLoadingGif];
    [self lq_hideLoadingCustomView];
}

#pragma mark - 初始化菊花加载动画
- (void)lq_initLoadingDefault {
    _lq_activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [_lq_activityIndicator setCenter:self.tableView.backgroundView.center];
    
}
#pragma mark - 加载菊花加载动画
- (void)lq_showLoadingDefault {
    if (!_lq_activityIndicator) {
        [self lq_initLoadingDefault];
    }
    
    self.tableView.backgroundView = _lq_activityIndicator;
    _lq_activityIndicator.hidden = NO;
    [_lq_activityIndicator startAnimating];
}
#pragma mark - 隐藏菊花加载动画
- (void)lq_hideLoadingDefault {
    if (_lq_activityIndicator) {
        self.tableView.backgroundView = nil;
        [_lq_activityIndicator stopAnimating];
    }
}
#pragma mark - 初始化加载中GIF动画
- (void)lq_initLoadingGif {
    // 设定位置和大小
    CGRect frame;
    CGSize size = [UIImage imageNamed:_lq_loadingGifName].size;
    size.width /= 2;
    size.height /= 2;
    frame.size = size;
    // 读取gif图片数据
    
    _lq_loadingGifView = [[YLImageView alloc] initWithFrame:frame];
    _lq_loadingGifView.image = [YLGIFImage imageNamed:_lq_loadingGifName];
}
#pragma mark - 显示加载中GIF动画
- (void)lq_showLoadingGif {
    if (!_lq_loadingGifView) {
        [self lq_initLoadingGif];
    }
    [self.tableView layoutIfNeeded];
    CGSize size = self.tableView.bounds.size;
    UIView *backgroudView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    backgroudView.backgroundColor = [UIColor clearColor];
    [backgroudView addSubview:_lq_loadingGifView];
    _lq_loadingGifView.center = backgroudView.center;
    self.tableView.backgroundView = backgroudView;
    _lq_loadingGifView.hidden = NO;
}
#pragma mark - 隐藏加载中GIF动画
- (void)lq_hideLoadingGif {
    if (_lq_loadingGifView) {
        self.tableView.backgroundView = nil;
        _lq_loadingGifView = nil;
    }
}
#pragma mark - 显示加载中自定义的View
- (void)lq_showLoadingCustomView {
    if (_lq_loadingView) {
        if (_lq_loadingView.frame.size.width <= 0 && _lq_loadingView.frame.size.height <=0) {
            [self.tableView layoutIfNeeded];
            CGSize size = self.tableView.bounds.size;
            _lq_loadingView.frame = CGRectMake(0, 0, size.width, size.height);
        }
        self.tableView.backgroundView = _lq_loadingView;
        _lq_loadingView.hidden = NO;
    }
}
#pragma mark - 隐藏加载中自定义的View
- (void)lq_hideLoadingCustomView {
    if (_lq_loadingView) {
        self.tableView.backgroundView = nil;
    }
}

/************************ 加载失败  ************************/
- (void)lq_showFailLoadWithType:(LQTableViewFailLoadViewType)type tipsString:(NSString *)tipsString{
    self.tableView.scrollEnabled = NO;
    [self lq_hideLoading];
    self.view.userInteractionEnabled = YES;
    _lq_failLoadViewType = type;
    self.lq_faildLoadDefaultTipsStr = tipsString;
    switch (_lq_failLoadViewType) {
        case LQTableViewFailLoadViewTypeDefault: {
            if (self.lq_faildLoadDefaultTipsStr.length == 0) {
                self.lq_faildLoadDefaultTipsStr = @"加载失败，点击屏幕刷新";
            }
            self.lq_faildLoadDefaultTipsIamgeName = @"页面加载失败";
            [self lq_showFaildLoadDefault];
            self.lq_faildLoadDefaultTipsStr = nil;
            self.lq_faildLoadDefaultTipsIamgeName = nil;
            
            break;
        }
        case LQTableViewFailLoadViewTypeGif: {
            [self lq_showFaildLoadGif];
            break;
        }
        case LQTableViewFailLoadViewTypeCustom: {
            [self lq_showFaildLoadCustomView];
            break;
        }
        case LQTableViewFailLoadViewTypeNoData: {
            if (self.lq_faildLoadDefaultTipsStr.length == 0) {
                self.lq_faildLoadDefaultTipsStr = @"空空如也";
            }
            self.lq_faildLoadDefaultTipsIamgeName = @"无网络";
            [self lq_showFaildLoadDefault];
            self.lq_faildLoadDefaultTipsStr = nil;
            self.lq_faildLoadDefaultTipsIamgeName = nil;
            break;
        }
    }
}

#pragma mark - 隐藏加载失败提示背景
- (void)lq_hideFailLoad {
    [self lq_hideFaildLoadDefault];
    [self lq_hideFaildLoadGif];
    [self lq_hideFaildLoadCustomView];
}

#pragma mark - 懒加载失败默认视图
- (NoDataTipsView *)lq_failLoadDefaultView {
    if (!_lq_failLoadDefaultView) {
        [self.tableView layoutIfNeeded];
        CGSize size = self.tableView.bounds.size;
        _lq_failLoadDefaultView = [NoDataTipsView setTipsBackGroupWithframe:CGRectMake(0, 0, size.width, size.height) tipsIamgeName:_lq_faildLoadDefaultTipsIamgeName tipsStr:_lq_faildLoadDefaultTipsStr];
        _lq_failLoadDefaultView.noDataBtn.hidden = NO;
        _lq_failLoadDefaultView.delegate = self;
    }
    return _lq_failLoadDefaultView;
}

- (void)setLq_faildLoadDefaultTipsBtnStr:(NSString *)lq_faildLoadDefaultTipsBtnStr {
    _lq_faildLoadDefaultTipsBtnStr = lq_faildLoadDefaultTipsBtnStr;
    [self.lq_failLoadDefaultView needBtnWithName:_lq_faildLoadDefaultTipsBtnStr];
}

#pragma mark - 显示加载失败默认视图
- (void)lq_showFaildLoadDefault {
    [self.lq_failLoadDefaultView setTipsString:_lq_faildLoadDefaultTipsStr];
    [self.lq_failLoadDefaultView setImageName:_lq_faildLoadDefaultTipsIamgeName];
    self.tableView.backgroundView = self.lq_failLoadDefaultView;
    _lq_failLoadDefaultView.hidden = NO;
}
#pragma mark - 隐藏加载失败默认视图
- (void)lq_hideFaildLoadDefault {
    if (_lq_failLoadDefaultView) {
        self.tableView.backgroundView = nil;
    }
}
#pragma mark - 初始化加载失败GIF动画
- (void)lq_initFaildLoadGif {
    // 设定位置和大小
    CGRect frame;
    frame.size = [UIImage imageNamed:_lq_faildLoadGifName].size;
    [self.tableView layoutIfNeeded];
    CGPoint origin = CGPointMake(self.tableView.bounds.size.width/2.0 - frame.size.width / 2.0, self.tableView.bounds.size.height/2.0 - frame.size.height / 2.0) ;
    frame.origin = origin;
    // 读取gif图片数据
    _lq_faildLoadGifView = [[YLImageView alloc] initWithFrame:frame];
    _lq_faildLoadGifView.image = [YLGIFImage imageNamed:_lq_faildLoadGifName];
}
#pragma mark - 显示加载失败GIF动画
- (void)lq_showFaildLoadGif {
    if (!_lq_faildLoadGifView) {
        [self lq_faildLoadGifView];
    }
    self.tableView.backgroundView = _lq_faildLoadGifView;
    _lq_faildLoadGifView.hidden = NO;
}
#pragma mark - 隐藏加载失败GIF动画
- (void)lq_hideFaildLoadGif {
    if (_lq_faildLoadGifView) {
        self.tableView.backgroundView = nil;
    }
}
#pragma mark - 显示加载中自定义的View
- (void)lq_showFaildLoadCustomView {
    if (_lq_failLoadView) {
        if (_lq_failLoadView.frame.size.width <= 0 || _lq_failLoadView.frame.size.height <=0) {
            [self.tableView layoutIfNeeded];
            CGSize size = self.tableView.bounds.size;
            _lq_failLoadView.frame = CGRectMake(0, 0, size.width, size.height);
        }
        self.tableView.backgroundView = _lq_failLoadView;
        _lq_failLoadView.hidden = NO;
    }
}
#pragma mark - 隐藏加载中自定义的View
- (void)lq_hideFaildLoadCustomView {
    if (_lq_failLoadView) {
        self.tableView.backgroundView = nil;
    }
}
#pragma mark - 清除背景
- (void)lq_cleanBackgroud {
    [self lq_hideLoading];
    [self lq_hideFailLoad];
    self.view.userInteractionEnabled = YES;
}

#pragma mark - 停止loading
- (void)lq_endLoading {
    [self lq_cleanBackgroud];
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
    [self.tableView.tg_header endRefreshing];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}



@end
