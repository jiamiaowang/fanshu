//
//  FSLogoutView.m
//  番属
//
//  Created by 王佳苗 on 2018/8/25.
//  Copyright © 2018年 王佳苗. All rights reserved.
//

#import "FSLogoutView.h"
#import "UIButton+Extension.h"
#import <Masonry.h>
@implementation FSLogoutView

-(instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if(self){
        UIButton *publishBitton=[UIButton buttonWithTitle:@"退出登录" font:[UIFont systemFontOfSize:16] textColor:[UIColor whiteColor] target:self action:@selector(logout)];
        publishBitton.backgroundColor=FSThemeColor;
        [self addSubview:publishBitton];
        [publishBitton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self);
            make.width.mas_equalTo(200);
        }];
    }
    return self;
}
-(void)logout{
    if(self.logoutBlcok){
        self.logoutBlcok();
    }
}
@end
