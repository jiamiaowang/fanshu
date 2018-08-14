//
//  FSVote.h
//  番属
//
//  Created by 王佳苗 on 2018/7/13.
//  Copyright © 2018年 王佳苗. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MJExtension/MJExtension.h>
@class FSVoteOptions;
@interface FSVote : NSObject
@property(nonatomic,assign)int vote_id;
@property(nonatomic,strong)NSString *title;
@property(nonatomic,assign)int isHaveImg; //是否有图片

@end
