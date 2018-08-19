//
//  UILabel+Extension.m
//  番属
//
//  Created by 王佳苗 on 2018/8/16.
//  Copyright © 2018年 王佳苗. All rights reserved.
//

#import "UILabel+Extension.h"

@implementation UILabel (Extension)

+(void)showTip:(NSString *)tipText toView:(UIView *)view centerYOffset:(CGFloat)offset{
    UILabel *message=[[UILabel alloc]init];
    message.layer.cornerRadius=10;
    message.clipsToBounds=YES;
    message.backgroundColor=RGBA(0, 0, 0, 0.8);
    message.font=[UIFont systemFontOfSize:15];
    message.textColor=[UIColor whiteColor];
    message.textAlignment=NSTextAlignmentCenter;
    
    message.text=tipText;
    CGSize size = [tipText boundingRectWithSize:CGSizeMake(MAXFLOAT, 50)
                                      options:NSStringDrawingUsesLineFragmentOrigin
                                   attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:15]}
                                      context:nil].size;
    message.frame = CGRectMake(0, 0, size.width + 20, size.height + 10);
    CGPoint center=view.center;
    center.y=center.y+offset;
    message.center = center;
    [view addSubview:message];
    
    [UIView animateWithDuration:1.5 animations:^{
        message.alpha = 1;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:2 animations:^{
            message.alpha = 0;
        } completion:^(BOOL finished) {
            [message removeFromSuperview];
            
        }];
    }];

}
@end
