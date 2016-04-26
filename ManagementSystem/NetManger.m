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
            [self homeProjectsaveWithArray:self.formArray];
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
//            [self projectcheck];
//            [self projectfollow];
//            [self sendmessage];
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
        
            
        default:
            break;
    }
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

// 获取内容列表 ChannelId值说明： 1001 公告 1002 提醒信息 1003 群发消息
- (void)articleGetarticlelistWithChannelID:(NSString *)channel
{
    
    AFHTTPRequestOperationManager *manger = [AFHTTPRequestOperationManager manager];
    manger.requestSerializer.timeoutInterval = 2;
    NSDictionary *parameters = @{
                                 @"_appid" : @"101",
                                 @"_code":self.userID_Code,
                                 @"ChannelId": channel,
                                 };
    //@"http://192.168.1.4:88/common/user/login"
    NSString *url = [NSString stringWithFormat:@"%@common/article/getarticlelist",ServerAddressURL];
//    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    [manger POST:url parameters:parameters success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject)
     {
         NSLog(@"获取内容列表：%@",responseObject[@"data"]);
         NSArray *dataLists = responseObject[@"data"][@"DataList"];
         NSLog(@"获取内容列表数组个数：%ld",dataLists.count);
         [self.m_listArr removeAllObjects];
         for (NSDictionary *dic in dataLists)
         {
            ProjectModel *model = [[ProjectModel alloc] init]; //Summary Title Author
//             NSLog(@"%@ %@ %@ %@",dic[@"ChannelName"],dic[@"Title"],dic[@"Author"],dic[@"Summary"]);
             model.summary = dic[@"Summary"];
             model.title = dic[@"Title"];
             if ([dic[@"ChannelName"]isEqualToString:@"群发消息"]) {
                 model.author = @"暂无";
             }
             else
             {
                 model.author = dic[@"Author"];
             }
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
// 上传 ResourceType值说明： 1 头像 201 项目图片
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
// 广告列表
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
         NSLog(@"广告列表：%@",responseObject[@"data"]);
        [LCProgressHUD showSuccess:@"加载成功"];
     } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
         NSLog(@"error : %@",error);
         [LCProgressHUD showFailure:@"获取数据失败"];
     }];
}

// 登录
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
         NSLog(@"登录：%@",responseObject[@"data"]);
         self.code = responseObject[@"code"];
         self.title = responseObject[@"msg"];
         if ([responseObject[@"msg"] isEqualToString:@"success"]) {
             self.userID_Code = responseObject[@"data"][@"Code"];
             NSDictionary *dic = [NSDictionary dictionaryWithDictionary:responseObject[@"data"]];
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

// 修改个人信息
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

// 项目列表
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
                       @"Status": @"2",
                       };
    }
    NSString *url = [NSString stringWithFormat:@"%@project/home/getprojectlist",ServerAddressURL];
    [manger POST:url parameters:parameters success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject)
     {
         // Status 14 未通过 2通过
         NSLog(@"项目列表：%@",responseObject[@"data"][@"DataList"]);
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
             model.test3            = @"暂无";
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
         [LCProgressHUD showSuccess:@"加载成功"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"GetprojectlistWithKeyword" object:nil];

         
     } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
         NSLog(@"error : %@",error);
         [LCProgressHUD showFailure:@"获取数据失败"];
     }];
}

// 项目详情
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
         
         /*
          @property (nonatomic, copy) NSString *applyManName;// 申请人
          @property (nonatomic, copy) NSString *telephone; // 电话
          @property (nonatomic, copy) NSString *createTime; // 时间
          @property (nonatomic, copy) NSString *natureType; // 项目性质
          @property (nonatomic, copy) NSString *test3; // 投资总额
          @property (nonatomic, copy) NSString *projectName; // 项目名称
          @property (nonatomic, copy) NSString *companyType; // 投资种类
          @property (nonatomic, copy) NSString *categoryType; // 行业
          @property (nonatomic, copy) NSString *processStatus; // 项目进度标识
          @property (nonatomic, copy) NSString *questions; // 存在问题
          @property (nonatomic, copy) NSString *processName; // 项目分类
          @property (nonatomic, copy) NSString *status; // 项目状态标识
          */
         NSDictionary *dic = [NSDictionary dictionaryWithDictionary:responseObject[@"data"]];
