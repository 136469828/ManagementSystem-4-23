//
//  AboutMeViewController.m
//  ManagementSystem
//
//  Created by admin on 16/3/25.
//  Copyright © 2016年 JCK. All rights reserved.
//

#import "AboutMeViewController.h"
#import "NetManger.h"
@interface AboutMeViewController ()

@end

@implementation AboutMeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    NetManger *manger = [NetManger shareInstance];
    [manger loadData:RequestOfGetlatestversoin];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(versionName:) name:@"VersionName" object:nil];
    
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
- (void)versionName:(NSNotification*)theObj
{
    self.titleLab.text = [NSString stringWithFormat:@"莆田北岸发改局管理系统 %@ 版",theObj.object];

}
@end
