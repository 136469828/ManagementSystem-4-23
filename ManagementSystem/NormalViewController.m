//
//  NormalViewController.m
//  MangerSystem
//
//  Created by JCong on 16/2/25.
//  Copyright © 2016年 JCK. All rights reserved.
//

#import "NormalViewController.h"
#import "NormalTableViewCell.h"
#import "NetManger.h"
#import "ProjectModel.h"
#import "MJRefresh.h"
//#import "LCProgressHUD.h"
@interface NormalViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NetManger *manger;
}
@property UITableView *normalTableView;

@end

@implementation NormalViewController
// 销毁通知中心
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
//    manger = [NetManger shareInstance];
//    manger.channelID = @"1002";
//    [manger loadData:RequestOfGetarticlelist];
    [self loadNewData];
    [self setTableView];
    [self registerNib];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadDataw) name:@"Getarticlelist" object:nil];
    self.normalTableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        // 进入刷新状态后会自动调用这个block
    }];
    
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadNewData方法）
    self.normalTableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    
    // 马上进入刷新状态
    [self.normalTableView.header beginRefreshing];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - 页面刷新
- (void)loadNewData
{
    manger = [NetManger shareInstance];
    manger.channelID = @"1003";
    [manger loadData:RequestOfGetarticlelist];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadDataw) name:@"Getarticlelist" object:nil];
    [_normalTableView.header endRefreshing];
}
- (void)reloadDataw
{
//    [LCProgressHUD showLoading:@"正在加载"];
    [self.normalTableView reloadData];
    [self hideHUD];
}
- (void)hideHUD {
//    [LCProgressHUD hide];
}

- (void)setTableView{
    _normalTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-69) style:UITableViewStylePlain];
    _normalTableView.delegate = self;
    _normalTableView.dataSource = self;
    self.normalTableView.estimatedRowHeight = 100;
    [self.view addSubview:_normalTableView];
    
}
#pragma mark - 注册Cell
- (void)registerNib{
    NSArray *registerNibs = @[@"NormalTableViewCell"];
    for (int i = 0 ; i < registerNibs.count; i++) {
        [_normalTableView registerNib:[UINib nibWithNibName:registerNibs[i] bundle:nil] forCellReuseIdentifier:registerNibs[i]];
    }
    
}
#pragma mark - tableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return manger.m_listArr.count;

}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NormalTableViewCell *normalCell = [_normalTableView dequeueReusableCellWithIdentifier:@"NormalTableViewCell"];
    NSString *contentStrData = @"无";
    NSString *contentStr = [NSString stringWithFormat:@"内容：%@",contentStrData];
    normalCell.contentLabel.text = contentStr;
    normalCell.titleLab.text = @"无";
    normalCell.nameLab.text = @"无";
    if (manger.m_listArr.count != 0)
    {
        ProjectModel *model = manger.m_listArr[indexPath.row];
        contentStrData = model.summary;
        contentStr = [NSString stringWithFormat:@"内容：%@",contentStrData];
        normalCell.contentLabel.text = contentStr;
        normalCell.titleLab.text = model.title;
        normalCell.nameLab.text = model.author;
        normalCell.timeLab.text = model.listCreateDate;

    }
    normalCell.selectionStyle = UITableViewCellSelectionStyleNone;
    return normalCell;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // 禁用 iOS7 返回手势
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    // 开启
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
}
@end
