//
//  SetRemindViewController.m
//  No.1 Pharmacy
//
//  Created by JCong on 15/11/23.
//  Copyright © 2015年 梁健聪. All rights reserved.
//

#import "SetRemindViewController.h"
//#import "RemindViewController.h"
#import "SetRemenberV.h"
@interface SetRemindViewController ()

@end

@implementation SetRemindViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIBarButtonItem *rBtn = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(pushRemindVC)];
    self.navigationItem.rightBarButtonItem = rBtn;
    SetRemenberV *srV = [[SetRemenberV alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self.view addSubview:srV];

}

- (void)pushRemindVC{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
+(UIViewController *)viewController:(UIView *)view{
    
    /// Finds the view's view controller.
    
    // Traverse responder chain. Return first found view controller, which will be the view's view controller.
    
    UIResponder *responder = view;
    
    while ((responder = [responder nextResponder]))
        
        if ([responder isKindOfClass: [UIViewController class]])
            
            return (UIViewController *)responder;
    
    // If the view controller isn't found, return nil.
    
    return nil;
    
}
@end
