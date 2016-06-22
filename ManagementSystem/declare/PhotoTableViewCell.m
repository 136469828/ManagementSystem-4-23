//
//  PhotoTableViewCell.m
//  ManagementSystem
//
//  Created by JCong on 16/2/29.
//  Copyright © 2016年 JCK. All rights reserved.
//

#import "PhotoTableViewCell.h"
#import "SetRemindViewController.h"
#import "DateViewController.h"
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
    [self.starTimeBtn addTarget:self action:@selector(StarTimeBtn:) forControlEvents:UIControlEventTouchDown];
    [self.finshTimeBtn addTarget:self action:@selector(finshTimeBtn:) forControlEvents:UIControlEventTouchDown];
    [self.openCrama addTarget:self action:@selector(visitCamers) forControlEvents:UIControlEventTouchDown];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadTime:) name:@"date" object:nil];
    // 设置图片选择器
    actionSheet = [[ZLPhotoActionSheet alloc] init];
    //设置照片最大选择数
    actionSheet.maxSelectCount = 5;
    //设置照片最大预览数
    actionSheet.maxPreviewCount = 20;

    
}
//- (void)reloadTime:(NSNotification *)obj
//{
//    NSLog(@"时间%@",obj.object);
//}
// 访问摄像头
- (void)visitCamers{
#pragma mark - 相机相册选择预览集合
    __weak typeof(self) weakSelf = self;
    [actionSheet showWithSender:[SetRemindViewController viewController:self] animate:YES completion:^(NSArray<UIImage *> * _Nonnull selectPhotos) {
        [weakSelf.ptotoOne.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        
        CGFloat width = [UIScreen mainScreen].bounds.size.width/6-2;
//        for (int i = 0; i < selectPhotos.count; i++) {
//            UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(i%5*(width+2), i/5*(width+2), width, width)];
//            // 将data上传到服务器
//            NSData *data=UIImageJPEGRepresentation(selectPhotos[i], 1.0);
////            NSLog(@"imageData%@",data);
//            imgView.image = selectPhotos[i];
//            [weakSelf.ptotoOne addSubview:imgView];
//        }
        NSString *strImg = nil;
        NSLog(@"开始处理图片");
        [self.array removeAllObjects];
        for (int i = 0; i < selectPhotos.count; i++)
        {
            UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(i%5*(width+2), i/5*(width+2), width, width)];
            imgView.image = selectPhotos[i];
            //            UIImage *croppedImg = [self resizeImage:imgView.image withWidth:101 withHeight:101];
            //            UIImage *croppedImg = nil;
            //            CGRect cropRect = CGRectMake(0 ,0,131,131); // set frame as you need
            //            croppedImg = [self croppIngimageByImageName:imgView.image toRect:cropRect];
            
            if (self.array.count == 0)
            {
                self.array = [[NSMutableArray alloc] initWithCapacity:0];
            }
            //            imgdata = [self image2DataURL:imgView.image];
            strImg = [self image2DataURL:imgView.image];
            [self.array addObject:strImg];
            //            NSLog(@"%@",strImg);
            [weakSelf.ptotoOne addSubview:imgView];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"notificationimgs" object:self.array];
        }
        NSLog(@"结束处理图片");

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
            
            // [next presentViewController:photoPickerController animated:YES completion:nil];
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

- (void)StarTimeBtn:(UIButton *)sender
{
    NSLog(@"选择开始时间");
    DateViewController *subvc = [[DateViewController alloc] init];
    subvc.title = @"选择日期";
    [[self viewController].navigationController pushViewController:subvc animated:YES];
    subvc.block = ^(NSString *str)
    {
//        NSLog(@"时间:%@",str);
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        [sender setTitle:str forState:UIControlStateNormal];
        [user setObject:sender.titleLabel.text forKey:@"starTime"];
    };
}


- (void)finshTimeBtn:(UIButton *)sender
{
    NSLog(@"选择结束时间");
    DateViewController *subvc = [[DateViewController alloc] init];
    subvc.title = @"选择日期";
    subvc.block = ^(NSString *str)
    {
//        NSLog(@"时间:%@",str);
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        [sender setTitle:str forState:UIControlStateNormal];
        [user setObject:sender.titleLabel.text forKey:@"finshTime"];
    };
    [[self viewController].navigationController pushViewController:subvc animated:YES];
}
- (UIViewController *)viewController {
    
    UIResponder *nextResponder = [self nextResponder]; //获取当前uiview的下一个事件响应者
    
    do {
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            //如果当前的事件响应者具备push方法,也就是属于
            return (UIViewController *)nextResponder; //UIViewController,返回UIViewController
        }
        nextResponder = [nextResponder nextResponder];//否则一直寻找下一个响应者
    } while (nextResponder);
    
    return nil;
}

- (UIImage *)croppIngimageByImageName:(UIImage *)imageToCrop toRect:(CGRect)rect
{
    //CGRect CropRect = CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, rect.size.height+15);
    
    CGImageRef imageRef = CGImageCreateWithImageInRect([imageToCrop CGImage], rect);
    UIImage *cropped = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    
    return cropped;
}

// 图片转64

- (NSString *) image2DataURL: (UIImage *) image
{
    NSLog(@"开始");
    NSData *data = UIImageJPEGRepresentation(image, 0.5);
    NSString *pictureDataString=[data base64Encoding];
    NSLog(@"结束");
    return pictureDataString;
}
@end
