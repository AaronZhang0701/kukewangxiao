//
//  CourseCatalogView.h
//  KukeApp
//
//  Created by iOSDeveloper on 2018/10/1.
//  Copyright © 2018年 zhangming. All rights reserved.
//

#import "CourseDetailListBaseView.h"
typedef void(^CourseVideoIdActionBlock)(NSString *ID);
typedef void(^coursePlayStateBlock)();
@interface CourseCatalogView : CourseDetailListBaseView
- (void)getCourseID:(NSString *)ID withClass:(NSInteger)classID;
@property (nonatomic ,copy) CourseVideoIdActionBlock myBlock;
@property (nonatomic ,copy) coursePlayStateBlock playStateBlock;
//@property (nonatomic ,copy) LiveBlock liveBlock;
@property (nonatomic ,strong) NSString *isDaliankao;
@property (nonatomic ,strong) NSString *play_id;
@property (strong, nonatomic) NSString *clickVideoID;
@property (nonatomic ,strong) NSDictionary *courseDict;
@property (nonatomic, assign) PLVVodPlaybackState myPlayBackState;
@end
