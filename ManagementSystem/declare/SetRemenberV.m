//
//  SetRemenberV.m
//  No.1 Pharmacy
//
//  Created by JCong on 15/12/7.
//  Copyright © 2015年 梁健聪. All rights reserved.
//

#import "SetRemenberV.h"
#import "KeyboardToolBar.h"
#import "PhotoTableViewCell.h"
#import "SetRemindViewController.h"
#import "SubMyViewController.h"
#import "LCProgressHUD.h"
#import "NetManger.h"
@implementation SetRemenberV
{
    NSArray *titls;
    NSArray *nams;
    NSArray *totals;
    NSArray *classifys;
    NSInteger components;
    BOOL isClick;
    NSString *projectName;
    NSString *projectQuestion;
    NSString *projectProgress;
    NSString *projectSuggest;
    NSString *projectApplyName;
    int pickerViewValue;
}
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame ];
    if (self) {
        [self _initTableiew];
    }
    return self;
}
- (void)_initTableiew{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, self.bounds.size.height-69) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
//    [_tableView setScrollEnabled:NO];
    [self addSubview:_tableView];
    [self _initTableViewFootView];
//    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];

    [_tableView registerNib:[UINib nibWithNibName:@"PhotoTableViewCell" bundle:nil] forCellReuseIdentifier:@"PhotoTableViewCell"];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboaedDidShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboaedDidappear:) name:UIKeyboardWillHideNotification object:nil];
    
    UITapGestureRecognizer *tableViewGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(commentTableViewTouchInSide)];
    tableViewGesture.numberOfTapsRequired = 1;
    tableViewGesture.cancelsTouchesInView = NO;
    [self.tableView addGestureRecognizer:tableViewGesture];
    
