//
//  NetManger.m
//  ManagementSystem
//
//  Created by admin on 16/4/12.
//  Copyright © 2016年 JCK. All rights reserved.
//

#import "NetManger.h"
#import "AFNetworking.h"
#import "ProjectModel.h"
#import "LCProgressHUD.h"
NSString *NetManagerRefreshNotify = @"NetManagerRefreshNotify";
static NetManger *manger = nil;
@implementation NetManger
// 单例
+ (instancetype)shareInstance{
    static dispatch_once_t oneToken;
    dispatch_once(&oneToken, ^{
        if (!manger) {
            manger = [[[self class] alloc] init];
            
        }
    });
    return manger;
}
- (instancetype)initWith:(RequestState)requet
{
    self = [super init];
    if (self) {
        [self loadData:requet];
    }
    return self;
}
- (void)loadData:(RequestState)requet
{
    switch (requet) {
        case RequestOfGetarticlelist:
        {
            [self articleGetarticlelistWithChannelID:self.channelID];
        }
            break;
        case RequestOfUpload:
        {
            [self fileUpload];
        }
            break;
        case RequestOfGetlist:
        {
            [self advertiseGetlist];
        }
            break;
        case RequestOfLogin:
        {
            [self userLoginName:self.name AndPassword:self.password];
        }
            break;
        case RequestOfUpdate:
        {
            [self userUpdate];
        }
            break;
        case RequestOfGetprojectlist:
        {
            [self homeGetprojectlistWithKeyword:self.isKeyword AndKeyword:self.keyword];
        }
            break;
        case RequestOfGetprojectt:
        {
            [self homeGetprojectWithProjectID:self.projectID];
        }
            break;
        case RequestOfProjectsave:
        {
            [self homeProjectsaveWithArray:self.formArray ImgArr:self.projectImgs];
        }
            break;
        case RequestOfUpdatepassword:
        {
            [self accountUpdatepasswordWithOldPassword:self.oldPword AndNewPassword:self.passwordOfnew];
        }
            break;
        case RequestOfResetpassword:
        {
            [self accountResetpassword];
        }
            break;
        case RequestOfGetlatestversoin:
        {
            [self systemsetGetlatestversoin];
        }
            break;
        case RequestOfAddfeedback:
        {
            [self systemsetAddfeedback];
        }
            break;
        case RequestOfuserGetcontacts:
        {
            [self userGetcontactsKeyword:self.keyword];
        }
            break;
        case RequestOfGetprojectts:
        {
            [self homeGetprojectWithProjectIDs:self.projectID];
        }
            break;
        case RequestOfProjectcheck:
        {
            [self projectcheck:self.projectID];
        }
            break;
        case RequestOfgetmessagelist:
        {
            [self getmessagelist];
        }
            break;
        case RequestOfprojectcancel:
        {
            [self projectcancel:self.keyword];
        }
            break;
        case RequestOfsendmessage:
        {
            [self sendmessage:self.linkMans Context:self.sendMeassContext Title:self.sendMeassTitle];
        }
            break;
        case RequestOffollow:
        {
            [self projectfollowID:self.followID Ramark:self.followContext Time:self.followTime];
        }
            break;
        
            
        default:
            break;
    }
    self.keyword = @" ";
}
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
#pragma mark - 获取内容列表 ChannelId值说明： 1001 公告 1002 提醒信息 1003 群发消息
- (void)articleGetarticlelistWithChannelID:(NSString *)channel
{
    
    AFHTTPRequestOperationManager *manger = [AFHTTPRequestOperationManager manager];
    manger.requestSerializer.timeoutInterval = 2;
    NSDictionary *parameters = @{
                                 @"_appid" : @"101",
                                 @"_code":self.userID_Code,
                                 @"ChannelId": channel,
                                 @"PageIndex": @"1",
                                 @"PageSize": @"3"
                                 };
    //@"http://192.168.1.4:88/common/user/login"
    NSString *url = [NSString stringWithFormat:@"%@common/article/getarticlelist",ServerAddressURL];
//    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    [manger POST:url parameters:parameters success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject)
     {
         NSLog(@"获取内容列表：%@",responseObject[@"data"]);
         NSArray *dataLists = responseObject[@"data"][@"DataList"];
         [self.m_listArr removeAllObjects];
         for (NSDictionary *dic in dataLists)
         {
            ProjectModel *model = [[ProjectModel alloc] init]; //Summary Title Author
//             NSLog(@"%@ %@ %@ %@",dic[@"ChannelName"],dic[@"Title"],dic[@"Author"],dic[@"Summary"]);
             model.summary = dic[@"Summary"];
             model.title = dic[@"Title"];
             model.author = dic[@"Author"];
             model.listCreateDate = dic[@"CreateDate"];
             if (self.m_listArr.count == 0)
             {
                 self.m_listArr = [[NSMutableArray alloc] initWithCapacity:0];
             }
             [self.m_listArr addObject:model];
         }
         [LCProgressHUD showSuccess:@"加载成功"];
         [[NSNotificationCenter defaultCenter] postNotificationName:@"Getarticlelist" object:nil];
         

         
     } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
         NSLog(@"error : %@",error);
         [LCProgressHUD showFailure:@"获取数据失败"];
         
     }];
    
}
#pragma mark - 上传 ResourceType值说明： 1 头像 201 项目图片
- (void)fileUpload
{
    AFHTTPRequestOperationManager *manger = [AFHTTPRequestOperationManager manager];
    manger.requestSerializer.timeoutInterval = 5;
    NSDictionary *parameters = @{
                                 @"_appid":@"101",
                                 @"_code":self.userID_Code,
                                 };
    NSString *url = [NSString stringWithFormat:@"%@common/file/upload",ServerAddressURL];
    [manger POST:url parameters:parameters success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject)
     {
         NSLog(@"上传：%@",responseObject[@"data"]);
      [LCProgressHUD showSuccess:@"加载成功"];
     } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
         NSLog(@"error : %@",error);
         [LCProgressHUD showFailure:@"获取数据失败"];
     }];
    
}
#pragma mark - 广告列表
- (void)advertiseGetlist
{
    AFHTTPRequestOperationManager *manger = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameters = @{
                                 @"_appid":@"101",
                                 @"_code":self.userID_Code,
                                 };
    NSString *url = [NSString stringWithFormat:@"%@common/advertise/getlist",ServerAddressURL ];
    [manger POST:url parameters:parameters success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject)
     {
//         NSLog(@"广告列表：%@",responseObject[@"data"]);
         [self.m_alrerList removeAllObjects];
         NSArray *datas = responseObject[@"data"];
         for (NSDictionary *dic in datas)
         {
             if (self.m_alrerList.count == 0)
             {
                 self.m_alrerList = [[NSMutableArray alloc] initWithCapacity:0];
             }
            [self.m_alrerList addObject: dic[@"Photo"]];
         }
        [[NSNotificationCenter defaultCenter] postNotificationName:@"common/advertise/getlist" object:responseObject];

     } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
         NSLog(@"error : %@",error);
         [LCProgressHUD showFailure:@"获取数据失败"];
     }];
}

