//
//  FSSearchViewController.m
//  番属
//
//  Created by 王佳苗 on 2018/7/9.
//  Copyright © 2018年 王佳苗. All rights reserved.
//

#import "FSSearchViewController.h"
#import "FSSearchBar.h"
#import "UIBarButtonItem+Extension.h"
@interface FSSearchViewController ()
@property(nonatomic,strong)FSSearchBar *searchBar;
@end

@implementation FSSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self setupNavigationBar];
}
-(void)setupNavigationBar{
    //搜索框
    self.searchBar=[FSSearchBar searchBarWithPlaceholder:@"番剧、同人"];
    self.navigationItem.titleView=self.searchBar;
    [self.searchBar becomeFirstResponder];
    
    self.navigationItem.leftBarButtonItem = nil;
    self.navigationItem.hidesBackButton = YES;
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem barButtonItemWithTitle:@"取消" target:self action:@selector(cancel)];
    
    
    
    
}
//取消按钮回调
-(void)cancel{
    [self.searchBar resignFirstResponder];
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}





@end
