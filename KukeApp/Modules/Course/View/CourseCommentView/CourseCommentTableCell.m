//
//  CourseCommentTableCell.m
//  KukeApp
//
//  Created by iOSDeveloper on 2018/10/15.
//  Copyright © 2018年 zhangming. All rights reserved.
//

#import "CourseCommentTableCell.h"
#import "LEEStarRating.h"
@interface  CourseCommentTableCell(){
    
}
@property(nonatomic,strong) LEEStarRating *ratingView;
@end


@implementation CourseCommentTableCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // 初始化子视图
        [self addSubview:self.headerImage];
        [self addSubview:self.nameLab];
        [self addSubview:self.timeLab];
        [self addSubview:self.contentLab];
        [self addSubview:self.replyView];
        [self addSubview:self.ratingView];
        [self.replyView addSubview:self.replyNameLab];
        [self.replyView addSubview:self.replyContentLab];
        [self.replyView addSubview:self.replyTimeLab];
    }
    return self;
}

- (UIImageView *)headerImage
{
    if (!_headerImage) {
        _headerImage = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 40, 40)];
        _headerImage.layer.cornerRadius = 20.0f;
        _headerImage.layer.masksToBounds = YES;
    }
    return _headerImage;
}

-(UILabel *)nameLab {
    
    if (!_nameLab) {
        _nameLab = [[UILabel alloc]initWithFrame:CGRectMake(maxX(self.headerImage)+10, 10, 100, 25)];
        _nameLab.font = [UIFont systemFontOfSize:15];
    }
    return _nameLab;
}
- (UIView *)ratingView{
    if (!_ratingView) {
        _ratingView = [[LEEStarRating alloc] initWithFrame:CGRectMake(maxX(_nameLab),10, 120, 30) Count:5]; //初始化并设置frame和个数
        
        _ratingView.spacing = 7.0f; //间距
        
        _ratingView.checkedImage = [UIImage imageNamed:@"我的订单评价黄色星星"]; //选中图片
        
        _ratingView.uncheckedImage = [UIImage imageNamed:@"填写评价灰色星星"]; //未选中图片
        
        _ratingView.type = RatingTypeWhole; //评分类型
        
        _ratingView.touchEnabled = YES; //是否启用点击评分 如果纯为展示则不需要设置
        
        _ratingView.slideEnabled = YES; //是否启用滑动评分 如果纯为展示则不需要设置
        
        _ratingView.maximumScore = 5.0f; //最大分数
        
        _ratingView.minimumScore = 0.0f; //最小分数
    }
    return _ratingView;
}
- (UILabel *)timeLab{
    if (!_timeLab) {
        _timeLab = [[UILabel alloc]initWithFrame:CGRectMake(maxX(self.headerImage)+10, maxY(self.nameLab), 150, 15)];
        _timeLab.font = [UIFont systemFontOfSize:13];
        _timeLab.textColor = [UIColor lightGrayColor];
    }
    return _timeLab;
}
- (UILabel *)contentLab{
    if (!_contentLab) {
        _contentLab = [[UILabel alloc]initWithFrame:CGRectMake(maxX(self.headerImage)+10, maxY(self.headerImage)+15, screenWidth()-100, 50)];
        _contentLab.font = [UIFont systemFontOfSize:15];
        _contentLab.numberOfLines = 0;
    }
    return _contentLab;
}
- (UIView *)replyView{
    if (!_replyView) {
        _replyView = [[UIView alloc]initWithFrame:CGRectMake(0, maxY(self.contentLab)+20, screenWidth(), 30)];
        _replyView.backgroundColor = CBackgroundColor;
    }
    return _replyView;
}
- (UILabel *)replyNameLab{
    
    if (!_replyNameLab) {
        _replyNameLab = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 100, 30)];
        _replyNameLab.text = @"库课回复：";
        _replyNameLab.textColor = CNavBgColor;
        _replyNameLab.font = [UIFont systemFontOfSize:15];
    }
    return _replyNameLab;
}
-(UILabel *)replyContentLab{
    if (!_replyContentLab) {
        _replyContentLab = [[UILabel alloc]initWithFrame:CGRectMake(maxX(self.replyNameLab), 10, screenWidth()-90, 30)];
        _replyContentLab.font = [UIFont systemFontOfSize:15];
        _replyContentLab.numberOfLines = 0;
    }
    return _replyContentLab;
}
- (UILabel *)replyTimeLab{
    
    if (!_replyTimeLab) {
        _replyTimeLab = [[UILabel alloc]initWithFrame:CGRectMake(maxX(self.replyNameLab),maxY(self.replyContentLab)+5, 150, 15)];
        _replyTimeLab.font = [UIFont systemFontOfSize:13];
        _replyTimeLab.textColor = [UIColor lightGrayColor];
    }
    return _replyTimeLab;
}
- (void)setModel:(CourseCommentListModel *)model{
    [self.headerImage sd_setImageWithURL:[NSURL URLWithString:model.img] placeholderImage:[UIImage imageNamed:@"个人中心未登录头像"]];
    self.nameLab.text = model.stu_name;
    self.timeLab.text = model.add_time;
    self.contentLab.frame = CGRectMake(maxX(self.headerImage)+10, maxY(self.headerImage)+15, screenWidth()-100, [model.content zm_getTextHeight:[UIFont systemFontOfSize:15] width:screenWidth()-100]);
    self.contentLab.text = model.content;
    self.replyNameLab.text = @"库课网校客服:";
    self.replyContentLab.text = model.reply;
    self.replyContentLab.frame = CGRectMake(maxX(self.replyNameLab), 10, screenWidth()-90, [model.reply zm_getTextHeight:[UIFont systemFontOfSize:15] width:screenWidth()-90]+10);
    self.replyTimeLab.text = model.reply_time;
    self.replyView.frame = CGRectMake(0, maxY(self.contentLab)+10, screenWidth(), [model.reply zm_getTextHeight:[UIFont systemFontOfSize:15] width:screenWidth()-90]+45);
    if (model.reply.length ==0) {
        self.replyView.hidden = YES;
    }else{
        self.replyView.hidden = NO;
    }
     _ratingView.currentScore = [model.kuke_star integerValue];
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
