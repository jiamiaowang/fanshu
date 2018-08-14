//
//  FSRegisterViewController.m
//  番属
//
//  Created by 王佳苗 on 2018/8/14.
//  Copyright © 2018年 王佳苗. All rights reserved.
//

#import "FSRegisterViewController.h"
#import "FSUnderlineTextField.h"
#import "UIButton+Extension.h"
#import "UIAlertController+Extension.h"

#import <Masonry.h>
#import "FSNetworkingTool.h"
extern BOOL islogin;
@interface FSRegisterViewController ()<UITextFieldDelegate>
@property(nonatomic,strong)FSUnderlineTextField *accountText;  //账号
@property(nonatomic,strong)FSUnderlineTextField *passwordText;  //密码
@property(nonatomic,strong)FSUnderlineTextField *usernameText;  //昵称
@property(nonatomic,strong)UIButton *registerButton;  //注册按钮
@end

@implementation FSRegisterViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.automaticallyAdjustsScrollViewInsets=NO;
    self.edgesForExtendedLayout=UIRectEdgeNone;
    self.view.backgroundColor=[UIColor whiteColor];
    self.navigationItem.hidesBackButton=YES;
    self.navigationItem.title=@"注册";
    
    [self initInterface];
    [self addNoticeForKeyboard];
}
-(void)initInterface{
    UIButton *backButton=[[UIButton alloc]init];
    [backButton setImage:[UIImage imageNamed:@"cha"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(closeVC) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backButton];
    [backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).mas_offset(30);
        make.left.equalTo(self.view).mas_offset(20);
    }];
    
    UIImageView *imageView=[[UIImageView alloc]init];
    imageView.image=[UIImage imageNamed:@"loginImg"];
    [self.view addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.view).mas_offset(100);
        make.width.mas_equalTo(230);
        make.height.mas_equalTo(100);
    }];
    
    
    //账号
    self.accountText=[FSUnderlineTextField createTextField:@"请输入您的手机"];
    [self.view addSubview:self.accountText];
    
    [self.accountText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.left.mas_equalTo(self.view).mas_offset(50);
        make.right.equalTo(self.view).mas_offset(-50);
        make.top.equalTo(imageView.mas_bottom).mas_offset(50);
        make.height.mas_equalTo(40);
    }];
    self.accountText.keyboardType=UIKeyboardTypeNumberPad;
    self.accountText.delegate=self;
    
    //昵称
    self.usernameText=[FSUnderlineTextField createTextField:@"请输入您的昵称"];
    [self.view addSubview:self.usernameText];
    
    [self.usernameText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.accountText.mas_bottom).mas_offset(20);
        make.centerX.equalTo(self.view);
        make.width.equalTo(self.accountText);
        make.height.equalTo(self.accountText);
    }];
    self.usernameText.delegate=self;
    
    //密码
    self.passwordText=[FSUnderlineTextField createTextField:@"请输入您的密码"];
    [self.view addSubview:self.passwordText];
    
    [self.passwordText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.usernameText.mas_bottom).mas_offset(20);
        make.centerX.equalTo(self.view);
        make.width.equalTo(self.accountText);
        make.height.equalTo(self.accountText);
    }];
    
    //输入变点
    self.passwordText.secureTextEntry=YES;
    self.passwordText.delegate=self;
    
    //已有账号按钮
    UIButton *loginButton=[UIButton buttonWithTitle:@"以有账号，去登录" font:[UIFont systemFontOfSize:13] textColor:RGB(149, 75, 88) target:self action:@selector(gotoLogin)];
    [self.view addSubview:loginButton];
    [loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.accountText);
        make.top.equalTo(self.passwordText.mas_bottom).mas_offset(20);
    }];
    
    
    //注册按钮
    self.registerButton=[UIButton buttonWithTitle:@"注册" font:[UIFont systemFontOfSize:15] textColor:[UIColor whiteColor] target:self action:@selector(gotoRegister)];
    self.registerButton.backgroundColor=FSThemeColor;
    [self.view addSubview:self.registerButton];
    [self.registerButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(loginButton.mas_bottom).mas_offset(20);
        make.centerX.equalTo(self.view);
        make.width.equalTo(self.accountText);
        make.height.equalTo(self.accountText);
    }];

}
-(void)closeVC{
    UIViewController *vc = self.presentingViewController;
    while (vc.presentingViewController) {
        vc = vc.presentingViewController;
    }
    [vc dismissViewControllerAnimated:YES  completion:nil];

}
//去登录
-(void)gotoLogin{
    [self dismissViewControllerAnimated:YES completion:nil];
}
//注册
-(void)gotoRegister{
    NSString *passStr=self.passwordText.text;
    NSString *accountStr=self.accountText.text;
    NSString *usernameStr=self.usernameText.text;
//    NSLog(@"%@",accountStr);
    if([accountStr isEqualToString:@""]){
        //        NSLog(@"用户名为空");
        UIAlertController *alert=[UIAlertController alertController:nil message:@"账号不能为空" actionTitle:@"确定"];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    if([usernameStr isEqualToString:@""]){
        UIAlertController *alert=[UIAlertController alertController:nil message:@"昵称不能为空" actionTitle:@"确定"];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    if([passStr isEqualToString:@""]){
        //        NSLog(@"密码为空");
        UIAlertController *alert=[UIAlertController alertController:nil message:@"密码不能为空" actionTitle:@"确定"];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    [self isPhone:accountStr];

}
-(void)isPhone:(NSString *)accountStr{
    NSString * MOBIL = @"^1(3[0-9]|4[579]|5[0-35-9]|7[01356]|8[0-9])\\d{8}$";
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBIL];
    if (![regextestmobile evaluateWithObject:accountStr]) {
//        NSLog(@"手机号不对");
        UIAlertController *alert=[UIAlertController alertController:nil message:@"请输入正确的手机号" actionTitle:@"确定"];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    [self isRegister];
    
}
-(void)isRegister{
    NSString *passwordStr=self.passwordText.text;
    NSString *accountStr=self.accountText.text;
    NSString *usernameStr=self.usernameText.text;
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:accountStr forKey:@"account"];
    [dict setValue:passwordStr forKey:@"password"];
    [dict setValue:usernameStr forKey:@"username"];
    [[FSNetworkingTool shareNetworkingTool]POST:@"login/register.php" parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject);
        NSString *result=responseObject[@"isSuccess"];
        [self canRegister:result];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
    
}
-(void)canRegister:(NSString *)result{
    if([result isEqualToString:@"success"]){
        islogin=true;
        [self closeVC];
        return;
    }
    else if([result isEqualToString:@"already"]){
        UIAlertController *alert=[UIAlertController alertController:nil message:@"该手机号已存在" actionTitle:@"确定"];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
}
#pragma mark - 添加键盘通知
-(void)addNoticeForKeyboard{
    //键盘出现的通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    //键盘消失的通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}
-(void)keyboardWillShow:(NSNotification *)notification{
//        NSLog(@"键盘弹出");
    //获取键盘高度
    CGFloat keyHeight=[[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    //判断控件是否会被遮住   20为控制上移位移的自定义值
    CGFloat offest=(self.registerButton.frame.origin.y+self.registerButton.frame.size.height+20)-(self.view.frame.size.height-keyHeight);
    //被挡住
    if(offest>0){
        //        NSLog(@"视图上移");
        //取得键盘的动画时间
        double duration=[[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
        //将视图上移计算好的偏移
        [UIView animateWithDuration:duration animations:^{
            self.view.frame=CGRectMake(0, -offest, self.view.frame.size.width, self.view.frame.size.height);
        }];
        
    }
}
-(void)keyboardWillHide:(NSNotification *)notification{
    //    NSLog(@"键盘收回");
    double duration=[[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    //视图下沉恢复原状   64是因为有导航栏的高度
    [UIView animateWithDuration:duration animations:^{
        self.view.frame=CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    }];
}

//收回键盘
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
