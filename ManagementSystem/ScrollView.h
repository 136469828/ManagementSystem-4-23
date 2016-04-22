//
//  ScrollView.h
//  No.1 Pharmacy
//
//  Created by JCong on 15/11/7.
//  Copyright © 2015年 梁健聪. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MyScrollViewdelegate <NSObject>

- (void)tapClick:(int)tag;

@end



@interface ScrollView : UIView<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scroll;
@property (nonatomic,strong)    UIPageControl *pageControl;
@property (strong, nonatomic) NSTimer *timer;
/**
 *  申明代理
 */
@property (assign,nonatomic)id <MyScrollViewdelegate>delegate;
@end
