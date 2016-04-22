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
@property (weak, nonatomic) IBOutlet UIImageView *photoTwo;
@property (weak, nonatomic) IBOutlet UIImageView *photoThree;
@property (weak, nonatomic) IBOutlet UITextField *ApproverTF;
@property (weak, nonatomic) IBOutlet UITextField *CopyCTF;
@property (weak, nonatomic) IBOutlet UIButton *nameBtn;
@property (weak, nonatomic) IBOutlet UIButton *CCnameBtn;
@property (nonatomic, strong) UIView *closeV;
@property (weak, nonatomic) IBOutlet UIButton *visitPhoto;
@property (weak, nonatomic) IBOutlet UIButton *openCrama;

@end
