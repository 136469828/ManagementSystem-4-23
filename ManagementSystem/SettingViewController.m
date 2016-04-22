//
//  SettingViewController.m
//  ManagementSystem
//
//  Created by JCong on 16/3/12.
//  Copyright © 2016年 JCK. All rights reserved.
//

#import "SettingViewController.h"
#import "LoginViewController.h"
#import "AboutMeViewController.h"
#import "PasswordViewController.h"
@interface SettingViewController ()<UITableViewDataSource,UITableViewDelegate>
@property UITableView *normalTableView;

@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setTableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -tableView
- (void)setTableView{
    _normalTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-69) style:UITableViewStyleGrouped];
    _normalTableView.delegate = self;
    _normalTableView.dataSource = self;
    [self.view addSubview:_normalTableView];
    
}

#pragma mark - tableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    switch (indexPath.section) {
        case 0:
        {
            cell.textLabel.text = @"修改密码";
        }
            break;
        case 1:
        {
            cell.textLabel.text = @"退出登录";
        }
            break;
        case 2:
        {
            cell.textLabel.text = @"关于我们";
        }
            break;

        default:
            break;
    }
//    tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:
        {
            PasswordViewController *pwVC = [[PasswordViewController alloc] init];
            pwVC.title = @"修改密码";
            [self.navigationController pushViewController:pwVC animated:YES];
        }
            break;
        case 1:
        {
            LoginViewController *loginVC = [[LoginViewController alloc] init];
            [self presentViewController:loginVC animated:YES completion:nil];
        }
            break;
        case 2:
        {
             AboutMeViewController *abVC = [[AboutMeViewController alloc] init];
            abVC.title = @"关于我们";
            [self.navigationController pushViewController:abVC animated:YES];
        }
            break;
            
        default:
            break;
    }
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
