//
//  FSPublishVoteNoImgCell.h
//  番属
//
//  Created by 王佳苗 on 2018/8/18.
//  Copyright © 2018年 王佳苗. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FSPublishVoteNoImgCell : UITableViewCell
@property(nonatomic,strong)NSString *nameText;
@property(nonatomic,assign)NSInteger index;
@property(nonatomic,copy)void (^nameTextWillEditBlock)(CGRect);  //开始编辑textField
@property(nonatomic,copy)void (^nameTextEndEditBlock)(NSString *);  //结束编辑textFIled
@property(nonatomic,copy)void (^deleteRowBlock)();  //删除某一行@end
@end
