//
//  PhotoTableViewCell.m
//  ManagementSystem
//
//  Created by JCong on 16/2/29.
//  Copyright © 2016年 JCK. All rights reserved.
//

#import "PhotoTableViewCell.h"
#import "SetRemindViewController.h"

#import "ZLPhotoActionSheet.h"
@implementation PhotoTableViewCell
{
    SetRemindViewController *viewCtr;
    UIImage *photo;
    ZLPhotoActionSheet *actionSheet;
}
- (void)awakeFromNib {
    // Initialization code
    self.ptotoOne.image = [UIImage imageNamed:@"show_photo"];
    self.photoTwo.image = [UIImage imageNamed:@"show_photo"];
    self.photoThree.image = [UIImage imageNamed:@"show_photo"];
    [self.nameBtn setImage:[UIImage imageNamed:@"contact_add"] forState:UIControlStateNormal];
    [self.CCnameBtn setImage:[UIImage imageNamed:@"contact_add"] forState:UIControlStateNormal];
    self.CopyCTF.delegate = self;
    self.ApproverTF.delegate = self;
    
    self.CopyCTF.tag = 999;
    self.ApproverTF.tag = 998;
//    self.visitPhoto.tag = 997;
     viewCtr = [[SetRemindViewController alloc] init];
    [self.visitPhoto addTarget:self action:@selector(clickOn:) forControlEvents:UIControlEventTouchDown];
    [self.openCrama addTarget:self action:@selector(visitCamers) forControlEvents:UIControlEventTouchDown];
    
    // 设置图片选择器
    actionSheet = [[ZLPhotoActionSheet alloc] init];
    //设置照片最大选择数
    actionSheet.maxSelectCount = 5;
    //设置照片最大预览数
    actionSheet.maxPreviewCount = 20;

    
}
// 访问摄像头
- (void)visitCamers{
#pragma mark - 相机相册选择预览集合
    __weak typeof(self) weakSelf = self;
    [actionSheet showWithSender:[SetRemindViewController viewController:self] animate:YES completion:^(NSArray<UIImage *> * _Nonnull selectPhotos) {
        [weakSelf.ptotoOne.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        
        CGFloat width = [UIScreen mainScreen].bounds.size.width/6-2;
        for (int i = 0; i < selectPhotos.count; i++) {
            UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(i%5*(width+2), i/5*(width+2), width, width)];
            imgView.image = selectPhotos[i];
            [weakSelf.ptotoOne addSubview:imgView];
        }
    }];

}

- (void)clickOn:(UIButton *)btn{
//    NSLog(@"%ld",btn.tag);
    
    UIImagePickerController *photoPickerController = [[UIImagePickerController alloc] init];
    photoPickerController.delegate = self;
    photoPickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
//    [self presentViewController:photoPickerController animated:YES completion:nil];
    id next = [self nextResponder] ;
    
    while (next != nil) {
        
        next = [next nextResponder];
        
        if ([next isKindOfClass:[viewCtr class]]) {
            
            [next presentViewController:photoPickerController animated:YES completion:nil];
            return;
            
        }
       
    }
    
}
// 读取图片
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    UIImage *userImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    self.ptotoOne.image = userImage;
//    NSLog(@"%@  %@",touxiang,userImage);// 有值
//    [self dismissViewControllerAnimated:YES completion:nil];
    id next = [self nextResponder] ;
    
    while (next != nil) {
        
        next = [next nextResponder];
        
        if ([next isKindOfClass:[viewCtr class]]) {
            
//            [next presentViewController:photoPickerController animated:YES completion:nil];
            [next dismissViewControllerAnimated:YES completion:nil];
            return;
            
        }
        
    }

}
// 从相册返回
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self dismassView];
}
- (void)dismassView{
    id next = [self nextResponder] ;
    
    while (next != nil) {
        
        next = [next nextResponder];
        
        if ([next isKindOfClass:[viewCtr class]]) {
            
            //            [next presentViewController:photoPickerController animated:YES completion:nil];
            [next dismissViewControllerAnimated:YES completion:nil];
            return;
            
        }
        
    }

}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
//    [UITableView animateWithDuration:0.25 animations:^{
//        self.superview.frame = CGRectMake(0, -238, ScreenWidth, ScreenHeight);
//    }];
    
}
- (void)closeView{
    [self.closeV removeFromSuperview];
    [self.superview endEditing:YES];
}
- (IBAction)addNameBtn:(UIButton *)sender {
}
- (IBAction)addCCnameBtn:(UIButton *)sender {
}
@end
