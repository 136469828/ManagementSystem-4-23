//
//  AddLinkmanViewController.m
//  ManagementSystem
//
//  Created by admin on 16/4/15.
//  Copyright © 2016年 JCK. All rights reserved.
//

#import "AddLinkmanViewController.h"

@interface AddLinkmanViewController ()<UITextFieldDelegate>
{
    NSString *nameStr;
    NSString *posttionStr;
    NSString *phoneStr;
    NSString *telStr;
    
    NSArray *infoContacts;
}
@end

@implementation AddLinkmanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.nameTextFild.delegate = self;
    self.nameTextFild.tag = 10000;
    self.positionTextFild.delegate = self;
    self.positionTextFild.tag = 10001;
    self.phoneTextFild.delegate = self;
    self.phoneTextFild.tag = 10002;
    self.telTextFild.delegate = self;
    self.telTextFild.tag = 10003;
    
    nameStr = @"空";
    posttionStr = @"空";
    phoneStr = @"空";
    telStr = @"空";
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark - texFildDelegate
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    switch (textField.tag) {
        case 10000:
        {
          nameStr = textField.text;
        }
            break;
        case 10001:
        {
            posttionStr = textField.text;
        }
            break;
        case 10002:
        {
            phoneStr = textField.text;
        }
            break;
        case 10003:
        {
            telStr = textField.text;
        }
            break;
            
        default:
            break;
    }
    
    infoContacts = @[nameStr,posttionStr,phoneStr,telStr];
    return YES;
}
- (IBAction)keepBtn:(UIButton *)sender {
    
   // 回调 infoContacts
    if (telStr.length != 0 )
    {
    
        if (self.block)
        {
 
            self.block(infoContacts);
            
            [self.navigationController popViewControllerAnimated:YES];
  
        }
    }
    else
    {
     
             NSLog(@"nil");
    
    }
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
@end
