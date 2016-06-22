//
//  LinkManViewController.m
//  ManagementSystem
//
//  Created by admin on 16/6/21.
//  Copyright © 2016年 JCK. All rights reserved.
//

#import "LinkManViewController.h"
#import "YXJSelectedCell.h"
#import "YXJFansListsModel.h"
#import "NetManger.h"
#import "ProjectModel.h"
@interface LinkManViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
{
    NetManger *manger;
    UIView *hearView;
}
@property (nonatomic, strong) UITableView *m_tableView;
@property (nonatomic ,strong) NSMutableArray *m_fansListsArray;
@property (nonatomic, strong) NSMutableArray *m_dateArray;


@end

@implementation LinkManViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (self.m_fansListsArray.count == 0)
    {
        self.m_fansListsArray = [[NSMutableArray alloc] initWithCapacity:0];
    }
    manger = [NetManger shareInstance];
    [manger loadData:RequestOfuserGetcontacts];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadDataw) name:@"Getcontacts" object:nil];
    [self createTableView];
#pragma mark - 设置navigationItem右侧按钮
    UIButton *meassageBut = ({
        UIButton *meassageBut = [UIButton buttonWithType:UIButtonTypeCustom];
        meassageBut.frame = CGRectMake(0, 0, 40, 20);
        meassageBut.titleLabel.font = [UIFont systemFontOfSize:13];
        [meassageBut addTarget:self action:@selector(disVC) forControlEvents:UIControlEventTouchDown];
        [meassageBut setTitle:@"确定" forState:UIControlStateNormal];
        [meassageBut setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        meassageBut;
    });
    
    UIBarButtonItem *rBtn = [[UIBarButtonItem alloc] initWithCustomView:meassageBut];
    self.navigationItem.rightBarButtonItem = rBtn;
    
}
#pragma mark - tableView头视图
- (UIView *)hearView
{
    hearView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    //    hearView.backgroundColor = [UIColor redColor];
    [self.view addSubview:hearView];
    UITextField *seachTextField = [[UITextField alloc] initWithFrame:CGRectMake(15, 0, SCREEN_WIDTH - 80, 30)];
    seachTextField.delegate = self;
    seachTextField.layer.borderColor = [UIColor lightGrayColor].CGColor; // set color as you want.
    seachTextField.layer.borderWidth = 1.0; // set borderWidth as you want.
    seachTextField.layer.cornerRadius=8.0f;
    seachTextField.layer.masksToBounds=YES;
    
    [hearView addSubview:seachTextField];
    
    UIButton *seachBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [seachBtn setImage:[UIImage imageNamed:@"seachBtn"] forState:UIControlStateNormal];
    seachBtn.frame = CGRectMake(SCREEN_WIDTH - 55, 0, 30, 30);
    //    [seachBtn addTarget:seachTextField action:@selector(seachOnSeach) forControlEvents:UIControlEventTouchDown];
    [hearView addSubview:seachBtn];
    return hearView;
}
- (void)reloadDataw
{
    //    [LCProgressHUD showLoading:@"正在加载"];
    for (int i = 0; i<manger.m_getcontacts.count; i++)
    {
        YXJFansListsModel *fansModel = [[YXJFansListsModel alloc] init];
        ProjectModel *model2 = manger.m_getcontacts[i];
        fansModel.m_nick = model2.linkManName;
        fansModel.linkID = [NSString stringWithFormat:@"%@",model2.linkID];
        if (_m_dateArray.count == 0) {
            _m_dateArray = [[NSMutableArray alloc] initWithCapacity:0];
        }
        [_m_dateArray addObject:fansModel];
    }
    [self.m_tableView reloadData];
}

- (void)createTableView
{
    CGRect frame = {0, 0, ScreenWidth, ScreenHeight-69};
    self.m_tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
    self.m_tableView.delegate = self;
    self.m_tableView.dataSource = self;
    self.m_tableView.tableHeaderView = [self hearView];
    [self.view addSubview:self.m_tableView];
}



//- (NSMutableArray *)m_dateArray
//{
//    if (_m_dateArray == nil)
//    {
//        _m_dateArray = [NSMutableArray array];
//        _m_dateArray = manger.m_getcontacts;
//        for (int i = 0; i<manger.m_getcontacts.count; i++)
//        {
//            YXJFansListsModel *fansModel = [[YXJFansListsModel alloc] init];
//            fansModel.m_nick = [NSString stringWithFormat:@"张连伟%d",i];
//            [_m_dateArray addObject:fansModel];
//        }
//    }
//    
//    return _m_dateArray;
//}


#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.m_tableView deselectRowAtIndexPath:indexPath animated:YES];
    YXJSelectedCell *cell = (YXJSelectedCell *)[self.m_tableView cellForRowAtIndexPath:indexPath];
    YXJFansListsModel *model = self.m_dateArray[indexPath.row];
    model.m_chooseBtn = !model.isChooseBtn;
    if (model.m_chooseBtn)
    { //选择了
        [self.m_fansListsArray addObject:model];
    }
    else
    { //取消
        [self.m_fansListsArray removeObject:model];
        
    }
    [cell rowSelected];
    NSLog(@"%@",self.m_fansListsArray);
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return manger.m_getcontacts.count;
    
}
- (void)disVC
{
    if (self.block)
    {
        self.block(self.m_fansListsArray,self.m_fansListsArray.count);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YXJSelectedCell *cell = [YXJSelectedCell selectedCell:tableView];
    
    YXJFansListsModel *model = self.m_dateArray[indexPath.row];
    
    cell.m_model = model;
    
    return cell;
}




@end
