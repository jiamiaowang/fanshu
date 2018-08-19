//
//  FSPublishVoteTitle.m
//  番属
//
//  Created by 王佳苗 on 2018/8/15.
//  Copyright © 2018年 王佳苗. All rights reserved.
//

#import "FSPublishVoteTitle.h"
#import <Masonry.h>
@interface FSPublishVoteTitle()<UITextFieldDelegate>
@property(nonatomic,strong)UITextField *textfield;
@end
@implementation FSPublishVoteTitle
-(instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if(self){
        self.backgroundColor=FSBackgroundColor;
        UIImageView *imageView=[[UIImageView alloc]init];
        imageView.image=[UIImage imageNamed:@"Main_voteImage"];
        [self addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).mas_offset(10);
            make.centerY.equalTo(self);
            make.width.mas_equalTo(20);
            make.height.mas_equalTo(20);
            
        }];
        
        _textfield=[[UITextField alloc]init];
//        _textfield.borderStyle=UITextBorderStyleNone;
        _textfield.placeholder=@"请输入标题";
        _textfield.tintColor=FSThemeColor;
        _textfield.textColor=FSThemeColor;
        _textfield.autocorrectionType=UITextAutocorrectionTypeNo;
        _textfield.clearButtonMode=UITextFieldViewModeWhileEditing;
        //首字母不大写
        _textfield.autocapitalizationType=UITextAutocapitalizationTypeNone;
        _textfield.delegate=self;
        [self addSubview:_textfield];
        [_textfield mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(imageView.mas_right).mas_offset(5);
            make.centerY.equalTo(self);
            make.right.equalTo(self).mas_offset(-10);
        }];

    }
    return self;
}
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    [textField setNeedsDisplay];
    if(self.titleWillEditBlock){
        self.titleWillEditBlock(textField.frame);
    }
    return YES;
}
//结束编辑时
-(void)textFieldDidEndEditing:(UITextField *)textField{
    if(self.titleEndEditBlock){
        self.titleEndEditBlock(textField.text);
    }
}


@end