#pragma mark - 登录
- (void)userLoginName:(NSString *)name AndPassword:(NSString *)password
{
    AFHTTPRequestOperationManager *manger = [AFHTTPRequestOperationManager manager];
    manger.requestSerializer.timeoutInterval = 10;
    NSDictionary *parameters = @{
                                 @"_appid":@"101",
//                                 @"_code":self.userID_Code,
//                                 @"content":@"application/json",
                                 @"UserName": name,
                                 @"Password": password,
                                 };
    NSString *url = [NSString stringWithFormat:@"%@common/user/login",ServerAddressURL ];
    [manger POST:url parameters:parameters success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject)
     {
         NSLog(@"登录：%@",responseObject);
         self.code = responseObject[@"code"];
         self.title = responseObject[@"msg"];
         if ([responseObject[@"msg"] isEqualToString:@"success"]) {
             self.userID_Code = responseObject[@"data"][@"Code"];
             self.userId = responseObject[@"data"][@"UserId"];
             NSDictionary *dic = [NSDictionary dictionaryWithDictionary:responseObject[@"data"]];
             self.AppRoleType = [NSString stringWithFormat:@"%@",dic[@"AppRoleType"]]; // 1 业主 2 发改委
             NSMutableArray *m_datas = [[NSMutableArray alloc] initWithCapacity:0];
             for (NSString *str in dic)
             {
                 [m_datas addObject:str];
             }
             for (int i = 0; i<m_datas.count; i++)
             {
//                 NSLog(@"%@",[dic objectForKey:m_datas[i]]);
             }

         }

         [[NSNotificationCenter defaultCenter] postNotificationName:NetManagerRefreshNotify object:responseObject];
         
         
     } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
         NSLog(@"error : %ld",(long)error.code); // -1001 超时 -1009没网络
         NSString *errorStr = [NSString stringWithFormat:@"%ld",error.code];
         [[NSNotificationCenter defaultCenter] postNotificationName:NetManagerRefreshNotify object:nil userInfo:@{@"errorCode":errorStr}];
     }];
   
}

