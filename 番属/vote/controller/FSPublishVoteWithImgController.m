//
//  FSPublishVoteViewController.m
//  番属
//
//  Created by 王佳苗 on 2018/8/14.
//  Copyright © 2018年 王佳苗. All rights reserved.
//

#import "FSPublishVoteWithImgController.h"
//view
#import "FSPublishVoteTitle.h"
#import "FSPublishFooter.h"
#import "FSPublishVoteWithImgCell.h"
#import "FSPublishVoteFooter.h"
//model
#import "FSPublishOption.h"

//
#import "UILabel+Extension.h"
#import "UILabel+Extension.h"
//第三方
#import <AFNetworking.h>

#import "FSNetworkingTool.h"

@interface FSPublishVoteWithImgController ()<UITableViewDelegate,UITableViewDataSource,UINavigationControllerDelegate,UIImagePickerControllerDelegate>
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray<FSPublishOption*> *voteOptions;
@property(nonatomic,assign)CGRect textFieldFrame;
@property(nonatomic,assign)NSInteger setImageIndex;  //记录当前添加的图片的cell
@property(nonatomic,strong)NSString *voteTitle;

@end

@implementation FSPublishVoteWithImgController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self.view addSubview:self.tableView];
    //在UITableView上添加手势 隐藏键盘
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyBoard)];
    //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
    tapGestureRecognizer.cancelsTouchesInView = NO;
    [self.tableView addGestureRecognizer:tapGestureRecognizer];
    
    [self setupTableViewHeaderAndFooter];
    [self addKeyboardNotification];
    
//    self.edgesForExtendedLayout=UIRectEdgeNone;
//    self.automaticallyAdjustsScrollViewInsets=NO;
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//
-(void)hideKeyBoard
{
    [self.view endEditing:YES];
}

