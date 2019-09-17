//
//  CourseCatalogView.m
//  KukeApp
//
//  Created by iOSDeveloper on 2018/10/1.
//  Copyright © 2018年 zhangming. All rights reserved.
//

#import "CourseCatalogView.h"
#import "CourseCatalogModel.h"
#import "TableViewModel.h"
#import "CourseCatalogTableViewCell.h"
#import "SGBrowserView.h"
#import "TIDeliveryView.h"
#import "CourseDetailViewController.h"
#import "TestPaperWebViewController.h"
#import "PayMentViewController.h"
#import "ExamWebViewController.h"
typedef enum : NSUInteger {
    defaultDirection,
    downDirection,
    upDirection,
} ScrollDirection;

@interface CourseCatalogView ()
{
    NSInteger oldY;
    int state; //0初始 1下 2上
    NSMutableArray *ary1;
    NSMutableArray *arys1;
    NSInteger classType;
    UIImageView *pic;
    UILabel *titleLab;
    UIImageView *arrowPic;
    UILabel *longTimeLab;
    UILabel *progressLab;
    UILabel *isSeekLab;
    NSDictionary *dict1;
    NSString *course_ID;
    NSInteger indexItem;
    YLImageView* imageView;
//    BOOL isClick;
    NSString *testIsClick;
    NSString *playID;
    PLVVodPlaybackState playState;
}
@property (strong, nonatomic) NSMutableArray *countArray;
@property (assign, nonatomic) NSInteger rowCount;
@property (strong, nonatomic) UILabel *label;
//@property (assign, nonatomic) NSIndexPath *selIndex;//单选，当前选中的行
//@property (nonatomic,assign) BOOL isSel;
@property (strong, nonatomic) NSMutableArray *sectionAry;
@property (strong, nonatomic) NSMutableArray *listAry;
@property (strong, nonatomic) NSDictionary *courseInfoDict;

//@property (strong, nonatomic) NSString *clickVideoID;

@end

@implementation CourseCatalogView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self.tableView registerNib:[UINib nibWithNibName:@"CourseCatalogTableViewCell" bundle:nil] forCellReuseIdentifier:@"CourseCatalogTableViewCell"];
//        isClick = NO;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(upLoadData) name:@"PaySuccess" object:nil];
    }
    return self;
}
-(void)upLoadData
{
    [self getCourseID:course_ID withClass:classType];
}

