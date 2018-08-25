//
//  FSPublishVoteCell.m
//  番属
//
//  Created by 王佳苗 on 2018/8/15.
//  Copyright © 2018年 王佳苗. All rights reserved.
//

#import "FSPublishVoteWithImgCell.h"

#import "FSUnderlineTextField.h"
#import "FSPublishOption.h"
#import <Masonry.h>
@interface FSPublishVoteWithImgCell()<UITextFieldDelegate>
@property(nonatomic,strong)UIImageView *optionImageView;
@property(nonatomic,strong)FSUnderlineTextField *nameText;
@property(nonatomic,strong)UILabel *numLabel;  //第几个
@end
@implementation FSPublishVoteWithImgCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        self.selectionStyle = UITableViewCellSelectionStyleNone;
//        self.backgroundColor=FSBackgroundColor;
        _numLabel=[[UILabel alloc]init];
        [self addSubview:_numLabel];
        [_numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).mas_offset(20);
            make.top.equalTo(self).mas_offset(10);

        }];
        

        //添加照片
        _optionImageView=[[UIImageView alloc]init];
        _optionImageView.contentMode = UIViewContentModeScaleAspectFill;
        _optionImageView.clipsToBounds=YES;
        _optionImageView.image=[UIImage imageNamed:@"Camera"];
        _optionImageView.userInteractionEnabled = YES;
        [self addSubview:_optionImageView];
        //添加手势
        UITapGestureRecognizer *gestrure=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(addPhoto)];
        [_optionImageView addGestureRecognizer:gestrure];
        [_optionImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(15);
            make.centerX.equalTo(self);
            make.size.mas_equalTo(CGSizeMake(100, 100));
        }];
        
        
        
        //名字文本框
        _nameText=[FSUnderlineTextField underlineTextField:@"选项名称" fontSize:14];
        _nameText.textAlignment=NSTextAlignmentCenter;
        [self addSubview:_nameText];
        [_nameText mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.optionImageView);
            make.bottom.equalTo(self).mas_offset(-10);
            make.width.mas_equalTo(100);
        }];
        _nameText.delegate=self;
        
        //删除按钮
        UIButton *deleteButton=[[UIButton alloc]init];
        [deleteButton setImage:[UIImage imageNamed:@"deleteIcon"] forState:UIControlStateNormal];
        [deleteButton addTarget:self action:@selector(deleteRow) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:deleteButton];
        [deleteButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).mas_offset(-10);
            make.centerY.equalTo(self);
        }];
        
        

    }
    return self;
}
-(void)setIndex:(NSInteger)index{
    _index=index;
    self.numLabel.text=[NSString stringWithFormat:@"%ld",(long)index];
    [self.numLabel sizeToFit];
}

-(void)setOption:(FSPublishOption *)option{
    _option=option;
    if(option.name.length){
        self.nameText.text=option.name;
    }
    else{
        self.nameText.text=@"";
    }
    if(option.image){
        self.optionImageView.image=option.image;
    }
    else{
        self.optionImageView.image=[UIImage imageNamed:@"Camera"];
    }
    
}
//删除某一行
-(void)deleteRow{
    if(self.deleteRowBlock){
        self.deleteRowBlock();
    }
}
//添加图片
-(void)addPhoto{
    if(self.addPhotoBlock){
        self.addPhotoBlock();
    }
}

#pragma maek - textField delegate
//即将开始编辑
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    [textField setNeedsDisplay];
    if(self.nameTextWillEditBlock){
        self.nameTextWillEditBlock(textField.frame);
    }
    return YES;
}
//结束编辑
-(void)textFieldDidEndEditing:(UITextField *)textField{
    if(self.nameTextEndEditBlock){
        self.nameTextEndEditBlock(textField.text);
    }
}
@end
