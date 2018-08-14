//
//  FSVoteOptionCell.m
//  番属
//
//  Created by 王佳苗 on 2018/7/18.
//  Copyright © 2018年 王佳苗. All rights reserved.
//

#import "FSVoteOptionCell.h"
#import "FSVoteOptions.h"
#import <UIImageView+WebCache.h>
@interface FSVoteOptionCell()
@property (weak, nonatomic) IBOutlet UIImageView *optionImageView;
@property (weak, nonatomic) IBOutlet UILabel *name;


@end
@implementation FSVoteOptionCell


//设置选中选中
-(void)setSelected:(BOOL)selected {
    if (selected) {
        self.backgroundColor = FSThemeColor;
    } else {
        self.backgroundColor = [UIColor whiteColor];
    }
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.backgroundColor=[UIColor whiteColor];
    //
    self.layer.cornerRadius=6.0;
    self.layer.masksToBounds=YES;
    
    
    
}

-(void)setOption:(FSVoteOptions *)option{
    _option=option;
    self.name.text=option.name;
//    self.optionImageView.image=[UIImage imageNamed:@"1.jpeg"];
    
    if(option.imageStr){
        [self.optionImageView sd_setImageWithURL:[NSURL URLWithString:option.imageStr]];
    }
}
@end