-(void)setupTableViewHeaderAndFooter{
    FSPublishVoteTitle *titleView=[[FSPublishVoteTitle alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 44)];
    self.tableView.tableHeaderView=titleView;
    WeakSelf;
    __weak typeof(titleView) weakView=titleView;
    titleView.titleWillEditBlock=^(CGRect frame){
        weakSelf.textFieldFrame=[weakView convertRect:frame toView:weakSelf.view];
    };
    //投票标题
    titleView.titleEndEditBlock = ^(NSString *title) {
        weakSelf.voteTitle=title;
    };
    
    FSPublishFooter *publishView=[[FSPublishFooter alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 60)];
    self.tableView.tableFooterView=publishView;
    //发布
    publishView.publishBolck = ^{
        
        [weakSelf canUpload];
    };
}
#pragma mark - 键盘通知
-(void)addKeyboardNotification{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}
//键盘弹出
-(void)keyboardWillShow:(NSNotification *)notification{

//    NSLog(@"键盘弹出");
    //获取键盘高度
    CGFloat keyHeight=[[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    //判断控件是否会被遮住   20为控制上移位移的自定义值,防止文本框和键盘刚好接在一起
    CGFloat offest=(self.textFieldFrame.origin.y+self.textFieldFrame.size.height)-(self.tableView.frame.size.height-keyHeight);
//    NSLog(@"%f",offest);
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
//键盘收回
-(void)keyboardWillHide:(NSNotification *)notification{
    double duration=[[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    //视图下沉恢复原状   64是因为有导航栏的高度
    [UIView animateWithDuration:duration animations:^{
        self.view.frame=CGRectMake(0, 44, self.view.frame.size.width, self.view.frame.size.height);
    }];
}
#pragma  mark - 懒加载
-(UITableView *)tableView{
    if(_tableView==nil){
        _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0,ScreenWidth, self.view.bounds.size.height-44-64) style:UITableViewStyleGrouped];
        _tableView.backgroundColor=FSBackgroundColor;
        _tableView.delegate=self;
        _tableView.dataSource=self;
        [_tableView registerClass:[FSPublishVoteWithImgCell class] forCellReuseIdentifier:@"voteCell"];
        
    }
    return _tableView;
}
-(NSMutableArray<FSPublishOption *> *)voteOptions{
    if(_voteOptions==nil){
        _voteOptions=[NSMutableArray array];
        for (int i=0; i<2; i++) {
            FSPublishOption *option=[[FSPublishOption alloc]init];
            [_voteOptions addObject:option];
        }
    }
    return _voteOptions;
}

#pragma mark - taleview dataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.voteOptions.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    FSPublishVoteWithImgCell *cell=[tableView dequeueReusableCellWithIdentifier:@"voteCell" forIndexPath:indexPath];
    cell.index=indexPath.row+1;
    cell.option=self.voteOptions[indexPath.row];
    __weak typeof(cell)weakCell = cell;
    WeakSelf;
    cell.nameTextWillEditBlock=^(CGRect frame){
        weakSelf.textFieldFrame=[weakCell convertRect:frame toView:weakSelf.view];
    };
    //
    cell.nameTextEndEditBlock=^(NSString *nameText){
        weakSelf.voteOptions[indexPath.row].name=nameText;
    };
    
    //添加图片
    cell.addPhotoBlock = ^{
        weakSelf.setImageIndex=indexPath.row;
        [weakSelf addPhoto];
    };
    //删除一行
    cell.deleteRowBlock = ^{
        [weakSelf.voteOptions removeObjectAtIndex:indexPath.row];
        [weakSelf.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        [weakSelf.tableView reloadData];
        
    };
    return cell;
}
#pragma mark - tableView delegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 150;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 44;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    FSPublishVoteFooter *footerView=[[FSPublishVoteFooter alloc]init];
    WeakSelf;
    //添加一行选项
    footerView.addRowBlock=^{
        [weakSelf.voteOptions addObject:[[FSPublishOption alloc]init]];
        NSInteger row=weakSelf.voteOptions.count-1;
        NSIndexPath *indexPath=[NSIndexPath indexPathForRow:row inSection:0];
        [weakSelf.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];

    };
    return footerView;
}
#pragma mark - 添加照片
-(void)addPhoto{
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
    [self.parentViewController presentViewController:imageController animated:YES completion:nil];
}
-(void)selectPhoto:(int)index{
    UIImagePickerController *imagePicker=[[UIImagePickerController alloc]init];
    imagePicker.delegate=self;
    imagePicker.allowsEditing=YES;
    if(index==0){
        //判断是否支持相机
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
            imagePicker.sourceType=UIImagePickerControllerSourceTypeCamera;
//            [self.parentVC presentViewController:imagePicker animated:YES completion:nil];

        }
        else{
            [UILabel showTip:@"当前设备不支持相机" toView:self.parentViewController.view centerYOffset:-64];
        }
        
    }
    else{
        imagePicker.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
        [self.parentViewController presentViewController:imagePicker animated:YES completion:nil];
    }
}

#pragma mark - UIImagePickerControlleryDeledate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
//    NSLog(@"%@",info);
    
    self.voteOptions[self.setImageIndex].image=info[UIImagePickerControllerEditedImage];
    //一个cell刷新
    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:self.setImageIndex inSection:0];
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
//    [self.tableView reloadData];
    [self.parentViewController dismissViewControllerAnimated:YES completion:nil];
}
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self.parentViewController dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - 网络上传
-(void)canUpload{
    if(!self.voteTitle.length){
        [UILabel showTip:@"投票的标题不能为空" toView:self.parentViewController.view centerYOffset:-64];
        
        return;
    }
    for (int i =0 ; i<self.voteOptions.count; i++) {
        if(!self.voteOptions[i].name.length){
            [UILabel showTip:@"选项名称不能为空" toView:self.parentViewController.view centerYOffset:-64];
            return;
        }
        if(self.voteOptions[i].image==nil){
            [UILabel showTip:@"选项图片不能为空" toView:self.parentViewController.view centerYOffset:-64];
            return;
        }
    }
    [self uploadData];
}
-(void)uploadData{
    NSMutableDictionary *dict=[[NSMutableDictionary alloc]init];
    [dict setValue:self.voteTitle forKey:@"voteTitle"];
    NSMutableArray *optionNameArray=[NSMutableArray array];
    for (int i=0; i<self.voteOptions.count; i++) {
        NSDictionary *dictName=[NSMutableDictionary dictionary];
        [dictName setValue:self.voteOptions[i].name forKey:@"name"];
        [optionNameArray addObject:dictName];
    }
    [dict setValue:optionNameArray forKey:@"voteOption"];
    
    //上传图片
    [[FSNetworkingTool shareNetworkingTool] POST:@"vote/uploadVoteWithImg.php" parameters:dict constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        for (int i=0; i<self.voteOptions.count; i++) {
            UIImage *image=self.voteOptions[i].image;
            //0.5表示质量
            NSData *imageData=UIImageJPEGRepresentation(image, 0.5);
            //在网络开发中，上传文件时，是文件不允许被覆盖，文件重名
            NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
            [formatter setDateFormat:@"yyyymmddhhmmss"];
            NSString *dateString=[formatter stringFromDate:[NSDate date]];
            NSString *fileName=[NSString stringWithFormat:@"%@.jpg",dateString];
            
            [formData appendPartWithFileData:imageData name:@"uploadImg[]" fileName:fileName mimeType:@"image/jpg/png/jpeg"];
        }
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject);
        [self.parentViewController.navigationController popViewControllerAnimated:YES];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}
@end
