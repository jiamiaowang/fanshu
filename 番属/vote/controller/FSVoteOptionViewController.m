//
//  FSVoteOptionViewController.m
//  番属
//
//  Created by 王佳苗 on 2018/7/17.
//  Copyright © 2018年 王佳苗. All rights reserved.
//

#import "FSVoteOptionViewController.h"
//view
#import "FSVoteOptionCell.h"
#import "FSVoteOptionNoImgCell.h"
#import "FSVoteOptionHeader.h"
#import "FSVoteOptionFooter.h"
//model
#import "FSVoteOptions.h"
#import "FSVote.h"
//跳转界面
#import "FSVotePollController.h"


#import "UILabel+Extension.h"

#import "FSNetworkingTool.h"
//
@interface FSVoteOptionViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property(nonatomic,strong)NSArray *voteOptionArray;  //投票的选项
@property(nonatomic,strong)UICollectionView *collectionView;
@property(nonatomic,strong)UICollectionViewFlowLayout *myFlowLayout;

@property(nonatomic,assign)int currentSelected;  //当前选择
@end

@implementation FSVoteOptionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initInterface];
    [self loadOptions];
    
}
//初始化界面
-(void)initInterface{
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self.view addSubview:self.collectionView];
    
    //配置导航栏
    //插入
    UIBarButtonItem *backItem=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"back.png"] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    
    self.navigationItem.leftBarButtonItem=backItem;
    self.navigationItem.title=@"投票";
    
    
}
//返回
-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 懒加载
-(UICollectionViewFlowLayout *)myFlowLayout{
    if(_myFlowLayout==nil){
        _myFlowLayout=[[UICollectionViewFlowLayout alloc]init];
        //设置item的大小
        _myFlowLayout.minimumLineSpacing=10.0f;
        _myFlowLayout.minimumInteritemSpacing=10.0;
        _myFlowLayout.sectionInset=UIEdgeInsetsMake(10, 10, 15, 10);
        if(self.vote.isHaveImg==1){
            CGFloat width=(self.collectionView.bounds.size.width-_myFlowLayout.minimumInteritemSpacing-_myFlowLayout.sectionInset.left-_myFlowLayout.sectionInset.right)/2;
        
            _myFlowLayout.itemSize=CGSizeMake(width, width);
        }
        else{
            _myFlowLayout.itemSize=CGSizeMake(self.collectionView.bounds.size.width-_myFlowLayout.sectionInset.left-_myFlowLayout.sectionInset.right, 40);
        }
        

        //设置滚动方向
        _myFlowLayout.scrollDirection=UICollectionViewScrollDirectionVertical;
        //设置头部大小
        _myFlowLayout.headerReferenceSize=CGSizeMake(CGRectGetWidth(self.view.bounds), 44);
        //设置脚部大小
        _myFlowLayout.footerReferenceSize=CGSizeMake(CGRectGetWidth(self.view.bounds), 44);
        
        //设置是否当元素超出屏幕之后固定头部视图位置，默认NO
//        _myFlowLayout.sectionHeadersPinToVisibleBounds=YES;
        
    }
    return _myFlowLayout;
}
-(UICollectionView *)collectionView{
    if(_collectionView==nil){
        _collectionView=[[UICollectionView alloc]initWithFrame:CGRectMake(0,64, ScreenWidth, CGRectGetHeight(self.view.bounds)-64) collectionViewLayout:self.myFlowLayout];
        
        _collectionView.backgroundColor=[UIColor brownColor];
        //设置是否允许滚动
        _collectionView.scrollEnabled=YES;
        //设置是否允许选中。默认为yes
//        _collectionView.allowsSelection=NO;
        //设置是否能多选，默认为no
        //_collectionView.allowsMultipleSelection=YES;
        
        _collectionView.dataSource=self;
        _collectionView.delegate=self;
        
        //注册item
//        NSArray *nibArrays=[[NSBundle mainBundle]loadNibNamed:@"FSVoteOptionCell" owner:nil options:nil];
        if(self.vote.isHaveImg==1){   //有图
            [_collectionView registerNib:[UINib nibWithNibName:@"FSVoteOptionCell" bundle:nil] forCellWithReuseIdentifier:@"voteOptionCellWithImg"];
        }
        else{  //无图
            [_collectionView registerClass:[FSVoteOptionNoImgCell class] forCellWithReuseIdentifier:@"voteOptionCellNoImg"];
        }
        
        //注册头部视图
        [_collectionView registerClass:[FSVoteOptionHeader class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"voteOptionHeader"];
        //注册脚部视图
        [_collectionView registerClass:[FSVoteOptionFooter class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"voteOptionFooter"];
        _collectionView.backgroundColor=FSBackgroundColor;
        
    }
    return _collectionView;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Collection View data Source
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.voteOptionArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    //有图
    if(self.vote.isHaveImg==1){
        
        FSVoteOptionCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"voteOptionCellWithImg" forIndexPath:indexPath];
        
        cell.option=self.voteOptionArray[indexPath.item];
        
        return cell;
    }
    //无图
    else{
        FSVoteOptionCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"voteOptionCellNoImg" forIndexPath:indexPath];
        
        cell.option=self.voteOptionArray[indexPath.item];
        return cell;
    }
    return nil;
    
}
//自定义头部和脚部
-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    // UICollectionElementKindSectionHeader：头部视图
    // UICollectionElementKindSectionFooter：尾部视图
    // 如果同时自定义头部、尾部视图，可根据 kind 参数判断当前加载的是头部还是尾部视图，然后进行相应配置。
    if([kind isEqualToString:UICollectionElementKindSectionHeader]){
        FSVoteOptionHeader *headerView=[self.collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"voteOptionHeader" forIndexPath:indexPath];
        headerView.title=self.vote.title;
        return headerView;
    }
    else if([kind isEqualToString:UICollectionElementKindSectionFooter]){
        FSVoteOptionFooter *footerView=[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"voteOptionFooter"forIndexPath:indexPath];
        
        //投票按钮回调
        footerView.votebuttonBlock=^{
            [self voteButtonClick];
        };
        
        return footerView;
    }
    return nil;
    
}

