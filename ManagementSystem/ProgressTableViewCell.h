
//
//  ProgressTableViewCell.h
//  ManagementSystem
//
//  Created by JCong on 16/3/10.
//  Copyright © 2016年 JCK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProgressTableViewCell : UITableViewCell
@property (nonatomic, assign) int stateSy;
@property (nonatomic, copy) NSString *stateTitle;
- (void)setState:(int)state;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *phoneLab;
@property (weak, nonatomic) IBOutlet UILabel *stateLab;
@property (weak, nonatomic) IBOutlet UILabel *departmentLab;
@property (weak, nonatomic) IBOutlet UILabel *record;

@end
