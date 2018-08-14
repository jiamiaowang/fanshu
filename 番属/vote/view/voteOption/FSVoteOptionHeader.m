//
//  FSVoteOptionHeader.m
//  番属
//
//  Created by 王佳苗 on 2018/7/18.
//  Copyright © 2018年 王佳苗. All rights reserved.
//

#import "FSVoteOptionHeader.h"
#import <Masonry.h>
@interface FSVoteOptionHeader()
@property(nonatomic,strong)UILabel *titleLabel;
@end
@implementation FSVoteOptionHeader

-(instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if(self){
        UIImageView *imageView=[[UIImageView alloc]init];
        imageView.image=[UIImage imageNamed:@"Main_voteImage"];
        [self addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).mas_offset(10);
            make.centerY.equalTo(self);
            make.width.mas_equalTo(20);
            make.height.mas_equalTo(20);

        }];
        
        _titleLabel=[[UILabel alloc]init];
        _titleLabel.textColor=FSThemeColor;
        [self addSubview:_titleLabel];
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(imageView.mas_right).mas_offset(5);
            make.centerY.equalTo(self);
        }];
        self.backgroundColor=[UIColor clearColor];
        
    }
    return self;
}
-(void)setTitle:(NSString *)title{
    _title=title;
    self.titleLabel.text=title;
}
//画线
- (void)drawRect:(CGRect)rect

{
    
    //获得处理的上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    //指定直线样式
    CGContextSetLineCap(context, kCGLineCapSquare);
    //直线宽度
    CGContextSetLineWidth(context, 2.0);
    //设置颜色  RGB(149, 75, 88)
    CGContextSetRGBStrokeColor(context, 149/255.0, 75/255.0, 88/255.0, 1.0);
    //开始绘制
    CGContextBeginPath(context);
    //画笔移动到点(31,170)
    CGContextMoveToPoint(context, 10, self.bounds.size.height);
    //下一点
    CGContextAddLineToPoint(context, self.bounds.size.width-10, self.bounds.size.height);
    //下一点
//    CGContextAddLineToPoint(context, 159, 148);
    //绘制完成
    CGContextStrokePath(context);
    
}


@end
