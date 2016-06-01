//
//  CommentTableViewCell.m
//  ManagementSystem
//
//  Created by JCong on 16/3/11.
//  Copyright © 2016年 JCK. All rights reserved.
//

#import "CommentTableViewCell.h"
#import "SubMyViewController.h"
#import "ProcessViewController.h"
#import "NetManger.h"
@implementation CommentTableViewCell

- (void)awakeFromNib {
    // Initialization code
    // 留言输入框
    self.textViewComment.layer.borderWidth = 2;
    self.textViewComment.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.textViewComment.layer.cornerRadius = 10;
    self.textViewComment.text = @"请输入审批意见(默认情况属实)";
    self.textViewComment.textColor = [UIColor lightGrayColor];
    self.textViewComment.delegate = self;
    // Btn
    UILabel *btnLabel = [[UILabel alloc] initWithFrame:self.refuseBtn.bounds];
    btnLabel.text = @"拒绝";
    btnLabel.textAlignment = NSTextAlignmentCenter;
    btnLabel.textColor = [UIColor whiteColor];
    [self.refuseBtn addSubview:btnLabel];
    self.refuseBtn.layer.cornerRadius = 10;
    
    UILabel *btnLabel2 = [[UILabel alloc] initWithFrame:self.agreeBtn.bounds];
    btnLabel2.text = @"同意";
    btnLabel2.textAlignment = NSTextAlignmentCenter;
    btnLabel2.textColor = [UIColor whiteColor];
    [self.agreeBtn addTarget:self action:@selector(agreeAction) forControlEvents:UIControlEventTouchDown];
    [self.agreeBtn addSubview:btnLabel2];
    self.agreeBtn.layer.cornerRadius = 10;

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
#pragma mark - BtnAction
- (void)agreeAction{
    // 单击同意，进入技术部领导审批，同时进去操作人的已办事项
//    NSLog(@"%@",self.ID);
    NetManger *manger = [NetManger shareInstance];
    manger.projectID = self.ID;
    [manger loadData:RequestOfProjectcheck];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadData) name:@"Projectcheck" object:nil];
    
    /* **
         DetailsViewController *detailsVC = [[DetailsViewController alloc] init];
         detailsVC.title = @"项目详情";
         detailsVC.proID = [NSString stringWithFormat:@"%d",self.statet];
         [self.navigationController pushViewController:detailsVC animated:YES];
     ** */
}
- (void)reloadData
{
    // 跳转到我的项目VC
    SubMyViewController *seachVC = [[SubMyViewController alloc] init];
    seachVC.title = @"我的项目";
    [[ProcessViewController viewController:self].navigationController pushViewController:seachVC animated:YES];

}
#pragma mark - textViewDelegate
- (void)textViewDidBeginEditing:(UITextView *)textView{
    textView.textColor = [UIColor blackColor];
    textView.text = @"";
}
@end