//    [self clickOn];
    

}
- (void)_initTableViewFootView{
#pragma mark - 设置尾视图
    UIView *footTopView = [[UIView alloc] initWithFrame:CGRectMake(0, 5, ScreenWidth-40, 64)];
    footTopView.backgroundColor = RGB(239, 239, 244);
    self.tableView.tableFooterView = footTopView;
    
    UIButton *publishBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [publishBtn setTitle:@"提      审" forState:UIControlStateNormal];
    publishBtn.frame = CGRectMake(80, 0, ScreenWidth - 160, 30);
    publishBtn.layer.cornerRadius = 10;
    [publishBtn setTintColor:[UIColor whiteColor]];
    publishBtn.backgroundColor = RGB(22, 160, 93);
    [publishBtn addTarget:self action:@selector(publishAction) forControlEvents:UIControlEventTouchUpInside];
    [footTopView addSubview:publishBtn];
}
- (void)commentTableViewTouchInSide{
    UITextField *messageTextField = (UITextField *)[self viewWithTag:999];
    UITextField *messageTextField2 = (UITextField *)[self viewWithTag:998];
    [messageTextField resignFirstResponder];
    [messageTextField2 resignFirstResponder];
    
    NSLog(@"clickOntableView");
}
#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 3;
    }
    if (section == 1) {
        return 5;
    }
    return 4;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";
    // UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier]; //改为以下的方法
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath]; //根据indexPath准确地取出一行，而不是从cell重用队列中取出
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }

    if (indexPath.section == 0) // 第一组
    {

        if (indexPath.row == 0) // 申请人名
        {
            _textField = [[UITextField alloc] initWithFrame:CGRectMake(ScreenWidth/2.8, 0, 250, 50)];
            _textField.delegate = self;
            _textField.tag = 1104;
            if (projectName.length == 0) {
                 _textField.placeholder = @"请输入申请人名称";
            }
            else
            {
                _textField.text = projectApplyName;
            }
            cell.textLabel.text = @"申请人名称:";
            [KeyboardToolBar registerKeyboardToolBar:self.textField];
            [cell.contentView addSubview:_textField];
        }
        if (indexPath.row == 1) // 电话号码
        {
            NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
            NSString *phone = [user objectForKey:@"userName"];
            cell.textLabel.text = [NSString stringWithFormat:@"电话号码:\t\t%@",phone];
            [user synchronize];
        }
        if (indexPath.row == 2) // 项目名
        {
            _textField = [[UITextField alloc] initWithFrame:CGRectMake(ScreenWidth/2.8, 0, 250, 50)];
            _textField.delegate = self;
            _textField.tag = 1100;
            if (projectName.length == 0) {
                _textField.placeholder = @"请输入项目名称";
            }
            else
            {
                _textField.text = projectName;
            }
            cell.textLabel.text = @"项目名称:";
            [KeyboardToolBar registerKeyboardToolBar:self.textField];
            [cell.contentView addSubview:_textField];
        }// 项目名
    }// 第一组
    else if (indexPath.section == 1) // 第二组
    {
        if (indexPath.row == 0) // 项目性质
        {
            cell.textLabel.text = @"项目性质:";
            UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth - 55,0, 50, 50)];
            imageV.backgroundColor = [UIColor clearColor];
            imageV.image = [UIImage imageNamed:@"addtixing"];
            [cell.contentView addSubview:imageV];
            UILabel *infoL = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth*0.4, 5, ScreenWidth*0.5, 40)];
            infoL.tag = 2000;
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            if ([userDefaults objectForKey:@"i1"]) {
                infoL.text = [userDefaults objectForKey:@"i1"];
            }
            infoL.textAlignment = NSTextAlignmentCenter;
            [cell.contentView addSubview:infoL];
        }// 项目性质
        if (indexPath.row == 1)
        {
            cell.textLabel.text = @"是否列入市/区开竣工";
            UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth - 55,0, 50, 50)];
            imageV.backgroundColor = [UIColor clearColor];
            imageV.image = [UIImage imageNamed:@"addtixing"];
            [cell.contentView addSubview:imageV];
            UILabel *infoL = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth*0.4, 5, ScreenWidth*0.5, 40)];
            infoL.tag = 1999;
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            if ([userDefaults objectForKey:@"i2"]) {
                infoL.text = [userDefaults objectForKey:@"i2"];
            }
            infoL.textAlignment = NSTextAlignmentCenter;
            [cell.contentView addSubview:infoL];

        }// 是否列入市区开竣工
        if (indexPath.row == 2)//validUnselect
        {
            cell.textLabel.text = @"列入攻坚项目";
            if(isClick)
            {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            }
            else
            {
                cell.accessoryType = UITableViewCellAccessoryNone;
            }

        }// 是否列入攻坚项目
        if (indexPath.row == 3) // 项目概况
        {
            cell.textLabel.text = @"投资总额 | 行业 | 投资种类 | 项目分类";
            cell.textLabel.font = [UIFont systemFontOfSize:15];
            UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth - 55,0, 50, 50)];
            imageV.backgroundColor = [UIColor clearColor];
            imageV.image = [UIImage imageNamed:@"addtixing"];
            [cell.contentView addSubview:imageV];
            
        }// 项目概况
        if (indexPath.row == 4) {
            UILabel *infoL = [[UILabel alloc] initWithFrame:CGRectMake(30, 5, ScreenWidth, 40)];
            infoL.tag = 2001;
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            if ([userDefaults objectForKey:@"i3"]) {
                infoL.text = [userDefaults objectForKey:@"i3"];
            }
            infoL.textAlignment = NSTextAlignmentLeft;
            [cell.contentView addSubview:infoL];
        }
        
    }
    else if (indexPath.section == 2) // 第二组
    {
        switch (indexPath.row) {

            case 0:
            {
                _textField = [[UITextField alloc] initWithFrame:CGRectMake(ScreenWidth/2.8, 0, 250, 50)];
                _textField.delegate = self;
                _textField.tag = 1101;
                if (projectProgress.length == 0)
                {
                   _textField.placeholder = @"请输入工作进度";
                }
                else
                {
                    _textField.text = projectProgress;
                }

                cell.textLabel.text = @"工作进度:";

                
                [KeyboardToolBar registerKeyboardToolBar:self.textField];
                [cell.contentView addSubview:_textField];

            }
                break;
            case 1:
            {
                _textField = [[UITextField alloc] initWithFrame:CGRectMake(ScreenWidth/2.8, 0, 250, 50)];
                _textField.delegate = self;
                _textField.tag = 1102;
                if (projectQuestion.length == 0) {
                    _textField.placeholder = @"请输入项目存在的问题";
                }
                else
                {
                    _textField.text = projectQuestion;
                }

                cell.textLabel.text = @"存在问题:";

                [KeyboardToolBar registerKeyboardToolBar:self.textField];
                [cell.contentView addSubview:_textField];
            }
                break;
            case 2:
            {
                
                _textField = [[UITextField alloc] initWithFrame:CGRectMake(ScreenWidth/2.8, 0, 250, 50)];
                _textField.delegate = self;
                _textField.tag = 1103;
                if (projectQuestion.length == 0) {
                    _textField.placeholder = @"请输入项目建议措施";
                }
                else
                {
                    _textField.text = projectSuggest;
                }
                cell.textLabel.text = @"建议措施:";
                [KeyboardToolBar registerKeyboardToolBar:self.textField];
                [cell.contentView addSubview:_textField];
            }
                break;
            case 3:
            {
                UITableViewCell *photoCell = [tableView dequeueReusableCellWithIdentifier:@"PhotoTableViewCell"];
                photoCell.selectionStyle = UITableViewCellSelectionStyleNone;
                return photoCell;
            }
                break;
                
            default:
                break;
        }

    }
    _textField.font     = [UIFont systemFontOfSize:15];
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    return cell;
}
#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 3;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 2)
    {
//        if (indexPath.row == 2)
//        {
//            return 200;
//        }
        if (indexPath.row == 3) {
            return 200;
        }
        return 50;
    }
    return 50;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //    NSLog(@"%@",indexPath);
    // 01 10 11
    if (indexPath.section == 1)
    {
        if (indexPath.row == 0)
        {
            titls = @[@"省",@"市",@"区",@"县",@"镇"];
            components = 1;
            pickerViewValue = 1;
            [self _initPickerView];
        }
        else if (indexPath.row == 1)
        {
            titls = @[@"否",@"市",@"区"];
            components = 1;
            pickerViewValue = 2;
            [self _initPickerView];
        }
        else if(indexPath.row == 2)
        {
            isClick = !isClick;
            NSIndexPath *indexPath=[NSIndexPath indexPathForRow:2 inSection:1];
            
            [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
            
        }
        else if(indexPath.row == 3)
        {
            titls = @[@"计划",@"实际"];

            nams = @[@"省重点",@"市重点"];
            
            totals = @[@"国企",@"央企"];
            
            classifys = @[@"能源",@"火电"];

            components = 4;
            [self _initPickerView];
        }
    }
    
}
- (void)keyboaedDidShow:(NSNotification *)notif{
    //        NSLog(@"键盘出现 %@",notif);
#if 0
    NSDictionary *info = [notif userInfo];
    NSValue *aValue = [info objectForKey:UIKeyboardWillShowNotification];
    CGSize keyboardSize = [aValue CGRectValue].size;
    CGRect viewRect = [self.view frame];
    viewRect.origin.y = viewRect.origin.y - keyboardSize.height - 30;
    NSLog(@"%f - %f    // BUG",viewRect.origin.y,viewRect.size.height);
    //    if (viewRect.origin.y >= 14) {
    //        return;
    //    }
    self.view.frame = viewRect;
#endif
    
    
}
- (void)keyboaedDidappear:(NSNotification *)notif{
    NSLog(@"键盘消失");
    [_closeV removeFromSuperview];
    _tableView.frame = CGRectMake(0,0, SCREEN_WIDTH, ScreenHeight - 69);
}
- (void)leaveEditMode {
    [self.textV resignFirstResponder];
    
}

