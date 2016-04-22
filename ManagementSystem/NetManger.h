//
//  NetManger.h
//  ManagementSystem
//
//  Created by admin on 16/4/12.
//  Copyright © 2016年 JCK. All rights reserved.
//

#import <Foundation/Foundation.h>
extern NSString *NetManagerRefreshNotify;
/*
 ---- 公共接口 ----
 方式	地址	说明
 POST	common/article/getarticlelist
 No documentation available.
 
 POST	common/file/upload
 上传 ResourceType值说明： 1 头像 201 项目图片
 
 POST	common/advertise/getlist
 广告列表
 
 POST	common/user/login
 登录
 
 POST	common/user/update
 修改个人信息
 
 
 ---- 项目管理 ----
 方式	地址	说明
 
 POST	project/home/getprojectlist
 项目列表
 
 POST	project/home/getproject
 项目详情
 
 POST	project/home/projectsave
 保存上报项目
 
 
 ---- 系统设置 ----
 方式	地址	说明
 
 POST	systemset/account/updatepassword
 修改密码
 
 POST	systemset/account/resetpassword
 重置用户密码
 
 POST	systemset/getlatestversoin
 获取最新版本
 
 POST	systemset/addfeedback
 添加系统反馈
 
 POST	systemset/addfeedbacktest
 添加系统反馈测试
 */

typedef enum
{
    RequestOfGetarticlelist = 0,    // 获取内容列表
    
    RequestOfUpload,                // 上传 ResourceType值说明： 1 头像 201 项目图片
    
    RequestOfGetlist,               // 广告列表
    
    RequestOfLogin,                 // 登录
    
    RequestOfUpdate,                // 修改个人信息
    
    RequestOfGetprojectlist,        // 项目列表
    
    RequestOfGetprojectt,           // 项目详情
    
    RequestOfProjectsave,           // 保存上报项目
    
    RequestOfUpdatepassword,        // 修改密码
    
    RequestOfResetpassword,         // 重置用户密码
    
    RequestOfGetlatestversoin,      // 获取最新版本
    
    RequestOfAddfeedback,           // 添加系统反馈
    
    RequestOfAddfeedbacktest,       // 添加系统反馈测试
    
    RequestOfuserGetcontacts        // 获取常用联系人
    
    
}RequestState;

@interface NetManger : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *code;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *password;
@property (nonatomic, copy) NSString *userID_Code;
@property (nonatomic, copy) NSString *versionName;
@property (nonatomic, copy) NSString *oldPword;
@property (nonatomic, copy) NSString *passwordOfnew;
@property (nonatomic, copy) NSString *projectID;
@property (nonatomic, copy) NSString *channelID;
@property (nonatomic, strong) NSArray *formArray;

@property (nonatomic, strong) NSMutableArray *m_details;
@property (nonatomic, strong) NSMutableArray *m_projectInfoArr;
@property (nonatomic, strong) NSMutableArray *m_listArr;
@property (nonatomic, strong) NSMutableArray *m_getcontacts;
@property (nonatomic, assign) BOOL isKeyword;
+ (instancetype)shareInstance;
- (void)loadData:(RequestState)requet;
@end
