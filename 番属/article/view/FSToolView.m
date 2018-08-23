//
//  FSToolView.m
//  番属
//
//  Created by 王佳苗 on 2018/8/22.
//  Copyright © 2018年 王佳苗. All rights reserved.
//

#import "FSToolView.h"
#import <Masonry.h>
@implementation FSToolView
-(instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if(self){
        self.backgroundColor=FSBackgroundColor;
        UIButton *imageButton=[[UIButton alloc]init];
        [imageButton setImage:[UIImage imageNamed:@"addPicture"] forState:UIControlStateNormal];
        [imageButton addTarget:self action:@selector(addPicture) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:imageButton];
        [imageButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.left.equalTo(self).offset(20);
        }];
        UIButton *downButton=[[UIButton alloc]init];
        [downButton setImage:[UIImage imageNamed:@"downward"] forState:UIControlStateNormal];
        [downButton addTarget:self action:@selector(endEdit) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:downButton];
        [downButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.right.equalTo(self).mas_offset(-20);
        }];
        
    }
    return self;
}
-(void)addPicture{
    if(self.addPictureBlock){
        self.addPictureBlock();
    }
}
-(void)endEdit{
    if(self.endEditBlcok){
        self.endEditBlcok();
    }
}
@end
