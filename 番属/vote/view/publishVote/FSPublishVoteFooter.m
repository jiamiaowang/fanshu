//
//  FSPublishVoteFooter.m
//  番属
//
//  Created by 王佳苗 on 2018/8/16.
//  Copyright © 2018年 王佳苗. All rights reserved.
//

#import "FSPublishVoteFooter.h"
#import "UIButton+Extension.h"

#import <Masonry.h>
@interface FSPublishVoteFooter()
@property(nonatomic,strong)UIButton *addRowButton;
@end

@implementation FSPublishVoteFooter
-(instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if(self){
        _addRowButton=[UIButton buttonWithTitle:@"添加选项" font:[UIFont systemFontOfSize:15] textColor:RGB(149,75,88) target:self action:@selector(addRow)];
        UIImage *image=[UIImage imageNamed:@"add"];
        [_addRowButton setImage:image forState:UIControlStateNormal];

        
        [self addSubview:_addRowButton];
        [_addRowButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).mas_offset(10);
            make.centerY.equalTo(self);
        }];
        
    }
    return self;
}
-(void)addRow{
    if(self.addRowBlock){
        self.addRowBlock();
    }
}
@end
