//
//  WebService+Account.h
//  DrivingOrder
//
//  Created by Pan on 15/5/21.
//  Copyright (c) 2015年 Pan. All rights reserved.
//

#import "WebService.h"
#import "VCodeModel.h"
#import "RegisterModel.h"

@interface WebService (Account)
/**
 *  获取切换城市的城市列表
 *
 *  @param completion nil
 */
- (void)cityList:(DMCompletionBlock)completion;

- (void)addShopWithImage:(NSString *)image completion:(DMCompletionBlock)completion;

/**
 *  请求验证码
 *
 *  @param phoneNumber 手机号
 *  @param forget      forget值为1时为忘记密码时请求验证码，0为用户注册
 *  @param completion  .
 */
- (void)getVerificationCode:(VCodeEntity *)entity
                 completion:(DMCompletionBlock)completion;

/**
 *  用户注册
 *
 *  @param phone        手机号
 *  @param nick         用户名
 *  @param password     密码
 *  @param image        头像
 */
- (void)userRegister:(NSString *)phone
            nickName:(NSString *)nick
            password:(NSString *)password
               image:(UIImage *)image
          completion:(DMCompletionBlock)completion;

/**
 *  用户登录
 *
 *  @param userName   用户名
 *  @param password   密码
 *  @param completion 回调
 */
- (void)login:(NSString *)userName password:(NSString *)password completion:(DMCompletionBlock)completion;

/**
 *  请求服务端发送短信给目标手机号
 *
 *  @param mobile     目标手机号
 *  @param forget     0:注册 1:忘记密码
 *  @param completion 回调
 */
- (void)sendTo:(NSString *)mobile forget:(NSInteger)forget completion:(DMCompletionBlock)completion;

/**
 *  更改为新密码
 *
 *  @param newPassword 新密码
 *  @param phone       手机号
 */
- (void)changePassword:(NSString *)newPassword phone:(NSString *)phone completion:(DMCompletionBlock)completion;

- (void)loginByWeixin:(NSString *)code completion:(DMCompletionBlock)completion;

- (void)loginByQQ:(NSString *)code
            photo:(NSString *)photo
         username:(NSString *)username
              sex:(Sex)sex
       completion:(DMCompletionBlock)completion;
@end