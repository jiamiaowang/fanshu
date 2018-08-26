//
//  FSImageHeader.m
//  番属
//
//  Created by 王佳苗 on 2018/7/9.
//  Copyright © 2018年 王佳苗. All rights reserved.
//

#import "FSImageHeader.h"
#import <Masonry.h>
#import "FSArticle.h"
#import <UIImageView+WebCache.h>
//#import <UIImageView+WebCache.h>

static int const imageViewCount=3;
@interface FSImageHeader()<UIScrollViewDelegate>
@property(nonatomic,strong)UIScrollView *scrollView;
@property(nonatomic,strong)UIPageControl *pageControl;
@property(nonatomic,strong)NSTimer *timer;
@property(nonatomic,assign)int count;
@property(nonatomic,assign)BOOL isAddTimer;  //是否以开启定时器
@end

@implementation FSImageHeader
-(instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if(self){
        //scrollView
        _scrollView=[[UIScrollView alloc]initWithFrame:self.bounds];
        _scrollView.pagingEnabled=YES;
        _scrollView.showsHorizontalScrollIndicator=NO;
        self.scrollView.contentSize=CGSizeMake(self.scrollView.frame.size.width*imageViewCount, 0);
        _scrollView.delegate=self;
        [self addSubview:_scrollView];
        
        
        
        //pageControl
        _pageControl=[[UIPageControl alloc]init];
        _pageControl.userInteractionEnabled=YES;
        _pageControl.pageIndicatorTintColor=[UIColor lightGrayColor];
        [self addSubview:_pageControl];
        [_pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.centerY.equalTo(self.mas_bottom).offset(-10);
        }];
        
        self.layer.cornerRadius=6;
        self.layer.masksToBounds=YES;
        
        

    }
    return self;
}

-(void)setContent:(NSArray *)content{
    _content=content;
//    NSLog(@"aa%@",self.content);

    self.count=(int)content.count;
    
    CGFloat x=0;
    CGFloat width=self.scrollView.frame.size.width;
    CGFloat height=self.frame.size.height;

    //添加图片按钮
    for (int i=0; i<imageViewCount; i++) {
        x=i*width;
        UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(x, 0, width, height)];
        imageView.contentMode=UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds=YES;
        [self.scrollView addSubview:imageView];
    }

    self.pageControl.numberOfPages=self.count;
    self.pageControl.currentPage=0;
    
    
    [self setupContent];
    //有数据才开启定时器
    if(!self.isAddTimer && self.count!=0){
        [self addTimer];
        self.isAddTimer=true;
    }
    
}

-(void)setupContent{
    // 设置图片，页码
//    NSLog(@"count%@",self.scrollView.subviews);
    for (int i = 0; i < imageViewCount; i++) {
       
        UIImageView *imageView = self.scrollView.subviews[i];
        NSInteger index = self.pageControl.currentPage;
        if (i == 0) {
            index--;
        } else if (i == 2) {
            index++;
        }
        if (index < 0) {
            index = self.pageControl.numberOfPages - 1;
        } else if (index >= self.pageControl.numberOfPages) {
            index = 0;
        }
        imageView.tag = index;
        FSArticle *article=self.content[index];
        
        [imageView sd_setImageWithURL:[NSURL URLWithString:article.headerImg]];

    }
    
    // 设置当前偏移量
    self.scrollView.contentOffset = CGPointMake(self.scrollView.frame.size.width, 0);
    
    
}

//图片按钮回调
-(void)imageClick:(UIButton*)sender{
    int tag=(int)sender.tag-100;
    FSArticle *imageloop=self.content[tag];
    NSString *url=imageloop.headerImg;
    !self.buttonClickBlock ? : self.buttonClickBlock(url);
}
//下一张图
-(void)nextImage{

    [self.scrollView setContentOffset:CGPointMake(self.scrollView.frame.size.width*2, 0) animated:YES];
    
}
//滚动的时候
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    // 找出最中间的那个图片控件
    NSInteger page = 0;
    CGFloat minDistance = MAXFLOAT;
    for (int i = 0; i<imageViewCount; i++) {
        UIImageView *imageView = self.scrollView.subviews[i];
        CGFloat distance = 0;
        
        distance = ABS(imageView.frame.origin.x - scrollView.contentOffset.x);
        
        if (distance < minDistance) {
            minDistance = distance;
            page = imageView.tag;
            
        }
    }
    
    self.pageControl.currentPage = page;

}
//滑动结束
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [self setupContent];
}
//滚动完成
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    [self setupContent];
}
//开始拖拽时
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self removeTimer];
}
//停止拖拽
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [self addTimer];
}
//添加定时器
-(void)addTimer{
    self.timer=[NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(nextImage) userInfo:nil repeats:YES];
}
//关闭定时器
-(void)removeTimer{
    [self.timer invalidate];
    self.timer=nil;
}

@end
