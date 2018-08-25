//
//  FSMineHeaderView.h
//  番属
//
//  Created by 王佳苗 on 2018/8/25.
//  Copyright © 2018年 王佳苗. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FSUserInfo;
@interface FSMineHeaderView : UIView
@property(nonatomic,strong)FSUserInfo *info;
@property(nonatomic,strong)UIImage *image;
@property(nonatomic,copy)void (^gotoLoginBlcok)();
@property(nonatomic,copy)void (^addAvatarImgBlcok)();
@end
