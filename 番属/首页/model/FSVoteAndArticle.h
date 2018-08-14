//
//  FSVoteAndAtricle.h
//  番属
//
//  Created by 王佳苗 on 2018/7/13.
//  Copyright © 2018年 王佳苗. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MJExtension/MJExtension.h>
@class FSVote;
@class FSArticle;
@interface FSVoteAndArticle : NSObject
@property(nonatomic,strong)NSArray<FSArticle *> *hot;//轮播图
@property(nonatomic,strong)NSArray<FSVote *> *vote;
@property(nonatomic,strong)NSArray<FSArticle *> *article;
//@property(nonatomic,assign)int count;
@end
