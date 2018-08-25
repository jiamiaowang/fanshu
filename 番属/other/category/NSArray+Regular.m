//
//  NSArray+Regular.m
//  番属
//
//  Created by 王佳苗 on 2018/8/25.
//  Copyright © 2018年 王佳苗. All rights reserved.
//

#import "NSArray+Regular.h"

@implementation NSArray (Regular)
-(NSArray *)RXToArray{
//    NSString *pattern = @"<img src=\"([^\\s]*)\"width=\"([^\\s]*)\"height=\"([^\\s]*)\"\\s*/>";
//    NSRegularExpression *expression = [NSRegularExpression regularExpressionWithPattern:pattern
//                                                                                options:0
//                                                                                  error:NULL];
    
    NSMutableArray * resultArr=[NSMutableArray array];
    for (NSString *str in self) {
        NSString *pattern = @"<img src=\"([^\\s]*)\"width=\"([^\\s]*)\"height=\"([^\\s]*)\"\\s*/>";
        NSRegularExpression *expression = [NSRegularExpression regularExpressionWithPattern:pattern
                                                                                    options:0
                                                                                      error:NULL];
        NSArray *lines = [expression matchesInString:str options:0 range:NSMakeRange(0, str.length)];
        NSTextCheckingResult *textCheckingResult=[lines firstObject];
        
        NSMutableDictionary *result = [NSMutableDictionary dictionary];
        NSString* value1 = [str substringWithRange:[textCheckingResult rangeAtIndex:1]];
        NSString* value2 = [str substringWithRange:[textCheckingResult rangeAtIndex:2]];
        NSString* value3 = [str substringWithRange:[textCheckingResult rangeAtIndex:3]];
        result[@"src"] = value1;
        result[@"width"] = value2;
        result[@"height"] = value3;
        [resultArr addObject:result];
    }
    
    
    
    
    
    return resultArr;
}
@end
