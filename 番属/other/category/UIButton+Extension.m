//
//  UIButton+Extension.m
//  番属
//
//  Created by 王佳苗 on 2018/7/13.
//  Copyright © 2018年 王佳苗. All rights reserved.
//

#import "UIButton+Extension.h"

@implementation UIButton (Extension)
+(UIButton *)buttonWithTitle:(NSString *)title font:(UIFont *)font textColor:(UIColor *)color target:(id)target action:(SEL)action{
    UIButton *button=[[UIButton alloc]init];
    [button setTitle:title forState:UIControlStateNormal];
    button.titleLabel.font=font;
    [button setTitleColor:color forState:UIControlStateNormal];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return button;
}
@end
