//
//  ProImgCell.h
//  ManagementSystem
//
//  Created by admin on 16/6/22.
//  Copyright © 2016年 JCK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProImgCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgV;
+ (instancetype)selectedCell:(UITableView *)tableView;
@end
