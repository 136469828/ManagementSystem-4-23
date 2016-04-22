//
//  SeachViewController.h
//  MangerSystem
//
//  Created by JCong on 16/2/25.
//  Copyright © 2016年 JCK. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum
{
    StateOfMy = 1004,                    // 我的项目
    
    StateOfSeach,                        // 审批项目
    
}State;
@interface SeachViewController : UIViewController<UITextFieldDelegate>
{
    UIView *hearView;
}
@property (nonatomic, assign) State *state;
@end
