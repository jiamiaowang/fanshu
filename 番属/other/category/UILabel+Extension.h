//
//  UILabel+Extension.h
//  番属
//
//  Created by 王佳苗 on 2018/8/16.
//  Copyright © 2018年 王佳苗. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (Extension)
/*
 *一个粗略的提示器
 *  tipText:提示内容
 *  view:添加到view上
 */
+(void)showTip:(NSString *)tipText toView:(UIView *)view centerYOffset:(CGFloat)offset;
@end
