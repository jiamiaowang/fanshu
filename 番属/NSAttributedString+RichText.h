//
//  NSAttributedString+RichText.h
//  番属
//
//  Created by 王佳苗 on 2018/8/21.
//  Copyright © 2018年 王佳苗. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSAttributedString (RichText)
- (NSString *)getPlainString;

//返回一个图片数组
-(NSArray *)getImgaeArray;
@end
