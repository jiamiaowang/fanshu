//
//  FSToolView.h
//  番属
//
//  Created by 王佳苗 on 2018/8/22.
//  Copyright © 2018年 王佳苗. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FSToolView : UIView
@property(nonatomic,copy)void (^addPictureBlock)();
@property(nonatomic,strong)void (^endEditBlcok)();
@end
