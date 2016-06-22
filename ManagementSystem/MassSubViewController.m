//
//  MassSubViewController.m
//  ManagementSystem
//
//  Created by JCong on 16/3/10.
//  Copyright © 2016年 JCK. All rights reserved.
//

#import "MassSubViewController.h"
#import "ChoseLinkManViewController.h"
#import "LinkManViewController.h"
#import "YXJFansListsModel.h"
#import "NetManger.h"

@interface MassSubViewController ()<UITextViewDelegate>
@property (nonatomic, strong) NSMutableArray *linkManDatas;
@property (nonatomic, strong) NSMutableArray *linkManIDs;
@end

@implementation MassSubViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.massLabel.text = @" ";
    UIBarButtonItem *rightBarBtn = [[UIBarButtonItem alloc] initWithTitle:@"发送" style:UIBarButtonItemStylePlain target:self action:@selector(rightBtnAction)];
    self.navigationItem.rightBarButtonItem = rightBarBtn;
    
    self.contentTextview.layer.borderWidth = 2;
    self.contentTextview.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.contentTextview.text = @"请输入群发内容";
    self.contentTextview.delegate = self;
    self.contentTextview.textColor = [UIColor lightGrayColor];
    self.contentTextview.layer.cornerRadius = 10;
    
}
#pragma mark - textViewDelegate
- (void)textViewDidBeginEditing:(UITextView *)textView{
    textView.textColor = [UIColor blackColor];
    textView.text = @"";
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (void)rightBtnAction{
    NSLog(@"发送");
    NetManger *manger = [NetManger shareInstance];
    manger.linkMans = self.self.linkManIDs;
    manger.sendMeassContext = self.contentTextview.text;
    manger.sendMeassTitle = self.titleTF.text;
    [manger loadData:RequestOfsendmessage];
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
- (IBAction)choseLinkMan:(UIButton *)sender
{
//    ChoseLinkManViewController *choseVC = [[ChoseLinkManViewController alloc] init];
//    [self.navigationController pushViewController:choseVC animated:YES];
    LinkManViewController *sub = [[LinkManViewController alloc] init];
    sub.title = @"选择好友";
    [self.navigationController pushViewController:sub animated:YES];
    sub.block = ^(NSArray *arr,NSInteger count)
    {
        [self.linkManDatas removeAllObjects];
        [self.linkManIDs removeAllObjects];
        for (int i = 0; i<count; i++) {
             YXJFansListsModel *model = arr[i];
             NSLog(@"%@ %@",model.linkID,model.m_nick);
            if (self.linkManDatas.count == 0)
            {
                self.linkManDatas = [[NSMutableArray alloc] initWithCapacity:0];
            }
            [self.linkManDatas addObject: model.m_nick];
            if (self.linkManIDs.count == 0)
            {
                self.linkManIDs = [[NSMutableArray alloc] initWithCapacity:0];
            }
            [self.linkManIDs addObject: model.linkID];
        }
        NSString *string = [self.linkManDatas componentsJoinedByString:@","];
        self.massLabel.text = string;
    };
}
@end