#pragma mark - 修改个人信息
- (void)userUpdate
{
    AFHTTPRequestOperationManager *manger = [AFHTTPRequestOperationManager manager];
    manger.requestSerializer.timeoutInterval = 5;
    NSDictionary *parameters = @{
                                 @"_appid":@"101",
                                 @"_code":self.userID_Code,
                                 @"content":@"application/json",
                                 
                                 @"Code": @"sample string 1",
                                 @"AreaName": @"sample string 2",
                                 @"UserId": @"3",
                                 @"AreaId": @"1",
                                 @"UserType": @"4",
                                 @"UserName": @"sample string 5",
                                 @"PasswordSalt": @"sample string 6",
                                 @"UserPassword": @"sample string 7",
                                 @"CnName": @"sample string 8",
                                 @"EnName": @"sample string 9",
                                 @"Gender": @"1",
                                 @"Mobile": @"sample string 10",
                                 @"RoleName": @"sample string 11",
                                 @"Photo": @"sample string 12",
                                 @"QQ": @"sample string 13",
                                 @"MicroMessage": @"sample string 14",
                                 @"Email": @"sample string 15",
                                 @"Address": @"sample string 16",
                                 @"Remark": @"sample string 17",
                                 @"Status": @"1",
                                 @"CreateUserId": @"1",
                                 @"CreateUserCnName": @"sample string 18",
                                 @"CreateTime": @"2016-04-14 09:48:54",
                                 @"UpdateUserId": @"1",
                                 @"UpdateUserCnName": @"sample string 19",
                                 @"UpdateTime": @"2016-04-14 09:48:54",
                                 @"WorkType": @"1",
                                 @"UserGrade": @"1",
                                 @"Profession": @"1",
                                 @"Age": @"1",
                                 @"C_PersonId": @"1"

                                 };
    NSString *url = [NSString stringWithFormat:@"%@common/user/update",ServerAddressURL];
    [manger POST:url parameters:parameters success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject)
     {
         NSLog(@"修改个人信息：%@",responseObject[@"data"]);
        [LCProgressHUD showSuccess:@"加载成功"];
     } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
         NSLog(@"error : %@",error);
         [LCProgressHUD showFailure:@"获取数据失败"];
     }];
}

