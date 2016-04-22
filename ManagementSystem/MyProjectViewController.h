//
//  MyProjectViewController.h
//  ManagementSystem
//
//  Created by admin on 16/3/26.
//  Copyright © 2016年 JCK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyProjectViewController : UIViewController<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate>
{
    UIView *hearView;
}
@property UITableView *tableView;
@property (nonatomic, assign) int statet;
+(UIViewController *)viewController:(UIView *)view;

@end
