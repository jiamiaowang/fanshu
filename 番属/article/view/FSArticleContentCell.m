//
//  FSArticleContentCell.m
//  番属
//
//  Created by 王佳苗 on 2018/8/25.
//  Copyright © 2018年 王佳苗. All rights reserved.
//

#import "FSArticleContentCell.h"
#import "PictureModel.h"
#import <UIImageView+WebCache.h>
@interface FSArticleContentCell()
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *contentStr;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imgViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imgViewWidth;
@end

@implementation FSArticleContentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)creatTextContainerString:(NSString *)contentStr withPicModel:(PictureModel *)model
{
    
    self.contentStr.text=nil;
    if ([contentStr isKindOfClass:[NSString class]]) {
        self.contentStr.text=contentStr;
        
    }
    
    
    NSString * imageStr=model.imgSrc;
    
    if (imageStr!=nil) {
        CGFloat ImgWidth=ScreenWidth-20;
        
        self.imgViewWidth.constant=ImgWidth;
        if (model.height>0) {
            
            CGFloat ImgHeight=model.height*ImgWidth/model.width;
            self.imgViewHeight.constant=ImgHeight;
            
        }
        __weak typeof(self) weakSelf=self;
        
        [self.imgView sd_setImageWithURL:[NSURL URLWithString:imageStr] placeholderImage:[UIImage imageNamed:@""] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
            if (image!=nil) {
                if (model.height==0) {
                    
                    CGFloat ImgHeight=image.size.height*ImgWidth/image.size.width;
                    weakSelf.imgViewHeight.constant=ImgHeight;
                    
                }
            }
            
        }];
    }
    
    else
    {
        self.imgViewHeight.constant=0;
    }
    
    [self layoutIfNeeded];
    [self layoutSubviews];
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