//          NSMutableArray *m_datas = [[NSMutableArray alloc] initWithCapacity:0];
//          for (NSString *str in dic)
//          {
//              [m_datas addObject:str];
//          }
         [self.m_details removeAllObjects];
         for (int i = 0; i<13; i++)
         {
             ProjectModel *model = [[ProjectModel alloc] init];
             model.applyManName     = [NSString stringWithFormat:@"%@",dic[@"ApplyManName"]];
             model.telephone        = [NSString stringWithFormat:@"%@",dic[@"Telephone"]];
             model.createTime       = [NSString stringWithFormat:@"%@",dic[@"CreateTime"]];
             model.natureType       = [NSString stringWithFormat:@"%@",dic[@"NatureTypeName"]];
             model.test3            = @"暂无";
             model.projectName      = [NSString stringWithFormat:@"%@",dic[@"ProjectName"]];
             model.categoryType     = [NSString stringWithFormat:@"%@",dic[@"CategoryTypeName"]];
             model.companyType      = [NSString stringWithFormat:@"%@",dic[@"CompanyTypeName"]];
             model.processStatus    = [NSString stringWithFormat:@"%@",dic[@"ProcessStatus"]];
             model.questions        = [NSString stringWithFormat:@"%@",dic[@"Questions"]];
             model.classTypeName      = [NSString stringWithFormat:@"%@",dic[@"ClassTypeName"]];
             model.status           = [NSString stringWithFormat:@"%@",dic[@"Status"]];

             if (self.m_details.count == 0)
             {
                 self.m_details = [[NSMutableArray alloc] initWithCapacity:0];
             }
             [self.m_details addObject:model];
         }
//         NSMutableArray *m_datas = [[NSMutableArray alloc] initWithCapacity:0];
//         for (NSString *str in dic)
//         {
//             [m_datas addObject:str];
//         }
//         for (int i = 0; i<m_datas.count; i++)
//         {
//            NSLog(@"%@",[dic objectForKey:m_datas[i]]);
//             if (self.m_details.count == 0)
//             {
//                  self.m_details = [[NSMutableArray alloc] initWithCapacity:0];
//             }
//             [self.m_details addObject:[dic objectForKey:m_datas[i]]];
//
//         }
        
         NSLog(@"项目详情：%@",responseObject[@"data"]);
         [LCProgressHUD showSuccess:@"加载成功"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"Getproject" object:nil];
     } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
         NSLog(@"error : %@",error);
         [LCProgressHUD showFailure:@"获取数据失败"];

     }];
}
// 保存上报项目
- (void)homeProjectsaveWithArray:(NSArray *)array
{
    AFHTTPRequestOperationManager *manger = [AFHTTPRequestOperationManager manager];
    manger.requestSerializer.timeoutInterval = 2;
    NSLog(@"%@",array);
    /*
     @property (nonatomic, copy) NSString *applyManName;// 申请人
     @property (nonatomic, copy) NSString *telephone; // 电话
     @property (nonatomic, copy) NSString *createTime; // 时间
     @property (nonatomic, copy) NSString *natureType; // 项目性质
     @property (nonatomic, copy) NSString *test3; // 投资总额
     @property (nonatomic, copy) NSString *projectName; // 项目名称
     @property (nonatomic, copy) NSString *companyType; // 投资种类
     @property (nonatomic, copy) NSString *categoryType; // 行业
     @property (nonatomic, copy) NSString *processStatus; // 项目进度标识
     @property (nonatomic, copy) NSString *questions; // 存在问题
     @property (nonatomic, copy) NSString *processName; // 项目分类
     @property (nonatomic, copy) NSString *status; // 项目状态标识
     
     model.applyManName     = [NSString stringWithFormat:@"%@",dic[@"ApplyManName"]];
     model.telephone        = [NSString stringWithFormat:@"%@",dic[@"Telephone"]];
     model.createTime       = [NSString stringWithFormat:@"%@",dic[@"CreateTime"]];
     model.natureType       = [NSString stringWithFormat:@"%@",dic[@"NatureTypeName"]];
     model.test3            = @"暂无";
     model.projectName      = [NSString stringWithFormat:@"%@",dic[@"ProjectName"]];
     model.categoryType     = [NSString stringWithFormat:@"%@",dic[@"CategoryTypeName"]];
     model.companyType      = [NSString stringWithFormat:@"%@",dic[@"CompanyTypeName"]];
     model.processStatus    = [NSString stringWithFormat:@"%@",dic[@"ProcessStatus"]];
     model.questions        = [NSString stringWithFormat:@"%@",dic[@"Questions"]];
     model.classTypeName      = [NSString stringWithFormat:@"%@",dic[@"ClassTypeName"]];
     model.status           = [NSString stringWithFormat:@"%@",dic[@"Status"]];

     */
    NSDictionary *parameters = @{
                                 @"_appid":@"101",
                                 @"_code":self.userID_Code,
                                 @"content":@"application/json",
                                 
                                 @"ProjectId":      array[0], // 项目ID
                                 @"ProjectName":    array[1],// 项目名
                                 @"ApplyMan":       array[2],
                                 @"ApplyManName":   array[3], // 申请人
                                 @"Telephone":      array[4], // 电话
                                 @"NatureType":     array[5], // 投资种类
                                 @"ClassType":      array[6],  // 项目性质
                                 @"CategoryType":   array[7], // 项目分类
                                 @"CompanyType":    array[8], // 行业
                                 @"Questions":      array[9], // 存在问题
                                 @"ApprovalMan":    array[10],
                                 @"ApprovalManName": array[11], // 同意
                                 @"CreateTime":     array[12], // 创建时间
                                 @"CreateUserId":   array[13], //创建人用户ID
                                 @"Status":         array[14], // 审批状态
                                 @"ProcessId":      array[15] // 进度状态
                                 };
    NSString *url = [NSString stringWithFormat:@"%@project/home/projectsave",ServerAddressURL];
    [manger POST:url parameters:parameters success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject)
     {
         NSLog(@"保存上报项目：%@",responseObject[@"data"]);
         [LCProgressHUD showSuccess:@"申请上报成功"];
     } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
         NSLog(@"error : %@",error);
         [LCProgressHUD showFailure:@"上报数据失败"];
     }];
}
// 修改密码
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
// 重置用户密码
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

