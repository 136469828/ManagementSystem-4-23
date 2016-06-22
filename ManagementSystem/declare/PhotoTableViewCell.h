//
//  PhotoTableViewCell.h
//  ManagementSystem
//
//  Created by JCong on 16/2/29.
//  Copyright © 2016年 JCK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoTableViewCell : UITableViewCell<UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *ptotoOne;
@property (weak, nonatomic) IBOutlet UIButton *starTimeBtn;
@property (weak, nonatomic) IBOutlet UIButton *finshTimeBtn;

@property (weak, nonatomic) IBOutlet UIButton *openCrama;
@property (nonatomic, strong) NSMutableArray *array;

@end
