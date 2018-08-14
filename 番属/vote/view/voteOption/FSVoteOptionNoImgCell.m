//
//  FSVoteOptionNoImgCell.m
//  番属
//
//  Created by 王佳苗 on 2018/8/6.
//  Copyright © 2018年 王佳苗. All rights reserved.
//

#import "FSVoteOptionNoImgCell.h"
#import <Masonry.h>
#import "FSVoteOptions.h"
@interface FSVoteOptionNoImgCell()
@property(nonatomic,strong)UILabel *name;
@end
@implementation FSVoteOptionNoImgCell
//设置选中选中
-(void)setSelected:(BOOL)selected {
    if (selected) {
        self.backgroundColor = FSThemeColor;
    } else {
        self.backgroundColor = [UIColor whiteColor];
    }
}

-(instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if(self){
        _name=[[UILabel alloc]init];
        _name.font=[UIFont systemFontOfSize:15];
        [self addSubview:_name];
        [_name mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self);
        }];
        self.selectedBackgroundView.backgroundColor=[UIColor orangeColor];
        self.backgroundColor=[UIColor whiteColor];
        self.layer.cornerRadius=6.0;
        self.layer.masksToBounds=YES;
        
    }
    return self;
}
-(void)setOption:(FSVoteOptions *)option{
    _option=option;
    self.name.text=option.name;
}
@end