#pragma mark - collectionViewFlowLayout
//
//-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
//    return  UIEdgeInsetsMake(0, 10, 0, 10);
//}

#pragma mark - 网络加载
-(void)loadOptions{
    NSString *url=[NSString stringWithFormat:@"vote/get_options.php?vote_id=%d",self.vote.vote_id];
    [[FSNetworkingTool shareNetworkingTool] GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        self.voteOptionArray=[FSVoteOptions mj_objectArrayWithKeyValuesArray:responseObject[@"options"]];
//        NSLog(@"%@",self.voteOptionArray);
        [self.collectionView reloadData];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}
//进行投票
-(void)votePoll:(int)option_id{
    NSString *url=[NSString stringWithFormat:@"vote/votePoll.php?option_id=%d&vote_id=%d",option_id,self.vote.vote_id];
    [[FSNetworkingTool shareNetworkingTool] GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"投票成功");
//        NSLog(@"%@",[NSThread currentThread]);
        //跳转票数显示页面
        self.hidesBottomBarWhenPushed=YES;
        FSVotePollController *pollVC=[[FSVotePollController alloc]init];
        pollVC.vote=self.vote;
        pollVC.backnum=1;
        [self.navigationController pushViewController:pollVC animated:YES];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"fail");
//        NSLog(@"%@",error);
    }];
}
#pragma mark - block回调
-(void)voteButtonClick{
    NSIndexPath *selectedIndexPath=[[self.collectionView indexPathsForSelectedItems]firstObject];
    if(selectedIndexPath==nil){
        [UILabel showTip:@"请选择一个选项" toView:self.view centerYOffset:0];

        return ;
    }
    FSVoteOptions *option=self.voteOptionArray[selectedIndexPath.item];
//    NSLog(@"%d",option.option_id);
    [self votePoll:option.option_id];
}







@end
