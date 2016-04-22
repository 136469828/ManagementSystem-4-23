//
//  PasswordViewController.m
//  ManagementSystem
//
//  Created by admin on 16/3/25.
//  Copyright © 2016年 JCK. All rights reserved.
//

#import "PasswordViewController.h"
#import "ForgetViewController.h"
#import "NetManger.h"
#import "LCProgressHUD.h"
@interface PasswordViewController ()<UITextFieldDelegate>

@end

@implementation PasswordViewController
// 销毁通知中心
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.theNewPassword.delegate = self;
    self.theNewPassword.secureTextEntry = YES;

    self.theOldPassword.delegate = self;
    self.theOldPassword.secureTextEntry = YES;
    [self.btn addTarget:self action:@selector(updatepassword) forControlEvents:UIControlEventTouchDown];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.

}
*/
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    NSLog(@"textField.tex %@",textField.text);
    return YES;
}
- (IBAction)fogetPasswordAction:(UIButton *)sender
{
    ForgetViewController *forgetVC = [[ForgetViewController alloc] init];
    [self.navigationController pushViewController:forgetVC animated:YES];
}
- (void)updatepassword
{
     [LCProgressHUD showLoading:@"正在加载"];
    NetManger *manger = [NetManger shareInstance];
    manger.oldPword = self.theOldPassword.text;
    manger.passwordOfnew = self.theNewPassword.text;
    [manger loadData:RequestOfUpdatepassword];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showUpdatepassword:) name:@"updatepassword" object:nil];
    
}
- (void)showUpdatepassword:(NSNotification*)theObj
{
    [self hideHUD];
     [LCProgressHUD showLoading:theObj.object[@"msg"]];
    UIAlertView *al = [[UIAlertView alloc] initWithTitle:@"提示" message:theObj.object[@"msg"] delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
    [al show];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
- (void)hideHUD {
    
    [LCProgressHUD hide];
}
@end
