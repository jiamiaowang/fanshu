//
//  FSArticleHeaderView.h
//  番属
//
//  Created by 王佳苗 on 2018/8/21.
//  Copyright © 2018年 王佳苗. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FSArticleHeaderView : UIView
@property(nonatomic,strong)UIImage *image;
@property(nonatomic,copy)void (^addPhotoBlock)();  //添加封面图片
@property(nonatomic,copy)void (^titleEndEditBlock)(NSString *);
@end
