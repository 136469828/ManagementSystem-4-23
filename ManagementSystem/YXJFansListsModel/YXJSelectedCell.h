//
//  YXJSelectedCell.h
//  多选
//
//  Created by yang on 16/6/21.
//  Copyright © 2016年 yang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YXJFansListsModel;

@interface YXJSelectedCell : UITableViewCell

+ (instancetype)selectedCell:(UITableView *)tableView;

@property (nonatomic, strong) YXJFansListsModel *m_model;

- (void)rowSelected;

@end