// 获取最新版本

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
// 添加系统反馈
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
// 获取常用联系人列表
- (void)userGetcontactsKeyword:(NSString *)keywork
{
    if (keywork.length == 0) {
        keywork = @"0";
    }
    AFHTTPRequestOperationManager *manger = [AFHTTPRequestOperationManager manager];
    manger.requestSerializer.timeoutInterval = 5;
    NSDictionary *parameters = @{
                                 @"_appid":@"101",
                                 @"_code":self.userID_Code,
                                 @"Keyword":keywork,
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
//            NSLog(@"%@ %@ %@ %@",dic[@"LinkManName"],dic[@"LinkPhone"],dic[@"LinkMobile"],dic[@"ZhiWuName"]);
             model.linkID = dic[@"UserId"];
             model.linkManName = dic[@"LinkManName"];
             model.linkPhone = dic[@"LinkPhone"];
             model.linkMobile = dic[@"LinkMobile"];
             model.zhiWuName = dic[@"ZhiWuName"];
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
// 群发
- (void)sendmessage
{
    AFHTTPRequestOperationManager *manger = [AFHTTPRequestOperationManager manager];
    manger.requestSerializer.timeoutInterval = 5;
    NSDictionary *parameters = @{
                                 @"_appid":@"101",
                                 @"_code":self.userID_Code,
                                 @"content":@"application/json",
                                 
                                 @"SendUsers": @[@"1",@"2",@"admin"],
                                 @"Id": @"14",
                                 @"UserFrom": @"14",
                                 @"UserTo": @"14",
                                 @"CreateTime": [self getDate],
                                 @"DataContent": @"xxxxx"
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
- (void)projectcheck
{
    AFHTTPRequestOperationManager *manger = [AFHTTPRequestOperationManager manager];
    manger.requestSerializer.timeoutInterval = 5;
    NSDictionary *parameters = @{
                                 @"_appid":@"101",
                                 @"_code":self.userID_Code,
                                 @"content":@"application/json",
                                 
                                 @"Id": @"1",
                                 @"ProjectId": @"2",
                                 @"ProcessId": @"3",
                                 @"ProcessName": @"ios",
                                 @"Number": @"5",
                                 @"StructureId": @"6",
                                 @"StructureName": @"swift",
                                 @"CheckStatus": @"14",
                                 @"CheckTime": [self getDate],
                                 @"CheckUserId": @"1",
                                 @"CheckUserName": @"cong",
                                 @"CheckCuauses": @"good"
                                 };
    NSString *url = [NSString stringWithFormat:@"%@project/home/projectcheck",ServerAddressURL];
    [manger POST:url parameters:parameters success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject)
     {
         NSLog(@"项目审查：%@",responseObject);
         [LCProgressHUD showSuccess:@"数据发送成功"];
     } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
         NSLog(@"error : %@",error);
         [LCProgressHUD showFailure:@"获取数据失败"];
     }];
}
- (void)projectfollow
{
    AFHTTPRequestOperationManager *manger = [AFHTTPRequestOperationManager manager];
    manger.requestSerializer.timeoutInterval = 5;
    NSDictionary *parameters = @{
                                 @"_appid":@"101",
                                 @"_code":self.userID_Code,
                                 @"content":@"application/json",
                                 
                                 @"Id": @"1",
                                 @"ProjectId": @"2",
                                 @"sType": @"3",
                                 @"Remark": @"ios test",
                                 @"CreateUserId": @"5",
                                 @"CreateUsesrName": @"ios",
                                 @"CreateTime": @"2016-04-25 09:51:28",
                                 @"FollowDate": @"2016-04-25 09:51:28"
                                 };
    NSString *url = [NSString stringWithFormat:@"%@project/home/projectfollow",ServerAddressURL];
    [manger POST:url parameters:parameters success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject)
     {
         NSLog(@"项目跟踪：%@",responseObject[@"data"]);
         
     } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
         NSLog(@"error : %@",error);
         [LCProgressHUD showFailure:@"获取数据失败"];
     }];
}
- (NSString *)getDate
{
    NSDate *currentDate = [NSDate date];//获取当前时间，日期
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY/MM/dd hh:mm"];
    NSString *dateString = [dateFormatter stringFromDate:currentDate];
    NSLog(@"dateString:%@",dateString);
    return dateString;
}
@end
