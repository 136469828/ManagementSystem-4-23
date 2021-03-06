//
//  DeclareViewController.m
//  ManagementSystem
//
//  Created by JCong on 16/2/29.
//  Copyright © 2016年 JCK. All rights reserved.
//

#import "ProjectSrachViewController.h"
#import "ProjectSeachTableViewCell.h"
#import "ProcessViewController.h"
#import "SeachViewViewController.h"
#import "DetailsViewController.h"
#import "KeyboardToolBar.h"
#import "NetManger.h"
#import "ProjectModel.h"
#import "MJRefresh.h"
//#import "LCProgressHUD.h"
@interface ProjectSrachViewController ()
{
    NSString *stateStr;
    NetManger *manger;
    NSArray *datas;
    UITextField *seachTextField;
}
@end

@implementation ProjectSrachViewController
// 销毁通知中心
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setTableView]; // 创建TableView
    [self registerNib]; //注册Cell

    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        // 进入刷新状态后会自动调用这个block
    }];
    
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadNewData方法）
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    
    // 马上进入刷新状态
    [self.tableView.header beginRefreshing];
    
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self loadNewData];
}
#pragma mark - Btn逻辑
- (void)seachOn{
    NSLog(@"clickOn");
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    [seachBtn addTarget:self action:@selector(seachOnSeach) forControlEvents:UIControlEventTouchDown];
    [hearView addSubview:seachBtn];
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(8, hearView.bounds.size.height - 1, ScreenWidth - 16, 0.5)];
    line.backgroundColor = [UIColor lightGrayColor];
    [hearView addSubview:line];
    
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
    
}
#pragma mark - 注册Cell
- (void)registerNib{
    NSArray *registerNibs = @[@"ProjectSeachTableViewCell"];
    for (int i = 0 ; i < registerNibs.count; i++) {
        [_tableView registerNib:[UINib nibWithNibName:registerNibs[i] bundle:nil] forCellReuseIdentifier:registerNibs[i]];
    }
}
#pragma mark - 页面刷新
- (void)loadNewData
{
    manger= [NetManger shareInstance];
    manger.isKeyword = NO;
    [manger loadData:RequestOfGetprojectlist];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadData) name:@"GetprojectlistWithKeyword" object:nil];
    [_tableView.header endRefreshing];
}
- (void)reloadData
{
//    [LCProgressHUD showLoading:@"正在加载"];    
    [self.tableView reloadData];

}
#pragma mark - tableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return manger.m_projectInfoArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 110;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ProjectSeachTableViewCell *proSeachCell = [_tableView dequeueReusableCellWithIdentifier:@"ProjectSeachTableViewCell"];
        ProjectModel *model = manger.m_projectInfoArr[indexPath.row];
        if ([model.status isEqualToString:@"1"])
        {
            model.status = @"审批中";
        }
        else if ([model.status isEqualToString:@"2"])
        {
            model.status = @"审批已通过";
        }
        else if ([model.status isEqualToString:@"3"])
        {
            model.status = @"审批不通过";
        }
        else if ([model.status isEqualToString:@"0"])
        {
            model.status = @"未审批";
        }
        else if ([model.status isEqualToString:@"4"])
        {
            model.status = @"已经撤销申请";
        }
        
        self.ID = model.projectIDofModel;
        proSeachCell.titleLab.text = model.projectName;
        proSeachCell.nameLab.text = model.applyManName;
        proSeachCell.timeLab.text = model.createTime;
        proSeachCell.stateLabel.text = [NSString stringWithFormat:@"当前状态:%@",model.status] ;
        proSeachCell.natureTypeLab.text = model.natureType;
        proSeachCell.tag = [self.ID integerValue];
        proSeachCell.selectionStyle = UITableViewCellSelectionStyleNone;
        datas = @[proSeachCell.nameLab.text,model.telephone,proSeachCell.stateLabel.text,proSeachCell.timeLab.text];

    return proSeachCell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ProjectSeachTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];

    DetailsViewController *proVC = [[DetailsViewController alloc] init];
    proVC.proID = [NSString stringWithFormat:@"%ld",cell.tag];
    if ([cell.stateLabel.text isEqualToString:@"当前状态:审批中"])
    {
        proVC.isNodo = 1;
    }
    else if ([cell.stateLabel.text isEqualToString:@"当前状态:审批已通过"])
    {
        proVC.isNodo = 1;
    }
    else if ([cell.stateLabel.text isEqualToString:@"当前状态:已经撤销申请"])
    {
        proVC.isNodo = 3;
    }
//    NSLog(@"%@",cell.stateLabel.text);
    proVC.title = @"项目详情";
    [self.navigationController pushViewController:proVC animated:YES];
}
-(void)hideKeyboard
{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    
}
- (void)seachOnSeach
{
    NSLog(@"seachOnSeach %@",seachTextField.text);
    SeachViewViewController *seachVC = [[SeachViewViewController alloc] init];
    seachVC.keyWord = seachTextField.text;
    seachVC.title = @"搜索结果";
    [self.navigationController pushViewController:seachVC animated:YES];
}


@end
