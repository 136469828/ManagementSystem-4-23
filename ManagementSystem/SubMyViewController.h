//
//  SeachMyViewController.h
//  ManagementSystem
//
//  Created by admin on 16/4/22.
//  Copyright © 2016年 JCK. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum
{
    stateFail  = 0,                 // 审核不通过
    
    stateSuccess,                   // 审核通过
    
    stating,                        // 审核中
    
}state;
@interface SubMyViewController : UIViewController<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate>
{
    UIView *hearView;
    state statetype;
}
@property UITableView *tableView;
@property (nonatomic, copy) NSString *ID;

@end
