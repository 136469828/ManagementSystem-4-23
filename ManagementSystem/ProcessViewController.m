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
@interface ProcessViewController ()

@end

@implementation ProcessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setTableView];
    [self registerNib];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)setTableView{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 10, SCREEN_WIDTH, SCREEN_HEIGHT - 69) style:UITableViewStylePlain];
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
    NSArray *registerNibs = @[@"CommentTableViewCell",@"ProgressTableViewCell",@"RecordTableViewCell"];
    for (int i = 0 ; i < registerNibs.count; i++) {
        [_tableView registerNib:[UINib nibWithNibName:registerNibs[i] bundle:nil] forCellReuseIdentifier:registerNibs[i]];
    }
    
}
#pragma mark - tableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3+1;
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
        cell.textLabel.text = self.data[3];
        cell.textLabel.font = [UIFont systemFontOfSize:13];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    if (indexPath.row == 1) {
//        NSLog(@"%d",self.statet);
        ProgressTableViewCell *cellProgess = [tableView dequeueReusableCellWithIdentifier:@"ProgressTableViewCell"];
        cellProgess.nameLab.text = self.data[0];
        cellProgess.phoneLab.text = self.data[1];
        cellProgess.stateLab.text = self.data[2];
        cellProgess.departmentLab.text = @"暂无";
        cellProgess.selectionStyle = UITableViewCellSelectionStyleNone;
        [cellProgess setState:self.statet];
        return cellProgess;
    }
    if (indexPath.row == 2) {
        CommentTableViewCell *cellComment = [tableView dequeueReusableCellWithIdentifier:@"CommentTableViewCell"];
        cellComment.selectionStyle = UITableViewCellSelectionStyleNone;
        return cellComment;
    }
    RecordTableViewCell *cellRecord = [tableView dequeueReusableCellWithIdentifier:@"RecordTableViewCell"];
    cellRecord.selectionStyle = UITableViewCellSelectionStyleNone;
    return cellRecord;

}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 40;
    }
    if (indexPath.row == 1) {
        return 120;
    }
    return 200;
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
