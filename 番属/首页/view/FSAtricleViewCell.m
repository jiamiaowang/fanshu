//
//  FSAtricleViewCell.m
//  番属
//
//  Created by 王佳苗 on 2018/7/13.
//  Copyright © 2018年 王佳苗. All rights reserved.
//

#import "FSAtricleViewCell.h"
#import "FSArticle.h"
#import <UIImageView+WebCache.h>
@interface FSAtricleViewCell()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *cellimageView;

@end
@implementation FSAtricleViewCell

//-(void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
//    [super setHighlighted:highlighted animated:animated];
//    if(highlighted){
//        self.contentView.backgroundColor=FSSelectedColor;
//    }
//    else{
//        // 增加延迟消失动画效果，提升用户体验
//        [UIView animateWithDuration:0.1 delay:0.1 options:UIViewAnimationOptionCurveEaseInOut animations:^{
//            self.contentView.backgroundColor=[UIColor whiteColor];
//        } completion:nil];
//    }
//}
- (void)awakeFromNib {
    [super awakeFromNib];
    self.layer.cornerRadius = 10;
    self.layer.masksToBounds = YES;
//    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
}
-(void)setArticle:(FSArticle *)article{
    _article=article;
    self.titleLabel.text=article.title;
    [self.cellimageView sd_setImageWithURL:[NSURL URLWithString:article.headerImg]];
}
@end
