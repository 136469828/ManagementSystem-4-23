//
//  SeachViewViewController.m
//  ManagementSystem
//
//  Created by admin on 16/4/25.
//  Copyright © 2016年 JCK. All rights reserved.
//

#import "SeachViewViewController.h"
#import "NetManger.h"
#import "ProjectModel.h"
#import "ProjectSeachTableViewCell.h"
#import "ProcessViewController.h"
@interface SeachViewViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSString *stateStr;
    NetManger *manger;
    NSArray *datas;

}
@property UITableView *tableView;
@end

@implementation SeachViewViewController
// 销毁通知中心
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    manger = [NetManger shareInstance];
    manger.keyword = self.keyWord;
    NSLog(@"%@ %@",manger.keyword, self.keyWord);
    manger.isKeyword = YES;
    [manger loadData:RequestOfGetprojectlist];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadData) name:@"GetprojectlistWithKeyword" object:nil];
    [self setTableView];
    [self registerNib];

}
- (void)setTableView{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 10, SCREEN_WIDTH, SCREEN_HEIGHT - 69) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];

    
}
#pragma mark - 注册Cell
- (void)registerNib{
    NSArray *registerNibs = @[@"ProjectSeachTableViewCell"];
    for (int i = 0 ; i < registerNibs.count; i++) {
        [_tableView registerNib:[UINib nibWithNibName:registerNibs[i] bundle:nil] forCellReuseIdentifier:registerNibs[i]];
    }
    
}
- (void)reloadData
{
    //    [LCProgressHUD showLoading:@"正在加载"];
    [self.tableView reloadData];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}
#pragma mark - tableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (manger.m_projectInfoArr.count == 0) {
        UIAlertView *al = [[UIAlertView alloc] initWithTitle:@"提示" message:@"未能搜索到相关项目" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [al show];
    }
    return manger.m_projectInfoArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 110;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ProjectSeachTableViewCell *proSeachCell = [_tableView dequeueReusableCellWithIdentifier:@"ProjectSeachTableViewCell"];
    if (manger.m_projectInfoArr.count == 0) {
        proSeachCell.timeLab.text = @"无";
        proSeachCell.stateLabel.text = @"无";
        proSeachCell.titleLab.text = @"无";
        proSeachCell.nameLab.text = @"无";
        proSeachCell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    else
    {
        ProjectModel *model = manger.m_projectInfoArr[indexPath.row];
        if ([model.status isEqualToString:@"2"])
        {
            model.status = @"审批未通过";
            proSeachCell.stateLabel.textColor = [UIColor redColor];
        }
        else if ([model.status isEqualToString:@"14"])
        {
            model.status = @"错误";
        }
        else if ([model.status isEqualToString:@"0"])
        {
            model.status = @"未审批";
        }
        else if ([model.status isEqualToString:@"1"])
        {
            model.status = @"审批通过";
        }
        self.ID = model.projectIDofModel;
        NSLog(@"NetManger *manger %@",self.ID);
        proSeachCell.titleLab.text = model.projectName;
        proSeachCell.nameLab.text = model.applyManName;
        proSeachCell.timeLab.text = model.createTime;
        proSeachCell.stateLabel.text = [NSString stringWithFormat:@"当前状态:%@",model.status] ;
        proSeachCell.natureTypeLab.text = model.natureType;
        proSeachCell.tag = [self.ID integerValue];
        proSeachCell.selectionStyle = UITableViewCellSelectionStyleNone;
        datas = @[proSeachCell.nameLab.text,model.telephone,proSeachCell.stateLabel.text,proSeachCell.timeLab.text];
        
    }
    
    return proSeachCell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ProjectSeachTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    ProcessViewController *proVC = [[ProcessViewController alloc] init];
    proVC.statet = (int)cell.tag;
    //    NSLog(@"cellTag%ld",cell.tag);
    proVC.title = @"项目进度";
    [self.navigationController pushViewController:proVC animated:YES];
}


@end
