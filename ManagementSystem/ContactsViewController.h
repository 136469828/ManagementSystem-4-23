//
//  ContactsViewController.h
//  ManagementSystem
//
//  Created by JCong on 16/3/10.
//  Copyright © 2016年 JCK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContactsViewController : UIViewController<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate>
{
    UIView *hearView;
    int count;
}

@property UITableView *tableView;
@end
