//
//  NetworkingTool.m
//  网易新闻
//
//  Created by 王佳苗 on 2018/5/15.
//  Copyright © 2018年 王佳苗. All rights reserved.
//

#import "FSNetworkingTool.h"

@implementation FSNetworkingTool
+(instancetype)shareNetworkingTool{
    static id networkTool=nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSURL *baseUrl=[NSURL URLWithString:@"http://127.0.0.1/fanshu/"];
        NSURLSessionConfiguration *configuration=[NSURLSessionConfiguration defaultSessionConfiguration];
        //设置请求超时时长
        configuration.timeoutIntervalForRequest=15;
        networkTool=[[self alloc] initWithBaseURL:baseUrl sessionConfiguration:configuration];
    });
    return networkTool;
}
@end
