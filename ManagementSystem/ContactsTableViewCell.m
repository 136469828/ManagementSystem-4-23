//
//  ContactsTableViewCell.m
//  ManagementSystem
//
//  Created by JCong on 16/3/10.
//  Copyright © 2016年 JCK. All rights reserved.
//

#import "ContactsTableViewCell.h"
#import "FansListsModel.h"
@implementation ContactsTableViewCell

- (void)rowSelected
{
    self.m_imageBtn.selected = !self.m_imageBtn.isSelected;
    [self.m_imageBtn setBackgroundImage:[UIImage imageNamed:@"score_icon_select.png"] forState:UIControlStateSelected];
}

- (void)setM_model:(FansListsModel *)m_model
{
    _m_model = m_model;
    
//    self.m_label.text = _m_model.m_nick;
}


+ (instancetype)selectedCell:(UITableView *)tableView
{
    static NSString *ID = @"ContactsTableViewCell";
    
    ContactsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ContactsTableViewCell" owner:self options:nil] firstObject];
    }
    
    return cell;
}
@end
