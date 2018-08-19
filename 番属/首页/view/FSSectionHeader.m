//
//  FSSectionHeader.m
//  番属
//
//  Created by 王佳苗 on 2018/7/13.
//  Copyright © 2018年 王佳苗. All rights reserved.
//

#import "FSSectionHeader.h"
#import "UIButton+Extension.h"
#import <Masonry.h>
@interface FSSectionHeader()
@property(nonatomic,strong)UIButton *moreButton;
@property(nonatomic,strong)UILabel *labelTitle;
@end
@implementation FSSectionHeader
-(instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if(self){
        _moreButton=[UIButton buttonWithTitle:@"更多 >" font:[UIFont systemFontOfSize:14] textColor:RGB(149, 75, 88) target:self action:@selector(moreClick:)];
        [self addSubview:_moreButton];
        [_moreButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.mas_right).mas_offset(-10);
            make.centerY.equalTo(self);
            
        }];
        
        [_moreButton addTarget:self action:@selector(moreClick:) forControlEvents:UIControlEventTouchUpInside];
        
        _labelTitle=[[UILabel alloc]init];
        _labelTitle.font=[UIFont systemFontOfSize:15];
        [self addSubview:_labelTitle];
        [_labelTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.mas_left).mas_offset(10);
            make.centerY.equalTo(self);
        }];
        
    }
    return self;
}
-(void)setTitle:(NSString *)title{
    _title=title;
    self.labelTitle.text=title;
    
}
-(void)moreClick:(UIButton *)sender{
    if(self.moreBlock){
        self.moreBlock();
    }
}


@end
