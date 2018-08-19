//
//  FSPublishVoteNoImgCell.m
//  番属
//
//  Created by 王佳苗 on 2018/8/18.
//  Copyright © 2018年 王佳苗. All rights reserved.
//

#import "FSPublishVoteNoImgCell.h"
#import "FSUnderlineTextField.h"
#import <Masonry.h>
@interface FSPublishVoteNoImgCell()<UITextFieldDelegate>
@property(nonatomic,strong)FSUnderlineTextField *textField;
@property(nonatomic,strong)UILabel *numLabel;  //第几个

@end
@implementation FSPublishVoteNoImgCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        
        self.selectionStyle=UITableViewCellSelectionStyleNone;
        
        _numLabel=[[UILabel alloc]init];
        [self addSubview:_numLabel];
        [_numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).mas_offset(20);
            make.top.equalTo(self).mas_offset(10);
            
        }];
        //文本框
        _textField=[FSUnderlineTextField underlineTextField:@"选项名称" fontSize:14];;
        _textField.textAlignment=NSTextAlignmentCenter;
        [self addSubview:_textField];
        [_textField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.bottom.equalTo(self).mas_offset(-10);
            make.width.mas_equalTo(100);
        }];
        _textField.delegate=self;
        
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
-(void)setNameText:(NSString *)nameText{
    _nameText=nameText;
    if(nameText.length){
        self.textField.text=nameText;
    }
    else{
        self.textField.text=@"";
    }
}
//删除一行
-(void)deleteRow{
    if(self.deleteRowBlock){
        self.deleteRowBlock();
    }
}
#pragma mark - textField
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if(self.nameTextWillEditBlock){
        self.nameTextWillEditBlock(textField.frame);
    }
    return YES;
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
    if(self.nameTextEndEditBlock){
        self.nameTextEndEditBlock(textField.text);
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
