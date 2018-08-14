//
//  UIAlertController+Extension.m
//  番属
//
//  Created by 王佳苗 on 2018/8/12.
//  Copyright © 2018年 王佳苗. All rights reserved.
//

#import "UIAlertController+Extension.h"

@implementation UIAlertController (Extension)
+(UIAlertController *)alertController:(NSString *)title message:(NSString *)message actionTitle:(NSString *)actionTitle{
    UIAlertController *alertController=[UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action=[UIAlertAction actionWithTitle:actionTitle style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:action];
    
    return alertController;
}
@end
