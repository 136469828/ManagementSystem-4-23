//
//  ChoseLinkManViewController.h
//  ManagementSystem
//
//  Created by guofeng on 16/4/20.
//  Copyright © 2016年 JCK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChoseLinkManViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
{
    UIView *hearView;
    int count;
}
@property (nonatomic, strong) UITableView *tableView;
@end
