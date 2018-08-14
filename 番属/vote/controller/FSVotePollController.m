//
//  FSVotePollController.m
//  番属
//
//  Created by 王佳苗 on 2018/8/7.
//  Copyright © 2018年 王佳苗. All rights reserved.
//

#import "FSVotePollController.h"
//view
#import "FSVoteOptionHeader.h"
#import "FSVotePollCell.h"
//model
#import "FSVote.h"
#import "FSVoteOptions.h"


#import "FSNetworkingTool.h"
@interface FSVotePollController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property(nonatomic,strong)UICollectionView *collectionView;
@property(nonatomic,strong)UICollectionViewFlowLayout *flowLayout;
@property(nonatomic,strong)NSArray *options; //
@property(nonatomic,assign)int sumpoll; //总票数
@end

@implementation FSVotePollController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initInterface];
    //
    [self loadOptions];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
}
//初始化界面
-(void)initInterface{
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self.view addSubview:self.collectionView];
    
    //配置导航栏
    //插入
    UIBarButtonItem *backItem=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"back.png"] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    
    self.navigationItem.leftBarButtonItem=backItem;
//    self.navigationItem.title=@"投票";
    
    
}
//返回到首页
-(void)back{
    
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)setOptions:(NSArray *)options{
    _options=options;
    
    for (FSVoteOptions *op in options) {
        self.sumpoll+=op.poll;
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - 懒加载
-(UICollectionViewFlowLayout *)flowLayout{
    if(_flowLayout==nil){
        _flowLayout=[[UICollectionViewFlowLayout alloc]init];
        _flowLayout.minimumLineSpacing=10.0f;
        //item大小
        _flowLayout.itemSize=CGSizeMake(CGRectGetWidth(self.view.bounds)-10, 60);
        //头部大小
        _flowLayout.headerReferenceSize=CGSizeMake(CGRectGetWidth(self.view.bounds), 44);
        //滚动方向
        _flowLayout.scrollDirection=UICollectionViewScrollDirectionVertical;
    }
    return _flowLayout;
}
-(UICollectionView *)collectionView{
    if(_collectionView==nil){
        _collectionView=[[UICollectionView alloc]initWithFrame:self.view.bounds collectionViewLayout:self.flowLayout];
        //无分割线
//        _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
        _collectionView.backgroundColor=FSBackgroundColor;
        
        //注册cell
        [_collectionView registerClass:[FSVotePollCell class] forCellWithReuseIdentifier:@"pollCell"];
        //注册头部
        [_collectionView registerClass:[FSVoteOptionHeader class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"pollHeader"];
        _collectionView.delegate=self;
        _collectionView.dataSource=self;
        
    }
    return _collectionView;
}
#pragma mark - table view delegate
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.options.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    FSVotePollCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"pollCell" forIndexPath:indexPath];
    cell.backgroundColor=[UIColor whiteColor];
    cell.option=self.options[indexPath.item];
    cell.sum=self.sumpoll;
    return cell;
}
-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    if([kind isEqualToString:UICollectionElementKindSectionHeader]){
        FSVoteOptionHeader *headerView=[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"pollHeader" forIndexPath:indexPath];
        headerView.title=self.vote.title;
        return headerView;
    }
   
    return nil;
}

#pragma  mark - 网络请求
-(void)loadOptions{
    NSString *url=[NSString stringWithFormat:@"vote/get_options.php?vote_id=%d",self.vote.vote_id];
    [[FSNetworkingTool shareNetworkingTool] GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        self.options=[FSVoteOptions mj_objectArrayWithKeyValuesArray:responseObject[@"options"]];
//        NSLog(@"%@",self.options);
        [self.collectionView reloadData];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

@end
