//
//  MassSubViewController.m
//  ManagementSystem
//
//  Created by JCong on 16/3/10.
//  Copyright © 2016年 JCK. All rights reserved.
//

#import "MassSubViewController.h"
#import "ChoseLinkManViewController.h"
@interface MassSubViewController ()<UITextViewDelegate>

@end

@implementation MassSubViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.massLabel.text = @"马化腾，李彦宏，马云，雷军，王自如，黄章，董明珠，刘强东";
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
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
- (IBAction)choseLinkMan:(UIButton *)sender {
    ChoseLinkManViewController *choseVC = [[ChoseLinkManViewController alloc] init];
    [self.navigationController pushViewController:choseVC animated:YES];
}
@end
