//
//  FSImageHeader.h
//  番属
//
//  Created by 王佳苗 on 2018/7/9.
//  Copyright © 2018年 王佳苗. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FSImageHeader : UIView
@property(nonatomic,strong)NSArray *content;
@property(nonatomic,strong)void (^buttonClickBlock)(NSString *url);
@end
