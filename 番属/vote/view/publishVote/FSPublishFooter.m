//
//  FSPublishFooter.m
//  番属
//
//  Created by 王佳苗 on 2018/8/16.
//  Copyright © 2018年 王佳苗. All rights reserved.
//

#import "FSPublishFooter.h"
#import "UIButton+Extension.h"
#import <Masonry.h>
@implementation FSPublishFooter

-(instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if(self){
        UIButton *publishBitton=[UIButton buttonWithTitle:@"发布" font:[UIFont systemFontOfSize:16] textColor:[UIColor whiteColor] target:self action:@selector(publish)];
        publishBitton.backgroundColor=FSThemeColor;
        [self addSubview:publishBitton];
        [publishBitton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self);
            make.width.mas_equalTo(200);
        }];
    }
    return self;
}
-(void)publish{
    if(self.publishBolck){
        self.publishBolck();
    }
}
@end
