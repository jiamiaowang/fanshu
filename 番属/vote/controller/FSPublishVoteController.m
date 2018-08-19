//
//  FSPublishVoteController.m
//  番属
//
//  Created by 王佳苗 on 2018/8/15.
//  Copyright © 2018年 王佳苗. All rights reserved.
//

#import "FSPublishVoteController.h"

#import "FSPublishVoteWithImgController.h"
#import "FSPublishVoteNoImgController.h"
@interface FSPublishVoteController ()
@property(nonatomic,strong)FSPublishVoteWithImgController *withImgVC;
@property(nonatomic,strong)FSPublishVoteNoImgController *noImgVC;

@property(nonatomic,strong)UIViewController *currentView;
@property(nonatomic,strong)UIButton *currentButton;

@property(nonatomic,strong)UIView *bottonView;
@end

@implementation FSPublishVoteController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=[UIColor whiteColor];
    self.edgesForExtendedLayout=UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets=NO;
    
    [self initInterface];
    [self setuoNavigation];
    
    
    
   
    
}
-(void)setuoNavigation{
    //配置导航栏
    UIBarButtonItem *backItem=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"back.png"] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    self.navigationItem.leftBarButtonItem=backItem;
}
-(void)back{
    UIAlertController *alertController=[UIAlertController alertControllerWithTitle:@"确定放弃编辑，离开页面" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *confirmAction=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
    [alertController addAction:confirmAction];
    UIAlertAction *cancelAction=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
    
}
-(void)initInterface{
    self.withImgVC=[[FSPublishVoteWithImgController alloc]init];
    self.withImgVC.view.frame=CGRectMake(0, 44, ScreenWidth, ScreenHeight-44);
    NSLog(@"%f",self.withImgVC.view.frame.size.height);
    [self addChildViewController:self.withImgVC];
    
    self.noImgVC=[[FSPublishVoteNoImgController alloc]init];
    self.noImgVC.view.frame=CGRectMake(0, 44, ScreenWidth, ScreenHeight-44);
    
    
    
    //默认第一个视图
    [self.view addSubview:self.withImgVC.view];
    
    //
    UIView *titleView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 44)];
    titleView.backgroundColor=[UIColor whiteColor];
    NSArray *titleArray=@[@"有图",@"无图"];
    CGFloat buttonW=self.view.bounds.size.width/titleArray.count;
    for (int i=0; i<titleArray.count; i++) {
        UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:titleArray[i] forState:UIControlStateNormal];
        button.frame=CGRectMake(i*buttonW, 0, buttonW, 44);
        button.tag=100+i;
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
        [titleView addSubview:button];
    }
    [self.view addSubview:titleView];
    //底部滑动条
    self.bottonView=[[UIView alloc]initWithFrame:CGRectMake(0, 40, buttonW, 4)];
    self.bottonView.backgroundColor=FSThemeColor;
    [self.view addSubview:self.bottonView];

    
    
    self.currentView=self.withImgVC;
    self.currentButton=[titleView.subviews objectAtIndex:0];
    [self.currentButton setTitleColor:RGB(149, 75, 88) forState:UIControlStateNormal];
}
-(void)click:(UIButton *)button{
    if((self.currentView == self.withImgVC && button.tag==100) || (self.currentView==self.noImgVC  && button.tag==101)  ){
        return;
    }
    switch (button.tag) {
        case 100:
            [self replaceController:self.currentView newController:self.withImgVC button:button];
            break;
        case 101:
            [self replaceController:self.currentView newController:self.noImgVC button:button];
            break;
        
        
        default:
            break;
    }
    
    
}
//切换各个标签内容
-(void)replaceController:(UIViewController *)oldViewController newController:(UIViewController *)newViewController button:(UIButton *)button{
    
    //    transitionFromViewController:toViewController:duration:options:animations:completion:
    //        fromViewController      当前显示在父视图控制器中的子视图控制器
    //        toViewController        将要显示的姿势图控制器
    //        duration                动画时间(这个属性,old friend 了 O(∩_∩)O)
    //        options                 动画效果(渐变,从下往上等等,具体查看API)
    //        animations              转换过程中得动画
    //        completion              转换完成
    
    [self addChildViewController:newViewController];
    
    [newViewController willMoveToParentViewController: nil];
    
    [self transitionFromViewController:oldViewController toViewController:newViewController duration:0.5 options:UIViewAnimationOptionTransitionNone animations:^{
        CGRect frame=self.bottonView.frame;
        frame.origin.x=frame.origin.x+(button.frame.origin.x-self.currentButton.frame.origin.x);
        self.bottonView.frame=frame;
        [self.currentButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        self.currentButton=button;
        [self.currentButton setTitleColor:RGB(149, 75, 88) forState:UIControlStateNormal];

    } completion:^(BOOL finished) {
        if(finished){
            
            [newViewController didMoveToParentViewController:self];
            [oldViewController willMoveToParentViewController:nil];
            [oldViewController removeFromParentViewController];
            self.currentView=newViewController;
            
//            self.currentButton=button;
//            [self.currentButton setTitleColor:RGB(149, 75, 88) forState:UIControlStateNormal];
        }
        else{
            self.currentView=oldViewController;
        }
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