#pragma mark - textFildDelegate
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    NSLog(@"%@",textField.text);
    switch (textField.tag) {
        case 1100:
            projectName = textField.text;
            break;
        case 1101:
            projectProgress = textField.text;
            break;
        case 1102:
            projectQuestion = textField.text;
            break;
        case 1103:
            projectSuggest = textField.text;
            break;
        case 1104:
            projectApplyName = textField.text;
            break;
            
        default:
            break;
    }
    return YES;
}

-(BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    //  667 - 313
    _closeV = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenHeight-50-49-258, ScreenWidth, 40)];
    _closeV.backgroundColor = [UIColor lightGrayColor];
    
    UIButton *colseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    colseBtn.frame = CGRectMake(ScreenWidth-45, 5, 40, 25);
    [colseBtn setTitle:@"关闭" forState:UIControlStateNormal];
    [colseBtn addTarget:self action:@selector(leaveEditMode) forControlEvents:UIControlEventTouchDown];
    [_closeV addSubview:colseBtn];
    [self addSubview:_closeV];
    
    [UITableView animateWithDuration:0.25 animations:^{
        _tableView.frame = CGRectMake(0, -238+30+59, ScreenWidth, ScreenHeight);
    }];
    textView.text=@"";
    _textV.textColor = [UIColor blackColor];
    return YES;
    
}
- (void)_initPickerView{
    _closeV= [[UIView alloc] initWithFrame:self.bounds];
    _closeV.backgroundColor = [UIColor lightGrayColor];
    _closeV.alpha = 0.4;
    UITapGestureRecognizer * tapV = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closeView)];
    _closeV.userInteractionEnabled = YES;
    [_closeV addGestureRecognizer:tapV];
    [self addSubview:_closeV];
    
    _pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, ScreenHeight - ScreenHeight/2, ScreenWidth,ScreenHeight/2.5)];
    _pickerView.backgroundColor = [UIColor whiteColor];
    _pickerView.delegate= self;
    _pickerView.dataSource = self;
    [self addSubview:_pickerView];
    _labelView = [[UIView alloc] initWithFrame:CGRectMake(0,ScreenHeight - ScreenHeight/2, ScreenWidth, 80)];
    _labelView.backgroundColor = [UIColor whiteColor];
    if (components == 4) {
        NSArray *titleNams = @[@"投资总额",@"项目分类",@"投资种类",@"项目行业"];
        for (int i = 0; i < 4; i++) {
            UILabel *pickerL = [[UILabel alloc] initWithFrame:CGRectMake(20 + (i*ScreenWidth/4),45, ScreenWidth, 40)];
            pickerL.text = titleNams[i];
//            pickerL.textAlignment = NSTextAlignmentCenter;
            pickerL.font = [UIFont systemFontOfSize:14];
            [self.labelView addSubview:pickerL];
        }
        
    }
    UIButton *cancelB = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelB.frame = CGRectMake(10,10, 40, 40);
    [cancelB setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [cancelB setTitle:@"取消" forState:UIControlStateNormal];
    [cancelB addTarget:self action:@selector(closeView) forControlEvents:UIControlEventTouchDown];
    [self.labelView addSubview:cancelB];
    
    UIButton *clickB = [UIButton buttonWithType:UIButtonTypeCustom];
    clickB.frame = CGRectMake(ScreenWidth - 55,10, 40, 40);
    [clickB setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [clickB setTitle:@"确定" forState:UIControlStateNormal];
    [clickB addTarget:self action:@selector(closeView) forControlEvents:UIControlEventTouchUpInside];
    [self.labelView addSubview:clickB];
    
    [self addSubview:_labelView];
}
// 显示列数
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (component == 0) {
        return titls.count;
    }
    if (component == 3) {
        return totals.count;
    }
    if (component == 2) {
        return classifys.count;
    }
    else
    {
        return nams.count;
    }
}
//
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerVie{
    return components;
}

