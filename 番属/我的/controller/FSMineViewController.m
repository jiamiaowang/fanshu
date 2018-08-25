//
//  MineViewController.m
//  番属
//
//  Created by 王佳苗 on 2018/7/8.
//  Copyright © 2018年 王佳苗. All rights reserved.
//

#import "FSMineViewController.h"
//view
#import "FSMineHeaderView.h"
#import "FSLoginViewController.h"
#import "FSLogoutView.h"

#import "FSNetworkingTool.h"
#import "UILabel+Extension.h"
//model
#import "FSUserInfo.h"

#import <MJExtension.h>
extern BOOL islogin;
@interface FSMineViewController ()<UITableViewDelegate,UITableViewDataSource,UINavigationControllerDelegate,UIImagePickerControllerDelegate>
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)FSMineHeaderView *headerView;
@property(nonatomic,strong)NSArray *listArray;
@end

@implementation FSMineViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if(islogin){
        [self loadInfo];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
    
    [self setupHeaderViewAndFooterView];
}
-(UITableView *)tableView{
    if(_tableView==nil){
        _tableView=[[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.backgroundColor=FSBackgroundColor;
        _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
        _tableView.delegate=self;
        _tableView.dataSource=self;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];

    }
    return _tableView;
}
-(NSArray *)listArray{
    if(_listArray==nil){
        _listArray=@[@"我发布的投票",@"我发布的文章",@"我参与的投票"];
    }
    return _listArray;
}

-(void)setupHeaderViewAndFooterView{
    self.headerView=[[FSMineHeaderView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 180)];
    self.tableView.tableHeaderView=self.headerView;
    WeakSelf;
    self.headerView.addAvatarImgBlcok = ^{
        if(!islogin){
          FSLoginViewController *loginVC=[[FSLoginViewController alloc]init];
          [weakSelf presentViewController:loginVC animated:YES completion:nil];
          return ;
        }
        [weakSelf addAvatar];
        
    };
    
    FSLogoutView *footerView=[[FSLogoutView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 60)];
    self.tableView.tableFooterView=footerView;
    footerView.logoutBlcok = ^{
        [weakSelf logout];
        
    };
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.listArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.textLabel.text=self.listArray[indexPath.section];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    return cell;
}
#pragma mark - TableView Delegate
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
      return 10;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:
            
            break;
            
        default:
            break;
    }
}
#pragma mark - 添加或修改头像
-(void)addAvatar{
    UIAlertController *imageController=[UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    WeakSelf;
    UIAlertAction *cameraAction=[UIAlertAction actionWithTitle:@"相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf selectPhoto:0];
    }];
    UIAlertAction *photoalbumAction=[UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf selectPhoto:1];
    }];
    UIAlertAction *cancelAction=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [imageController addAction:cameraAction];
    [imageController addAction:photoalbumAction];
    [imageController addAction:cancelAction];
    [self presentViewController:imageController animated:YES completion:nil];
    
}
-(void)selectPhoto:(int)index{
    UIImagePickerController *imagePicker=[[UIImagePickerController alloc]init];
    imagePicker.delegate=self;
    imagePicker.allowsEditing=YES;
    if(index==0){
        //判断是否支持相机
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
            imagePicker.sourceType=UIImagePickerControllerSourceTypeCamera;
            [self presentViewController:imagePicker animated:YES completion:nil];
            
        }
        else{
            [UILabel showTip:@"当前设备不支持相机" toView:self.parentViewController.view centerYOffset:-64];
        }
        
    }
    else{
        imagePicker.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:imagePicker animated:YES completion:nil];
    }
}
#pragma mark - UIImagePickerControlleryDeledate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    [self dismissViewControllerAnimated:YES completion:nil];
    UIImage *image=[info objectForKey:UIImagePickerControllerEditedImage];
    //添加图片 自动换行
    self.headerView.image=image;
    
    [self uploadAvatar];
    
    
}
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - 网络
//获取用户信息
-(void)loadInfo{
    [[FSNetworkingTool shareNetworkingTool]GET:@"login/getUserInfo.php" parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject);
        FSUserInfo *info=[FSUserInfo mj_objectWithKeyValues:responseObject];
        self.headerView.info=info;
        [self.tableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}
//上传头像
-(void)uploadAvatar{
    [[FSNetworkingTool shareNetworkingTool]POST:@"login/uploadAvatar.php" parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        UIImage *headerImg=self.headerView.image;
        NSData *headerImageData=UIImageJPEGRepresentation(headerImg, 0.5);
        [formData appendPartWithFileData:headerImageData name:@"avatarImg" fileName:@"avatar.jpg" mimeType:@"image/jpg/png/jpeg"];
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSLog(@"%@",responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"aaaaa  %@",error);
    }];
}
//注销
-(void)logout{
    [[FSNetworkingTool shareNetworkingTool]GET:@"logout.php" parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        islogin=false;
        FSUserInfo *info=[[FSUserInfo alloc]init];
        self.headerView.info=info;
        NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
        [defaults removeObjectForKey:@"account"];
        [defaults removeObjectForKey:@"password"];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}

@end
