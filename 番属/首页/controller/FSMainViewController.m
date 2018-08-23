//
//  FSMainViewController.m
//  番属
//
//  Created by 王佳苗 on 2018/7/8.
//  Copyright © 2018年 王佳苗. All rights reserved.
//

#import "FSMainViewController.h"


//model
#import "FSArticle.h"
#import "FSVote.h"
#import "FSVoteOptions.h"

#import "FSVoteAndArticle.h"

//view
#import "FSAtricleViewCell.h"
#import "FSVoteViewCell.h"
#import "FSSectionHeader.h"
#import "FSImageHeader.h"

//跳转界面
#import "FSVoteOptionViewController.h"
#import "FSVotePollController.h"
#import "FSSearchViewController.h"
#import "FSLoginViewController.h"

#import "FSMoreVoteController.h"
#import "FSMoreArticleController.h"

#import "FSNetworkingTool.h"
//第三方
#import <MJRefresh.h>
#import <MJExtension.h>
#import <Masonry.h>
extern BOOL islogin;

@interface FSMainViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)FSImageHeader *header;  //头部轮播图
@property(nonatomic,strong)FSVoteAndArticle *voteAndArticle;  //投票和文章


@end

@implementation FSMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = FSBackgroundColor;
    
    
    //加载网络数据
    [self loadNewData];
    
    
    [self setupNavigationBar];
    [self setupTableView];
    [self setupTableViewHeader];
    [self setupRefrensh];
    
    
    //
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    
    
    
}


//设置导航栏
-(void)setupNavigationBar{
    //搜索按钮
    UIBarButtonItem *searchButton=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"searchButton"] style:UIBarButtonItemStylePlain target:self action:@selector(search)];
    self.navigationItem.rightBarButtonItem=searchButton;
    self.title=@"番属";
//    self.navigationController.navigationBar.barTintColor=FSThemeColor;
}
-(void)search{
    FSSearchViewController *searchVC=[[FSSearchViewController alloc]init];
    [self.navigationController pushViewController:searchVC animated:YES];
}
//设置头部（轮播图）
-(void)setupTableViewHeader{
    self.header=[[FSImageHeader alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 115)];
    self.header.content=self.voteAndArticle.hot;
    self.tableView.tableHeaderView=self.header;
    
}

-(void)setupTableView{
    self.tableView=[[UITableView alloc]init];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.backgroundColor = FSBackgroundColor;
    [self.tableView registerClass:[FSVoteViewCell class]
           forCellReuseIdentifier:@"voteCell"];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([FSAtricleViewCell class]) bundle:nil]
    forCellReuseIdentifier:@"atricleCell"];
    
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(5, 10, 5, 10));
    }];
    
    
   
   
}
//设置刷新
-(void)setupRefrensh{
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    
    
    [self.tableView.mj_header beginRefreshing];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.voteAndArticle.article.count+1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(section==0){
        return self.voteAndArticle.vote.count;
    }

    return 1;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section==0){
        FSVoteViewCell *cell=[self.tableView dequeueReusableCellWithIdentifier:@"voteCell"forIndexPath:indexPath];
        FSVote *vote=self.voteAndArticle.vote[indexPath.row];
        cell.title=vote.title;
        return cell;
    }
    else{
        FSAtricleViewCell *cell=[self.tableView dequeueReusableCellWithIdentifier:@"atricleCell" forIndexPath:indexPath];
        FSArticle *article=self.voteAndArticle.article[indexPath.section-1];
        cell.article=article;
    
        return cell;
    }
}
#pragma mark - Table View delegate
//行头
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if(section<2){
        return 40;
    }
    return 10;
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {

    FSSectionHeader *sectionHeader=[[FSSectionHeader alloc]init];
    if(section==0){
        sectionHeader.title=@"投票";
        sectionHeader.moreBlock=^{
            self.hidesBottomBarWhenPushed=YES;
            FSMoreVoteController *moreVC=[[FSMoreVoteController alloc]init];
            [self.navigationController pushViewController:moreVC animated:YES];
            self.hidesBottomBarWhenPushed=NO;
        };
        return sectionHeader;
    }
    else if(section==1){
        sectionHeader.title=@"推荐文章";
        sectionHeader.moreBlock=^{
            self.hidesBottomBarWhenPushed=YES;
            FSMoreArticleController *moreVC=[[FSMoreArticleController alloc]init];
            [self.navigationController pushViewController:moreVC animated:YES];
            self.hidesBottomBarWhenPushed=NO;
        };
        return sectionHeader;
    }
    
    return nil;
    
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView

{
    CGFloat sectionHeaderHeight;
    sectionHeaderHeight = 40;
    if (scrollView == self.tableView) {
        //去掉UItableview的section的headerview黏性
        if (scrollView.contentOffset.y<=sectionHeaderHeight && scrollView.contentOffset.y>=0) {
            scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
        } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
            scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
        }
    }
}

//cell高
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section==0){
        return 40;
    }
    else if(indexPath.section>=1){
        return 180;
    }
    return 0;
}
//
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //调转投票选项
    if(indexPath.section==0){
        //未登录
        if(!islogin){
            FSLoginViewController *loginVC=[[FSLoginViewController alloc]init];
            [self presentViewController:loginVC animated:YES completion:nil];
            return;
        }
        
        FSVote *vote=self.voteAndArticle.vote[indexPath.row];
        [self isVoted:vote];
    }
    else{
        
    }
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
#pragma mark - 网络请求
-(void)loadNewData{
//    [self.tableView.mj_footer endRefreshing];
    [[FSNetworkingTool shareNetworkingTool] GET:@"main.php"
            parameters:nil
              progress:nil
               success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                   self.voteAndArticle=[FSVoteAndArticle mj_objectWithKeyValues:responseObject];
//                   NSLog(@"%@",self.voteAndArticle.hot);
                   self.header.content=self.voteAndArticle.hot;
                   [self.tableView reloadData];
                   [self.tableView.mj_header endRefreshing];
               } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                   NSLog(@"loadNewData --- failure");
//                   NSLog(@"%@",error);
                   [self.tableView.mj_header endRefreshing];
                }];

}
//获取判断该用户是否以投票
-(void)isVoted:(FSVote *)vote{
    NSString *url=[NSString stringWithFormat:@"vote/isVoted?vote_id=%d",vote.vote_id];
    [[FSNetworkingTool shareNetworkingTool]GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        int isvoted=[responseObject[@"isvoted"] intValue];
//        NSLog(@"%d",isvoted);
        [self whichVC:isvoted vote:vote];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        NSLog(@"%@",error);
    }];
}


@end
