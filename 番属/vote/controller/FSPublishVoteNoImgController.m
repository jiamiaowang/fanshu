//
//  FSPublishVoteNoImgController.m
//  番属
//
//  Created by 王佳苗 on 2018/8/15.
//  Copyright © 2018年 王佳苗. All rights reserved.
//

#import "FSPublishVoteNoImgController.h"
#import "UILabel+Extension.h"
//view
#import "FSPublishVoteTitle.h"
#import "FSPublishFooter.h"
#import "FSPublishVoteNoImgCell.h"
#import "FSPublishVoteFooter.h"
//
#import "FSNetworkingTool.h"
@interface FSPublishVoteNoImgController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,assign)CGRect textFieldFrame;
@property(nonatomic,strong)NSString *voteTitle;
@property(nonatomic,strong)NSMutableArray<NSString *> *nameArray; //选项名称数组
@end

@implementation FSPublishVoteNoImgController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.tableView];
    
    //在UITableView上添加手势 隐藏键盘
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyBoard2)];
    //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
    tapGestureRecognizer.cancelsTouchesInView = NO;
    [self.tableView addGestureRecognizer:tapGestureRecognizer];

    
    
    [self setupTableViewHeaderAndFooter];
    
    [self addKeyboardNotification];
    
    self.edgesForExtendedLayout=UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets=NO;

}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
//
-(void)hideKeyBoard2
{
    [self.view endEditing:YES];
}
//设置头部和脚部
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
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - 懒加载
-(NSMutableArray<NSString *> *)nameArray{
    if(_nameArray==nil){
        _nameArray=[NSMutableArray array];
        for (int i=0 ; i<2; i++) {
            NSString *str=[NSString string];
            [_nameArray addObject:str];
        }
    }
    return _nameArray;
}
-(UITableView *)tableView{
    if(_tableView==nil){
        _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0,ScreenWidth, self.view.bounds.size.height-44-64) style:UITableViewStyleGrouped];
        _tableView.backgroundColor=FSBackgroundColor;
        _tableView.delegate=self;
        _tableView.dataSource=self;
        [_tableView registerClass:[FSPublishVoteNoImgCell class] forCellReuseIdentifier:@"optionCell"];
    }
    return _tableView;
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
#pragma mark - tableView dataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.nameArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    FSPublishVoteNoImgCell *cell=[tableView dequeueReusableCellWithIdentifier:@"optionCell" forIndexPath:indexPath];
    cell.index=indexPath.row+1;
    cell.nameText=self.nameArray[indexPath.row];
    
    
    WeakSelf;
    __weak typeof(cell) weakCell=cell;
    cell.nameTextWillEditBlock=^(CGRect frame){
        weakSelf.textFieldFrame=[weakCell convertRect:frame toView:self.view];
    };
    cell.nameTextEndEditBlock = ^(NSString *name) {
        weakSelf.nameArray[indexPath.row]=name;
    };
    //删除一行
    cell.deleteRowBlock = ^{
        [weakSelf.nameArray removeObjectAtIndex:indexPath.row];
        [weakSelf.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        [weakSelf.tableView reloadData];

    };
    return cell;
}

#pragma  mark - tableView delegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 44;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    FSPublishVoteFooter *footerView=[[FSPublishVoteFooter alloc]init];
    WeakSelf;
    //添加一行选项
    footerView.addRowBlock=^{
        [weakSelf.nameArray addObject:[[NSString alloc]init]];
        NSInteger row=weakSelf.nameArray.count-1;
        NSIndexPath *indexPath=[NSIndexPath indexPathForRow:row inSection:0];
        [weakSelf.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        
    };
    return footerView;
}
#pragma mark - 网络上传
-(void)canUpload{
    if(!self.voteTitle.length){
        [UILabel showTip:@"投票的标题不能为空" toView:self.parentViewController.view centerYOffset:-64];
        return;
    }
    for (int i =0 ; i<self.nameArray.count; i++) {
        if(!self.nameArray[i].length){
            [UILabel showTip:@"选项名称不能为空" toView:self.parentViewController.view centerYOffset:-64];
            return;
        }
        
    }
    [self uploadData];
}
-(void)uploadData{
    NSMutableDictionary *dict=[NSMutableDictionary dictionary];
    [dict setValue:self.voteTitle forKey:@"voteTitle"];
    NSMutableArray *optionNameArray=[NSMutableArray array];
    for (int i=0; i<self.nameArray.count; i++) {
        NSDictionary *dictName=[NSMutableDictionary dictionary];
        [dictName setValue:self.nameArray[i] forKey:@"name"];
        [optionNameArray addObject:dictName];
    }
    [dict setValue:optionNameArray forKey:@"voteOption"];
    [[FSNetworkingTool shareNetworkingTool]POST:@"vote/uploadVoteNoImg.php" parameters:dict progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject);
        [self .parentViewController.navigationController popViewControllerAnimated:YES];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [UILabel showTip:@"请检查网络" toView:self.parentViewController.view centerYOffset:-64];
        NSLog(@"%@",error);
    }];
}
@end
