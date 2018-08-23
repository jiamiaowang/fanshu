//
//  NSAttributedString+RichText.m
//  番属
//
//  Created by 王佳苗 on 2018/8/21.
//  Copyright © 2018年 王佳苗. All rights reserved.
//

#import "NSAttributedString+RichText.h"
#import "FSImageTextAttachment.h"
@implementation NSAttributedString (RichText)
- (NSString *)getPlainString {
    NSMutableString *plainString = [NSMutableString stringWithString:self.string];
    __block NSUInteger base = 0;
    
    [self enumerateAttribute:NSAttachmentAttributeName inRange:NSMakeRange(0, self.length)
                     options:0
                  usingBlock:^(id value, NSRange range, BOOL *stop) {
                      if (value && [value isKindOfClass:[FSImageTextAttachment class]]) {
                          [plainString replaceCharactersInRange:NSMakeRange(range.location + base, range.length)
                                                     withString:((FSImageTextAttachment *) value).imageTag];
                          base += ((FSImageTextAttachment *) value).imageTag.length - 1;
                      }
                  }];
    
    return plainString;
}
-(NSArray *)getImgaeArray
{
    
    
    NSMutableArray * imageArr=[NSMutableArray array];
    [self enumerateAttribute:NSAttachmentAttributeName inRange:NSMakeRange(0, self.length)
                     options:0
                  usingBlock:^(id value, NSRange range, BOOL *stop) {
                      if (value && [value isKindOfClass:[FSImageTextAttachment class]]) {
                          FSImageTextAttachment* TA=(FSImageTextAttachment*)value;
                          [imageArr addObject:TA.image];
                      }
                  }];
    
    return imageArr;
}
@end
