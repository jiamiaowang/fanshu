//
//  FSVoteOptions.h
//  番属
//
//  Created by 王佳苗 on 2018/7/13.
//  Copyright © 2018年 王佳苗. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MJExtension/MJExtension.h>
@interface FSVoteOptions : NSObject
@property(nonatomic,assign)int option_id;
@property(nonatomic,strong)NSString *imageStr;
@property(nonatomic,strong)NSString *name;
@property(nonatomic,assign)int poll;//票数
@end
