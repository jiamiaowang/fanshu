//
//  FSVoteAndAtricle.m
//  番属
//
//  Created by 王佳苗 on 2018/7/13.
//  Copyright © 2018年 王佳苗. All rights reserved.
//

#import "FSVoteAndArticle.h"
@implementation FSVoteAndArticle
+(NSDictionary*)mj_objectClassInArray{
    return @{
            @"hot":@"FSArticle",
            @"vote":@"FSVote",
            @"article":@"FSArticle"
            };
}
@end
