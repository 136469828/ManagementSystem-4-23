//
//  ChoseLinkManViewController.m
//  ManagementSystem
//
//  Created by guofeng on 16/4/20.
//  Copyright © 2016年 JCK. All rights reserved.
//

#import "ChoseLinkManViewController.h"
#import "ContactsTableViewCell.h"
#import "AddLinkmanViewController.h"
#import "ProjectModel.h"
#import "NetManger.h"
//#import "LCProgressHUD.h"
@interface ChoseLinkManViewController ()
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
    BOOL isClick;
}
@property (nonatomic ,strong) NSMutableArray *m_fansListsArray;
@property (nonatomic, strong) NSMutableArray *m_dateArray;
@end

@implementation ChoseLinkManViewController
// 销毁通知中心
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
        UIBarButtonItem *rBtn = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(dismissVC)];
        self.navigationItem.rightBarButtonItem = rBtn;
    manger = [NetManger shareInstance];
    [manger loadData:RequestOfuserGetcontacts];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadDataw) name:@"Getcontacts" object:nil];
    [self setTableView];
    [self registerNib];
    
    
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

    contactsCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return contactsCell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    NSLog(@"%@",m_nameDatas);
    tel = m_telDatas[indexPath.row];
    phone = m_phoneDatas[indexPath.row];
//    isClick = !isClick;
    ContactsTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell rowSelected];
    [self.tableView reloadData];
}


-(void)hideKeyboard
{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];//关闭键盘

}
#pragma mark - Btn逻辑
- (void)seachOn{
    NSLog(@"clickOn");
    
}
- (void)dismissVC
{
    [self.navigationController popViewControllerAnimated:YES];

}

@end
