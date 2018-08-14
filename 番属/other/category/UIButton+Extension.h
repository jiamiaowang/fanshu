//
//  UIButton+Extension.h
//  番属
//
//  Created by 王佳苗 on 2018/7/13.
//  Copyright © 2018年 王佳苗. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (Extension)
//快速创建一个button
+(UIButton *)buttonWithTitle:(NSString *)title font:(UIFont *)font textColor:(UIColor *)color target:(id)target action:(SEL)action;
@end
