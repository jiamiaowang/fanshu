//
//  FSMoreArticleController.m
//  番属
//
//  Created by 王佳苗 on 2018/8/21.
//  Copyright © 2018年 王佳苗. All rights reserved.
//

#import "FSMoreArticleController.h"
//view
#import "FSAtricleViewCell.h"

#import "FSNetworkingTool.h"

//model
#import "FSArticle.h"
//跳转界面
#import "FSPublishArticleController.h"
#import "FSLoginViewController.h"

#import <MJExtension.h>
#import <MJRefresh.h>
#import <Masonry.h>

extern BOOL islogin;
@interface FSMoreArticleController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSArray *articleArray;  //
@end

@implementation FSMoreArticleController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=FSBackgroundColor;
    [self initInterface];
    [self setupRefrensh];
    [self loadNewData];
}
-(void)initInterface{
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.edgesForExtendedLayout=UIRectEdgeNone;
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(0, 10, 0, 10));
    }];
    
    
    //配置导航栏
    UIBarButtonItem *backItem=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"back.png"] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    self.navigationItem.leftBarButtonItem=backItem;
    self.navigationItem.title=@"文章";
    
    UIBarButtonItem *rightItem=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"publish"] style:UIBarButtonItemStylePlain target:self action:@selector(publishArticle)];
    self.navigationItem.rightBarButtonItem=rightItem;

}
-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)publishArticle{
    //未登录
//    if(!islogin){
//        FSLoginViewController *loginVC=[[FSLoginViewController alloc]init];
//        [self presentViewController:loginVC animated:YES completion:nil];
//        return;
//    }
    
    self.hidesBottomBarWhenPushed=YES;
    FSPublishArticleController *publishArtcleVC=[[FSPublishArticleController alloc]init];
    [self.navigationController pushViewController:publishArtcleVC animated:YES];
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
        _tableView=[[UITableView alloc]init];
        _tableView.delegate=self;
        _tableView.dataSource=self;
        _tableView.backgroundColor=FSBackgroundColor;
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([FSAtricleViewCell class]) bundle:nil] forCellReuseIdentifier:@"atricleCell"];
        
    }
    return _tableView;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma  mark - tableView dataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.articleArray.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    FSAtricleViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"atricleCell" forIndexPath:indexPath];
    cell.article=self.articleArray[indexPath.section];
    return cell;
}
#pragma mark - tableView delegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 180;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}
#pragma mark - 网络加载
-(void)loadNewData{
    [[FSNetworkingTool shareNetworkingTool]GET:@"article/getArticle.php" parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSLog(@"%@",responseObject);
        self.articleArray=[FSArticle mj_objectArrayWithKeyValuesArray:responseObject[@"article"]];
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self.tableView.mj_header endRefreshing];
        NSLog(@"%@",error);
    }];
}
-(void)loadMoreData{
    [self.tableView.mj_footer endRefreshing];
}
@end
