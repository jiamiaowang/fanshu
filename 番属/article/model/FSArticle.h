//
//  FSImageLoop.h
//  番属
//
//  Created by 王佳苗 on 2018/7/9.
//  Copyright © 2018年 王佳苗. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MJExtension/MJExtension.h>
@interface FSArticle : NSObject
@property(nonatomic,assign)int article_id;
@property(nonatomic,strong)NSString *headerImg; //图片的链接
@property(nonatomic,strong)NSString *title;  //标题
@end
