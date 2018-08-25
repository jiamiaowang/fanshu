//
//  FSArticleCoverController.m
//  番属
//
//  Created by 王佳苗 on 2018/8/23.
//  Copyright © 2018年 王佳苗. All rights reserved.
//

#import "FSArticleCoverController.h"
//view
#import "FSArticleHeaderView.h"
#import "FSMoreArticleController.h"
#import "UILabel+Extension.h"

#import "FSNetworkingTool.h"
//model
#import "FSArticleContent.h"
@interface FSArticleCoverController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate>
@property(nonatomic,strong)FSArticleHeaderView *headerView;
@property(nonatomic,strong)NSString *articleTitle;
@end

@implementation FSArticleCoverController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.edgesForExtendedLayout=UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor=FSBackgroundColor;
    [self initInterface];
    [self setupNavigation];
}
-(void)initInterface{
    self.headerView=[[FSArticleHeaderView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 220)];
    [self.view addSubview:self.headerView];
    WeakSelf;
    self.headerView.addPhotoBlock = ^{
        [weakSelf addPicture];
    };
    self.headerView.titleEndEditBlock = ^(NSString *title) {
        weakSelf.articleTitle=title;
    };
}
-(void)setupNavigation{
    //配置导航栏
    UIBarButtonItem *leftItem=[UIBarButtonItem barButtonItemWithTitle:@"上一步" target:self action:@selector(back)];
    self.navigationItem.leftBarButtonItem=leftItem;
    UIBarButtonItem *rightItem=[UIBarButtonItem barButtonItemWithTitle:@"发布" target:self action:@selector(publish)];
    self.navigationItem.rightBarButtonItem=rightItem;
}
-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
    
}
-(void)publish{
    [self.view endEditing:YES];
    if(!self.headerView.image){
        [UILabel showTip:@"请添加封面" toView:self.view centerYOffset:-64];
        return;
    }
    if(self.articleTitle.length==0){
        [UILabel showTip:@"文章标题不能为空" toView:self.view centerYOffset:-64];
        return;
    }
    [self uploadData];
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)addPicture{
    //
    
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
    imagePicker.allowsEditing=NO;
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
    UIImage *image=[info objectForKey:UIImagePickerControllerOriginalImage];
    //添加图片 自动换行
    self.headerView.image=image;
    
    
    
}
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - 上传
-(void)uploadData{
    NSMutableDictionary *dict=[NSMutableDictionary dictionary];
    [dict setValue:self.articleTitle forKey:@"articleTitle"];
    [dict setValue:self.content.contentStr forKey:@"contentStr"];
    
    [[FSNetworkingTool shareNetworkingTool]POST:@"article/uploadArticle.php" parameters:dict constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        UIImage *headerImg=self.headerView.image;
        NSData *headerImageData=UIImageJPEGRepresentation(headerImg, 0.5);
        [formData appendPartWithFileData:headerImageData name:@"headerImg" fileName:@"headerImage.jpg" mimeType:@"image/jpg/png/jpeg"];
        if(self.content.imgArr.count>0){
            for (int i=0; i<self.content.imgArr.count; i++) {
                UIImage *image=self.content.imgArr[i];
                //0.5表示质量
                NSData *imageData=UIImageJPEGRepresentation(image, 0.5);
                //在网络开发中，上传文件时，是文件不允许被覆盖，文件重名
                NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
                [formatter setDateFormat:@"yyyymmddhhmmss"];
                NSString *dateString=[formatter stringFromDate:[NSDate date]];
                NSString *fileName=[NSString stringWithFormat:@"%@.jpg",dateString];
                
                [formData appendPartWithFileData:imageData name:@"uploadImg[]" fileName:fileName mimeType:@"image/jpg/png/jpeg"];
            }
        }
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject);
        [self publishSuccess];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}
-(void)publishSuccess{
    FSMoreArticleController *moreVC=self.navigationController.viewControllers[1];
    [self.navigationController popToViewController:moreVC animated:YES];
}
@end
