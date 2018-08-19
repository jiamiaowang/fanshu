//
//  FSPublishVoteTitle.h
//  番属
//
//  Created by 王佳苗 on 2018/8/15.
//  Copyright © 2018年 王佳苗. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FSPublishVoteTitle : UIView
@property(nonatomic,copy)void (^titleWillEditBlock)(CGRect );
@property(nonatomic,copy)void (^titleEndEditBlock)(NSString *);
@end
