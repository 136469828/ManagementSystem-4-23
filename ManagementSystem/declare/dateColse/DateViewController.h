//
//  DateViewController.h
//  PinFan
//
//  Created by JCong on 16/3/17.
//  Copyright © 2016年 JCK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JTCalendar.h"
typedef void (^mblock)(NSString *str);
@interface DateViewController : UIViewController<JTCalendarDataSource>
@property (weak, nonatomic) IBOutlet JTCalendarMenuView *calendarMenuView;
@property (weak, nonatomic) IBOutlet JTCalendarContentView *calendarContentView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *calendarContentViewHeight;
@property (nonatomic, copy) mblock block;
@property (strong, nonatomic) JTCalendar *calendar;

@end
