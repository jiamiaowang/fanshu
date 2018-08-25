//
//  NSString+Regular.m
//  番属
//
//  Created by 王佳苗 on 2018/8/25.
//  Copyright © 2018年 王佳苗. All rights reserved.
//

#import "NSString+Regular.h"

@implementation NSString (Regular)
//输出正则里面的内容
-(NSArray *)RXToArray
{
    NSString *pattern = @"<img src=\"([^\\s]*)\"width=\"([^\\s]*)\" height=\"([^\\s]*)\">";
    NSRegularExpression *expression = [NSRegularExpression regularExpressionWithPattern:pattern
                                                                                options:0
                                                                                  error:NULL];
    NSArray *lines = [expression matchesInString:self options:0 range:NSMakeRange(0, self.length)];
    
    NSMutableArray * resultArr=[NSMutableArray array];
    for (NSTextCheckingResult *textCheckingResult in lines) {
        NSMutableDictionary *result = [NSMutableDictionary dictionary];
        
        //0 代表整个正则内容
        NSString* value1 = [self substringWithRange:[textCheckingResult rangeAtIndex:1]];
        NSString* value2 = [self substringWithRange:[textCheckingResult rangeAtIndex:2]];
        NSString* value3 = [self substringWithRange:[textCheckingResult rangeAtIndex:3]];
        
        
        result[@"src"] = value1;
        result[@"width"] = value2;
        result[@"height"] = value3;
        [resultArr addObject:result];
        
    }
    
    
    return resultArr;
}

@end
