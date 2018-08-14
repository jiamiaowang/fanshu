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
    
}
-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}
//设置刷新
-(void)setupRefrensh{
    self.tableView.mj_header =[MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
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
    FSVoteOptionViewController *optionVC=[[FSVoteOptionViewController alloc]init];
    optionVC.vote=vote;
    [self.navigationController pushViewController:optionVC animated:YES];
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

@end
