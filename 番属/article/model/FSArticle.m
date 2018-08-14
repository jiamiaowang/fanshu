//
//  FSImageLoop.m
//  番属
//
//  Created by 王佳苗 on 2018/7/9.
//  Copyright © 2018年 王佳苗. All rights reserved.
//

#import "FSArticle.h"

@implementation FSArticle
+(NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
             @"article_id":@"id"
           };
}
@end
