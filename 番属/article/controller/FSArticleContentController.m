;//
//  FSArticleContentController.m
//  番属
//
//  Created by 王佳苗 on 2018/8/24.
//  Copyright © 2018年 王佳苗. All rights reserved.
//

#import "FSArticleContentController.h"

#import "FSNetworkingTool.h"
#import "NSString+Regular.h"
#import "NSString+CaclSize.h"
//model
#import "FSArticleContent.h"
#import "FSArticle.h"
#import "PictureModel.h"

//view
#import "FSArticleShowHeader.h"
#import "FSArticleContentCell.h"


#import <MJExtension.h>
@interface FSArticleContentController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)FSArticleShowHeader *headerView;
@property(nonatomic,strong)FSArticleContent *content;
@property(nonatomic,strong)NSArray *contentStr;
@property(nonatomic,strong)NSMutableArray *cellHeightArr;
@property(nonatomic,strong)NSMutableArray *imageArr;
@end

@implementation FSArticleContentController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view addSubview:self.tableView];
    [self setupnavigation];
    [self setupHeaderView];
    
    [self loadData];
    
    self.edgesForExtendedLayout=UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets=NO;
}
-(void)setupnavigation{
    //配置导航栏
    UIBarButtonItem *backItem=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"back.png"] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    self.navigationItem.leftBarButtonItem=backItem;
    
    
}
-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)setupHeaderView{
    self.headerView=[[FSArticleShowHeader alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 220)];
    self.tableView.tableHeaderView=self.headerView;
    self.headerView.article=self.article;

}
#pragma mark - 懒加载
-(UITableView *)tableView{
    if(_tableView==nil){
        _tableView=[[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
        _tableView.delegate=self;
        _tableView.dataSource=self;
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([FSArticleContentCell class]) bundle:nil] forCellReuseIdentifier:@"articleContentCell"];
        
        
    }
    return _tableView;
}
-(void)setArticle:(FSArticle *)article{
    _article=article;
    
    
}
-(void)setImgArr{
    NSString *separatedStr=[NSString stringWithFormat:@"%@\n",RICHTEXT_IMAGE];
    self.contentStr=[self.content.contentStr componentsSeparatedByString:separatedStr];
    if(self.content.imgArr!=NULL){
        NSString *string = [self.content.imgArr componentsJoinedByString:@","];
        
        self.imageArr=[NSMutableArray array];
        NSArray * imageOfWH=[string RXToArray];
        if (self.imageArr!=nil) {
            [self.imageArr removeAllObjects];
        }
        //获取字符串中的图片
        for (NSDictionary * dict in imageOfWH) {
            if ([dict isKindOfClass:[NSDictionary class]]) {
                
                PictureModel * model=[[PictureModel alloc]init];
                model.imgSrc=dict[@"src"];
                model.width=[dict[@"width"] floatValue];;
                model.height=[dict[@"height"] floatValue];
                [self.imageArr addObject:model];
   
                
            }
        }
        
    }
    
        

    
    [self setCellHeight];


}
-(void)setCellHeight{
    self.cellHeightArr=[NSMutableArray array];
    for (int i=0; i<self.contentStr.count; i++) {
        
        NSString * str=[self.contentStr objectAtIndex:i];
        CGSize textSize=CGSizeZero;
        CGFloat cellHeight=0.f;
        //注意这里的设置，是根据约束条件来的
        textSize=[str calculateSize:CGSizeMake(ScreenWidth-20, FLT_MAX) font:[UIFont systemFontOfSize:16.f]];
        
        if (i<self.contentStr.count-1) {
            PictureModel * model=[self.imageArr objectAtIndex:i];
            CGFloat ImgWidth=ScreenWidth-20;
            
            if (model.width>0||model.height>0) {
                
                CGFloat ImgHeight=model.height*ImgWidth/model.width;
                cellHeight=ImgHeight+textSize.height;
                
                [self.cellHeightArr addObject:[NSNumber numberWithFloat:cellHeight]];
                
            }
            
        }
        else
        {
            
            [self.cellHeightArr addObject:[NSNumber numberWithFloat:textSize.height]];
        }
    }
}
#pragma mark - tableView dataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.contentStr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    FSArticleContentCell *cell=[tableView dequeueReusableCellWithIdentifier:@"articleContentCell" forIndexPath:indexPath];
    PictureModel * model=nil;
    if (indexPath.row<self.imageArr.count) {
        model=[self.imageArr objectAtIndex:indexPath.row];
        
    }
    
    [cell creatTextContainerString:self.contentStr[indexPath.row] withPicModel:model];

    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row < self.cellHeightArr.count) {
        return [[self.cellHeightArr objectAtIndex:indexPath.row] floatValue];
    }
    return 0;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - 网络请求
-(void)loadData{
    NSString *url=[NSString stringWithFormat:@"article/getContent.php?articleID=%d",self.article.article_id];
    [[FSNetworkingTool shareNetworkingTool]GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        self.content=[FSArticleContent mj_objectWithKeyValues:responseObject];
//        NSLog(@"constr %@",self.content.contentStr);
//        NSLog(@"img %@",self.content.imgArr);
        [self setImgArr];
        [self.tableView reloadData];
//        NSLog(@"%@",responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}


@end
