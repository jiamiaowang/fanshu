//
//  UIView+ViewController.m
//  番属
//
//  Created by 王佳苗 on 2018/8/15.
//  Copyright © 2018年 王佳苗. All rights reserved.
//

#import "UIView+ViewController.h"
#import "FSPublishVoteController.h"
@implementation UIView (ViewController)
- (UIViewController *)viewController
{

    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (FSPublishVoteController *)nextResponder;
        }
    }
    return nil;
    
    
}
@end
