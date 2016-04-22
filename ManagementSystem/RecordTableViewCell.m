//
//  RecordTableViewCell.m
//  ManagementSystem
//
//  Created by JCong on 16/3/11.
//  Copyright © 2016年 JCK. All rights reserved.
//

#import "RecordTableViewCell.h"

@implementation RecordTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.recordLabel.text = @"如图,很多页面其实就是这种展示结果,通常需要imageView,textLabel,detailTextlabel,而UITableViewCell本身提供了方便的自动布局(当有图片和没图片时,textLabel和detailLabel的位置会左右自动调整). 但是图片的大小却是没有办法固定的(直接设置imageView.frame是无法固定imageView的大小的),那么一般来说解决这个问题的办法有两种:";
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
