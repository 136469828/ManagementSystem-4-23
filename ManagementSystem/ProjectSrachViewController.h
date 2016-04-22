//
//  DeclareViewController.h
//  ManagementSystem
//
//  Created by JCong on 16/2/29.
//  Copyright © 2016年 JCK. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum
{
    stateFail  = 0,                 // 审核不通过
    
    stateSuccess,                   // 审核通过
    
    stating,                        // 审核中

}state;

@interface ProjectSrachViewController : UIViewController<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate>
{
    UIView *hearView;
    state statetype;
}
@property UITableView *tableView;
@property (nonatomic, copy) NSString *ID;
@end
