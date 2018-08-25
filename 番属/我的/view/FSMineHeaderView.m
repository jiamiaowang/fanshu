//
//  FSMineHeaderView.m
//  番属
//
//  Created by 王佳苗 on 2018/8/25.
//  Copyright © 2018年 王佳苗. All rights reserved.
//

#import "FSMineHeaderView.h"
#import "FSUserInfo.h"
#import <Masonry.h>
#import <UIImageView+WebCache.h>
@interface FSMineHeaderView()
@property(nonatomic,strong)UIImageView *avatarImageView;
@property(nonatomic,strong)UILabel *usernamelabel;
@end
@implementation FSMineHeaderView

-(instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if(self){
        self.backgroundColor=FSBackgroundColor;
        _avatarImageView=[[UIImageView alloc]init];
        _avatarImageView.image=[UIImage imageNamed:@"avatarDefault"];
        _avatarImageView.contentMode = UIViewContentModeScaleAspectFill;
        _avatarImageView.clipsToBounds=YES;
        [self addSubview:_avatarImageView];
        [_avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.size.mas_equalTo(CGSizeMake(70, 70));
            make.top.equalTo(self).mas_offset(40);
        }];

        _avatarImageView.userInteractionEnabled=YES;
        UITapGestureRecognizer *gesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(addAvatarImg)];
        [_avatarImageView addGestureRecognizer:gesture];
        
        _usernamelabel=[[UILabel alloc]init];
        _usernamelabel.textColor=FSThemeColor;
        _usernamelabel.text=@"未登录";
        [self addSubview:_usernamelabel];
        [_usernamelabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.top.equalTo(self.avatarImageView.mas_bottom).mas_offset(20);
        }];
        
    }
    return self;
}
-(void)addAvatarImg{
    if(self.addAvatarImgBlcok){
        self.addAvatarImgBlcok();
    }
}
-(void)setInfo:(FSUserInfo *)info{
    _info=info;
    if(info.avatar){
        [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:info.avatar]];
        self.avatarImageView.layer.cornerRadius=_avatarImageView.frame.size.width/2;
        self.avatarImageView.layer.masksToBounds=YES;
    }
    else{
        self.avatarImageView.image=[UIImage imageNamed:@"avatarDefault"];
    }
    if(info.username.length){
        self.usernamelabel.text=info.username;
    }
    else{
        self.usernamelabel.text=@"未登录";
    }
}
-(void)setImage:(UIImage *)image{
    _image=image;
    if(image){
        self.avatarImageView.image=image;
    }
}
@end
