//
//  HZNewListHeaderSortView.m
//  YXYC
//
//  Created by ios hzjt on 2018/6/5.
//  Copyright © 2018年 hzjt. All rights reserved.
//

#import "CourseListHeaderSortView.h"
#import "CourseListHeaderSortViewCell.h"

@interface CourseListHeaderSortView()<UITableViewDataSource, UITableViewDelegate>

//@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *titleArray;
@property (nonatomic, assign) NSInteger selectItem;


@end

@implementation CourseListHeaderSortView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self configSelf];
        [self configTableView];
//        self.selectItem = 0;
        [self configSelectItem:0];

        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, maxY(_tableView), screenWidth(), self.frame.size.height-_tableView.height)];
        [self addSubview:view];
        [view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapSelfView)]];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(closeView) name:@"CloseSortAndFiltrate" object:nil];
    }
    return self;
}
- (void)closeView{
    [self removeFromSuperview];
}
- (void)configSelf {
    self.backgroundColor = [UIColor colorWithRed:0.00f green:0.00f blue:0.00f alpha:0.75f];
    
    
//    [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapSelfView)]];
    
}
- (void)configTableView {
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 44 * self.titleArray.count) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.scrollEnabled = NO;
    
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    [_tableView registerClass:[CourseListHeaderSortViewCell class] forCellReuseIdentifier:@"CourseListHeaderSortViewCell"];
    
    
    [self addSubview:_tableView];
}
- (void)tapSelfView {
    [self removeFromSuperview];
}

#pragma mark -UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.titleArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CourseListHeaderSortViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CourseListHeaderSortViewCell" forIndexPath:indexPath];
    [cell configWithText:self.titleArray[indexPath.row] Selected:(indexPath.row==self.selectItem)];
    
    return cell;
}

#pragma mark -UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self configSelectItem:indexPath.row];
    if (self.myBlock) {
        self.myBlock(_titleArray[indexPath.row],indexPath.row);
    }
}
#pragma mark -animation


#pragma mark -lazy load
- (NSArray *)titleArray {
    if (!_titleArray) {
        _titleArray = @[@"综合排序", @"人气排序", @"价格降序",@"价格升序"];
    }
    return _titleArray;
}
-  (void)configSelectItem:(NSInteger)item {
    self.selectItem = item;
    
    [self.tableView reloadData];
    [self removeFromSuperview];

}


#pragma mark -<#Code#>

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
