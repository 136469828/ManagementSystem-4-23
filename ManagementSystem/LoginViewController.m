//
//  LoginViewController.m
//  ManagementSystem
//
//  Created by JCong on 16/2/27.
//  Copyright © 2016年 JCK. All rights reserved.
//

#import "LoginViewController.h"
#import "NetManger.h"
#import "RootTabbarController.h"
#import "LCProgressHUD.h"
@interface LoginViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIButton *rememberBtn;
@property (weak, nonatomic) IBOutlet UIButton *aotuLoginBtn;
@property (weak, nonatomic) IBOutlet UITextField *userNameTF;
@property (weak, nonatomic) IBOutlet UIImageView *passWordImg;
@property (weak, nonatomic) IBOutlet UITextField *passWordTF;
@property (weak, nonatomic) IBOutlet UIImageView *nameImg;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@end

@implementation LoginViewController
// 销毁通知中心
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    self.userNameTF.text = [userDefaults objectForKey:@"userName"];
    self.passWordTF.text = [userDefaults objectForKey:@"passwork"];
    [userDefaults synchronize];
    // Do any additional setup after loading the view from its nib.
//    [self.rememberBtn addTarget:self action:@selector(checkrememberBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.rememberBtn  setImage:[UIImage imageNamed:@"gouxuan2"] forState:UIControlStateNormal];
    [self.rememberBtn  setImage:[UIImage imageNamed:@"gouxuan1"] forState:UIControlStateSelected];
    
    [self.aotuLoginBtn addTarget:self action:@selector(checkboxClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.aotuLoginBtn  setImage:[UIImage imageNamed:@"gouxuan2"] forState:UIControlStateNormal];
    [self.aotuLoginBtn  setImage:[UIImage imageNamed:@"gouxuan1"] forState:UIControlStateSelected];
    [self.aotuLoginBtn setTitle:@"" forState:UIControlStateNormal];
    self.nameImg.image = [UIImage imageNamed:@"loginName"];
    self.passWordImg.image = [UIImage imageNamed:@"loginPW"];
    
    self.loginBtn.layer.cornerRadius = 15;
    
    self.userNameTF.tag = 11111;
    self.passWordTF.tag = 22222;
    self.userNameTF.delegate = self;
    self.passWordTF.delegate = self;
    self.passWordTF.secureTextEntry = YES;

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loging:) name:NetManagerRefreshNotify object:nil];

}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self hideHUD];
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
#pragma mark - UITextFilddelegate
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    if (self.aotuLoginBtn.selected == NO)
    {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        
        switch (textField.tag) {
            case 11111:
            {
                NSLog(@"%@",textField.text);
                [userDefaults setObject:textField.text forKey:@"userName"];
            }
                break;
            case 22222:
            {
                NSLog(@"%@",textField.text);
                [userDefaults setObject:textField.text forKey:@"passwork"];
            }
                break;
                
            default:
                break;
        }
        [userDefaults synchronize];
    }
    
    return YES;
}
-(void)checkboxClick:(UIButton *)btn
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    btn.selected = !btn.selected;
    if (!btn.selected)
    {
        [userDefaults setObject:self.userNameTF.text forKey:@"userName"];
        [userDefaults setObject:self.passWordTF.text forKey:@"passwork"];
        [userDefaults synchronize];
        NSLog(@"自动登录");
    }
    else
    {
        [userDefaults removeObjectForKey:@"userName"];
        [userDefaults removeObjectForKey:@"passwork"];
    }
    self.rememberBtn.selected = btn.selected;
}
- (void)checkrememberBtn:(UIButton *)btn
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    btn.selected = !btn.selected;
    if (!btn.selected) {
        
        [userDefaults setObject:self.userNameTF.text forKey:@"userName"];
        [userDefaults synchronize];
        NSLog(@"记住账号");
    }
    else
    {
        [userDefaults removeObjectForKey:@"userName"];
    }

}
- (IBAction)loginOn:(UIButton *)sender {
    
    NetManger *manger = [NetManger shareInstance];
    manger.name = self.userNameTF.text; manger.password = self.passWordTF.text;
    [manger loadData:RequestOfLogin];
    [LCProgressHUD showLoading:@"正在登录"];
    
    
//    RootTabbarController *rootTabbarCtr = [[RootTabbarController alloc] init];
//    [self presentViewController:rootTabbarCtr animated:YES completion:nil];
}
- (void)showSuccess {
    
    [LCProgressHUD showSuccess:@"加载成功"];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
#pragma mark - 判断账号密码
- (void)loging:(NSNotification*)theObj
{
//    NSLog(@"%@ %@",theObj.object[@"code"],theObj.object[@"msg"]);
    NSLog(@"%@",theObj.userInfo[@"errorCode"]);
    if ([theObj.userInfo[@"errorCode"] isEqualToString:@"-1009"])
    {
        [LCProgressHUD showSuccess:@"未连接到网络"];
    }
    else if ([theObj.userInfo[@"errorCode"] isEqualToString:@"-1001"]) {
        [LCProgressHUD showSuccess:@"连接超时"];
    }
    else
    {
        if ([theObj.object[@"msg"] isEqualToString:@"success"])
        {
            RootTabbarController *rootTabbarCtr = [[RootTabbarController alloc] init];
            [self presentViewController:rootTabbarCtr animated:YES completion:nil];
        }
        else
        {
            //        UIAlertView *al = [[UIAlertView alloc] initWithTitle:@"提示" message:theObj.object[@"msg"] delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
            //        [al show];
            [LCProgressHUD showSuccess:theObj.object[@"msg"]];
        }
    }
    

}
- (void)hideHUD {
    
    [LCProgressHUD hide];
}
@end
