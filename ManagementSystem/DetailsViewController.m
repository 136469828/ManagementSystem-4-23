//
//  DetailsViewController.m
//  ManagementSystem
//
//  Created by JCong on 16/3/11.
//  Copyright © 2016年 JCK. All rights reserved.
//

#import "DetailsViewController.h"
#import "ProImgCell.h"
#import "NetManger.h"
#import "ProjectModel.h"
#import "LCProgressHUD.h"
#import "UIImageView+WebCache.h"
#import "HCommentsController.h"
@interface DetailsViewController ()
{
    NSArray *dataArr;
}
@property (nonatomic, strong) NetManger *manger;
@property NSArray *titleArr;
@end

@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.titleArr = @[
                       @"申请人:"
                      ,@"电话:"
                      ,@"时间:"
                      ,@"项目性质:"
                      ,@"投资总额:"
                      ,@"项目名称:"
                      ,@"行业:"
                      ,@"投资种类:"
                      ,@"工程进度:"
                      ,@"存在问题:"
                      ,@"项目分类:"
                      ,@"当前状态:"
                      ];
    dataArr = @[ @"无"
                 ,@"无"
                 ,@"无-无-无"
                 ,@"无"
                 ,@"无"
                 ,@"无"
                 ,@"无"
                 ,@"无"
                 ,@"正常"
                 ,@"正常"
                 ,@"无"
                 ,@"审核未通过"];
    _manger = [NetManger shareInstance];
//    NSLog(@"%@",self.proID);
    _manger.projectID = self.proID;
    [_manger loadData:RequestOfGetprojectt];
    [_manger loadData:RequestOfGetprojectts];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadData) name:@"Getproject" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadData) name:@"Getprojects" object:nil];
    [self setTableView];
    
}
- (void)reloadData
{
//    [LCProgressHUD showLoading:@"正在加载"];    
    [self.tableView reloadData];
//    [self hideHUD];
}
- (void)setTableView{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 69) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self _initTableViewFootView];
    [self.view addSubview:_tableView];

}
- (void)_initTableViewFootView{
#pragma mark - 设置尾视图
    UIView *footTopView = [[UIView alloc] initWithFrame:CGRectMake(0, 5, ScreenWidth-40, 64+100)];
    footTopView.backgroundColor = RGB(239, 239, 244);
    self.tableView.tableFooterView = footTopView;

    
    UIButton *cencelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    if (self.isNodo == 0)
    {
        [cencelBtn setTitle:@"撤 销 申 请" forState:UIControlStateNormal];
    }
    else if(self.isNodo == 1)
    {
        [cencelBtn setTitle:@"跟      进" forState:UIControlStateNormal];
    }
    else
    {
        cencelBtn.hidden = YES;
    }
    cencelBtn.frame = CGRectMake(80, 0, ScreenWidth - 160, 30);
    cencelBtn.layer.cornerRadius = 10;
    [cencelBtn setTintColor:[UIColor whiteColor]];
    cencelBtn.backgroundColor = [UIColor orangeColor];
    [cencelBtn addTarget:self action:@selector(cencelBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [footTopView addSubview:cencelBtn];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView // 一个表视图里面有多少组
{
    return 3;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section // 返回组的头宽
{
    return 2;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section // 返回组的尾宽
{
    return 5;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1)
    {
        return ScreenWidth*0.6;
    }
    return 44;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0)
    {
        return 12;
    }
    if ([NetManger shareInstance].m_proImg.count <= 1)
    {
        return 0;
    }
    else if(section == 1)
    {
        return [NetManger shareInstance].m_proImg.count-1;
    }
    else
    {
        return [NetManger shareInstance].m_processArr.count;
    }
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0)
    {
        static NSString *cellIdentifier = @"cell";
        UITableViewCell *cell = nil;
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            cell.textLabel.text = self.titleArr[indexPath.row];
            UILabel *contentL = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth/3, 2, ScreenWidth - ScreenWidth/3 - 10, 40)];
            if (_manger.m_details.count == 0)
            {
                contentL.text = dataArr[indexPath.row];
            }
            else
            {
                ProjectModel *model = _manger.m_details[indexPath.row];
                
                if ([model.status isEqualToString:@"3"])
                {
                    model.status = @"审批未通过";
                }
                else if ([model.status isEqualToString:@"4"])
                {
                    model.status = @"已撤销申请";
                }
                else if ([model.status isEqualToString:@"2"])
                {
                    model.status = @"审批通过";
                }
                else if ([model.status isEqualToString:@"0"])
                {
                    model.status = @"未审批";
                }
                
                dataArr = @[model.applyManName, // 申请人
                            model.telephone,    // 电话
                            model.createTime,   // 时间
                            model.natureType,   // 项目性质
                            model.money,        // 投资总额
                            model.projectName,  // 项目名称
                            model.categoryType,  // 行业
                            model.classTypeName, // 投资种类
                            model.processStatus, // 项目进度标识
                            model.questions,    // 存在问题
                            model.companyType,// 项目分类
                            model.status,    // 项目状态标识
                            ];
                
                contentL.text = dataArr[indexPath.row];
                
            }
            contentL.font = [UIFont systemFontOfSize:15];
            [cell.contentView addSubview:contentL];
            if (indexPath.row == 11)
            {
                contentL.textColor = [UIColor redColor];
            }
            
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    if (indexPath.section == 2)
    {
        static NSString *allCell = @"cells";
        UITableViewCell *cells = nil;
        if (!cells) {
            cells = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:allCell];
            cells.selectionStyle = UITableViewCellAccessoryNone;
        }
        ProjectModel *model = [NetManger shareInstance].m_processArr[indexPath.row];
        cells.textLabel.text = model.processCheckCuauses;
        cells.detailTextLabel.text = model.processCheckTime;
        cells.textLabel.font = [UIFont systemFontOfSize:13];
        return cells;
    }
    ProImgCell *imgCell = [ProImgCell selectedCell:tableView];
    [imgCell.imgV sd_setImageWithURL:[NSURL URLWithString:[NetManger shareInstance].m_proImg[indexPath.row]]];
    return imgCell;
    
}
#pragma cancelAction
- (void)cencelBtnAction
{
    if (self.isNodo == 0)
    {
        self.manger.keyword = self.proID;
        [self.manger loadData:RequestOfprojectcancel];
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        HCommentsController *sub = [[HCommentsController alloc] init];
        sub.title = @"跟进意见";
        sub.shopID = self.proID;
        [self.navigationController pushViewController:sub animated:YES];

    }

}
- (void)hideHUD {
    
    [LCProgressHUD hide];
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