#pragma mark - 项目列表
- (void)homeGetprojectlistWithKeyword:(BOOL) iskeyword AndKeyword:(NSString *)keyword
{
    AFHTTPRequestOperationManager *manger = [AFHTTPRequestOperationManager manager];
    manger.requestSerializer.timeoutInterval = 5;
    NSDictionary *parameters = [[NSDictionary alloc] init];
    if (iskeyword == YES) {
        parameters = @{
                       
                       @"_appid":@"101",
                       @"_code":self.userID_Code,
                       @"content":@"application/json",
                       @"Keyword": keyword,
                       
                       };
    }
    else
    {
        parameters = @{
                       @"_appid":@"101",
                       @"_code":self.userID_Code,
                       @"content":@"application/json",
                       @"Status": @"0",
                       };
    }
    NSString *url = [NSString stringWithFormat:@"%@project/home/getprojectlist",ServerAddressURL];
    [manger POST:url parameters:parameters success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject)
     {
         // Status 14 未通过 2通过
         NSLog(@"项目列表：%@",responseObject);
         NSArray *dataLists = responseObject[@"data"][@"DataList"];
         NSLog(@"%ld",dataLists.count);
//         for (int i = 0; i< dataLists.count; i++)
//         {
//
//         }
         [self.m_projectInfoArr removeAllObjects];
         for (NSDictionary *dic in dataLists) {
             ProjectModel *model = [[ProjectModel alloc] init];
             //                 NSLog(@"%@",dic[@"ProjectName"]);
             model.applyManName     = [NSString stringWithFormat:@"%@",dic[@"ApplyManName"]];
             model.telephone        = [NSString stringWithFormat:@"%@",dic[@"Telephone"]];
             model.createTime       = [NSString stringWithFormat:@"%@",dic[@"CreateTime"]];
             model.natureType       = [NSString stringWithFormat:@"%@",dic[@"NatureTypeName"]];
             model.money            = @"暂无";
             model.projectName      = [NSString stringWithFormat:@"%@",dic[@"ProjectName"]];
             model.categoryType     = [NSString stringWithFormat:@"%@",dic[@"CategoryTypeName"]];
             model.companyType      = [NSString stringWithFormat:@"%@",dic[@"CompanyTypeName"]];
             model.processStatus    = [NSString stringWithFormat:@"%@",dic[@"ProcessStatus"]];
             model.questions        = [NSString stringWithFormat:@"%@",dic[@"Questions"]];
             model.classTypeName      = [NSString stringWithFormat:@"%@",dic[@"ClassTypeName"]]; 
             model.status           = [NSString stringWithFormat:@"%@",dic[@"Status"]];
             model.projectIDofModel = [NSString stringWithFormat:@"%@",dic[@"ProjectId"]];
             if (self.m_projectInfoArr.count == 0)
             {
                 self.m_projectInfoArr = [[NSMutableArray alloc] initWithCapacity:0];
             }
             [self.m_projectInfoArr addObject:model];
             
         }
//         [LCProgressHUD showSuccess:@"加载成功"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"GetprojectlistWithKeyword" object:nil];

         
     } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
         NSLog(@"error : %@",error);
         [LCProgressHUD showFailure:@"获取数据失败"];
     }];
}

