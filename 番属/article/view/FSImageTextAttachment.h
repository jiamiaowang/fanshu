//
//  FSImageTextAttachment.h
//  番属
//
//  Created by 王佳苗 on 2018/8/22.
//  Copyright © 2018年 王佳苗. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FSImageTextAttachment : NSTextAttachment
@property(strong, nonatomic) NSString *imageTag;
@property(assign, nonatomic) CGSize imageSize;
@end
