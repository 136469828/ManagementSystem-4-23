//
//  ContactsViewController.m
//  ManagementSystem
//
//  Created by JCong on 16/3/10.
//  Copyright © 2016年 JCK. All rights reserved.
//

#import "ContactsViewController.h"
#import "ContactsTableViewCell.h"
#import "AddLinkmanViewController.h"
#import "ProjectModel.h"
#import "NetManger.h"
#import "MJRefresh.h"
#import "KeyboardToolBar.h"
//#import "LCProgressHUD.h"
@interface ContactsViewController ()<UIActionSheetDelegate>
{
    NSString *nameStr;
    NSString *telStr;
    NSString *phoneStr;
    NSString *tel;
    NSString *phone;
    NSMutableArray *m_nameDatas;
    NSMutableArray *m_phoneDatas;
    NSMutableArray *m_telDatas;
    NetManger *manger;
    
    UITextField *seachTextField;
}

@end

@implementation ContactsViewController
// 销毁通知中心
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
//    UIBarButtonItem *rBtn = [[UIBarButtonItem alloc] initWithTitle:@"添加" style:UIBarButtonItemStylePlain target:self action:@selector(pushAddVC)];
//    self.navigationItem.rightBarButtonItem = rBtn;
    manger = [NetManger shareInstance];
    [manger loadData:RequestOfuserGetcontacts];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadDataw) name:@"Getcontacts" object:nil];
    [self setTableView];
    [self registerNib];
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        // 进入刷新状态后会自动调用这个block
    }];
    
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadNewData方法）
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    
    // 马上进入刷新状态
    [self.tableView.header beginRefreshing];
    

}
#pragma mark - 页面刷新
- (void)loadNewData
{
    manger = [NetManger shareInstance];
    manger.keyword = @"";
    [manger loadData:RequestOfuserGetcontacts];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadDataw) name:@"Getcontacts" object:nil];
    [_tableView.header endRefreshing];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)reloadDataw
{
//    [LCProgressHUD showLoading:@"正在加载"];
    [self.tableView reloadData];
    [self hideHUD];
}
- (void)hideHUD {
    
//    [LCProgressHUD hide];
}
#pragma mark - tableView头视图
- (void)hearView{
    
    hearView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    //    hearView.backgroundColor = [UIColor redColor];
    [self.view addSubview:hearView];
    seachTextField = [[UITextField alloc] initWithFrame:CGRectMake(15, 0, SCREEN_WIDTH - 80, 30)];
    seachTextField.delegate = self;
    seachTextField.layer.borderColor = [UIColor lightGrayColor].CGColor; // set color as you want.
    seachTextField.layer.borderWidth = 1.0; // set borderWidth as you want.
    seachTextField.layer.cornerRadius=8.0f;
    seachTextField.layer.masksToBounds=YES;
    seachTextField.clearButtonMode = UITextFieldViewModeAlways;
    [KeyboardToolBar registerKeyboardToolBar:seachTextField];
    [hearView addSubview:seachTextField];
    
    UIButton *seachBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [seachBtn setImage:[UIImage imageNamed:@"seachBtn"] forState:UIControlStateNormal];
    seachBtn.frame = CGRectMake(SCREEN_WIDTH - 55, 0, 30, 30);
    [seachBtn addTarget:self action:@selector(seachOnBtn) forControlEvents:UIControlEventTouchDown];
    [hearView addSubview:seachBtn];
    
}
- (void)setTableView{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 10, SCREEN_WIDTH, SCREEN_HEIGHT - 69) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self hearView];
    _tableView.tableHeaderView = hearView;
    [self.view addSubview:_tableView];

    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    gestureRecognizer.cancelsTouchesInView = NO;
    
    [_tableView addGestureRecognizer:gestureRecognizer];
    
    self.tableView.estimatedRowHeight = 200;
    
}
#pragma mark - 注册Cell
- (void)registerNib{
    NSArray *registerNibs = @[@"ContactsTableViewCell"];
    for (int i = 0 ; i < registerNibs.count; i++) {
        [_tableView registerNib:[UINib nibWithNibName:registerNibs[i] bundle:nil] forCellReuseIdentifier:registerNibs[i]];
    }
    
}
#pragma mark - tableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return manger.m_getcontacts.count +count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ContactsTableViewCell *contactsCell = [_tableView dequeueReusableCellWithIdentifier:@"ContactsTableViewCell"];
    if (manger.m_getcontacts.count != 0) {
        if (m_nameDatas.count == 0) {
            m_nameDatas = [[NSMutableArray alloc] initWithCapacity:0];
        }
        if (m_phoneDatas.count == 0) {
            m_phoneDatas = [[NSMutableArray alloc] initWithCapacity:0];
        }
        if (m_telDatas.count == 0) {
            m_telDatas = [[NSMutableArray alloc] initWithCapacity:0];
        }
        ProjectModel *model = manger.m_getcontacts[indexPath.row];
        contactsCell.nameLab.text = model.linkManName;
        nameStr = contactsCell.nameLab.text;
        
        contactsCell.zhiwuLab.text = model.zhiWuName;
        contactsCell.phoneLab.text = model.linkPhone;
        phoneStr = contactsCell.phoneLab.text;
        
        contactsCell.telLab.text = model.linkMobile;
        telStr = contactsCell.telLab.text;
        [m_nameDatas addObject:nameStr];
        [m_telDatas addObject:telStr];
        [m_phoneDatas addObject:phoneStr];

    }
    else
    {
        contactsCell.nameLab.text = @"无";
        nameStr = contactsCell.nameLab.text;
        contactsCell.zhiwuLab.text = @"无";
        contactsCell.phoneLab.text = @"无";
        contactsCell.telLab.text = @"无";
    }
    
    contactsCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return contactsCell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"%@",m_nameDatas);
    tel = m_telDatas[indexPath.row];
    phone = m_phoneDatas[indexPath.row];
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                        initWithTitle:m_nameDatas[indexPath.row]
                                        delegate:self
                                        cancelButtonTitle:@"取消"
                                        destructiveButtonTitle:nil
                                        otherButtonTitles:@"座机", @"手机",nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    [actionSheet showInView:self.view];
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
        {
            NSLog(@"座机");
            NSString *num = [[NSString alloc] initWithFormat:@"tel://%@",tel]; //number为号码字符串
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:num]];
            break;
        }
        case 1:
        {
            NSLog(@"手机");
            NSString *num = [[NSString alloc] initWithFormat:@"tel://%@",phone]; //number为号码字符串
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:num]];
            break;
        }
        case 2:
            NSLog(@"取消");
            break;
        default:
            break;
    }
    
}