#pragma mark - 项目详情
- (void)homeGetprojectWithProjectID :(NSString *)ID
{
    AFHTTPRequestOperationManager *manger = [AFHTTPRequestOperationManager manager];
    manger.requestSerializer.timeoutInterval = 2;
    NSDictionary *parameters = @{
                                 @"_appid":@"101",
                                 @"_code":self.userID_Code,
                                 @"content":@"application/json",
                                 
                                 @"Id":ID
                                 };
    NSString *url = [NSString stringWithFormat:@"%@project/home/getproject",ServerAddressURL];
    [manger POST:url parameters:parameters success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject)
     {
         NSDictionary *dic = [NSDictionary dictionaryWithDictionary:responseObject[@"data"]];
         NSArray *imgs = dic[@"Images"];
        [self.m_details removeAllObjects];
         [self.m_proImg removeAllObjects];
         for (NSString *str in imgs)
         {
             if (self.m_proImg.count == 0) {
                 self.m_proImg = [[NSMutableArray alloc] initWithCapacity:0];
             }
             [self.m_proImg addObject: str];
         }
         for (int i = 0; i<13; i++)
         {
             ProjectModel *model = [[ProjectModel alloc] init];
             model.applyManName     = [NSString stringWithFormat:@"%@",dic[@"ApplyManName"]];
             model.telephone        = [NSString stringWithFormat:@"%@",dic[@"Telephone"]];
             model.createTime       = [NSString stringWithFormat:@"%@",dic[@"CreateTime"]];
             model.natureType       = [NSString stringWithFormat:@"%@",dic[@"NatureTypeName"]];
             model.money            = [NSString stringWithFormat:@"暂无"];
             model.projectName      = [NSString stringWithFormat:@"%@",dic[@"ProjectName"]];
             model.categoryType     = [NSString stringWithFormat:@"%@",dic[@"CategoryTypeName"]];
             model.companyType      = [NSString stringWithFormat:@"%@",dic[@"CompanyTypeName"]];
             model.processStatus    = [NSString stringWithFormat:@"%@",dic[@"ProcessStatus"]];
             model.questions        = [NSString stringWithFormat:@"%@",dic[@"Questions"]];
             model.classTypeName    = [NSString stringWithFormat:@"%@",dic[@"ClassTypeName"]];
             model.status           = [NSString stringWithFormat:@"%@",dic[@"Status"]];
             if (self.m_details.count == 0)
             {
                 self.m_details = [[NSMutableArray alloc] initWithCapacity:0];
             }
             [self.m_details addObject:model];
         }
        
         NSLog(@"项目详情：%@",responseObject[@"data"]);
         [LCProgressHUD showSuccess:@"加载成功"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"Getproject" object:nil];
     } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
         NSLog(@"error : %@",error);
         [LCProgressHUD showFailure:@"获取数据失败"];

     }];
}
#pragma mark - 保存上报项目
- (void)homeProjectsaveWithArray:(NSArray *)array ImgArr:(NSArray *)imgs
{
    if (imgs.count == 0)
    {
        imgs = @[@" "];
    }
    AFHTTPRequestOperationManager *manger = [AFHTTPRequestOperationManager manager];
    manger.requestSerializer.timeoutInterval = 2;
//    NSLog(@"%@",array);
    NSDictionary *parameters = @{
                                 @"_appid":@"101",
                                 @"_code":self.userID_Code,
                                 @"content":@"application/json",
                                 @"ProjectId":      @"0", // 项目ID
                                 @"ProjectName":    array[1],// 项目名
                                 @"ApplyManName":   array[2], // 申请人
                                 @"Telephone":      array[3], // 电话
                                 @"NatureType":     array[4], // 项目性质
                                 @"ClassType":      array[5],  // 投资分类
                                 @"CategoryType":   array[6], // 行业
                                 @"CompanyType":    array[7], // 项目分类
                                 @"Questions":      array[8], // 存在问题
//                                 @"CreateTime":     array[9], // 创建时间
                                 @"CreateUserId":   array[10], //创建人用户ID
                                 @"ProcessIdName":      array[11], // 进度状态
                                 @"AreaType":      array[12],// 开竣工
                                 @"IsHard":      array[13],// 攻坚
                                 @"MoneyType":      array[14],// 投资总额
                                 @"ImgData":imgs,// 项目图片
                                 @"StartDate": array[15],// 开始时间
                                 @"FinishDate": array[16]// 结束时间
                                 };
    NSString *url = [NSString stringWithFormat:@"%@project/home/projectsave",ServerAddressURL];
    [manger POST:url parameters:parameters success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject)
     {
//         NSLog(@"%@",parameters);
         NSLog(@"保存上报项目：%@",responseObject[@"data"]);
         [LCProgressHUD showSuccess:@"申请上报成功"];
     } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
         NSLog(@"error : %@",error);
         [LCProgressHUD showFailure:@"上报数据失败"];
     }];
}
#pragma mark - 修改密码
- (void)accountUpdatepasswordWithOldPassword:(NSString *)oldPw AndNewPassword:(NSString *)newPw
{
    AFHTTPRequestOperationManager *manger = [AFHTTPRequestOperationManager manager];
    manger.requestSerializer.timeoutInterval = 5;
    NSDictionary *parameters = @{
                                 @"_appid":@"101",
                                 @"_code":self.userID_Code,
                                 @"content":@"application/json",
                                 
                                 @"OldPassword": oldPw,
                                 @"NewPassword": newPw
                                 };
    NSString *url = [NSString stringWithFormat:@"%@systemset/account/updatepassword",ServerAddressURL];
    [manger POST:url parameters:parameters success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject)
     {
//         NSLog(@"%@ %@ %@",oldPw,newPw,self.userID_Code);
        NSLog(@"修改密码：%@ %@ %@",responseObject[@"code"],responseObject[@"data"],responseObject[@"msg"]);
         
         [[NSNotificationCenter defaultCenter] postNotificationName:@"updatepassword" object:responseObject];
         
         
     } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
         NSLog(@"error : %@",error);
         [LCProgressHUD showFailure:@"修改密码失败"];
     }];
}
#pragma mark - 重置用户密码
- (void)accountResetpassword
{
    AFHTTPRequestOperationManager *manger = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameters = @{
                                 @"_appid":@"101",
                                 @"_code":self.userID_Code,
                                 @"content":@"application/json",
                                 
                                 @"Mobile": @"sample string 1",
                                 @"Code": @"sample string 2",
                                 @"NewPassword": @"sample string 3"
                                 };
    NSString *url = [NSString stringWithFormat:@"%@systemset/account/resetpassword",ServerAddressURL];
    [manger POST:url parameters:parameters success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject)
     {
        NSLog(@"重置用户密码：%@",responseObject[@"data"]);
         
     } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
         NSLog(@"error : %@",error);
         [LCProgressHUD showFailure:@"获取数据失败"];
     }];
}

#pragma mark - 获取最新版本

