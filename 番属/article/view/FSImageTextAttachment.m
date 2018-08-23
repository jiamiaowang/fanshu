//
//  FSImageTextAttachment.m
//  番属
//
//  Created by 王佳苗 on 2018/8/22.
//  Copyright © 2018年 王佳苗. All rights reserved.
//

#import "FSImageTextAttachment.h"

@implementation FSImageTextAttachment
- (CGRect)attachmentBoundsForTextContainer:(NSTextContainer *)textContainer proposedLineFragment:(CGRect)lineFrag glyphPosition:(CGPoint)position characterIndex:(NSUInteger)charIndex {
    
     //调整图片大小
    return CGRectMake(ScreenWidth/2-_imageSize.width/2, 0, _imageSize.width, _imageSize.height);
}
@end