-(void)hideKeyboard
{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];//关闭键盘
    
    //    [UIView beginAnimations:nil context:nil];
    //    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    //    [UIView setAnimationDelay:0.35];
    //
    //    [UIView setAnimationDelegate:self];
    //
    //    _tableView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    //
    //    [UIView commitAnimations];
}
#pragma mark - Btn逻辑

- (void)seachOnBtn
{
//    NSLog(@"%@",seachTextField.text);
    manger = [NetManger shareInstance];
    manger.keyword = seachTextField.text;
    [manger loadData:RequestOfuserGetcontacts];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadDataw) name:@"Getcontacts" object:nil];

}
- (void)pushAddVC
{
//    AddLinkmanViewController *addLinkManVC = [[AddLinkmanViewController alloc] init];
//    addLinkManVC.title = @"添加常用联系人";
//    [self.navigationController pushViewController:addLinkManVC animated:YES];
    AddLinkmanViewController *second = [[AddLinkmanViewController alloc] initWithNibName:@"AddLinkmanViewController" bundle:nil];
    [self.navigationController pushViewController:second animated:YES];
    //    [self presentViewController:second animated:YES completion:nil];
    
    second.block = ^(NSArray *arr){
        
        NSLog(@"%@",arr);
//        count =  (int)arr.count;
        count ++;
        [self.tableView reloadData];
        
    };
}

@end
