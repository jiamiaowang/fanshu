//
//  FSSectionHeader.h
//  番属
//
//  Created by 王佳苗 on 2018/7/13.
//  Copyright © 2018年 王佳苗. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FSSectionHeader : UIView
@property(nonatomic,strong)NSString *title;
@property(nonatomic,strong)void (^moreBlock)();
@end
