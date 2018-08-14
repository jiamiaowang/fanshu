//
//  FSTabBarViewController.m
//  番属
//
//  Created by 王佳苗 on 2018/7/8.
//  Copyright © 2018年 王佳苗. All rights reserved.
//

#import "FSTabBarViewController.h"
#import "FSMainViewController.h"
#import "FSMineViewController.h"
#import "FSLoginViewController.h"

extern BOOL islogin;
@interface FSTabBarViewController ()

@end

@implementation FSTabBarViewController

+(void)initialize{
    //默认颜色
    NSMutableDictionary *normalAttrs=[NSMutableDictionary dictionary];
    normalAttrs[NSFontAttributeName]=[UIFont systemFontOfSize:11];
    normalAttrs[NSForegroundColorAttributeName]=FSTabBarNormalColor;
    //选中颜色
    NSMutableDictionary *selectedAttr=[NSMutableDictionary dictionary];
    selectedAttr[NSFontAttributeName]=normalAttrs[NSFontAttributeName];
    selectedAttr[NSForegroundColorAttributeName]=FSThemeColor;
    //
    UITabBarItem *item=[UITabBarItem appearance];
    [item setTitleTextAttributes:normalAttrs forState:UIControlStateNormal];
    [item setTitleTextAttributes:selectedAttr forState:UIControlStateSelected];
    //tabbar颜色
    UITabBar *tabBar = [UITabBar appearance];
    [tabBar setBarTintColor:[UIColor whiteColor]];
    tabBar.translucent = NO;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupChildViewController:[[FSMainViewController alloc]init] title:@"首页" image:@"tabMainDeselected" selectedImage:@"tabMainSelected"] ;
    [self setupChildViewController:[[FSMineViewController alloc]init] title:@"我的" image:@"tabMeDeselected" selectedImage:@"tabMeSelected"] ;
//      [self setupChildViewController:[[FSLoginViewController alloc]init] title:@"我的" image:@"tabMeDeselected" selectedImage:@"tabMeSelected"] ;
    
    

    
}
//设置子视图
-(void)setupChildViewController:(UIViewController *)childController title:(NSString *)title image:(NSString *)image selectedImage:(NSString *)selectedImage{
    childController.title=title;
    [childController.tabBarItem setImage:[UIImage imageNamed:image]];
    [childController.tabBarItem setSelectedImage:[UIImage imageNamed:selectedImage]];
    
    UINavigationController *nav=[[UINavigationController alloc]initWithRootViewController:childController];
    
    [nav.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    nav.navigationBar.barTintColor=FSThemeColor;


    nav.title=title;

    
    [self addChildViewController:nav];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
