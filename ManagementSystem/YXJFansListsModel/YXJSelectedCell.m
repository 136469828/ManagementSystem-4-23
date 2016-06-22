//
//  YXJSelectedCell.m
//  多选
//
//  Created by yang on 16/6/21.
//  Copyright © 2016年 yang. All rights reserved.
//

#import "YXJSelectedCell.h"
#import "YXJFansListsModel.h"

@interface YXJSelectedCell ()

@property (weak, nonatomic) IBOutlet UILabel *m_label;
@property (weak, nonatomic) IBOutlet UIButton *m_imageBtn;

@end

@implementation YXJSelectedCell



- (void)rowSelected
{
    self.m_imageBtn.selected = !self.m_imageBtn.isSelected;
    [self.m_imageBtn setBackgroundImage:[UIImage imageNamed:@"score_icon_select.png"] forState:UIControlStateSelected];
}

- (void)setM_model:(YXJFansListsModel *)m_model
{
    _m_model = m_model;
    
    self.m_label.text = _m_model.m_nick;
}


+ (instancetype)selectedCell:(UITableView *)tableView
{
    static NSString *ID = @"YXJSelectedCell";
    
    YXJSelectedCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"YXJSelectedCell" owner:self options:nil] firstObject];
    }
    
    return cell;
}
@end
