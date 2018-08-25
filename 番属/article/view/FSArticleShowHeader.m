//
//  FSArticleShowHeader.m
//  番属
//
//  Created by 王佳苗 on 2018/8/24.
//  Copyright © 2018年 王佳苗. All rights reserved.
//

#import "FSArticleShowHeader.h"
#import "FSArticle.h"
#import <Masonry.h>
#import <UIImageView+WebCache.h>
@interface FSArticleShowHeader()
@property(nonatomic,strong)UIImageView *coverImgView;
@property(nonatomic,strong)UILabel *titleLabel;
@end
@implementation FSArticleShowHeader

-(instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if(self){
        self.backgroundColor=FSBackgroundColor;
        
        _coverImgView=[[UIImageView alloc]init];
        _coverImgView.contentMode = UIViewContentModeScaleAspectFill;
        _coverImgView.clipsToBounds=YES;
        [self addSubview:_coverImgView];
        [_coverImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self);
            make.width.equalTo(self);
            make.centerX.equalTo(self);
            make.height.mas_equalTo(170);
        }];
        
        _titleLabel=[[UILabel alloc]init];
        _titleLabel.font=[UIFont boldSystemFontOfSize:18];
        [self addSubview:_titleLabel];
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).mas_offset(10);
            make.bottom.equalTo(self).mas_offset(-10);
        }];

        
    }
    return self;
}
-(void)setArticle:(FSArticle *)article{
    self.titleLabel.text=article.title;
    [self.coverImgView sd_setImageWithURL:[NSURL URLWithString:article.headerImg] placeholderImage:[UIImage imageNamed:@""]];
    
}
@end
