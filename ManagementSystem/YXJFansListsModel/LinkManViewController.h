//
//  LinkManViewController.h
//  ManagementSystem
//
//  Created by admin on 16/6/21.
//  Copyright © 2016年 JCK. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^ablock)(NSArray *arr,NSInteger count);
@interface LinkManViewController : UIViewController
@property (nonatomic, copy) ablock block;
@property (nonatomic, assign) BOOL isShow;
@end