- (void)setMyPlayBackState:(PLVVodPlaybackState)myPlayBackState{
    playState = myPlayBackState;
    [self.tableView reloadData];
}
- (void)setPlay_id:(NSString *)play_id{
    playID = play_id;
    [self.tableView reloadData];
}
- (void)setCourseDict:(NSDictionary *)courseDict{
    self.courseInfoDict = [NSDictionary dictionary];
    self.courseInfoDict = courseDict;
    
}
- (void)getCourseID:(NSString *)ID withClass:(NSInteger)classID {
    self.countArray = [NSMutableArray array];
    course_ID = ID;
    classType = classID;

    switch (classID) {
        case 0:{
        };break;
        case 1:{//请求题库数据
            NSMutableDictionary *parmDic = [NSMutableDictionary dictionary];
            [parmDic setObject:ID forKey:@"id"];

            [ZMNetworkHelper POST:@"/exam/testpaper" parameters:parmDic cache:YES responseCache:^(id responseCache) {
                
            } success:^(id responseObject) {
                if (responseObject == nil) {
                    
                }else{
                    if ([responseObject[@"code"] isEqualToString:@"0"]) {
                        [self dataAnalysis:responseObject];
                        
                    }else{
                        
                        [BaseTools showErrorMessage:responseObject[@"msg"]];
                    }
                }
                
            } failure:^(NSError *error) {
                
            }];
            
            
        };break;
        case 2:{
        };break;
        case 3:{//请求课程数据
            NSMutableDictionary *parmDic = [NSMutableDictionary dictionary];
            [parmDic setObject:ID forKey:@"course_id"];
            [ZMNetworkHelper POST:@"/course/nodes" parameters:parmDic cache:YES responseCache:^(id responseCache) {
                
            } success:^(id responseObject) {
                if (responseObject == nil) {
                    
                }else{
                    if ([responseObject[@"code"] isEqualToString:@"0"]) {
                        [self dataAnalysis:responseObject];
                        
                    }else{
                        
                        [BaseTools showErrorMessage:responseObject[@"msg"]];
                    }
                }
                
            } failure:^(NSError *error) {
                
            }];
            
            
        };break;
        case 4:{//请求图书数据
        };break;
        case 5:{//请求套餐数据
            self.tableView .separatorStyle = UITableViewCellSeparatorStyleNone;
            NSMutableDictionary *parmDic = [NSMutableDictionary dictionary];
            [parmDic setObject:ID forKey:@"id"];
            [ZMNetworkHelper POST:@"/classroom/detail_content" parameters:parmDic cache:YES responseCache:^(id responseCache) {
                
            } success:^(id responseObject) {
                if (responseObject == nil) {
                    
                }else{
                    if ([responseObject[@"code"] isEqualToString:@"0"]) {
                        [self dataAnalysis:responseObject];
                        
                    }else{
                        
                        [BaseTools showErrorMessage:responseObject[@"msg"]];
                    }
                }
                
            } failure:^(NSError *error) {
                
            }];
            
        };break;
        case 6:{//请求直播数据
            self.tableView .separatorStyle = UITableViewCellSeparatorStyleNone;
            NSMutableDictionary *parmDic = [NSMutableDictionary dictionary];
            [parmDic setObject:ID forKey:@"live_id"];
            [ZMNetworkHelper POST:@"/live/nodes" parameters:parmDic cache:YES responseCache:^(id responseCache) {
                
            } success:^(id responseObject) {
                if (responseObject == nil) {
                    
                }else{
                    if ([responseObject[@"code"] isEqualToString:@"0"]) {
                        [self dataAnalysis:responseObject];
                        
                    }else{
                        
                        [BaseTools showErrorMessage:responseObject[@"msg"]];
                    }
                }
                
            } failure:^(NSError *error) {
                
            }];
            
        };break;
        default:
            break;
    }
    
    
}
#pragma mark —————  请求到的数据进行解析  --———
- (void)dataAnalysis:(id)data{
    
    if (classType == 1) {
        [self.countArray addObjectsFromArray:data[@"data"]];
        
    }else if (classType == 3 || classType == 6){
        [self.countArray addObjectsFromArray:data[@"data"]];
        ary1 = [NSMutableArray array];
        for (NSMutableDictionary *obj in self.countArray) {
            NSMutableDictionary *dict1 = [NSMutableDictionary dictionaryWithDictionary:obj];
            NSMutableArray *ary2 = [NSMutableArray array];
            for (id obj2 in obj[@"children"]) {
                NSMutableDictionary *dict2 = [NSMutableDictionary dictionaryWithDictionary:obj2];
                NSMutableArray *ary3 = [NSMutableArray array];
                for (NSMutableDictionary *obj3 in obj2[@"children"]) {
                    NSMutableDictionary *dict3 = [NSMutableDictionary dictionaryWithDictionary:obj3];
                    [dict3 setObject:obj3[@"node"][@"is_open"] forKey:@"open"];
                    [ary3 addObject:dict3];
                    
                }
                [dict2 setObject:obj2[@"node"][@"is_open"] forKey:@"open"];
                [dict2 setObject:ary3 forKey:@"children"];
                [ary2 addObject:dict2];
                
            }
            [dict1 setObject:obj[@"node"][@"is_open"] forKey:@"open"];
            [dict1 setObject:ary2 forKey:@"children"];
            [ary1 addObject:dict1];
        }
        
        arys1 = [NSMutableArray array];


        for (int i = 0; i<ary1.count; i++) {
            [arys1 addObject:ary1[i]];
            NSDictionary *models = [ary1 objectAtIndex:i];
            
            for (int k = 0; k<[models[@"children"] count]; k++) {
                NSDictionary *models0 = [models[@"children"]  objectAtIndex:k];
                if ([models[@"open"] isEqualToString:@"1"]) {
                    [arys1 addObject:models0];
                    
                    for (int j = 0; j<[models0[@"children"] count]; j++) {
                        NSDictionary *models1 = [models0[@"children"]  objectAtIndex:j];
//                        if ([models1[@"open"] isEqualToString:@"1"]) {
                            [arys1 addObject:models1];
//                        }
                    }
                }
            }
        }

        self.countArray = [NSMutableArray arrayWithArray:arys1];
    }else if (classType == 5){
        self.sectionAry = [NSMutableArray array];
        self.listAry = [NSMutableArray array];
//        dict = [NSDictionary dictionaryWithDictionary:data[@"data"]];
        
        if([data[@"data"][@"lives"] count] != 0 ){
            [self.sectionAry addObject:@"直播列表"];
            [self.listAry addObject:data[@"data"][@"lives"]];
        }
        if ([data[@"data"][@"courses"] count] !=0) {
            [self.sectionAry addObject:@"课程列表"];
            [self.listAry addObject:data[@"data"][@"courses"]];
        }
        if([data[@"data"][@"exams"] count] != 0 ){
            [self.sectionAry addObject:@"题库列表"];
            [self.listAry addObject:data[@"data"][@"exams"]];
        }
        if([data[@"data"][@"books"] count] != 0 ){
            [self.sectionAry addObject:@"图书列表"];
            [self.listAry addObject:data[@"data"][@"books"]];
        }
        
        
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
    
}
- (void)setIsDaliankao:(NSString *)isDaliankao{
    testIsClick = isDaliankao;
}
#pragma mark - UITableViewDelegate、UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (classType ==5) {
        return self.sectionAry.count;
        
    }else{
        return 1;
    }
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (classType == 5) {
    
         return [self.listAry[section] count];
        
    }else{

        return self.countArray.count;
    }
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (classType == 1) {
        return 70;
    }else if (classType == 3 || classType == 6){
        NSDictionary *model = [self.countArray objectAtIndex:indexPath.row];
        if ([model[@"node"][@"node_type"]isEqualToString:@"3"]){//课时
            return 70;
        }else{
            return 50;
        }
        
    }else{
        return 70;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (classType == 1) {

        CourseCatalogTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CourseCatalogTableViewCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.titleLab.text = self.countArray[indexPath.row][@"title"];
        cell.titleLab.font = [UIFont systemFontOfSize:13];
        cell.pic.image = [UIImage imageNamed:@"试卷图标"];
        cell.arrow.image = [UIImage imageNamed:@"套餐试卷答题图标"];
        cell.arrow.frame = CGRectMake(screenWidth()-40, 25, 20, 20);
        cell.numberLab.text = [NSString stringWithFormat:@"题数 %@",self.countArray[indexPath.row][@"item_count"]];
        cell.scoreLab.text = [NSString stringWithFormat:@"总分 %@",self.countArray[indexPath.row][@"score"]];
        cell.btn.layer.cornerRadius = 3;
        cell.btn.layer.borderWidth = 0.5f;
        cell.btn.layer.borderColor = [CTitleColor CGColor];
        if ([self.countArray[indexPath.row][@"study_status"] isEqualToString:@"2"]) {
            cell.isMakeLab.text =[NSString stringWithFormat:@"得分 %@",self.countArray[indexPath.row][@"stu_score"]];
            cell.isMakeLab.hidden = NO;
            cell.isMakeLab.textColor = [UIColor colorWithHexString:@"#41A45F"];
            cell.btn.hidden = NO;
        }else if([self.countArray[indexPath.row][@"study_status"] isEqualToString:@"1"]){
            cell.isMakeLab.hidden = NO;
            cell.isMakeLab.textColor = CNavBgColor;
            cell.isMakeLab.text = @"进行中";
            cell.btn.hidden = YES;
        }else{
            cell.isMakeLab.hidden = NO;
            cell.isMakeLab.text = @"未开始";
            cell.btn.hidden = YES;
        }
        
        return cell;

    }else if (classType == 3 || classType == 6){

        NSDictionary *model = [self.countArray objectAtIndex:indexPath.row];
        
        
        
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

            
            longTimeLab = [[UILabel alloc]initWithFrame:CGRectMake(maxX(pic)+30,maxY(titleLab)+5, 200, 20)];
            longTimeLab.font = [UIFont systemFontOfSize:12];
            longTimeLab.textColor = [UIColor lightGrayColor];
            [cell.contentView addSubview:longTimeLab];
            
            progressLab = [[UILabel alloc]initWithFrame:CGRectMake(maxX(longTimeLab),maxY(titleLab)+5,70, 20)];
            progressLab.font = [UIFont systemFontOfSize:12];
            progressLab.textColor = [UIColor lightGrayColor];
            [cell.contentView addSubview:progressLab];
            
            isSeekLab = [[UILabel alloc]initWithFrame:CGRectMake(maxX(longTimeLab)+5,maxY(titleLab)+5, 80, 20)];
            isSeekLab.font = [UIFont systemFontOfSize:12];
            isSeekLab.textColor = [UIColor colorWithHexString:@"41a45f"];
            [cell.contentView addSubview:isSeekLab];
            
            imageView = [[YLImageView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
            imageView.hidden = YES;
            [cell.contentView addSubview:imageView];

        }

        
        if([model[@"children"] count]>0){
        
            if ([model[@"node"][@"node_type"]isEqualToString:@"2"]) {//节▽△
                cell.backgroundColor = CBackgroundColor;
                NSString *titleStr = model[@"node"][@"title"];
                NSString *str =  model[@"node"][@"cn_number"];
                titleLab.text = [NSString stringWithFormat:@"第%@节·%@",str,titleStr];
                pic.hidden = YES;
         
                progressLab.hidden = YES;
                longTimeLab.hidden = YES;
                isSeekLab.hidden = YES;
                if ([model[@"node"][@"open"] isEqualToString:@"1"]) {
                    arrowPic.image = [UIImage imageNamed:@"向上图标"];
                }else{
                    arrowPic.image = [UIImage imageNamed:@"向下图标"];
                }
                return cell;
            }else if ([model[@"node"][@"node_type"]isEqualToString:@"3"]){//课时
                cell.backgroundColor = CBackgroundColor;

                NSString *titleStr = model[@"node"][@"title"];
                NSString *str =  model[@"node"][@"number"];
                titleLab.text = [NSString stringWithFormat:@"课时%@·%@",str,titleStr];
                titleLab.frame = CGRectMake(maxX(pic)+30, 15, screenWidth()-100, 20);
                pic.hidden = NO;
                longTimeLab.hidden = NO;
                isSeekLab.hidden = YES;
                
//                priceLab.text = [NSString stringWithFormat:@"单课 %@",model[@"node"][@"price"]];
                if (classType == 6) {
                    if ([model[@"node"][@"node_status"] isEqualToString:@"0"]) {
                        
                        longTimeLab.text = [NSString stringWithFormat:@"%@",model[@"node"][@"live_time_text"]];
                    }else if ([model[@"node"][@"node_status"] isEqualToString:@"2"]){
                    
                        longTimeLab.text = [NSString stringWithFormat:@"%@",model[@"node"][@"live_time_text"]];
                    }else if ([model[@"node"][@"node_status"] isEqualToString:@"3"]){
                        
                        longTimeLab.text = [NSString stringWithFormat:@"时长 %@",model[@"node"][@"media_count"]];
                    }
                }else{
                     longTimeLab.text = [NSString stringWithFormat:@"时长 %@",model[@"node"][@"media_count"]];
                }
                if (longTimeLab.text.length < 7) {
                    longTimeLab.hidden = YES;
                }else{
                    longTimeLab.hidden = NO;
                }
               
          
                if (longTimeLab.text.length < 7) {
                    longTimeLab.hidden = YES;
                    progressLab.frame = CGRectMake(maxX(pic)+30,maxY(titleLab)+5, 120, 20);
                }else{
                    progressLab.frame = CGRectMake(maxX(longTimeLab)+10,maxY(titleLab)+5, 100, 20);
                    longTimeLab.hidden = NO;
                }
                if ([model[@"node"][@"is_free"] isEqualToString:@"1"]) {
                    arrowPic.image = [UIImage imageNamed:@"灰色播放按钮"];
                }else{
                    if ([model[@"node"][@"is_buy"] isEqualToString:@"1"]) {
                        arrowPic.image = [UIImage imageNamed:@"灰色播放按钮"];
                    }else{
                        arrowPic.image = [UIImage imageNamed:@"iOS购买"];
                    }
                    
                }
                if ([model[@"node"][@"learn_status"] isEqualToString:@"1"] ) {//学习状态 0未开始 1学习中 2已学完
                    //                 titleLab.textColor = CNavBgColor;
                    progressLab.text = [NSString stringWithFormat:@"已学习%@%%",model[@"node"][@"learned_ratio"]];
                    titleLab.textColor = [UIColor blackColor];
                    
                    if (classType == 6) {
                        imageView.hidden = YES;
                        pic.hidden = NO;
                        pic.frame =  CGRectMake(55, 17.5, 15, 15);
                        if ([model[@"node"][@"node_status"] isEqualToString:@"0"]) {
                            pic.image = [UIImage imageNamed:@"课程大纲列表-未开始"];
                        }else if ([model[@"node"][@"node_status"] isEqualToString:@"2"]){
                            pic.image = [UIImage imageNamed:@"课程大纲列表-直播中"];
                        }else if ([model[@"node"][@"node_status"] isEqualToString:@"3"]){
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
                }else if([model[@"node"][@"learn_status"] isEqualToString:@"2"]){
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
                    if (classType == 6) {
                        imageView.hidden = YES;
                        pic.hidden = NO;
                        pic.frame =  CGRectMake(55, 17.5, 15, 15);
                        if ([model[@"node"][@"node_status"] isEqualToString:@"0"]) {
                            pic.image = [UIImage imageNamed:@"课程大纲列表-未开始"];
                        }else if ([model[@"node"][@"node_status"] isEqualToString:@"2"]){
                            pic.image = [UIImage imageNamed:@"课程大纲列表-直播中"];
                        }else if ([model[@"node"][@"node_status"] isEqualToString:@"3"]){
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
                if ( [model[@"node"][@"id"] isEqualToString:playID]) {
                    titleLab.textColor = CNavBgColor;
                    if (classType == 6) {
                        imageView.hidden = YES;
                        pic.hidden = NO;
                        pic.frame =  CGRectMake(55, 17.5, 15, 15);
                        if ([model[@"node"][@"node_status"] isEqualToString:@"0"]) {
                            
                            if(playState == PLVVodPlaybackStatePlaying ) {
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
                        }else if ([model[@"node"][@"node_status"] isEqualToString:@"2"]){
                            pic.image = [UIImage imageNamed:@"课程大纲列表-直播中"];
                            titleLab.textColor = [UIColor blackColor];
                        }else if ([model[@"node"][@"node_status"] isEqualToString:@"3"]){
                            
                            if(playState == PLVVodPlaybackStatePlaying ) {
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
                        if(playState == PLVVodPlaybackStatePlaying ) {
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
                if ([model[@"node"][@"is_free"] isEqualToString:@"0"] && [model[@"node"][@"is_buy"] isEqualToString:@"0"]) {
                    arrowPic.image = [UIImage imageNamed:@"iOS购买"];
                }
//                if (isClick) {
//                    if (_isSel && _selIndex == indexPath) {
//                        titleLab.textColor = CNavBgColor;
//
//                        if (classType == 6) {
//                            imageView.hidden = YES;
//                            pic.hidden = NO;
//                            pic.frame =  CGRectMake(55, 17.5, 15, 15);
//                            if ([model[@"node"][@"node_status"] isEqualToString:@"0"]) {
//
//                                if(playState == PLVVodPlaybackStatePlaying ) {
//                                    imageView.frame = CGRectMake(55, 17.5, 15, 15);
//                                    imageView.hidden = NO;
//                                    imageView.image = [YLGIFImage imageNamed:@"播放中动图.gif"];
//                                    pic.hidden = YES;
//                                    arrowPic.image = [UIImage imageNamed:@"暂停按钮"];
//                                }else{
//                                    pic.hidden = NO;
//                                    pic.frame = CGRectMake(55, 17.5, 15, 15);;
//                                    pic.image = [UIImage imageNamed:@"课程大纲列表-未开始"];
//                                    arrowPic.image = [UIImage imageNamed:@"课程详情页大纲播放(1)"];
//                                }
//                            }else if ([model[@"node"][@"node_status"] isEqualToString:@"2"]){
//                                pic.image = [UIImage imageNamed:@"课程大纲列表-直播中"];
//                            }else if ([model[@"node"][@"node_status"] isEqualToString:@"3"]){
//
//                                if(playState == PLVVodPlaybackStatePlaying ) {
//                                    imageView.frame = CGRectMake(55, 17.5, 15, 15);
//                                    imageView.hidden = NO;
//                                    imageView.image = [YLGIFImage imageNamed:@"播放中动图.gif"];
//                                    pic.hidden = YES;
//                                    arrowPic.image = [UIImage imageNamed:@"暂停按钮"];
//                                }else{
//                                    pic.hidden = NO;
//                                    pic.frame = CGRectMake(55, 17.5, 15, 15);;
//                                    pic.image = [UIImage imageNamed:@"直播大纲1-回放"];
//                                    arrowPic.image = [UIImage imageNamed:@"课程详情页大纲播放(1)"];
//                                }
//                            }
//                        }else{
//                            if(playState == PLVVodPlaybackStatePlaying ) {
//                                imageView.frame = CGRectMake(55, 17.5, 15, 15);
//                                imageView.hidden = NO;
//                                imageView.image = [YLGIFImage imageNamed:@"播放中动图.gif"];
//                                pic.hidden = YES;
//                                arrowPic.image = [UIImage imageNamed:@"暂停按钮"];
//                            }else{
//                                pic.hidden = NO;
//                                pic.frame = CGRectMake(55, 17.5, 15, 15);;
//                                pic.image = [UIImage imageNamed:@"上次播放图标"];
//                                arrowPic.image = [UIImage imageNamed:@"课程详情页大纲播放(1)"];
//                            }
//                        }
//
//                    }else{
//                        titleLab.textColor = [UIColor blackColor];
//                        if (classType == 6) {
//                            imageView.hidden = YES;
//                            pic.hidden = NO;
//                            pic.frame =  CGRectMake(55, 17.5, 15, 15);
//                            if ([model[@"node"][@"node_status"] isEqualToString:@"0"]) {
//                                pic.image = [UIImage imageNamed:@"课程大纲列表-未开始"];
//                            }else if ([model[@"node"][@"node_status"] isEqualToString:@"2"]){
//                                pic.image = [UIImage imageNamed:@"课程大纲列表-直播中"];
//                            }else if ([model[@"node"][@"node_status"] isEqualToString:@"3"]){
//                                pic.image = [UIImage imageNamed:@"直播大纲1-回放"];
//                            }
//                        }else{
//                            imageView.hidden = YES;
//                            pic.hidden = NO;
//                            pic.frame = CGRectMake(67, 22, 7, 7);
//                            pic.image = [UIImage imageNamed:@"椭圆5"];
//                        }
//
//                    }
//                }else{
//                    if ([model[@"node"][@"is_open"]isEqualToString:@"1"]) {
//                        pic.frame = CGRectMake(55, 17.5, 15, 15);
//                        pic.image = [UIImage imageNamed:@"上次播放图标"];
//                        titleLab.textColor = CNavBgColor;
//                    }else{
//                        if (classType == 6) {
//                            imageView.hidden = YES;
//                            pic.hidden = NO;
//                            pic.frame =  CGRectMake(55, 17.5, 15, 15);
//                            if ([model[@"node"][@"node_status"] isEqualToString:@"0"]) {
//                                pic.image = [UIImage imageNamed:@"课程大纲列表-未开始"];
//                            }else if ([model[@"node"][@"node_status"] isEqualToString:@"2"]){
//                                pic.image = [UIImage imageNamed:@"课程大纲列表-直播中"];
//                            }else if ([model[@"node"][@"node_status"] isEqualToString:@"3"]){
//                                pic.image = [UIImage imageNamed:@"直播大纲1-回放"];
//                            }
//
//                        }else{
//                            titleLab.textColor = [UIColor blackColor];
//                            pic.frame = CGRectMake(67, 22, 7, 7);
//                            pic.image = [UIImage imageNamed:@"椭圆5"];
//                        }
//                    }
//                }
                if ([[UserDefaultsUtils valueWithKey:@"access_token"] length] !=0 ) {
                    if ([model[@"node"][@"node_status"] isEqualToString:@"3"]){
                        progressLab.hidden = NO;
                    }else{
                        progressLab.hidden = YES;
                    }
                }else{
                    progressLab.hidden = YES;
                }
                
                return cell;
            }else{//章
                cell.backgroundColor = [UIColor whiteColor];
                NSString *titleStr = model[@"node"][@"title"];
                NSString *str =  model[@"node"][@"cn_number"];
                titleLab.text = [NSString stringWithFormat:@"第%@章·%@",str,titleStr];
                pic.image = [UIImage imageNamed:@"课程大纲章节图标"];
                progressLab.hidden = YES;
                longTimeLab.hidden = YES;
                isSeekLab.hidden = YES;
                if ([model[@"node"][@"open"] isEqualToString:@"1"]) {
                    arrowPic.image = [UIImage imageNamed:@"向上图标"];
                }else{
                    arrowPic.image = [UIImage imageNamed:@"向下图标"];
                }
                return cell;
            }
        }else{
            
            if ([model[@"node"][@"node_type"]isEqualToString:@"2"]) {
                NSString *titleStr = model[@"node"][@"title"];
                NSString *str =  model[@"node"][@"cn_number"];
                titleLab.text = [NSString stringWithFormat:@"第%@节·%@",str,titleStr];
                pic.hidden = YES;
                progressLab.hidden = YES;
                longTimeLab.hidden = YES;
                isSeekLab.hidden = YES;
                cell.backgroundColor = CBackgroundColor;
                return cell;
            }else if ([model[@"node"][@"node_type"]isEqualToString:@"3"]){
                cell.backgroundColor = CBackgroundColor;
                NSString *titleStr = model[@"node"][@"title"];
                NSString *str =  model[@"node"][@"number"];
                titleLab.text = [NSString stringWithFormat:@"课时%@·%@",str,titleStr];
                titleLab.frame = CGRectMake(maxX(pic)+30, 15, screenWidth()-100, 20);
                
                
                
                pic.hidden = NO;
                progressLab.hidden = NO;
                longTimeLab.hidden = NO;
                isSeekLab.hidden = YES;
                
//                priceLab.text = [NSString stringWithFormat:@"单课 %@",model[@"node"][@"price"]];
                if (classType == 6) {
                    if ([model[@"node"][@"node_status"] isEqualToString:@"0"]) {
                        
                        longTimeLab.text = [NSString stringWithFormat:@"%@",model[@"node"][@"live_time_text"]];
                    }else if ([model[@"node"][@"node_status"] isEqualToString:@"2"]){
                        
                        longTimeLab.text = [NSString stringWithFormat:@"%@",model[@"node"][@"live_time_text"]];
                    }else if ([model[@"node"][@"node_status"] isEqualToString:@"3"]){
                        
                        longTimeLab.text = [NSString stringWithFormat:@"时长 %@",model[@"node"][@"media_count"]];
                    }
                }else{
                    longTimeLab.text = [NSString stringWithFormat:@"时长 %@",model[@"node"][@"media_count"]];
                }
                if (longTimeLab.text.length < 7) {
                    longTimeLab.hidden = YES;
                }else{
                    longTimeLab.hidden = NO;
                }
                isSeekLab.text = @"123";
                if ([model[@"node"][@"is_free"] isEqualToString:@"1"]) {
                    arrowPic.image = [UIImage imageNamed:@"灰色播放按钮"];
                }else{
                    if ([model[@"node"][@"is_buy"] isEqualToString:@"1"]) {
                        arrowPic.image = [UIImage imageNamed:@"灰色播放按钮"];
                    }else{
                        arrowPic.image = [UIImage imageNamed:@"iOS购买"];
                    }
                }
                
                
                
                arrowPic.frame = CGRectMake(screenWidth()-30, 27.5f, 15, 15);
                if ([model[@"node"][@"learn_status"] isEqualToString:@"1"] ) {//学习状态 0未开始 1学习中 2已学完
                    //                 titleLab.textColor = CNavBgColor;
                    progressLab.text = [NSString stringWithFormat:@"已学习%@%%",model[@"node"][@"learned_ratio"]];
                    titleLab.textColor = [UIColor blackColor];
                    
                    if (classType == 6) {
                        imageView.hidden = YES;
                        pic.hidden = NO;
                        pic.frame =  CGRectMake(55, 17.5, 15, 15);
                        if ([model[@"node"][@"node_status"] isEqualToString:@"0"]) {
                            pic.image = [UIImage imageNamed:@"课程大纲列表-未开始"];
                        }else if ([model[@"node"][@"node_status"] isEqualToString:@"2"]){
                            pic.image = [UIImage imageNamed:@"课程大纲列表-直播中"];
                        }else if ([model[@"node"][@"node_status"] isEqualToString:@"3"]){
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
                }else if([model[@"node"][@"learn_status"] isEqualToString:@"2"]){
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
                    if (classType == 6) {
                        imageView.hidden = YES;
                        pic.hidden = NO;
                        pic.frame =  CGRectMake(55, 17.5, 15, 15);
                        if ([model[@"node"][@"node_status"] isEqualToString:@"0"]) {
                            pic.image = [UIImage imageNamed:@"课程大纲列表-未开始"];
                        }else if ([model[@"node"][@"node_status"] isEqualToString:@"2"]){
                            pic.image = [UIImage imageNamed:@"课程大纲列表-直播中"];
                        }else if ([model[@"node"][@"node_status"] isEqualToString:@"3"]){
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
                
//                if (isClick) {
//                    if (_isSel && _selIndex == indexPath) {
//                        titleLab.textColor = CNavBgColor;
//                        if (classType == 6) {
//                            imageView.hidden = YES;
//                            pic.hidden = NO;
//                            pic.frame =  CGRectMake(55, 17.5, 15, 15);
//                            if ([model[@"node"][@"node_status"] isEqualToString:@"0"]) {
//
//                                if(playState == PLVVodPlaybackStatePlaying ) {
//                                    imageView.frame = CGRectMake(55, 17.5, 15, 15);
//                                    imageView.hidden = NO;
//                                    imageView.image = [YLGIFImage imageNamed:@"播放中动图.gif"];
//                                    pic.hidden = YES;
//                                    arrowPic.image = [UIImage imageNamed:@"暂停按钮"];
//                                }else{
//                                    pic.hidden = NO;
//                                    pic.frame = CGRectMake(55, 17.5, 15, 15);;
//                                    pic.image = [UIImage imageNamed:@"课程大纲列表-未开始"];
//                                    arrowPic.image = [UIImage imageNamed:@"课程详情页大纲播放(1)"];
//                                }
//                            }else if ([model[@"node"][@"node_status"] isEqualToString:@"2"]){
//                                pic.image = [UIImage imageNamed:@"课程大纲列表-直播中"];
//                            }else if ([model[@"node"][@"node_status"] isEqualToString:@"3"]){
//
//                                if(playState == PLVVodPlaybackStatePlaying ) {
//                                    imageView.frame = CGRectMake(55, 17.5, 15, 15);
//                                    imageView.hidden = NO;
//                                    imageView.image = [YLGIFImage imageNamed:@"播放中动图.gif"];
//                                    pic.hidden = YES;
//                                    arrowPic.image = [UIImage imageNamed:@"暂停按钮"];
//                                }else{
//                                    pic.hidden = NO;
//                                    pic.frame = CGRectMake(55, 17.5, 15, 15);;
//                                    pic.image = [UIImage imageNamed:@"直播大纲1-回放"];
//                                    arrowPic.image = [UIImage imageNamed:@"课程详情页大纲播放(1)"];
//                                }
//                            }
//                        }else{
//                            if(playState == PLVVodPlaybackStatePlaying ) {
//                                imageView.frame = CGRectMake(55, 17.5, 15, 15);
//                                imageView.hidden = NO;
//                                imageView.image = [YLGIFImage imageNamed:@"播放中动图.gif"];
//                                pic.hidden = YES;
//                                arrowPic.image = [UIImage imageNamed:@"暂停按钮"];
//                            }else{
//                                pic.hidden = NO;
//                                pic.frame = CGRectMake(55, 17.5, 15, 15);;
//                                pic.image = [UIImage imageNamed:@"上次播放图标"];
//                                arrowPic.image = [UIImage imageNamed:@"课程详情页大纲播放(1)"];
//                            }
//                        }
//                    }else{
//
//                        if (classType == 6) {
//                            imageView.hidden = YES;
//                            pic.hidden = NO;
//                            pic.frame =  CGRectMake(55, 17.5, 15, 15);
//                            if ([model[@"node"][@"node_status"] isEqualToString:@"0"]) {
//                                pic.image = [UIImage imageNamed:@"课程大纲列表-未开始"];
//                            }else if ([model[@"node"][@"node_status"] isEqualToString:@"2"]){
//                                pic.image = [UIImage imageNamed:@"课程大纲列表-直播中"];
//                            }else if ([model[@"node"][@"node_status"] isEqualToString:@"3"]){
//                                pic.image = [UIImage imageNamed:@"直播大纲1-回放"];
//                            }
//                        }else{
//                            titleLab.textColor = [UIColor blackColor];
//                            imageView.hidden = YES;
//                            pic.hidden = NO;
//                            pic.frame = CGRectMake(67, 22, 7, 7);
//                            pic.image = [UIImage imageNamed:@"椭圆5"];
//                        }
//                    }
//                }else
//                {
//                    if ([model[@"node"][@"is_open"]isEqualToString:@"1"]) {
//                        pic.frame = CGRectMake(55, 17.5, 15, 15);
//                        pic.image = [UIImage imageNamed:@"上次播放图标"];
//                        titleLab.textColor = CNavBgColor;
//                    }else{
//                        if (classType == 6) {
//                            imageView.hidden = YES;
//                            pic.hidden = NO;
//                            pic.frame =  CGRectMake(55, 17.5, 15, 15);
//                            if ([model[@"node"][@"node_status"] isEqualToString:@"0"]) {
//                                pic.image = [UIImage imageNamed:@"课程大纲列表-未开始"];
//                            }else if ([model[@"node"][@"node_status"] isEqualToString:@"2"]){
//                                pic.image = [UIImage imageNamed:@"课程大纲列表-直播中"];
//                            }else if ([model[@"node"][@"node_status"] isEqualToString:@"3"]){
//                                pic.image = [UIImage imageNamed:@"直播大纲1-回放"];
//                            }
//                        }else{
//                            titleLab.textColor = [UIColor blackColor];
//                            pic.frame = CGRectMake(67, 22, 7, 7);
//                            pic.image = [UIImage imageNamed:@"椭圆5"];
//                        }
//                    }
//                }
                if (playID == model[@"node"][@"id"]) {
                    titleLab.textColor = CNavBgColor;
                    if (classType == 6) {
                        imageView.hidden = YES;
                        pic.hidden = NO;
                        pic.frame =  CGRectMake(55, 17.5, 15, 15);
                        if ([model[@"node"][@"node_status"] isEqualToString:@"0"]) {
                            
                            if(playState == PLVVodPlaybackStatePlaying ) {
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
                        }else if ([model[@"node"][@"node_status"] isEqualToString:@"2"]){
                            pic.image = [UIImage imageNamed:@"课程大纲列表-直播中"];
                            titleLab.textColor = [UIColor blackColor];
                        }else if ([model[@"node"][@"node_status"] isEqualToString:@"3"]){
                            
                            if(playState == PLVVodPlaybackStatePlaying ) {
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
                        if(playState == PLVVodPlaybackStatePlaying ) {
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
//                else{
//                    if (classType == 6) {
//                        imageView.hidden = YES;
//                        pic.hidden = NO;
//                        pic.frame =  CGRectMake(55, 17.5, 15, 15);
//                        if ([model[@"node"][@"node_status"] isEqualToString:@"0"]) {
//                            pic.image = [UIImage imageNamed:@"课程大纲列表-未开始"];
//                        }else if ([model[@"node"][@"node_status"] isEqualToString:@"2"]){
//                            pic.image = [UIImage imageNamed:@"课程大纲列表-直播中"];
//                        }else if ([model[@"node"][@"node_status"] isEqualToString:@"3"]){
//                            pic.image = [UIImage imageNamed:@"直播大纲1-回放"];
//                        }
//                    }else{
//                        titleLab.textColor = [UIColor blackColor];
//                        imageView.hidden = YES;
//                        pic.hidden = NO;
//                        pic.frame = CGRectMake(67, 22, 7, 7);
//                        pic.image = [UIImage imageNamed:@"椭圆5"];
//
//                    }
//                }
                if ([model[@"node"][@"is_free"] isEqualToString:@"0"] && [model[@"node"][@"is_buy"] isEqualToString:@"0"]) {
                    arrowPic.image = [UIImage imageNamed:@"iOS购买"];
                }
                if ([[UserDefaultsUtils valueWithKey:@"access_token"] length] !=0 ) {
                    if ([model[@"node"][@"node_status"] isEqualToString:@"3"]){
                        progressLab.hidden = NO;
                    }else{
                        progressLab.hidden = YES;
                    }
                }else{
                    progressLab.hidden = YES;
                }
                return cell;
            }else{
                NSString *titleStr = model[@"node"][@"title"];
                NSString *str =  model[@"node"][@"cn_number"];
                titleLab.text = [NSString stringWithFormat:@"第%@章·%@",str,titleStr];
                pic.hidden = YES;
                progressLab.hidden = YES;
                longTimeLab.hidden = YES;
                isSeekLab.hidden = YES;
                cell.backgroundColor = [UIColor whiteColor];
                return cell;
            }
            
        }

    }else{
        CourseCatalogTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CourseCatalogTableViewCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.btn.hidden = YES;
        cell.arrow.frame = CGRectMake(screenWidth()-40, 25, 20, 20);
        cell.titleLab.font = [UIFont systemFontOfSize:13];
        cell.titleLab.text = self.listAry[indexPath.section][indexPath.row][@"title"];
        if ([self.sectionAry[indexPath.section] isEqualToString:@"直播列表"]) {
            cell.arrow.image = [UIImage imageNamed:@"套餐大纲播放(1)拷贝"];
            cell.scoreLab.text = [NSString stringWithFormat:@"课时 %@",self.listAry[indexPath.section][indexPath.row][@"lesson_num"]];
            cell.numberLab.text = [NSString stringWithFormat:@"单价 %@",self.listAry[indexPath.section][indexPath.row][@"discount_price"]];
            cell.isMakeLab.text = [NSString stringWithFormat:@"开课时间:%@",[BaseTools getLiveDateStringWithTimeStr: self.listAry[indexPath.section][indexPath.row][@"live_start_time"]]];
            cell.pic.image = [UIImage imageNamed:@"详情页直播"];
            cell.isMakeLab.hidden = NO;
        }else if ([self.sectionAry[indexPath.section] isEqualToString:@"课程列表"]) {
            cell.arrow.image = [UIImage imageNamed:@"套餐大纲播放(1)拷贝"];
            cell.scoreLab.text = [NSString stringWithFormat:@"课时 %@",self.listAry[indexPath.section][indexPath.row][@"lesson_num"]];
            cell.numberLab.text = [NSString stringWithFormat:@"单价 %@",self.listAry[indexPath.section][indexPath.row][@"discount_price"]];
            cell.pic.image = [UIImage imageNamed:@"详情页课时"];
            cell.isMakeLab.hidden = YES;
        }else if ([self.sectionAry[indexPath.section] isEqualToString:@"题库列表"]) {
            cell.arrow.image = [UIImage imageNamed:@"套餐试卷答题图标"];
            cell.pic.image = [UIImage imageNamed:@"详情页试卷"];
            cell.scoreLab.text = [NSString stringWithFormat:@"试卷 %@",self.listAry[indexPath.section][indexPath.row][@"testpaper_num"]];
            cell.numberLab.text = [NSString stringWithFormat:@"单价 %@",self.listAry[indexPath.section][indexPath.row][@"discount_price"]];
            cell.isMakeLab.hidden = YES;
        }else if ([self.sectionAry[indexPath.section] isEqualToString:@"图书列表"]) {
            cell.arrow.image = [UIImage imageNamed:@"套餐图书图标"];
            cell.pic.image = [UIImage imageNamed:@"详情页-tushu"];
            cell.scoreLab.hidden = YES;
            cell.numberLab.text = [NSString stringWithFormat:@"单价 %@",self.listAry[indexPath.section][indexPath.row][@"discount_price"]];
            cell.isMakeLab.hidden = YES;
        }else{
            
        }
        return cell;
    }

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    if (classType == 1) {
        if ([testIsClick isEqualToString:@"0"]) {
            NSDictionary *model = [self.countArray objectAtIndex:indexPath.row];
            NSMutableDictionary *parmDic = [NSMutableDictionary dictionary];
            [parmDic setObject:model[@"exam_id"] forKey:@"exam_id"];
            [ZMNetworkHelper POST:@"/exam/is_buy_exam" parameters:parmDic cache:YES responseCache:^(id responseCache) {
                
            } success:^(id responseObject) {
                if (responseObject == nil) {
                    
                }else{
                    if ([responseObject[@"code"] isEqualToString:@"0"]) {
                        dispatch_async(dispatch_get_main_queue(), ^{
   
                            ExamWebViewController *vc = [[ExamWebViewController alloc]init];
                            vc.url =[NSString stringWithFormat:@"%@%@",SERVER_HOSTM,model[@"url"]];
                            [[[AppDelegate shareAppDelegate] getCurrentUIVC].navigationController pushViewController:vc animated:YES];
                        });
                        
                    }else{
                        
                        [BaseTools showErrorMessage:responseObject[@"msg"]];
                    }
                }
                
            } failure:^(NSError *error) {
                
            }];
        }else if ([testIsClick isEqualToString:@"1"]){
            [BaseTools showErrorMessage:@"大联考还未开始～"];
        }else if ([testIsClick isEqualToString:@"2"]){
            [BaseTools showErrorMessage:@"大联考已经结束～"];
        }
        
       
    }
    if (classType == 3 || classType == 6) {

        
        NSDictionary *model = [self.countArray objectAtIndex:indexPath.row];
        dict1 = model;
        if ([model[@"open"] boolValue]) {
            [self deleteData:model[@"children"]];
        }else{
            self.rowCount = indexPath.row;
            [self insertData:model[@"children"]];
        }
        if ([model[@"open"] boolValue]) {
            [model setValue:@"0" forKey:@"open"];
        }else{
            [model setValue:@"1" forKey:@"open"];
        }
        
        if ([model[@"node"][@"node_type"]isEqualToString:@"3"]){

            if ([model[@"node"][@"is_free"] isEqualToString:@"1"]) {

                if (self.myBlock) {
                    self.myBlock(model[@"node"][@"id"]);
                }
            }else{
                if ([model[@"node"][@"is_buy"] isEqualToString:@"1"]) {

                    if (self.myBlock) {
                        self.myBlock(model[@"node"][@"id"]);
                    }
                }else{
                    if ([self.courseInfoDict[@"is_sell"] isEqualToString:@"0"]) {
                        [BaseTools showErrorMessage:@"暂不支持购买"];
                    }else{
                        TIDeliveryView *deliveryView = [[TIDeliveryView alloc]initWithFrame:CGRectMake(30, 100, screenWidth()-60, 160) title:self.courseInfoDict[@"title"] price:[NSString stringWithFormat:@"课程价格：%@",self.courseInfoDict[@"discount_price"]]];
                        [deliveryView.allPrice addTarget:self action:@selector(allCoursePay) forControlEvents:(UIControlEventTouchUpInside)];
                        [deliveryView.onePrice addTarget:self action:@selector(oneCoursePay) forControlEvents:(UIControlEventTouchUpInside)];
                        [SGBrowserView showZoomView:deliveryView yDistance:20];
                    }
                }
            }
        }
        [self.tableView reloadData];
        state = 0;
    }
    if (classType == 5) {
        if ([self.sectionAry[indexPath.section] isEqualToString:@"课程列表"]) {
            KPostNotification(@"SetMealCourse", self.listAry[indexPath.section][indexPath.row]);
        }else if ([self.sectionAry[indexPath.section] isEqualToString:@"题库列表"]) {
            KPostNotification(@"SetMealExams", self.listAry[indexPath.section][indexPath.row]);
        }else if ([self.sectionAry[indexPath.section] isEqualToString:@"图书列表"]) {
            KPostNotification(@"SetMealBooks", self.listAry[indexPath.section][indexPath.row]);
        }else if ([self.sectionAry[indexPath.section] isEqualToString:@"直播列表"]) {
            KPostNotification(@"SetMealLives", self.listAry[indexPath.section][indexPath.row]);
        }
    }
}
- (void)oneCoursePay{
    [SGBrowserView hide];
//    PayMentViewController *vc = [[PayMentViewController alloc]init];
//    vc.goodID = dict1[@"node"][@"id"];
//    vc.goodType = @"2";
//    [[[AppDelegate shareAppDelegate] getCurrentUIVC].navigationController pushViewController:vc animated:YES];
    
}
- (void)allCoursePay{
    [SGBrowserView hide];
    PayMentViewController *vc = [[PayMentViewController alloc]init];
    if (dict1[@"node"][@"distribute"] == nil) {
        vc.dist_id = @"0";
    }
    
    if (classType == 6) {
        vc.goodID = dict1[@"node"][@"live_id"];

    }else{
        vc.goodID = dict1[@"node"][@"course_id"];

    }

    vc.goodType = [NSString stringWithFormat:@"%ld",classType];
    [[[AppDelegate shareAppDelegate] getCurrentUIVC].navigationController pushViewController:vc animated:YES];
    
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if (classType == 5) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenWidth(), 30)];
        view.backgroundColor = CBackgroundColor;
        UIView *redView = [[UIView alloc]initWithFrame:CGRectMake(17.5, 12.5, 5, 20)];
        redView.backgroundColor = CNavBgColor;
        [view addSubview:redView];
        UILabel *titleLab1 = [[UILabel alloc]initWithFrame:CGRectMake(maxX(redView)+5, 7.5, 120, 30)];
 
        titleLab1.text = self.sectionAry[section];
        
        titleLab1.font = [UIFont systemFontOfSize:14];
        [view addSubview:titleLab1];
        return view;
    }else{
        return [UIView new];
    }
    
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (classType == 5) {
        return 45;
    }else{
        return 0;
    }
}

//cell显示
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (classType == 3 || classType == 6) {
        if (self.countArray.count>indexPath.row && state == 1) {
            for (NSInteger i = indexPath.row ; i>=0; i--) {
                NSDictionary *model = [self.countArray objectAtIndex:indexPath.row];
                if (model[@"open"]) {
                    self.label.hidden = NO;
                    self.label.text = model[@"node"][@"title"];
                    return;
                }
            }
            self.label.hidden = YES;
        }
//        NSDictionary *model = [self.countArray objectAtIndex:indexPath.row];
//        NSLog(@"加载完成！！！");
//        if ([model[@"open"] isEqualToString:@"1"]) {
//            if([indexPath row] == ((NSIndexPath*)[[tableView indexPathsForVisibleRows] lastObject]).row){
//
//
//                dispatch_async(dispatch_get_main_queue(),^{
//
//                    [self tableView:self.tableView didSelectRowAtIndexPath:indexPath];
//
//
//                });
//
//
//            }
//        }
//
        

    }
    
}

//cell消失
- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath*)indexPath NS_AVAILABLE_IOS(6_0) {
    if(classType == 3){
        if (self.countArray.count>indexPath.row && state == 2) {
            NSDictionary *model = [self.countArray objectAtIndex:indexPath.row];
            if(model[@"open"]) {
                self.label.hidden = NO;
                self.label.text = model[@"node"][@"title"];
            }
        }
    }
    
}

//收起所有子节点
- (void)deleteData:(NSMutableArray *)array {
    for (int i = 0; i<array.count; i++) {
        NSDictionary *model = [array objectAtIndex:i];
        if ([model[@"children"] count]>0) {
            [self deleteData:model[@"children"]];
        }
        [self.countArray removeObject:model];
    }
    
}

//展开所有子节点
- (void)insertData:(NSMutableArray *)array {
    for (int i = 0; i<array.count; i++) {
        NSDictionary *model = [array objectAtIndex:i];
        self.rowCount++;
        [self.countArray insertObject:model atIndex:self.rowCount];
        if ([model[@"children"] count]>0) {
            [self insertData:model[@"children"]];
        }
    }

 
}

////cell显示
//- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
//
//    if (classType == 3) {
//        if (self.countArray.count>indexPath.row && state == 1) {
//            for (NSInteger i = indexPath.row ; i>=0; i--) {
//                NSDictionary *model = [self.countArray objectAtIndex:indexPath.row];
//                if (model[@"node"][@"is_open"]) {
//                    self.label.hidden = NO;
//                    self.label.text = model[@"node"][@"title"];
//                    return;
//                }
//            }
//            self.label.hidden = YES;
//        }
//    }
//
//}
//
////cell消失
//- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath*)indexPath NS_AVAILABLE_IOS(6_0) {
//    if(classType == 3){
//        if (self.countArray.count>indexPath.row && state == 2) {
//            NSDictionary *model = [self.countArray objectAtIndex:indexPath.row];
//            if(model[@"node"][@"is_open"]) {
//                self.label.hidden = NO;
//                self.label.text = model[@"node"][@"title"];
//            }
//        }
//    }
//
//}
//
////收起所有子节点
//- (void)deleteData:(NSMutableArray *)array {
//    for (int i = 0; i<array.count; i++) {
//       NSDictionary *model = [array objectAtIndex:i];
//        if ([model[@"children"] count]>0) {
//            [self deleteData:model[@"children"]];
//        }
//        [self.countArray removeObject:model];
//    }
//
//}
//
////展开所有子节点
//- (void)insertData:(NSMutableArray *)array {
//    for (int i = 0; i<array.count; i++) {
//        NSDictionary *model = [array objectAtIndex:i];
//        self.rowCount++;
//        [self.countArray insertObject:model atIndex:self.rowCount];
//        if ([model[@"children"] count]>0 && [model[@"node"][@"is_open"] isEqualToString:@"1"]) {
//            [self insertData:model[@"children"]];
//        }
//    }
//}

@end

