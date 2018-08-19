//
//  FSUnderlineTextField.m
//  番属
//
//  Created by 王佳苗 on 2018/8/9.
//  Copyright © 2018年 王佳苗. All rights reserved.
//

#import "FSUnderlineTextField.h"

@implementation FSUnderlineTextField


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
+(FSUnderlineTextField *)underlineTextField:(NSString *)placeholder fontSize:(CGFloat)fontSize{
    FSUnderlineTextField *textField=[[FSUnderlineTextField alloc]init];
    textField.font=[UIFont systemFontOfSize:fontSize];
    textField.placeholder=placeholder;
    textField.autocorrectionType=UITextAutocorrectionTypeNo;
    textField.clearButtonMode=UITextFieldViewModeWhileEditing;
    textField.tintColor=FSThemeColor;

    //首字母不大写
    textField.autocapitalizationType=UITextAutocapitalizationTypeNone;
    
    return textField;
}
- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    //获得处理的上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    //指定直线样式
    CGContextSetLineCap(context, kCGLineCapSquare);
    //直线宽度
    CGContextSetLineWidth(context, 2.0);
    //设置颜色  RGB(225, 225, 225)灰
    CGContextSetRGBStrokeColor(context, 225/255.0, 225/255.0, 225/255.0, 1.0);
    //开始绘制
    CGContextBeginPath(context);
    //画笔移动到点(31,170)
    CGContextMoveToPoint(context, 0, self.bounds.size.height);
    //下一点
    CGContextAddLineToPoint(context, self.bounds.size.width, self.bounds.size.height);
    //下一点
    //    CGContextAddLineToPoint(context, 159, 148);
    //绘制完成
    CGContextStrokePath(context);

}


@end
