//
//  NSString+Hash.h
//  模拟登录
//
//  Created by 王佳苗 on 2018/5/6.
//  Copyright © 2018年 王佳苗. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Hash)
//md5
-(NSString *)md5String;
//hmac
-(NSString *)hmacMD5StringWithKey:(NSString *)key;
@end
