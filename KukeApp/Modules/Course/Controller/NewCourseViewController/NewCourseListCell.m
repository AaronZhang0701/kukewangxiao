//
//  GridListCollectionViewCell.m
//  Grid-List
//
//  Created by LeeJay on 16/10/17.
//  Copyright © 2016年 Mob. All rights reserved.
//  代码下载地址https://github.com/leejayID/List2Grid

#import "NewCourseListCell.h"


#define ScreenWidth ([UIScreen mainScreen].bounds.size.width)

@interface NewCourseListCell ()

@property (nonatomic, strong) UIImageView *imageV;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) UILabel *describeLabel;
@end

@implementation NewCourseListCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self configureUI];
    }
    return self;
}

- (void)configureUI
{
    _imageV = [[UIImageView alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:_imageV];
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _titleLabel.numberOfLines = 0;
    
    _titleLabel.text = @"asd";
    [self.contentView addSubview:_titleLabel];
    
    _priceLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _priceLabel.textColor = [UIColor redColor];
    [self.contentView addSubview:_priceLabel];
    

    _describeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _describeLabel.textColor = [UIColor colorWithHexString:@"#8A8A8A"];
    _describeLabel.font = [UIFont systemFontOfSize:10];
    [self.contentView addSubview:_describeLabel];
}

- (void)setIsGrid:(BOOL)isGrid
{
    _isGrid = isGrid;
    
    if (isGrid) {//grid
        _imageV.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.width*0.67);
        _titleLabel.frame = CGRectMake(10,maxY(_imageV)+8,self.bounds.size.width-20, 35);
        _priceLabel.frame = CGRectMake(10, maxY(_titleLabel)+23, self.bounds.size.width-20, 15);
        _describeLabel.frame = CGRectMake(10, maxY(_priceLabel)+5, self.bounds.size.width-20, 8);
        self.layer.cornerRadius = 5;
        _imageV.layer.cornerRadius = 0;
        [_imageV addRoundedCorners:UIRectCornerTopLeft | UIRectCornerTopRight withRadii:CGSizeMake(5.0, 5.0)];
//        self.layer.masksToBounds = YES;
//        [self addRoundedCorners:UIRectCornerAllCorners withRadii:CGSizeMake(5.0, 5.0)];
        
        _titleLabel.font = [UIFont systemFontOfSize:13];
    } else {//list
        _imageV.frame = CGRectMake(15, 15, 141, 94);
        _titleLabel.frame = CGRectMake(maxX(_imageV)+10, 15, screenWidth()-141 - 35, 35);
        _priceLabel.frame = CGRectMake(maxX(_imageV)+10, maxY(_titleLabel)+30, 150, 15);
        _describeLabel.frame = CGRectMake(maxX(_imageV)+10, maxY(_priceLabel)+6, 200, 10);
        _imageV.layer.cornerRadius = 5;
        _titleLabel.font = [UIFont systemFontOfSize:14];
        _imageV.layer.masksToBounds = YES;
    }
}

- (void)setModel:(NewCourseListDataAryModel *)model{
    [_imageV sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",model.goods_img]] placeholderImage:[UIImage imageNamed:@"goodsImage"]];
    
    _titleLabel.text = model.goods_title;
//    if ([model.goods_type isEqualToString:@"4"]) {
//        _imageV.frame = CGRectMake((138-95/3*2)/2, 14, 138/3*2,95);
//    }else{
//        _imageV.frame = CGRectMake(8, 14, 138, 95);
//    }

    
    NSString *price = model.goods_discount_price;
    NSString *market_price = model.goods_price;
    
    
    NSMutableAttributedString * ma_price = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@   %@",price,market_price]];
    [ma_price addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(0, price.length)];
    [ma_price addAttribute:NSForegroundColorAttributeName value:CNavBgColor range:NSMakeRange(0,  price.length)];
    
    [ma_price addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:10] range:NSMakeRange( price.length+3,  market_price.length)];
    [ma_price addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#8A8A8A"] range:NSMakeRange( price.length+3,  market_price.length)];
    
    [ma_price addAttributes:@{NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle], NSBaselineOffsetAttributeName : @(NSUnderlineStyleSingle)} range:NSMakeRange(price.length+3,  market_price.length)];
    
    
    _priceLabel.attributedText = ma_price;
    
    if ([model.goods_type isEqualToString:@"1"]) {
        self.describeLabel.text = [NSString stringWithFormat:@"%@套试卷    随到随学",model.testpaper_num];
    }else if ([model.goods_type isEqualToString:@"3"]){
        self.describeLabel.text = [NSString stringWithFormat:@"%@个课时    随到随学",model.lesson_num];
    }else if ([model.goods_type isEqualToString:@"4"]){
        self.describeLabel.text = [NSString stringWithFormat:@"已售%@本",model.student_num];
    }else if ([model.goods_type isEqualToString:@"5"]){
        NSMutableArray *ary = [NSMutableArray array];
        if ([model.live_num integerValue]>0) {
            [ary addObject:[NSString stringWithFormat:@"%@个直播",model.live_num]];
        }
        if ([model.course_num integerValue]>0) {
            [ary addObject:[NSString stringWithFormat:@"%@个课程",model.course_num]];
        }
        if ([model.exam_num integerValue]>0) {
            [ary addObject:[NSString stringWithFormat:@"%@套题库",model.exam_num]];
        }
        if ([model.book_num integerValue]>0) {
            [ary addObject:[NSString stringWithFormat:@"%@本图书",model.book_num] ];
            
        }
        if (ary.count == 0) {
            self.describeLabel.hidden = YES;
        }else{
            self.describeLabel.hidden = NO;
            NSString *text = [ary componentsJoinedByString:@"  "];
            self.describeLabel.text = text;
        }
    }
    
    
}

//- (void)setModel:(GridListModel *)model
//{
//    _model = model;
//
//    [_imageV sd_setImageWithURL:[NSURL URLWithString:model.imageurl]];
//    _titleLabel.text = model.wname;
//    _priceLabel.text = [NSString stringWithFormat:@"￥%.2f",model.jdPrice];
//}
//     //自定义 cell 中,要实现这个功能。
//
//    - (void)setSelected:(BOOL)selected{
//
//            [super setSelected:selected];
//
//            if(selected) {
//
//                    self.templateTitle.backgroundColor = kCommonBGColor;
//
//                    self.templateTitle.textColor = JSColor_16(@"FFFFFF");
//
//                   self.templateSelectedImage.hidden  = NO;
//
//               }else{
//
//                        self.templateTitle.textColor = JSColor_16(@"666666");
//
//                        self.templateTitle.backgroundColor = JSColor_16(@"FFFFFF");
//
//                        self.templateSelectedImage.hidden  = YES;
//
//                   }
//
//}
@end
