//
//  FSSearchBar.h
//  番属
//
//  Created by 王佳苗 on 2018/7/9.
//  Copyright © 2018年 王佳苗. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FSSearchBar : UISearchBar
@property(nonatomic,copy)void (^searchBarShouldBeginEditingBlock)();//点击回调

+(instancetype)searchBarWithPlaceholder:(NSString *)placeholder;

@end
