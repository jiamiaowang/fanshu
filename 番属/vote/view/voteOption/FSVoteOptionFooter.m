//
//  FSVoteOptionFooter.m
//  番属
//
//  Created by 王佳苗 on 2018/7/18.
//  Copyright © 2018年 王佳苗. All rights reserved.
//

#import "FSVoteOptionFooter.h"
#import <Masonry.h>
@implementation FSVoteOptionFooter

-(instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if(self){
        UIButton *voteButton=[UIButton buttonWithType:UIButtonTypeRoundedRect];
        [voteButton setTitle:@"投票" forState:UIControlStateNormal];
        [voteButton setTintColor:[UIColor whiteColor]];
        [voteButton addTarget:self action:@selector(vote) forControlEvents:UIControlEventTouchUpInside];
        voteButton.layer.cornerRadius=4;
        voteButton.layer.masksToBounds=YES;
        [voteButton setBackgroundColor:RGB(149, 75, 88)];
        [self addSubview:voteButton];
        [voteButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.centerX.equalTo(self);
            make.width.mas_equalTo(70);
        }];
        
    }
    return self;
}
-(void)vote{
    !self.votebuttonBlock ? : self.votebuttonBlock();
}
@end
