//
//  AddLinkmanViewController.h
//  ManagementSystem
//
//  Created by admin on 16/4/15.
//  Copyright © 2016年 JCK. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^ablock)(NSArray *arr);
@interface AddLinkmanViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *nameTextFild;
@property (weak, nonatomic) IBOutlet UITextField *positionTextFild;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextFild;
@property (weak, nonatomic) IBOutlet UITextField *telTextFild;
@property (nonatomic, copy) ablock block;
@end
