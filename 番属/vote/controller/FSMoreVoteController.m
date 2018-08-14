//
//  FSMoreVoteController.m
//  番属
//
//  Created by 王佳苗 on 2018/8/8.
//  Copyright © 2018年 王佳苗. All rights reserved.
//

#import "FSMoreVoteController.h"
//view
#import "FSVoteViewCell.h"
//model
#import "FSVote.h"


//跳转界面
#import "FSVoteOptionViewController.h"
#import "FSVotePollController.h"
#import "FSPublishVoteViewController.h"

#import "FSNetworkingTool.h"
//第三方
#import <MJRefresh.h>
#import <MJExtension.h>
@interface FSMoreVoteController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSArray *voteArray;
@end

@implementation FSMoreVoteController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view .backgroundColor=FSBackgroundColor;
    [self initInterface];
    
    [self setupRefrensh];
    
    [self loadNewData];
    self.edgesForExtendedLayout=UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets=NO;
    
}
//初始化界面
-(void)initInterface{
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self.view addSubview:self.tableView];
    
    //配置导航栏
    UIBarButtonItem *backItem=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"back.png"] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    self.navigationItem.leftBarButtonItem=backItem;
    self.navigationItem.title=@"投票";
    
    UIBarButtonItem *rightItem=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"publish"] style:UIBarButtonItemStylePlain target:self action:@selector(publishVote)];
    self.navigationItem.rightBarButtonItem=rightItem;
    
}
-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)publishVote{
    self.hidesBottomBarWhenPushed=YES;
    FSPublishVoteViewController *publishVC=[[FSPublishVoteViewController alloc]init];
    [self.navigationController pushViewController:publishVC animated:YES];
}
//设置刷新
-(void)setupRefrensh{
    self.tableView.mj_header =[MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self
                                                                    refreshingAction:@selector(loadMoreData)];
}
#pragma mark - 懒加载
-(UITableView *)tableView{
    if(_tableView==nil){
        _tableView=[[UITableView alloc]initWithFrame:CGRectMake(10, 0, ScreenWidth-20, CGRectGetHeight(self.view.bounds)) style:UITableViewStylePlain];
        _tableView.delegate=self;
        _tableView.dataSource=self;
        _tableView.backgroundColor=FSBackgroundColor;
        [_tableView registerClass:[FSVoteViewCell class] forCellReuseIdentifier:@"moreVote"];
        
    }
    return _tableView;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - table view data soure
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.voteArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    FSVoteViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"moreVote" forIndexPath:indexPath];
    FSVote *vote=self.voteArray[indexPath.row];
    cell.title=vote.title;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    FSVote *vote=self.voteArray[indexPath.row];
    [self isVoted:vote];
}
//根据请求结果决定该跳转的界面
-(void)whichVC:(int)isvoted vote:(FSVote *)vote{
    self.hidesBottomBarWhenPushed=YES;
    if(isvoted ==0){
        FSVoteOptionViewController *voteOptionVC=[[FSVoteOptionViewController alloc]init];
        voteOptionVC.vote=vote;
        [self.navigationController pushViewController:voteOptionVC animated:YES];
    }
    else{
        FSVotePollController *pollVC=[[FSVotePollController alloc]init];
        pollVC.vote=vote;
        [self.navigationController pushViewController:pollVC animated:YES];
    }
    self.hidesBottomBarWhenPushed=NO;
}
#pragma mark - 网络加载
-(void)loadNewData{
    [[FSNetworkingTool shareNetworkingTool]GET:@"vote/get_vote.php" parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        self.voteArray=[FSVote mj_objectArrayWithKeyValuesArray:responseObject[@"vote"]];
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
        [self.tableView.mj_header endRefreshing];

    }];
}
-(void)loadMoreData{
    [self.tableView.mj_footer endRefreshing];
}
//获取判断该用户是否以投票
-(void)isVoted:(FSVote *)vote{
    NSString *url=[NSString stringWithFormat:@"vote/isVoted?vote_id=%d",vote.vote_id];
    [[FSNetworkingTool shareNetworkingTool]GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        int isvoted=[responseObject[@"isvoted"] intValue];
        //        NSLog(@"%d",isvoted);
        [self whichVC:isvoted vote:vote];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}
@end
