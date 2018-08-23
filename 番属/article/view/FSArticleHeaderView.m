//
//  FSArticleHeaderView.m
//  番属
//
//  Created by 王佳苗 on 2018/8/21.
//  Copyright © 2018年 王佳苗. All rights reserved.
//

#import "FSArticleHeaderView.h"
#import "FSUnderlineTextField.h"
#import <Masonry.h>
@interface FSArticleHeaderView()<UITextFieldDelegate>
@property(nonatomic,strong)FSUnderlineTextField *textField;
@property(nonatomic,strong)UIImageView *mainImageView;
@end
@implementation FSArticleHeaderView
-(instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if(self){
        _textField=[FSUnderlineTextField underlineTextField:@"请输入文章标题" fontSize:18];
        _textField.textAlignment=NSTextAlignmentCenter;
        [self addSubview:_textField];
        [_textField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self).offset(-10);
            make.left.equalTo(self).offset(10);
            make.right.equalTo(self).offset(-10);
            make.centerX.equalTo(self);
        }];
        _textField.delegate=self;
        
        
        _mainImageView=[[UIImageView alloc]init];
        _mainImageView.image=[UIImage imageNamed:@"addCover"];
        _mainImageView.contentMode = UIViewContentModeScaleAspectFill;
        _mainImageView.clipsToBounds=YES;
        _mainImageView.userInteractionEnabled=YES;
        
        UITapGestureRecognizer *gesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(addPhoto)];
        [_mainImageView addGestureRecognizer:gesture];
        [self addSubview:_mainImageView];
        [_mainImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self);
            make.width.equalTo(self);
            make.centerX.equalTo(self);
            make.height.mas_equalTo(170);
//            make.bottom.equalTo(self.textField.mas_top).offset(-15);
        }];

    }
    return self;
}
-(void)setImage:(UIImage *)image{
    _image=image;
    self.mainImageView.image=image;
}
-(void)addPhoto{
    if(self.addPhotoBlock){
        self.addPhotoBlock();
    }
}

#pragma mark - textField
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    return YES;
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
    if(self.titleEndEditBlock){
        self.titleEndEditBlock(textField.text);
    }
}










@end
