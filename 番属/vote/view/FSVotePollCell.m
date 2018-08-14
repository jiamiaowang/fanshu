//
//  FSVotePollCell.m
//  番属
//
//  Created by 王佳苗 on 2018/8/8.
//  Copyright © 2018年 王佳苗. All rights reserved.
//

#import "FSVotePollCell.h"
#import "FSVoteOptions.h"
#import <Masonry.h>
@interface FSVotePollCell()
@property(nonatomic,strong)UILabel *name;
@property(nonatomic,strong)UILabel *pollLabel;
@property(nonatomic,strong)UIProgressView *progressView;
@end
@implementation FSVotePollCell
-(instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if(self){
        _name=[[UILabel alloc]initWithFrame:CGRectMake(15, 10, 30, 30)];
        _name.font=[UIFont systemFontOfSize:15];
        _name.textColor=FSThemeColor;
        [self addSubview:_name];

        //票数
        _pollLabel=[[UILabel alloc]init];
        _pollLabel.textColor=FSThemeColor;
        _pollLabel.font=[UIFont systemFontOfSize:15];
        [self addSubview:_pollLabel];
        
        
        
        //票数条
        _progressView=[[UIProgressView alloc]init];
        _progressView.progress=0;
        _progressView.progressTintColor=FSThemeColor;
        _progressView.progressViewStyle=UIProgressViewStyleBar;
        [self addSubview:_progressView];
        [_progressView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
//            make.width.mas_lessThanOrEqualTo(self);
            make.bottom.equalTo(self).mas_offset(-15);
            make.left.equalTo(self).mas_offset(10);
            make.right.equalTo(self).mas_offset(-10);
            
        }];
        _progressView.transform=CGAffineTransformMakeScale(1.0f, 6.0f);
        
        
    }
    return self;

}
-(void)setOption:(FSVoteOptions *)option{
    _option=option;
    self.name.text=option.name;
    [self.name sizeToFit];
    
    self.pollLabel.text=[NSString stringWithFormat:@"(%d票)",option.poll];
    [_pollLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_name.mas_right).mas_offset(5);
        make.centerY.equalTo(_name);
    }];
}
-(void)setSum:(int)sum{
    _sum=sum;
    self.progressView.progress=self.option.poll*1.0/sum;
}
@end
