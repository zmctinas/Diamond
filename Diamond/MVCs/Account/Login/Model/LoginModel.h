//
//  LoginModel.h
//  Diamond
//
//  Created by Pan on 15/7/13.
//  Copyright (c) 2015年 Pan. All rights reserved.
//

#import "BaseModel.h"

@interface LoginModel : BaseModel

/**
 *  注册环信账号
 *
 *  @param username 用户名
 *  @param password 密码
 */
- (void)registerEaseMobAccountWithUsername:(NSString *)username password:(NSString *)password;

/**
 *  登陆环信账号
 *
 *  @param username 用户名
 *  @param password 密码
 */
- (void)loginEaseMobWithUsername:(NSString *)username password:(NSString *)password;

/**
 *  登录
 *
 *  @param username 用户名
 *  @param password 密码
 */
- (void) login:(NSString *)username password:(NSString *)password;

- (void)loginByWeixin:(NSString *)code;

- (void)loginByQQ:(NSString *)code
            photo:(NSString *)photo
         username:(NSString *)username
              sex:(Sex)sex;
@end