// 显示内容
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if (component == 0)
    {
        NSString *title = [titls objectAtIndex:row];
        return title;
    }
    if (component == 1) {
        NSString *title = [totals objectAtIndex:row];
        return title;
    }
    if (component == 2) {
        NSString *title = [classifys objectAtIndex:row];
        return title;
    }
    else
    {
        NSString *title = [nams objectAtIndex:row];
        return title;
    }
    return nil;
}
// 选择了..
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if (components == 1)
    {
        if (pickerViewValue == 1) {
            //        NSLog(@"%@",[NSString stringWithFormat:@"%@",titls[row]]);
            UILabel *infoL = (UILabel *)[self viewWithTag:2000];
            //        infoL1.textAlignment = UITextAlignmentRight;
            infoL.text = titls[row];
            NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
            [user setObject:infoL.text forKey:@"i1"];
            [user synchronize];
        }
        else
        {
            UILabel *infoL = (UILabel *)[self viewWithTag:1999];
            infoL.text = titls[row];
            NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
            [user setObject:infoL.text forKey:@"i2"];
            [user synchronize];

        }
       
        
        
    }
    if (components == 2)
    {
        
    }
    else if (components == 4)
    {
        NSInteger selectedOneIndex = [self.pickerView selectedRowInComponent:0];
        NSInteger selectedTwoIndex = [self.pickerView selectedRowInComponent:1];
        NSInteger selectedThreeIndex = [self.pickerView selectedRowInComponent:2];
        NSInteger selectedFourIndex = [self.pickerView selectedRowInComponent:3];
        //        NSLog(@"%@",[NSString stringWithFormat:@"%@-%@-%@-%@",titls[selectedOneIndex],nams[selectedTwoIndex],nams[selectedThreeIndex],nams[selectedFourIndex]]);
        UILabel *infoL = (UILabel *)[self viewWithTag:2001];
        infoL.text = [NSString stringWithFormat:@"%@  |  %@  |  %@  |  %@",titls[selectedOneIndex],totals[selectedTwoIndex],classifys[selectedThreeIndex],nams[selectedFourIndex]];
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        [user setObject:infoL.text forKey:@"i3"];
        [user synchronize];


    }

    
}
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel* pickerLabel = (UILabel*)view;
    if (!pickerLabel){
        pickerLabel = [[UILabel alloc] init];
        // Setup label properties - frame, font, colors etc
        //adjustsFontSizeToFitWidth property to YES
//        pickerLabel.minimumFontSize = 8.;
        pickerLabel.font = [UIFont systemFontOfSize:10];
        pickerLabel.adjustsFontSizeToFitWidth = YES;
//        [pickerLabel setTextAlignment:UITextAlignmentCenter];
        pickerLabel.textAlignment = NSTextAlignmentCenter;
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
        [pickerLabel setFont:[UIFont boldSystemFontOfSize:15]];
    }
    // Fill the label text here
    pickerLabel.text=[self pickerView:pickerView titleForRow:row forComponent:component];
    return pickerLabel;
}
- (void)closeView{
    [self.closeV removeFromSuperview];
    [self.pickerView removeFromSuperview];
    [self.labelView removeFromSuperview];
}
#pragma mark - BtnAction
- (void)publishAction{
    // 审核按钮 点击将信息上传到服务器提交审核
    if (![self cheakTheForm])
    {
        [LCProgressHUD showSuccess:@"申报单不能有空缺"];
    }
    else
    {
        // 跳转到我的项目VC里
        SubMyViewController *seachVC = [[SubMyViewController alloc] init];
        [[SetRemindViewController viewController:self].navigationController pushViewController:seachVC animated:YES];
    }
    NSLog(@"ClickOn");

}
#pragma mark - 判定申报单是否缺漏
- (BOOL)cheakTheForm
{
    if
        (projectName.length      != 0 &&
        projectProgress.length   != 0 &&
         projectApplyName        !=0)
    {
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        [user synchronize];
        /*
         "ProjectId": 1, 项目ID
         "ProjectName": "sample string 2", 项目名
         "ApplyMan": 3,
         "ApplyManName": "sample string 4", 申请人
         "Telephone": "sample string 5", 电话
         "NatureType": 6, 项目性质
         "ClassType": 7, 项目分类
         "CategoryType": 8, 投资种类
         "CompanyType": 9,  行业
         "Questions": "sample string 10", 发现问题
         "ApprovalMan": 1,
         "ApprovalManName": "sample string 11", 审批人
         "CreateTime": "2016-04-22 16:04:32", 申请时间
         "CreateUserId": 13, 创建人ID
         "Status": 14, 状态
         "ProcessId": 15 进度ID
         
         */
        NSDate *currentDate = [NSDate date];//获取当前时间，日期
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"YYYY-MM-dd HH:mm "];
        NSString *dateString = [dateFormatter stringFromDate:currentDate];
        NSArray *array = [[user objectForKey:@"i3"] componentsSeparatedByString:@"|"];
        NSLog(@"array:%@",array);
        NSMutableArray *m_StrArr;
        for (NSString *str in array)
        {
            NSLog(@"%@",[str stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]);
            if (m_StrArr.count == 0)
            {
                m_StrArr = [[NSMutableArray alloc] initWithCapacity:0];
            }
            [m_StrArr addObject:str];
        }
        NSLog(@"%@",m_StrArr);
        NSArray *arr = @[@"0",
                         projectName,
                         @"3",
                         projectApplyName,
                         @"18575523716",
                         [user objectForKey:@"i1"],
                         m_StrArr[1],
                         m_StrArr[2],
                         m_StrArr[3],
                         projectQuestion,
                         @"1",
                         @"admin",
                         dateString,
                         @"13",
                         @"14",
                         projectProgress];
        
        NetManger *manger = [NetManger shareInstance];
        manger.formArray = arr;
        [manger loadData:RequestOfProjectsave];
        return YES;
    }
    
    return NO;
}
@end
