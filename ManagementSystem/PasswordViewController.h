//
//  PasswordViewController.h
//  ManagementSystem
//
//  Created by admin on 16/3/25.
//  Copyright © 2016年 JCK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PasswordViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *btn;
@property (weak, nonatomic) IBOutlet UITextField *theOldPassword;

@property (weak, nonatomic) IBOutlet UITextField *theNewPassword;


@end
