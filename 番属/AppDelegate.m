//
//  AppDelegate.m
//  番属
//
//  Created by 王佳苗 on 2018/7/8.
//  Copyright © 2018年 王佳苗. All rights reserved.
//

#import "AppDelegate.h"
#import "FSTabBarViewController.h"
#import "FSNetworkingTool.h"
#import "FSLoginViewController.h"
@interface AppDelegate ()<UITabBarControllerDelegate>

@end
BOOL islogin;  //用户是否登陆
@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    FSTabBarViewController *tabVC=[[FSTabBarViewController alloc]init];
    tabVC.delegate=self;
    self.window.rootViewController=tabVC;
    [self.window makeKeyAndVisible];
    islogin=false;
    [self checkLogin];
    return YES;
}
-(void)checkLogin{
    [[FSNetworkingTool shareNetworkingTool]GET:@"logined.php" parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        islogin=[responseObject[@"login"] intValue];
//        NSLog(@"%d",islogin);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}
-(BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController{
    
    //我的  判断是否登录
    if(viewController==[tabBarController.viewControllers objectAtIndex:1]){
        if(!islogin){
            FSLoginViewController *login = [[FSLoginViewController alloc] init];

            [((UINavigationController *)viewController) presentViewController:login animated:YES completion:nil];
        }
    }
    return YES;
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
