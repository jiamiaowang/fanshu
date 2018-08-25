//
//  FSArticleContentCell.h
//  番属
//
//  Created by 王佳苗 on 2018/8/25.
//  Copyright © 2018年 王佳苗. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PictureModel;
@interface FSArticleContentCell : UITableViewCell
- (void)creatTextContainerString:(NSString *)contentStr withPicModel:(PictureModel *)model;

@end
