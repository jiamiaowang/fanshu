//
//  FSPublishVoteCell.h
//  番属
//
//  Created by 王佳苗 on 2018/8/15.
//  Copyright © 2018年 王佳苗. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FSPublishOption;
@interface FSPublishVoteWithImgCell : UITableViewCell
@property(nonatomic,strong)FSPublishOption *option;
@property(nonatomic,assign)NSInteger index;
@property(nonatomic,copy)void (^addPhotoBlock)();  //添加图片
@property(nonatomic,copy)void (^nameTextWillEditBlock)(CGRect);  //开始编辑textField
@property(nonatomic,copy)void (^nameTextEndEditBlock)(NSString *);  //结束编辑textFIled
@property(nonatomic,copy)void (^deleteRowBlock)();  //删除某一行
@end
