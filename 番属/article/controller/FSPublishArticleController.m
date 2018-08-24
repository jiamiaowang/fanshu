//
//  FSPublishArticleController.m
//  番属
//
//  Created by 王佳苗 on 2018/8/21.
//  Copyright © 2018年 王佳苗. All rights reserved.
//

#define headerViewHeight 210


#import "FSPublishArticleController.h"
#import "UIBarButtonItem+Extension.h"

//view
#import "FSToolView.h"
#import "FSImageTextAttachment.h"

#import "UILabel+Extension.h"
#import "NSAttributedString+RichText.h"

//model
#import "FSArticleContent.h"

#import "FSArticleCoverController.h"
#import <Masonry.h>
@interface FSPublishArticleController ()<UITextViewDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>
@property(nonatomic,strong)UITextView *textView;
@property(nonatomic,strong)UILabel *placeholderLabel;//提示文字

@property(nonatomic,assign)NSRange imageRange; //记录选择图片的位置
@property(nonatomic,assign)NSRange newRange;//记录最新内容的范围
@property(nonatomic,strong)NSString *newstr; //记录最新的内容
@property(nonatomic,assign)CGFloat fontSize;
@property(nonatomic,strong)UIColor *fontColor;

@property(nonatomic,strong)FSToolView *toolView;  //工具栏
@property(nonatomic,assign)CGFloat keyboardHeight;//键盘高度

//记录变化时的内容
@property(nonatomic,strong)NSMutableAttributedString *locationStr;
@property(nonatomic,assign)BOOL isDelete; //是否回删


@end

