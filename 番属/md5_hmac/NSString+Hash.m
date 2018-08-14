//
//  NSString+Hash.m
//  模拟登录
//
//  Created by 王佳苗 on 2018/5/6.
//  Copyright © 2018年 王佳苗. All rights reserved.
//

#import "NSString+Hash.h"
//md5要添加的头文件
#import<CommonCrypto/CommonDigest.h>
//hmac要添加的头文件
#import <CommonCrypto/CommonHMAC.h>
@implementation NSString (Hash)
//
-(NSString *)md5String{
    const char *cStr = [self UTF8String];
    unsigned char buffer[16];
    CC_MD5(cStr, (CC_LONG)strlen(cStr),buffer );
    return [self stringWithByte:buffer length:16];
    
}
-(NSString *)stringWithByte:(uint8_t *)bytes length:(int)length{
    NSMutableString *hash =[NSMutableString string];
    for (int i = 0; i < length; i++)
        [hash appendFormat:@"%02X", bytes[i]];
    return [hash copy];
}
-(NSString *)hmacMD5StringWithKey:(NSString *)key{
//    const char *cKey=[key UTF8String] ;
//    const char *cStr=[self UTF8String];
//    unsigned char cHMAC[16];
//    CCHmac(kCCHmacAlgSHA256, cKey, strlen(cKey), cStr, strlen(cStr), cHMAC);
//    
//    return [self stringWithByte:cHMAC length:16];
    
    const char *cKey  = [key cStringUsingEncoding:NSASCIIStringEncoding];
    const char *cData = [self cStringUsingEncoding:NSASCIIStringEncoding];
    unsigned char cHMAC[CC_SHA256_DIGEST_LENGTH];
    CCHmac(kCCHmacAlgSHA256, cKey, strlen(cKey), cData, strlen(cData), cHMAC);
    NSData *HMACData = [NSData dataWithBytes:cHMAC length:sizeof(cHMAC)];
    const unsigned char *buffer = (const unsigned char *)[HMACData bytes];
    NSMutableString *HMAC = [NSMutableString stringWithCapacity:HMACData.length * 2];
    for (int i = 0; i < HMACData.length; ++i){
        [HMAC appendFormat:@"%02x", buffer[i]];
    }
    
    return HMAC;
    
}
@end
