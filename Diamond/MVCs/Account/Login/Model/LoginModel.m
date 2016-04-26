//
//  LoginModel.m
//  Diamond
//
//  Created by Pan on 15/7/13.
//  Copyright (c) 2015年 Pan. All rights reserved.
//

#import "LoginModel.h"
#import "WebService+Account.h"
#import "Util.h"
#import "UserInfo.h"
#import "ValidationManager.h"
#import "AppDelegate.h"
@interface LoginModel()

@end

@implementation LoginModel


- (void)registerEaseMobAccountWithUsername:(NSString *)username password:(NSString *)password
{
    //异步注册账号
    [[EaseMob sharedInstance].chatManager asyncRegisterNewAccount:username
                                                         password:password
                                                   withCompletion:
     ^(NSString *username, NSString *password, EMError *error)
     {
         NSString *message;
         
         if (!error)
         {
             message = @"注册成功,请登录";
         }
         else
         {
             switch (error.errorCode)
             {
                 case EMErrorServerNotReachable:
                     message = @"Connect to the server failed!";
                     break;
                 case EMErrorServerDuplicatedAccount:
                     message = @"You registered user already exists!";
                     break;
                 case EMErrorNetworkNotConnected:
                     message = @"No network connection!";
                     break;
                 case EMErrorServerTimeout:
                     message = @"Connect to the server timed out!";
                     break;
                 default:
                     message = @"Registration failed";
                     break;
             }
         }
         
         [[NSNotificationCenter defaultCenter] postNotificationName:emRegisterNotification object:message];
         
     } onQueue:nil];
}

- (void)loginEaseMobWithUsername:(NSString *)username password:(NSString *)password
{
//    BOOL isAutoLogin = [[[EaseMob sharedInstance] chatManager] isAutoLoginEnabled];
//    
//    if (isAutoLogin)
//    {
//        return;
//    }
    //异步登陆账号
    [[EaseMob sharedInstance].chatManager asyncLoginWithUsername:username
                                                        password:password
                                                      completion:
     ^(NSDictionary *loginInfo, EMError *error)
     {
         NSString *message = nil;
         if (loginInfo && !error)
         {
             //设置是否自动登录
             [[EaseMob sharedInstance].chatManager setIsAutoLoginEnabled:YES];
             
             //将2.1.0版本旧版的coredata数据导入新的数据库
             EMError *error = [[EaseMob sharedInstance].chatManager importDataToNewDatabase];
             if (!error) {
                 error = [[EaseMob sharedInstance].chatManager loadDataFromDatabase];
             }
             
             //发送自动登陆状态通知
             //             [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@YES];
         }
         else
         {
             switch (error.errorCode)
             {
                 case EMErrorNotFound:
                     message = (error.description);
                     break;
                 case EMErrorNetworkNotConnected:
                     message = @"网络没有连接!";
                     break;
                 case EMErrorServerNotReachable:
                     message = @"连接服务器失败!";
                     break;
                 case EMErrorServerAuthenticationFailure:
                     message = error.description;
                     break;
                 case EMErrorServerTimeout:
                     message = @"连接超时";
                     break;
                 default:
                     message = @"登录失败";
                     break;
             }
             [[NSNotificationCenter defaultCenter] postNotificationName:WebServiceErrorNotification object:message];
         }
     } onQueue:nil];
}

- (void)login:(NSString *)username password:(NSString *)password
{
    NSString *passwordencryption = [Util md5:password];
    [self.webService login:username password:passwordencryption completion:^(BOOL isSuccess, NSString *message, id result)
     {
         if (isSuccess && message.length<1)
         {
             [self handleLoginSuccess:result];
             [[NSNotificationCenter defaultCenter] postNotificationName:LOGIN_NOTIFICATION object:result];
         }
         else
         {
             [[NSNotificationCenter defaultCenter] postNotificationName:WebServiceErrorNotification object:message];
         }
     }];
}

- (void)loginByWeixin:(NSString *)code
{
    [self.webService loginByWeixin:code completion:^(BOOL isSuccess, NSString *message, id result)
     {
         if (isSuccess && message.length<1)
         {
             [self handleLoginSuccess:result];
             [[NSNotificationCenter defaultCenter] postNotificationName:WCHAT_LOGIN object:result];
         }
         else
         {
             [[NSNotificationCenter defaultCenter] postNotificationName:WebServiceErrorNotification object:message];
         }
     }];
    
}

- (void)loginByQQ:(NSString *)code
            photo:(NSString *)photo
         username:(NSString *)username
              sex:(Sex)sex;
{
    [self.webService loginByQQ:code
                         photo:(NSString *)photo
                      username:(NSString *)username
                           sex:(Sex)sex
                    completion:^(BOOL isSuccess, NSString *message, id result)
     {
         if (isSuccess && message.length<1)
         {
             [self handleLoginSuccess:result];
             [[NSNotificationCenter defaultCenter] postNotificationName:QQ_LOGIN object:result];
         }
         else
         {
             [[NSNotificationCenter defaultCenter] postNotificationName:WebServiceErrorNotification object:message];
         }
     }];
}

- (void)handleLoginSuccess:(id)result
{
    UserEntity *user = result;
    [UserInfo info].currentUser = user;//持久化用户
    //为Jpush注册别名
     AppDelegate *appdelegete = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [appdelegete registerJpushAlias];
    [ValidationManager setLoginStatus:YES];
}

@end