@implementation FSPublishArticleController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.edgesForExtendedLayout=UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = NO;

    self.view.backgroundColor=[UIColor whiteColor];
    [self setupNavigation];
    
    [self initInterface];
    
    [self addKeyboardNotification];
    
}
-(void)initInterface{

    WeakSelf;
    self.textView=[[UITextView alloc]initWithFrame:CGRectMake(10, 0, ScreenWidth-20, self.view.frame.size.height-40)];
    [self.view addSubview:self.textView];
    self.textView.font=[UIFont systemFontOfSize:16];
    self.textView.scrollEnabled=YES;
    self.textView.delegate=self;
    
    [self resetStyle];

    
    //提示文字
    self.placeholderLabel=[[UILabel alloc]initWithFrame:CGRectMake(10, 0, 100, 40)];
    self.placeholderLabel.text=@"请输入正文...";
//    [self.placeholderLabel sizeToFit];
    self.placeholderLabel.font=[UIFont systemFontOfSize:16];
    self.placeholderLabel.textColor=[UIColor lightGrayColor];
    [self.view addSubview:_placeholderLabel];
    
    
    //工具栏
    self.toolView=[[FSToolView alloc]init];
    [self.view addSubview:self.toolView];
    [self.toolView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.view);
        make.bottom.equalTo(self.view);
        make.height.mas_equalTo(40);
    }];
    
    self.toolView.endEditBlcok = ^{
        [weakSelf.view endEditing:YES];
    };
    self.toolView.addPictureBlock = ^{
        [weakSelf.view endEditing:YES];
        [weakSelf addPicture];
    };

}
-(void)setupNavigation{
    //配置导航栏
    UIBarButtonItem *backItem=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"back.png"] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    self.navigationItem.leftBarButtonItem=backItem;
    
    
    
    UIBarButtonItem *rightItem=[UIBarButtonItem barButtonItemWithTitle:@"下一步" target:self action:@selector(nextStep)];
    self.navigationItem.rightBarButtonItem=rightItem;
}
-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)nextStep{
    [self.view endEditing:YES];
    
    if(!(self.textView.attributedText.length>0)){
        [UILabel showTip:@"内容不能为空" toView:self.view centerYOffset:-64];
        return;
    }
    FSArticleContent *content=[[FSArticleContent alloc]init];
    content.contentStr=[self.textView.attributedText getPlainString];
    content.imgArr=[self.textView.attributedText getImgaeArray];
    
    FSArticleCoverController *coverVC=[[FSArticleCoverController alloc]init];
    coverVC.content=content;
    [self.navigationController pushViewController:coverVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - textView各种设置
-(void)resetStyle{
//    self.textView.backgroundColor=[UIColor redColor];
    self.textView.autocorrectionType=UITextAutocorrectionTypeNo;
    self.textView.autocapitalizationType=UITextAutocapitalizationTypeNone;
    self.textView.tintColor=FSThemeColor;
    self.fontSize=16;
    self.fontColor=[UIColor blackColor];
    
    [self setInitLocation];
    NSRange wholeRange=NSMakeRange(0, _textView.textStorage.length);
    [_textView.textStorage removeAttribute:NSFontAttributeName range:wholeRange];
    [_textView.textStorage removeAttribute:NSForegroundColorAttributeName range:wholeRange];
    
    //字体颜色
    [_textView.textStorage addAttribute:NSForegroundColorAttributeName value:self.fontColor range:wholeRange];
    [_textView.textStorage addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:self.fontSize] range:wholeRange];
    NSMutableParagraphStyle *paragraphStyle=[[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineSpacing=10.0; //行距
    [_textView.textStorage addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:wholeRange];


}
-(void)setInitLocation{
    self.locationStr=nil;
    self.locationStr=[[NSMutableAttributedString alloc]initWithAttributedString:self.textView.attributedText];
    if(self.textView.textStorage.length>0){
        self.placeholderLabel.hidden=YES;
    }
}
-(void)setStyle{
    //把最新的内容进行替换
    [self setInitLocation];
    
    if(self.isDelete){
        return;
    }
    NSMutableParagraphStyle *paragraphStyle=[[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineSpacing=5.0; //行距
    NSDictionary *attributes = @{
                                 NSFontAttributeName:[UIFont systemFontOfSize:self.fontSize],
                                 NSForegroundColorAttributeName:self.fontColor,
                                 NSParagraphStyleAttributeName:paragraphStyle
                                 };
    NSAttributedString *replaceAttributeStr=[[NSAttributedString alloc]initWithString:self.newstr attributes:attributes];
    [self.locationStr replaceCharactersInRange:self.newRange withAttributedString:replaceAttributeStr];
    _textView.attributedText=self.locationStr;
    //把光标重新设定
    self.textView.selectedRange=NSMakeRange(self.newRange.location+self.newRange.length,0);
    
}

#pragma mark - textView delegate

-(void)textViewDidChange:(UITextView *)textView{
    
    if(self.textView.attributedText.length>0){
        self.placeholderLabel.hidden=YES;
    }
    else{
        self.placeholderLabel.hidden=NO;
    }
    
    NSInteger len=self.textView.attributedText.length-self.locationStr.length;
    if(len>0){
        self.isDelete=NO;
        self.newRange=NSMakeRange(self.textView.selectedRange.location-len, len);
        self.newstr=[self.textView.text substringWithRange:self.newRange];
    }
    else{
        self.isDelete=YES;
    }
    [self setStyle];
}

#pragma mark - 键盘监听
-(void)addKeyboardNotification{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
//键盘弹出
-(void)keyboardWillShow:(NSNotification *)notification{
    
    //NSLog(@"键盘弹出");
    //获取键盘高度
    CGFloat keyHeight=[[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    if (self.keyboardHeight == keyHeight) {
        return;
    }
    self.keyboardHeight = keyHeight;
    double duration=[[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        [self layoutTextView];
    } completion:nil];

    
}
//键盘收回
-(void)keyboardWillHide:(NSNotification *)notification{
    if(self.keyboardHeight==0){
        return;
    }
    self.keyboardHeight=0;
    double duration=[[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    //视图下沉恢复原状   64是因为有导航栏的高度
    [UIView animateWithDuration:duration animations:^{
        [self layoutTextView];
    }];
}
-(void)layoutTextView{
    CGFloat toolbarHeight = 40.f;
    self.toolView.frame = ({
        CGRect rect=self.toolView.frame;
        rect.origin.y = CGRectGetHeight(self.view.bounds) - toolbarHeight - self.keyboardHeight;
        rect;
    });
    
    
    UIEdgeInsets insets = self.textView.contentInset;
    insets.bottom = self.keyboardHeight + 30.f;
    insets.bottom += toolbarHeight;
    self.textView.contentInset = insets;
    
    
}
#pragma mark - 添加图片
-(void)addPicture{
    //
    self.imageRange=self.textView.selectedRange;
    
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
//设置图片
-(void)setImage:(UIImage *)img withRange:(NSRange)range {
    UIImage *image=img;
    if(image==nil){
        return;
    }
    if(![image isKindOfClass:[UIImage class]]){
        return;
    }
    CGFloat imageHeight=image.size.height*(ScreenWidth-30.0)/image.size.width;
    FSImageTextAttachment *imageTextAttachment=[FSImageTextAttachment new];
    imageTextAttachment.imageTag = RICHTEXT_IMAGE;
    imageTextAttachment.image =image;
    
    //
    imageTextAttachment.imageSize = CGSizeMake(ScreenWidth-30, imageHeight);

    NSAttributedString * imageAtt=[self appenReturn:[NSAttributedString attributedStringWithAttachment:imageTextAttachment]];
    //插入图片
    [_textView.textStorage insertAttributedString:imageAtt
                                          atIndex:range.location];
    
    //
    self.textView.selectedRange = NSMakeRange(range.location + 1, range.length);
    
    //设置locationStr的设置
    [self setInitLocation];
    
    
    
}
// 添加图片的时候前后自动换行
-(NSAttributedString *)appenReturn:(NSAttributedString*)imageStr
{
    NSAttributedString * returnStr=[[NSAttributedString alloc]initWithString:@"\n"];
    NSMutableAttributedString * att=[[NSMutableAttributedString alloc]initWithAttributedString:imageStr];
    [att appendAttributedString:returnStr];
    [att insertAttributedString:returnStr atIndex:0];
    
    return att;
}
#pragma mark - UIImagePickerControlleryDeledate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    [self dismissViewControllerAnimated:YES completion:nil];
    UIImage *image=[info objectForKey:UIImagePickerControllerOriginalImage];
    //添加图片 自动换行
    [self setImage:image withRange:self.imageRange ];

    
    
}
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
