//
//  ProImgCell.m
//  ManagementSystem
//
//  Created by admin on 16/6/22.
//  Copyright © 2016年 JCK. All rights reserved.
//

#import "ProImgCell.h"

@implementation ProImgCell

+ (instancetype)selectedCell:(UITableView *)tableView
{
    static NSString *ID = @"ProImgCell";
    
    ProImgCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ProImgCell" owner:self options:nil] firstObject];
    }
    
    return cell;
}

@end
