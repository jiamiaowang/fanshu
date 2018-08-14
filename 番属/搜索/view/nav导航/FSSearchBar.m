//
//  FSSearchBar.m
//  番属
//
//  Created by 王佳苗 on 2018/7/9.
//  Copyright © 2018年 王佳苗. All rights reserved.
//

#import "FSSearchBar.h"
@interface FSSearchBar()<UISearchBarDelegate>
@end
@implementation FSSearchBar

+(instancetype)searchBarWithPlaceholder:(NSString *)placeholder{
    FSSearchBar *searchBar=[[FSSearchBar alloc]init];
    searchBar.delegate=searchBar;
    searchBar.placeholder=placeholder;
    //光标颜色
    searchBar.tintColor=FSTabBarSelectedColor;
    
    
    
    return searchBar;
}
#pragma mark UISearchBarDelegate
//将要输入文字时
-(BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    !self.searchBarShouldBeginEditingBlock ? :self.searchBarShouldBeginEditingBlock();
    return  YES;
}
    

//- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
//    !self.searchBarShouldBeginEditingBlock ? : self.searchBarShouldBeginEditingBlock();
//    return YES;
//}
//
//- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
//    !self.searchBarTextDidChangedBlock ? : self.searchBarTextDidChangedBlock();
//}
//
//- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
//    !self.searchBarDidSearchBlock ? : self.searchBarDidSearchBlock();
//}
@end
