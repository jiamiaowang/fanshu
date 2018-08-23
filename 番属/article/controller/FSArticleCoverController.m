//
//  FSArticleCoverController.m
//  番属
//
//  Created by 王佳苗 on 2018/8/23.
//  Copyright © 2018年 王佳苗. All rights reserved.
//

#import "FSArticleCoverController.h"
#import "FSArticleHeaderView.h"
#import "UILabel+Extension.h"
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
    UIImage *image=[info objectForKey:UIImagePickerControllerOriginalImage];
    //添加图片 自动换行
    self.headerView.image=image;
    
    
    
}
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
