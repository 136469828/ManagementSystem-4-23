//
//  SeachViewController.m
//  MangerSystem
//
//  Created by JCong on 16/2/25.
//  Copyright © 2016年 JCK. All rights reserved.
//

#import "SeachViewController.h"
#import "NormalTableViewCell.h"
#import "MyProjectViewController.h"

#import "Tool.h"
//#import "Util.h"
//#import "NSDate+Helper.h"
//#import "NSDate+Lunar.h"
@interface SeachViewController ()<UITableViewDataSource,UITableViewDelegate>
@property UITableView *tableView;
@end

@implementation SeachViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setTableView]; // 创建TableView
    [self registerNib]; //注册Cell
    
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

    self.tableView.estimatedRowHeight = 200;

}
#pragma mark - 注册Cell
- (void)registerNib{
    NSArray *registerNibs = @[@"NormalTableViewCell"];
    for (int i = 0 ; i < registerNibs.count; i++) {
        [_tableView registerNib:[UINib nibWithNibName:registerNibs[i] bundle:nil] forCellReuseIdentifier:registerNibs[i]];
    }
    
}
#pragma mark - tableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NormalTableViewCell *normalCell = [_tableView dequeueReusableCellWithIdentifier:@"NormalTableViewCell"];
    NSString *contentStrData = @"这个方法的命名和编程行为也是可以学习的。它告诉我们，单例的创建并不都是一成不变的使用sharedXXX方法，也可以使用一个setSharedXXX:传递一个自定义的本类对象，虽然单例对象是外部创建而不是预设的，但是这样创建之后sharedXXX方法依然是获取单例的方法。";
    NSString *contentStr = [NSString stringWithFormat:@"内容：%@",contentStrData];
    normalCell.contentLabel.text = contentStr;
    normalCell.selectionStyle = UITableViewCellSelectionStyleNone;
    normalCell.titleLab.text = @"iOS项目";
    normalCell.nameLab.text = @"梁健聪";
    return normalCell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    NSLog(@"-%ld",(long)self.state);
    if ((long)self.state == StateOfMy) {
// 点击我的项目跳转
        MyProjectViewController *myProjectVC = [[MyProjectViewController alloc] init];
        [self.navigationController pushViewController:myProjectVC animated:YES];
    }

}
-(void)loadDataSource
{
    /**
     *  @开始日期:当前日期 结束时间:往后推一个月1
     */
//    NSString *strEndDate = [Util dateStrWithOriginalString:[Util dateToStringFromDate:[NSDate date]] FromFormatter:@"yyyy-MM-dd HH:mm:ss" toFormatter:@"yyyy-MM-dd"];
//    
//    NSDate *strTmpStartDate = [[NSDate date] dateAfterDay:-30];
//
//    NSString *strStartDate = [Util dateStrWithOriginalString:[Util dateToStringFromDate:strTmpStartDate] FromFormatter:@"yyyy-MM-dd HH:mm:ss" toFormatter:@"yyyy-MM-dd"];
//    
//    strStartDate = @"2015-09-01";
//    
//    strEndDate = @"2015-10-01";
    
    
//    JsonService *jsonService = [JsonService sharedManager];
//    
//    [jsonService setWebserviceDelegate:self];
    
//    NSString *strMethod = @"";
//    
//    strMethod =@"GetHealthBloodPressure";
//    
//    [jsonService getHealthInfoWithDeviceID:self.strDeviceID withMethodName:strMethod beginDate:strStartDate endDate:strEndDate];
//    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
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
- (void)seachOnSeach{
    NSLog(@"seachOnSeach");
}
- (void)blackHomeVC{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
@end
