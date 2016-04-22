//
//  ScrollView.m
//  No.1 Pharmacy
//
//  Created by JCong on 15/11/7.
//  Copyright © 2015年 梁健聪. All rights reserved.
//

#import "ScrollView.h"
//#import "NextManger.h"
//#import "CarouselModel.h"
//#import "UIImageView+WebCache.h"

#define scrollView_Hight ScreenHeight*0.28
@implementation ScrollView
{
    NSInteger imageCount;
    NSString *_firstImg;
    NSString *_lastImg;
    
    NSArray *imgs;
    
}
- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame ];
    if (self) {
        [self prepareScollView];
        [self preparePageView];
    }
    return self;
}
#pragma - mark scorllView
- (void)prepareScollView {
    NSString *img1 = @"zq1.jpg";
    NSString *img2 = @"zq2.jpg";
    NSString *img3 = @"zq3.jpg";
    NSString *img4 = @"zq4.jpg";
    imgs = @[img1,img2,img3,img4];
//    imageCount = [NextManger shareInstance].carouselDatas.count;
    //        NSLog(@"%ld",imageCount);
    imageCount = imgs.count;
    CGFloat scrollH = scrollView_Hight+10;
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, scrollH)];
    scrollView.delegate = self;
    
    for (int i = 0; i < imageCount; i++) {
//        CarouselModel *model2 = [NextManger shareInstance].carouselDatas[i];
//        CarouselModel *model3 = [NextManger shareInstance].carouselDatas[0];
//        _firstImg = model2.carouselImage;
//        _lastImg = model3.carouselImage;
        _firstImg = imgs[0];
        _lastImg = imgs[i];

        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.tag = i;
//        if ([NextManger shareInstance].carouselDatas.count == 0) {
//            return;
//        }
        CGFloat imageX = ScreenWidth * (i + 1);
        imageView.frame = CGRectMake(imageX, 0, ScreenWidth, scrollH);
//        
//        CarouselModel *model = [NextManger shareInstance].carouselDatas[i];
//        [imageView sd_setImageWithURL: [NSURL URLWithString:model.carouselImage]];
        imageView.image = [UIImage imageNamed:imgs[i]];
        
        [scrollView addSubview:imageView];
        
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapUpClick:)];
        imageView.userInteractionEnabled = YES;
        [imageView addGestureRecognizer:tap];
    }
    
    UIImageView *firstImage = [[UIImageView alloc] init];
//    [firstImage sd_setImageWithURL:[NSURL URLWithString:_firstImg]];
    firstImage.image = [UIImage imageNamed:img1];
    firstImage.frame = CGRectMake(0, 0, ScreenWidth, scrollH);
    [scrollView addSubview:firstImage];
    scrollView.contentOffset = CGPointMake(ScreenWidth, 0);
    
    UIImageView *lastImage = [[UIImageView alloc] init];
//    [lastImage sd_setImageWithURL:[NSURL URLWithString:_lastImg]];
    lastImage.image = [UIImage imageNamed:img4];
    lastImage.frame = CGRectMake((imageCount + 1) * ScreenWidth, 0, ScreenWidth, scrollH);
    [scrollView addSubview:lastImage];
    scrollView.contentSize = CGSizeMake((imageCount + 2) * ScreenWidth, 0);
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.pagingEnabled = YES;
    [self addSubview:scrollView];
    self.scroll = scrollView;
    [self addTimer];
    
}

-(void)preparePageView {
    CGFloat pageW = 100;
    UIPageControl *pageView = [[UIPageControl alloc] initWithFrame:CGRectMake((ScreenWidth - pageW) * 0.8, scrollView_Hight, pageW, 4)];
    pageView.numberOfPages = imageCount;
    pageView.currentPageIndicatorTintColor = [UIColor whiteColor];
    pageView.pageIndicatorTintColor = [UIColor lightGrayColor];
    pageView.currentPage = 0;
    [self addSubview:pageView];
    self.pageControl = pageView;
}

- (void)addTimer{
    // 过滤计时器
    if ([_timer isValid]) {
        [_timer invalidate];
        _timer = nil;
    }
    _timer = [NSTimer scheduledTimerWithTimeInterval:2.5 target:self selector:@selector(nextImage) userInfo:nil repeats:YES];
    
    NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
    [runLoop addTimer:self.timer forMode:NSRunLoopCommonModes];
}

-(void)nextImage {
    CGFloat width = self.scroll.frame.size.width;
    NSInteger index = self.pageControl.currentPage;
    if (index == imageCount + 1) {
        index = 0;
    } else {
        index++;
    }
    [self.scroll setContentOffset:CGPointMake((index + 1) * width, 0)animated:YES];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    CGFloat width = self.scroll.frame.size.width;
    long index = (self.scroll.contentOffset.x + width * 0.5) / width;
    if (index == imageCount + 2) {
        index = 1;
    } else if(index == 0) {
        index = imageCount;
    }
    self.pageControl.currentPage = index - 1;
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.timer invalidate];
    self.timer = nil;
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [self addTimer];
}

-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    [self scrollViewDidEndDecelerating:scrollView];
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    CGFloat width = self.scroll.frame.size.width;
    int index = (self.scroll.contentOffset.x + width * 0.5) / width;
    if (index == imageCount + 1) {
        [self.scroll setContentOffset:CGPointMake(width, 0) animated:NO];
    } else if (index == 0) {
        [self.scroll setContentOffset:CGPointMake(imageCount * width, 0) animated:NO];
    }
}
/**
 *  图片点击事件
 */
- (void)tapUpClick:(UITapGestureRecognizer*)tap
{
    if (_delegate)
    {
        [_delegate tapClick:(int)tap.view.tag];
    }
}@end
