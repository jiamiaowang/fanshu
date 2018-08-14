//
//  NetworkingTool.h
//  网易新闻
//
//  Created by 王佳苗 on 2018/5/15.
//  Copyright © 2018年 王佳苗. All rights reserved.
//

#import "AFHTTPSessionManager.h"

@interface FSNetworkingTool : AFHTTPSessionManager
+(instancetype)shareNetworkingTool;
@end
