//
//  FSVoteViewCell.m
//  番属
//
//  Created by 王佳苗 on 2018/7/13.
//  Copyright © 2018年 王佳苗. All rights reserved.
//

#import "FSVoteViewCell.h"
#import <Masonry.h>
@interface FSVoteViewCell()
@property(nonatomic,strong)UIImageView *voteimageView;
@property(nonatomic,strong)UILabel *labelTitle;
@end
@implementation FSVoteViewCell

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
// 配置cell高亮状态
//-(void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
//    [super setHighlighted:highlighted animated:animated];
//    if(highlighted){
//        self.backgroundColor=FSSelectedColor;
//    }
//    else{
//        [UIView animateWithDuration:0.1 delay:0.1 options:UIViewAnimationOptionCurveEaseInOut animations:^{
//            self.backgroundColor=[UIColor whiteColor];
//            
//        } completion:nil];
//    }
//}


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        _voteimageView=[[UIImageView alloc]init];
        _voteimageView.image=[UIImage imageNamed:@"Main_voteImage.png"];
        [self addSubview:_voteimageView];
        [_voteimageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.mas_right).mas_offset(-10);
            make.centerY.equalTo(self);
            make.width.mas_equalTo(25);
            make.height.mas_equalTo(25);
        }];
        
        
        _labelTitle=[[UILabel alloc]init];
        _labelTitle.font=[UIFont systemFontOfSize:15];
        _labelTitle.textColor=FSThemeColor;
        [self addSubview:_labelTitle];
        [_labelTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).mas_offset(10);
            make.centerY.equalTo(self);
        }];
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        
        
    }
    return self;
}
-(void)setTitle:(NSString *)title{
    _title=title;
    self.labelTitle.text=title;
}











@end
