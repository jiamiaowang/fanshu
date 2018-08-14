//
//  UIBarButtonItem+Extension.m
//  番属
//
//  Created by 王佳苗 on 2018/7/9.
//  Copyright © 2018年 王佳苗. All rights reserved.
//

#import "UIBarButtonItem+Extension.h"

@implementation UIBarButtonItem (Extension)
+ (instancetype)barButtonItemWithTitle:(NSString *)title
                                target:(id)target
                                action:(SEL)action {
    
    UIButton *button=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 50, 40)];
    button.titleLabel.textAlignment=NSTextAlignmentRight;
//    [button setTitleColor:RGB(149, 75, 88) forState:UIControlStateNormal];
    button.titleLabel.font=[UIFont boldSystemFontOfSize:16];
    [button setTitle:title forState:UIControlStateNormal];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    
    UIBarButtonItem *buttonItem=[[UIBarButtonItem alloc]initWithCustomView:button];
    return buttonItem;
    
    
    

}
@end
