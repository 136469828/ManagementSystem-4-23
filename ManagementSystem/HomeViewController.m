//
//  HomeViewController.m
//  ManagementSystem
//
//  Created by JCong on 16/2/27.
//  Copyright © 2016年 JCK. All rights reserved.
//

#import "HomeViewController.h"

// 二级Controller
#import "SeachViewController.h"
#import "NormalViewController.h"
#import "SetRemindViewController.h"
#import "MassViewController.h"
#import "ContactsViewController.h"
#import "ProjectSrachViewController.h"
#import "SettingViewController.h"
#import "ScrollView.h"
@interface HomeViewController ()
{
    UIScrollView *mainScrollView;
    ScrollView *announcementScroV;
}

@end

@implementation HomeViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    if(mainScrollView == nil)
    {
        mainScrollView = [[UIScrollView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        mainScrollView.showsHorizontalScrollIndicator = NO;
        mainScrollView.showsVerticalScrollIndicator = NO;
        mainScrollView.showsHorizontalScrollIndicator = YES;
        mainScrollView.alwaysBounceVertical = YES;
        mainScrollView.scrollEnabled = YES;
        UIView *blackView = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenWidth*0.28+59, ScreenWidth, 100*3+15)];
        blackView.backgroundColor = [UIColor lightGrayColor];
        [mainScrollView addSubview:blackView];
        [self.view addSubview:mainScrollView];
    }
//    self.view.backgroundColor = [UIColor lightGrayColor];
    self.title = @"欢迎使用莆田北岸发改局管理系统";
    // Do any additional setup after loading the view from its nib.
    NSArray *titles = @[@"公告", @"提醒信息", @"项目查询", @"上报项目", @"我的项目", @"群发消息", @"常用联系人",@"设置",@" "];
    NSArray *imageNames = @[@"home_gonggao",@"home_tixin",@"home_chaxun.jpg",@"home_shangbao",@"home_wodexiangmu",@"home_qunfa",@"home_lianxiren",@"home_setting",@" "];
    [self drawHoneViewWithAppviewW:ScreenWidth/3 AppviewH:100 Totalloc:3 Count:9 ImageArray:imageNames TitleArray:titles];
    [self _initAnnouncementView];
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
#pragma mark - 公告栏announcementView
- (void)_initAnnouncementView{
    announcementScroV = [[ScrollView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight*0.28)];
    [mainScrollView addSubview:announcementScroV];
    
}
#pragma mark - 创建九宫格
- (void)drawHoneViewWithAppviewW:(CGFloat)appviewWith AppviewH:(CGFloat)appviewHeght Totalloc:(int)totalloc Count:(int)count ImageArray:(NSArray *)images TitleArray:(NSArray *)titles{
//    三列
//    int totalloc=3;
//    CGFloat appvieww=80;
//    CGFloat appviewh=100;
    CGFloat margin=([UIScreen mainScreen].bounds.size.width-totalloc*appviewWith)/(totalloc+1);
//    int count = 8;
    for (int i=0; i<count; i++) {
        int row=i/totalloc;//行号
        //1/3=0,2/3=0,3/3=1;
        int loc=i%totalloc;//列号
        
        CGFloat appviewx=margin+(appviewWith + .5)*loc;
        CGFloat appviewy=margin+(appviewHeght + .5)*row;
        
        //创建uiview控件
        UIView *appview=[[UIView alloc]initWithFrame:CGRectMake(appviewx,appviewy+ScreenHeight*0.28+10, appviewWith, appviewHeght)];
        appview.backgroundColor = [UIColor whiteColor];
        [mainScrollView addSubview:appview];
        
        // 创建按钮
        UIButton *bTn = [UIButton buttonWithType:UIButtonTypeCustom];
        bTn.frame = CGRectMake(0, 0, appviewWith,appviewHeght);
        [bTn addTarget:self action:@selector(clickOn:) forControlEvents:UIControlEventTouchDown];
        [bTn setBackgroundColor:[UIColor clearColor]];
        bTn.tag = 1000 + i;
        [appview addSubview:bTn];
                
        //创建uiview控件中的子视图
        UIImageView *appimageview=[[UIImageView alloc]initWithFrame:CGRectMake(appview.bounds.size.width/2 - 19,appview.bounds.size.height/2-18, 38, 36)];
        UIImage *appimage=[UIImage imageNamed:images[i]];
        appimageview.image=appimage;
        [appimageview setContentMode:UIViewContentModeScaleAspectFit];
        // NSLog(@"%@",self.apps[i][@"icon"]);
        [appview addSubview:appimageview];
        
        //创建文本标签
        UILabel *applable=[[UILabel alloc]initWithFrame:CGRectMake(0, 70, appview.bounds.size.width, 20)];
        //        applable.backgroundColor = [UIColor redColor];
        [applable setText:titles[i]];
        [applable setTextAlignment:NSTextAlignmentCenter];
        [applable setFont:[UIFont systemFontOfSize:12.0]];
        [appview addSubview:applable];

    }

}
#pragma mark - action
- (void)clickOn:(UIButton *)btn{
    
    NSLog(@"%ld",(long)btn.tag);
    switch (btn.tag) {
        case 1000:
        {
            NormalViewController*normalV= [[NormalViewController alloc] init];
            normalV.title = @"公告";
            normalV.tagChanne = btn.tag;
            [self.navigationController pushViewController:normalV animated:YES];
        }
            break;
        case 1001:
        {
            NormalViewController *normalV= [[NormalViewController alloc] init];
            normalV.title = @"提醒信息";
            normalV.tagChanne = btn.tag;
            [self.navigationController pushViewController:normalV animated:YES];
        }
            break;
        case 1002:
        {
            ProjectSrachViewController *seachV= [[ProjectSrachViewController alloc] init];
            seachV.title = @"项目查询";
            [self.navigationController pushViewController:seachV animated:YES];
        }
            break;
        case 1003:
        {
            SetRemindViewController *declareCrt = [[SetRemindViewController alloc] init];
            declareCrt.title = @"上报项目申报单";
            declareCrt.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:declareCrt animated:YES];
        }
            break;
        case 1004:
        {
            //SeachViewController *seachV= [[SeachViewController alloc] init];
            ProjectSrachViewController *seachV= [[ProjectSrachViewController alloc] init];
            seachV.title = @"我的项目";
            //seachV.state = btn.tag;
            [self.navigationController pushViewController:seachV animated:YES];
        }
            break;
//        case 1005:
//        {
//            //SeachViewController *seachV= [[SeachViewController alloc] init];
//            ProjectSrachViewController *seachV= [[ProjectSrachViewController alloc] init];
//            seachV.title = @"审批项目";
//           // seachV.state = btn.tag;
//            [self.navigationController pushViewController:seachV animated:YES];
//        }
            break;
        case 1005:
        {
            MassViewController *massVC= [[MassViewController alloc] init];
            massVC.title = @"群发消息";
            [self.navigationController pushViewController:massVC animated:YES];
        }
            break;
        case 1006:
        {
            ContactsViewController *contactsVC= [[ContactsViewController alloc] init];
            contactsVC.title = @"常用联系人";
            [self.navigationController pushViewController:contactsVC animated:YES];
        }
            break;
        case 1007:
        {
            SettingViewController *setVC= [[SettingViewController alloc] init];
            setVC.title = @"账号设置";
            [self.navigationController pushViewController:setVC animated:YES];
        }
            break;

        default:
            break;
    }
    
}

@end
