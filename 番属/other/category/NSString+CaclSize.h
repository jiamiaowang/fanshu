//
//  NSString+CaclSize.h
//  番属
//
//  Created by 王佳苗 on 2018/8/25.
//  Copyright © 2018年 王佳苗. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (CaclSize)
//NSLineBreakByWordWrapping,以单词为单位换行，以单位为单位截断。
- (CGSize)calculateSize:(CGSize)size font:(UIFont *)font;


 //ios7 显示
// NSLineBreakByWordWrapping,以单词为单位换行，以单位为单位截断。
// NSLineBreakByCharWrapping,以字符为单位换行，以单位为单位截断。
// NSLineBreakByClipping,以单词为单位换行。以字符为单位截断。
// NSLineBreakByTruncatingHead,以单词为单位换行。如果是单行，则开始部分有省略号。如果是多行，则中间有省略号，省略号后面有4个字符。
- (CGSize)calculateSize:(CGSize)size font:(UIFont *)font lineBreakMode:(NSLineBreakMode)mode;

@end
