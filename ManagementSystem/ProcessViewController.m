//
//  ProcessViewController.m
//  ManagementSystem
//
//  Created by JCong on 16/3/10.
//  Copyright © 2016年 JCK. All rights reserved.
//

#import "ProcessViewController.h"
#import "CommentTableViewCell.h"
#import "ProgressTableViewCell.h"
#import "DetailsViewController.h"
#import "RecordTableViewCell.h"
#import "NetManger.h"
#import "ProjectModel.h"
@interface ProcessViewController ()
{
    NetManger *manger;
    NSInteger count;
}
@end

@implementation ProcessViewController
// 销毁通知中心
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    manger = [NetManger shareInstance];
//    NSLog(@"%d",self.statet);
    manger.projectID = [NSString stringWithFormat:@"%d",self.statet];
    [manger loadData:RequestOfGetprojectts];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadData) name:@"Getprojects" object:nil];
    [self setTableView];
    [self registerNib];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)setTableView{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 10, SCREEN_WIDTH, SCREEN_HEIGHT - 69) style:UITableViewStylePlain];
    self.tableView.estimatedRowHeight = 120;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableHeaderView = hearView;
    [self.view addSubview:_tableView];
    
    
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    gestureRecognizer.cancelsTouchesInView = NO;
    
    [_tableView addGestureRecognizer:gestureRecognizer];
    
//    self.tableView.estimatedRowHeight = 200;
    
}
#pragma mark - 注册Cell
- (void)registerNib{
    NSArray *registerNibs = @[@"CommentTableViewCell",@"ProgressTableViewCell"];
    for (int i = 0 ; i < registerNibs.count; i++) {
        [_tableView registerNib:[UINib nibWithNibName:registerNibs[i] bundle:nil] forCellReuseIdentifier:registerNibs[i]];
    }
    
}
#pragma mark - tableViewDelegate
- (void)reloadData
{
    [self.tableView reloadData];
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    count = 2+manger.m_processArr.count;
    return 2+manger.m_processArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    if (indexPath.row == 0) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        //        btn.tintColor = [UIColor blackColor];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        btn.frame = CGRectMake(ScreenWidth-120, 0, 100, 30);
        [btn setTitle:@"项目详细>>" forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(pushProject) forControlEvents:UIControlEventTouchDown];
        [cell.contentView addSubview:btn];
        cell.textLabel.text = @"最近项目进度";
        cell.textLabel.font = [UIFont systemFontOfSize:13];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    if (indexPath.row == count-1) {
        CommentTableViewCell *cellComment = [tableView dequeueReusableCellWithIdentifier:@"CommentTableViewCell"];
        cellComment.ID = [NSString stringWithFormat:@"%d",self.statet];
        cellComment.selectionStyle = UITableViewCellSelectionStyleNone;
        return cellComment;
    }

    ProgressTableViewCell *cellProgess = [tableView dequeueReusableCellWithIdentifier:@"ProgressTableViewCell"];
    if (manger.m_processArr.count == 0) {
        cellProgess.nameLab.text = @"暂无";
        cellProgess.phoneLab.text = @"暂无";
        cellProgess.stateLab.text = @"暂无";
        cellProgess.departmentLab.text = @"暂无";
        cellProgess.record.text = @"暂无";
        cellProgess.selectionStyle = UITableViewCellSelectionStyleNone;
        [cellProgess setState:self.statet];
        
    }
    else
    {
        ProjectModel *model = manger.m_processArr[indexPath.row-1];
        cellProgess.nameLab.text = model.processCheckUserName;
        cellProgess.phoneLab.text = model.processCheckTime;
        cellProgess.stateLab.text = self.stateStr;
        cellProgess.departmentLab.text = model.processStructureName;
        cellProgess.record.text = model.processCheckCuauses;
        cellProgess.selectionStyle = UITableViewCellSelectionStyleNone;
        [cellProgess setState:self.statet];
    }
    return cellProgess;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 40;
    }
//    if (indexPath.row == 1) {
//        return 120;
//    }
    return 150;
}
-(void)hideKeyboard
{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];//关闭键盘

}
#pragma mark - btnAction
- (void)pushProject{
    NSLog(@"click");
    DetailsViewController *detailsVC = [[DetailsViewController alloc] init];
    detailsVC.title = @"项目详情";
    detailsVC.proID = [NSString stringWithFormat:@"%d",self.statet];
    [self.navigationController pushViewController:detailsVC animated:YES];
}
+(UIViewController *)viewController:(UIView *)view{
    
    /// Finds the view's view controller.
    
    // Traverse responder chain. Return first found view controller, which will be the view's view controller.
    
    UIResponder *responder = view;
    
    while ((responder = [responder nextResponder]))
        
        if ([responder isKindOfClass: [UIViewController class]])
            
            return (UIViewController *)responder;
    
    // If the view controller isn't found, return nil.
    
    return nil;
    
}
@end