- (void)systemsetGetlatestversoin
{
    AFHTTPRequestOperationManager *manger = [AFHTTPRequestOperationManager manager];
    manger.requestSerializer.timeoutInterval = 5;
    NSDictionary *parameters = @{
                                 @"_appid":@"101",
                                 @"_code":self.userID_Code,
                                 @"content":@"application/json",
                                 
                                @"AppId": @"103"
                                 };
    NSString *url = [NSString stringWithFormat:@"%@systemset/getlatestversoin",ServerAddressURL];
    [manger POST:url parameters:parameters success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject)
     {
        NSLog(@"获取最新版本：%@",responseObject[@"data"]);
         self.code = responseObject[@"code"];
         self.title = responseObject[@"msg"];
         if ([responseObject[@"msg"] isEqualToString:@"success"]) {
             
            NSDictionary *dic = [NSDictionary dictionaryWithDictionary:responseObject[@"data"]];
             NSMutableArray *m_datas = [[NSMutableArray alloc] initWithCapacity:0];
             for (NSString *str in dic)
             {
                 [m_datas addObject:str];
             }
             for (int i = 0; i<m_datas.count; i++)
             {
//                 NSLog(@"%@",[dic objectForKey:m_datas[i]]);
                self.versionName =dic[@"FileDesc"];
             }
             
         }
         
         [[NSNotificationCenter defaultCenter] postNotificationName:@"VersionName" object:self.versionName];
         
     } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
         NSLog(@"error : %@",error);
         [LCProgressHUD showFailure:@"获取数据失败"];
     }];
}
#pragma mark - 添加系统反馈
- (void)systemsetAddfeedback
{
    AFHTTPRequestOperationManager *manger = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameters = @{
                                 @"_appid":@"101",
                                 @"_code":self.userID_Code,
                                 @"content":@"application/json",
                                 
                                 @"ClientAppId": @"103",
                                 @"ClientAppVersion": @"sample string 2",
                                 @"Content": @"sample string 3"
                                 };
    NSString *url = [NSString stringWithFormat:@"%@systemset/addfeedback",ServerAddressURL];
    [manger POST:url parameters:parameters success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject)
     {
        NSLog(@"添加系统反馈：%@",responseObject[@"data"]);
         
     } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
         NSLog(@"error : %@",error);
         [LCProgressHUD showFailure:@"获取数据失败"];
     }];
}
#pragma mark - 获取常用联系人列表
- (void)userGetcontactsKeyword:(NSString *)keywork
{
    if (keywork.length == 0) {
        keywork = @" ";
    }
    AFHTTPRequestOperationManager *manger = [AFHTTPRequestOperationManager manager];
    manger.requestSerializer.timeoutInterval = 5;
    NSDictionary *parameters = @{
                                 @"_appid":@"101",
                                 @"_code":self.userID_Code,
                                 @"content":@"application/json",
//                                 @"Keyword":keywork,
                                 };
    NSString *url = [NSString stringWithFormat:@"%@common/user/getcontacts",ServerAddressURL];
    [manger POST:url parameters:parameters success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject)
     {
         NSLog(@"获取常用联系人列表：%@",responseObject);
         NSArray *dataLists = responseObject[@"data"][@"DataList"];
         NSLog(@"获取常用联系人列表数组个数：%ld",dataLists.count);
         [self.m_getcontacts removeAllObjects];
         for (NSDictionary *dic in dataLists)
         {
             ProjectModel *model = [[ProjectModel alloc] init];
             model.linkID = dic[@"LinkUserId"];
             model.linkManName = dic[@"LinkManName"];
             
             NSString *value2 = [dic objectForKey:@"ZhiWuName"];
             if ((NSNull *)value2 == [NSNull null])
             {
                 model.zhiWuName = @" ";
             }
             else
             {
                 model.zhiWuName = @" ";
             }
             
             NSString *value = [dic objectForKey:@"LinkPhone"];
             if ((NSNull *)value == [NSNull null])
             {
                 model.linkPhone = @"无";
             }
             else
             {
                 model.linkPhone = dic[@"LinkPhone"];
             }
             
             NSString *value3 = [dic objectForKey:@"LinkMobile"];
             if ((NSNull *)value3 == [NSNull null])
             {
                 model.linkMobile = @"无";
             }
             else
             {
                 model.linkMobile = dic[@"LinkMobile"];
             }
             
             if (self.m_getcontacts.count == 0)
             {
                 self.m_getcontacts = [[NSMutableArray alloc] initWithCapacity:0];
             }
             [self.m_getcontacts addObject:model];
         }
         [LCProgressHUD showSuccess:@"加载成功"];
         [[NSNotificationCenter defaultCenter] postNotificationName:@"Getcontacts" object:nil];

         
     } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
         NSLog(@"error : %@",error);
         [LCProgressHUD showFailure:@"获取数据失败"];
     }];
}
#pragma mark - 群发
- (void)sendmessage:(NSArray *)sendUsers Context:(NSString *)context Title:(NSString *)title
{
    AFHTTPRequestOperationManager *manger = [AFHTTPRequestOperationManager manager];
    manger.requestSerializer.timeoutInterval = 5;
    NSDictionary *parameters = @{
                                 @"_appid":@"101",
                                 @"_code":self.userID_Code,
                                 @"content":@"application/json",
                                 
                                 @"SendUsers": sendUsers,
//                                 @"Id": self.userId,
//                                 @"UserFrom": @"1",
//                                 @"UserTo": @"1",
//                                 @"CreateTime": [self getDate],
                                 @"HeadTitle": title,
                                 @"DataContent": context
                                 };
    NSString *url = [NSString stringWithFormat:@"%@common/user/sendmessage",ServerAddressURL];
    [manger POST:url parameters:parameters success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject)
     {
         NSLog(@"发送信息：%@",responseObject);
         [LCProgressHUD showSuccess:@"发送成功"];
     } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
         NSLog(@"error : %@",error);
         [LCProgressHUD showFailure:@"发送失败"];
     }];
}
#pragma mark - 审批 ProjectId，Number，CheckStatus，CheckCuauses必传
- (void)projectcheck:(NSString *)ID
{
    AFHTTPRequestOperationManager *manger = [AFHTTPRequestOperationManager manager];
    manger.requestSerializer.timeoutInterval = 2;
    NSDictionary *parameters = @{
                                 @"_appid":@"101",
                                 @"_code":self.userID_Code,
                                 @"content":@"application/json",
                                 
                                 @"ProjectId": ID,
                                 @"Number": @"1",
                                 @"StructureId": @"2",
//                                 @"StructureName": @"人力资源",
                                 @"CheckStatus": @"2",
                                 @"CheckTime": [self getDate],
                                 @"CheckCuauses": @"good"
                                 };
    NSString *url = [NSString stringWithFormat:@"%@project/home/projectcheck",ServerAddressURL];
    [manger POST:url parameters:parameters success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject)
     {
         NSLog(@"项目审查：%@",responseObject);
         [LCProgressHUD showSuccess:responseObject[@"msg"]];
         [[NSNotificationCenter defaultCenter] postNotificationName:@"Projectcheck" object:nil];
     } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
         NSLog(@"error : %@",error);
         [LCProgressHUD showFailure:@"获取数据失败"];
     }];
}
- (void)projectfollowID:(NSString *)ID Ramark:(NSString *)remark Time:(NSString *)time
{
    if (time.length == 0) {
        time = [self getDate];
    }
    AFHTTPRequestOperationManager *manger = [AFHTTPRequestOperationManager manager];
    manger.requestSerializer.timeoutInterval = 5;
    NSDictionary *parameters = @{
                                 @"_appid":@"101",
                                 @"_code":self.userID_Code,
                                 @"content":@"application/json",
                                
                                 @"ProjectId": ID,
                                 @"sType": @"1",
                                 @"Remark": remark,
                                 @"FollowDate": time,
                                 };
    NSString *url = [NSString stringWithFormat:@"%@project/home/projectfollow",ServerAddressURL];
    [manger POST:url parameters:parameters success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject)
     {
         NSLog(@"项目跟踪：%@",responseObject[@"msg"]);
         [LCProgressHUD showInfoMsg:@"操作成功"];
         
     } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
         NSLog(@"error : %@",error);
         [LCProgressHUD showFailure:@"获取数据失败"];
     }];
}
#pragma mark - 群发消息列表
- (void)getmessagelist
{
    AFHTTPRequestOperationManager *manger = [AFHTTPRequestOperationManager manager];
//    manger.requestSerializer.timeoutInterval = 5;
    NSDictionary *parameters = @{
                                 @"_appid":@"101",
                                 @"_code":self.userID_Code,
                                 @"content":@"application/json",
                                 
//                                 @"Keyword": @"14",
//                                 @"PageIndex": @"2",
//                                 @"PageSize": @"3"
                                 };
    NSString *url = [NSString stringWithFormat:@"%@common/user/getmessagelist",ServerAddressURL];
    [manger POST:url parameters:parameters success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject)
     {
         NSLog(@"群发消息列表：%@",responseObject);
         NSArray *dataLists = responseObject[@"data"][@"DataList"];
         [self.m_messages removeAllObjects];
         for (NSDictionary *dic in dataLists)
         {
             ProjectModel *model = [[ProjectModel alloc] init];
             model.messageID = dic[@"Id"];
             model.messageeName = dic[@"UserNameFrom"];
             model.messageContext = dic[@"DataContent"];
             model.messageTime = dic[@"CreateTime"];
             if (self.m_messages.count == 0)
             {
                 self.m_messages = [[NSMutableArray alloc] initWithCapacity:0];
             }
             [self.m_messages addObject:model];
         }
         [LCProgressHUD showSuccess:@"加载成功"];
         [[NSNotificationCenter defaultCenter] postNotificationName:@"getmessagelist" object:nil];
         
     } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
         NSLog(@"error : %@",error);
         [LCProgressHUD showFailure:@"获取数据失败"];
     }];
}
#pragma mark - 项目进度详情
- (void)homeGetprojectWithProjectIDs :(NSString *)ID
{
    AFHTTPRequestOperationManager *manger = [AFHTTPRequestOperationManager manager];
    manger.requestSerializer.timeoutInterval = 2;
    NSDictionary *parameters = @{
                                 @"_appid":@"101",
                                 @"_code":self.userID_Code,
                                 @"content":@"application/json",
                                 
                                 @"Id":ID
                                 };
    NSString *url = [NSString stringWithFormat:@"%@project/home/getproject",ServerAddressURL];
    [manger POST:url parameters:parameters success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject)
     {
         
         NSLog(@"%@",responseObject);
         /*
          ProjectId	:	2
          StructureName	:	人力资源
          CheckTime	:	2016-04-09 10:07:31
          CheckUserName	:	admin
          CheckCuauses	:	非常有创意
          
          */
         NSDictionary *datas = responseObject[@"data"][@"FollowList"];
         [self.m_processArr removeAllObjects];
         for (NSDictionary *dic in datas) {
             ProjectModel *model = [[ProjectModel alloc] init];
             model.processCheckCuauses = dic[@"Remark"];
             model.processCheckTime = dic[@"FollowDate"];
             if (self.m_processArr.count == 0) {
                 self.m_processArr = [[NSMutableArray alloc] initWithCapacity:0];
             }
             [self.m_processArr addObject:model];
         }
//         [LCProgressHUD showSuccess:@"加载成功"];
         [[NSNotificationCenter defaultCenter] postNotificationName:@"Getprojects" object:nil];
     } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
         NSLog(@"error : %@",error);
         [LCProgressHUD showFailure:@"获取数据失败"];
         
     }];
}
#pragma mark - 撤销
- (void)projectcancel:(NSString *)ID
{
    AFHTTPRequestOperationManager *manger = [AFHTTPRequestOperationManager manager];
    manger.requestSerializer.timeoutInterval = 5;
    NSDictionary *parameters = @{
                                 @"_appid":@"101",
                                 @"_code":self.userID_Code,
                                 @"content":@"application/json",
                                 
                                 @"Id": ID,
                                 };
    NSString *url = [NSString stringWithFormat:@"%@project/home/projectcancel",ServerAddressURL];
    [manger POST:url parameters:parameters success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject)
     {
         NSLog(@"撤销信息：%@",responseObject);
         if ([responseObject[@"msg"] isEqualToString:@"success"])
         {
            [LCProgressHUD showSuccess:@"撤销成功"];
         }
         else
         {
             [LCProgressHUD showSuccess:responseObject[@"msg"]];
         }
     } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
         NSLog(@"error : %@",error);
         [LCProgressHUD showFailure:@"撤销失败"];
     }];
}
- (NSString *)getDate
{
    NSDate *currentDate = [NSDate date];//获取当前时间，日期
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd"];
    NSString *dateString = [dateFormatter stringFromDate:currentDate];
    NSLog(@"dateString:%@",dateString);
    return dateString;
}
@end
