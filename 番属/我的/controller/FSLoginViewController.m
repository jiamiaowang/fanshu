//
//  FSLoginViewController.m
//  番属
//
//  Created by 王佳苗 on 2018/8/9.
//  Copyright © 2018年 王佳苗. All rights reserved.
//

#import "FSLoginViewController.h"
#import "FSUnderlineTextField.h"

#import "FSMineViewController.h"
#import "UIButton+Extension.h"
#import "UILabel+Extension.h"
//跳转界面
#import "FSRegisterViewController.h"
//
#import "FSNetworkingTool.h"
#import "NSString+Hash.h"
#import <Masonry.h>
extern BOOL islogin;
@interface FSLoginViewController ()<UITextFieldDelegate>
@property(nonatomic,strong)FSUnderlineTextField *accountText;  //账号
@property(nonatomic,strong)FSUnderlineTextField *passwordText;  //密码
@property(nonatomic,strong)UIButton *loginButton;  //登录按钮

@end

@implementation FSLoginViewController

- (void)viewDidLoad {
    self.automaticallyAdjustsScrollViewInsets=NO;
    self.edgesForExtendedLayout=UIRectEdgeNone;
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor=[UIColor whiteColor];
    [self initInterface];
    
    [self addNoticeForKeyboard];
    
    
    }
//初始化界面
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
    self.accountText=[FSUnderlineTextField underlineTextField:@"手机／邮箱" fontSize:15];
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
    //密码
    self.passwordText=[FSUnderlineTextField underlineTextField:@"密码" fontSize:15];
    [self.view addSubview:self.passwordText];
    
    [self.passwordText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.accountText.mas_bottom).mas_offset(20);
        make.centerX.equalTo(self.view);
        make.width.equalTo(self.accountText);
        make.height.equalTo(self.accountText);
    }];
  
    //输入变点
    self.passwordText.secureTextEntry=YES;
    self.passwordText.delegate=self;
    
    //立即注册按钮
    UIButton *registerButton=[UIButton buttonWithTitle:@"立即注册" font:[UIFont systemFontOfSize:13] textColor:RGB(149, 75, 88) target:self action:@selector(gotoRegister)];
    [self.view addSubview:registerButton];
    [registerButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.accountText);
        make.top.equalTo(self.passwordText.mas_bottom).mas_offset(20);
    }];
    
    
    //登陆按钮
    self.loginButton=[UIButton buttonWithTitle:@"登录" font:[UIFont systemFontOfSize:15] textColor:[UIColor whiteColor] target:self action:@selector(gotoLogin)];
    self.loginButton.backgroundColor=FSThemeColor;
    [self.view addSubview:self.loginButton];
    [self.loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(registerButton.mas_bottom).mas_offset(20);
        make.centerX.equalTo(self.view);
        make.width.equalTo(self.accountText);
        make.height.equalTo(self.accountText);
    }];

}
-(void)closeVC{
    [self dismissViewControllerAnimated:YES completion:nil];
}
//
-(void)gotoRegister{
//    NSLog(@"注册");
    FSRegisterViewController *registerVC=[[FSRegisterViewController alloc]init];
    [self presentViewController:registerVC animated:YES completion:nil];
}
#pragma mark - 登录
-(void)gotoLogin{
//    NSLog(@"登陆");
    NSString *passStr=self.passwordText.text;
    NSString *accountStr=self.accountText.text;
//    NSLog(@"%@",accountStr);
    if([accountStr isEqualToString:@""]){
//        NSLog(@"用户名为空");
        [UILabel showTip:@"用户名不能为空" toView:self.view centerYOffset:0];
        return;
    }
    if([passStr isEqualToString:@""]){
//        NSLog(@"密码为空");
        [UILabel showTip:@"密码不能为空" toView:self.view centerYOffset:0];
        return;
    }
    
    
    
    [self getTIme:passStr];
    
    
}

//获取系统时间
-(void)getTIme:(NSString *)passStr{
    [[FSNetworkingTool shareNetworkingTool]GET:@"login/getLoginTime.php" parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //从服务器获取当前时间 到分钟的字符串
        NSString *time=responseObject[@"time"];
        [self passAddTime:time password:passStr];
//        NSLog(@"%@",time);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"请求时间失败");
        [UILabel showTip:@"请检查网络" toView:self.view centerYOffset:0];

//        NSLog(@"%@",error);
        return ;
    }];

}
//获取原密码+时间的一个密码
-(void)passAddTime:(NSString *)time password:(NSString *)passStr{
    //自定义一个字符串fanshu md5计算
    NSString *key =[@"fanshu" md5String];
    //把原密码和之前生成的md5值进行hmac加密
    NSString *hmacKey=[passStr hmacMD5StringWithKey:key];
    //第二步产生的hmac值+时间 和第一步生成的md5值进行hmac
    NSString *passEnd=[[hmacKey stringByAppendingString:time] hmacMD5StringWithKey:key];
//    NSLog(@"%@",passEnd);
    
    
    NSString *accountStr=self.accountText.text;
    [self login:accountStr password:passEnd];
}

//判断账号和密码
-(void)login:(NSString *)account password:(NSString *)password{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:account forKey:@"account"];
    [dict setValue:password forKey:@"password"];
//    NSLog(@"%@",dict);
    [[FSNetworkingTool shareNetworkingTool]POST:@"login/checkLogin.php" parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSLog(@"%@",responseObject);
        NSString *isSuccess=responseObject[@"success"];
        [self iscanLogin:isSuccess];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {

//        NSLog(@"%@",error);
        return ;
    }];
}
//判断是否登录成功
-(void)iscanLogin:(NSString *)isSuccess{
    if([isSuccess isEqualToString:@"success"]){
        [self logined];
    }
    else{
        [UILabel showTip:@"用户名或密码错误" toView:self.view centerYOffset:0];
        
    }
}
//登录成功之后
-(void)logined{
    islogin=true;

    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 文本框
//限制文本框的内容和长度
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    //这里的if时候为了获取删除操作,如果没有次if会造成当达到字数限制后删除键也不能使用的后果
        if (range.length == 1 && string.length == 0) {
            return YES;
        }
    if(textField==self.accountText){
        //先设置只能输入的集合  invertedSet就是将咱们允许输入的字符串的字符找出
        NSCharacterSet *cs=[[NSCharacterSet characterSetWithCharactersInString:@"1234567890\n"]invertedSet];
        //把允许输入的内容转化成数组,再转化成字符串(按cs分离出数组,数组按@""分离出字符串)
        NSString *str=[[string componentsSeparatedByCharactersInSet:cs]componentsJoinedByString:@""];
        BOOL canChange=[string isEqualToString:str];
        if(textField.text.length<11 && canChange){
            return YES;
        }
        else{
            return NO;
        }
    
    }
    else{
        return YES;
    }
    
}
//处理回车事件
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self gotoLogin];
    return YES;
}
#pragma mark - 添加键盘通知
-(void)addNoticeForKeyboard{
    //键盘出现的通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    //键盘消失的通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}
- (void)dealloc {
    NSLog(@"bb");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
-(void)keyboardWillShow:(NSNotification *)notification{
//    NSLog(@"键盘弹出");
    //获取键盘高度
    CGFloat keyHeight=[[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    //判断控件是否会被遮住   20为控制上移位移的自定义值
    CGFloat offest=(self.loginButton.frame.origin.y+self.loginButton.frame.size.height+20)-(self.view.frame.size.height-keyHeight);
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
