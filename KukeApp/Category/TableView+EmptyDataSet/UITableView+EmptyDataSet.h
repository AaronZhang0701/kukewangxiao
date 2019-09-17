//
//  UITableView+EmptyDataSet.h
//  KukeApp
//
//  Created by iOSDeveloper on 2018/8/15.
//  Copyright © 2018年 zhangming. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIScrollView+EmptyDataSet.h"

typedef void (^loadingBlock)();
@interface UITableView (EmptyDataSet)<ZMEmptyDataSetSource, ZMEmptyDataSetDelegate>
/**
 *  是否在加载 YES:转菊花 or NO:立即空状态界面
 *  PS:在加载数据前设置为YES(必需)，随后根据数据调整为NO(可选)
 */
@property (nonatomic, assign)BOOL loading;



/**
 *  不加载状态下的图片(loading = NO)
 *  PS:空状态下显示图片
 */
@property (nonatomic, copy)NSString *loadedImageName;
@property (nonatomic, copy)NSString *descriptionText;// 空状态下的文字详情
/**
 *  刷新按钮文字
 */
@property (nonatomic, copy)NSString *buttonText;
@property (nonatomic,strong) UIColor *buttonNormalColor;// 按钮Normal状态下文字颜色
@property (nonatomic,strong) UIColor *buttonHighlightColor;// 按钮Highlight状态下文字颜色


/**
 *  视图的垂直位置
 *  PS:tableView中心点为基准点,(基准点＝0)
 */
@property (nonatomic, assign)CGFloat dataVerticalOffset;




@property(nonatomic,copy)loadingBlock loadingClick;// 点击回调block的属性
/**
 *  点击回调方法：跟loadingClick属性效果一样的
 *
 *  @param block 要执行的操作
 */
-(void)gzwLoading:(loadingBlock)block;
@end




//使用


//- (void)viewDidLoad {
//    [super viewDidLoad];
//
//    // 如果出现加载菊花和tableView重复出现的话，就设置FooterView，因为tableView默认对没有数据的列表也会显示cell
//    self.tableView.tableFooterView = [UIView new];
//
//    // 配置参数
//    //    self.tableView.buttonText = @"再次请求";
//    //    self.tableView.buttonNormalColor = [UIColor redColor];
//    //    self.tableView.buttonHighlightColor = [UIColor yellowColor];
//    //    self.tableView.loadedImageName = @"58x58";
//    //    self.tableView.descriptionText = @"破网络，你还是再请求一次吧";
//    //    self.tableView.dataVerticalOffset = 200;
//
//    // 点击响应
//    [self.tableView gzwLoading:^{
//        NSLog(@"再点我就肛你");
//        [self loadingData:NO];
//    }];
//}
//// 有数据
//- (IBAction)loadData:(id)sender {
//    [self loadingData:YES];
//}
//// 没数据
//- (IBAction)noData:(id)sender {
//    [self loadingData:NO];
//}
//-(void)loadingData:(BOOL)data
//{
//    if (self.data.count > 0) {
//        [self.data removeAllObjects];
//        [self.tableView reloadData];
//    }
//
//    // 只需一行代码，我来解放你的代码
//    self.tableView.loading = YES;
//
//    // 模拟延迟
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        if (data) {
//            for (int i = 0; i < 10; i++) {
//                [self.data addObject:[NSString stringWithFormat:@"I'm data，fuck！"]];
//            }
//        }else {// 无数据时
//            self.tableView.loading = NO;
//        }
//        [self.tableView reloadData];
//    });
//}
//
//
//
//
//
//
//
//-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//    return self.data.count;
//}
//-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ID"];
//    cell.textLabel.text = self.data[indexPath.row];
//    return cell;
//}
//@end

