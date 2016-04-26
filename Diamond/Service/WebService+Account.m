//
//  WebService+Account.m
//  DrivingOrder
//
//  Created by Pan on 15/5/21.
//  Copyright (c) 2015年 Pan. All rights reserved.
//
#import "WebService+Account.h"
#import "ValidationManager.h"
#import "VCodeModel.h"
#import "VCodeEntity.h"
#import "UserEntity.h"
#import "Util.h"

@implementation WebService (Account)

- (void)cityList:(DMCompletionBlock)completion
{
    [self postWithMethodName:GET_CITY_LIST data:nil success:^(id JSON) {
        if ([JSON isKindOfClass:[NSDictionary class]])
        {
            int status = [[JSON objectForKey:STATUS] intValue];
            if (status == ResponseStatusSuccess)
            {
                NSDictionary *objDict = [JSON objectForKey:DATA];
                if (![objDict isEqual:[NSNull null]])
                {
                    completion(YES,nil,objDict);
                }
            }
            else if (status == ResponseStatusFailed)
            {
                NSDictionary *objDict = [JSON objectForKey:DATA];
                NSString *message = SERVER_ERROE_MESSAGE;
                if (![objDict isEqual:[NSNull null]])
                {
                    message = [objDict objectForKey:RESULT_MESSAGE];
                }
                completion(YES,message,nil);
            }
        }
    } failure:^(NSError *error, id JSON) {
        completion(NO,[error.userInfo objectForKey:NSLocalizedFailureReasonErrorKey],nil);
    }];
}

- (void)addShopWithImage:(NSString *)image completion:(DMCompletionBlock)completion
{
    
}

/**
 *  请求验证码
 *
 *  @param phoneNumber 手机号
 *  @param forget      forget值为1时为忘记密码时请求验证码，0为用户注册
 *  @param completion  .
 */
- (void)getVerificationCode:(VCodeEntity *)entity
                 completion:(DMCompletionBlock)completion
{
    NSDictionary *postData = entity.keyValues;
    
    [self postWithMethodName:VERIFICATION_CODE data:postData success:^(id JSON) {
        if ([JSON isKindOfClass:[NSDictionary class]])
        {
            int status = [[JSON objectForKey:STATUS] intValue];
            if (status == ResponseStatusSuccess)
            {
                NSDictionary *objDict = [JSON objectForKey:DATA];
                if (![objDict isEqual:[NSNull null]])
                {
                    completion(YES,nil,objDict);
                }
            }
            else if (status == ResponseStatusFailed)
            {
                NSDictionary *objDict = [JSON objectForKey:DATA];
                NSString *message = SERVER_ERROE_MESSAGE;
                if (![objDict isEqual:[NSNull null]])
                {
                    message = [objDict objectForKey:RESULT_MESSAGE];
                }
                completion(YES,message,nil);
            }
        }
    } failure:^(NSError *error, id JSON) {
        completion(NO,[error.userInfo objectForKey:NSLocalizedFailureReasonErrorKey],nil);
    }];

}

/**
 *  用户注册
 *
 *  @param userName    用户名
 *  @param password    密码
 *  @param phoneNumber 手机号
 *  @param sex         性别
 */
- (void) userRegister:(NSString *)phone
             nickName:(NSString *)nick
             password:(NSString *)password
                image:(UIImage *)image
           completion:(DMCompletionBlock)completion
{
    NSString *passwordEny = [Util md5:password];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: @"yyyy-MM-dd"];
    NSString *registerDate = [dateFormatter stringFromDate:[NSDate date]];
    NSMutableDictionary *dataDic = [[NSMutableDictionary alloc] init];
    [dataDic setValue:nick forKey:@"user_name"];
    [dataDic setValue:passwordEny forKey:@"password"];
    [dataDic setValue:phone forKey:@"phoneNumber"];
    [dataDic setValue:@0 forKey:@"sex"];
    [dataDic setValue:registerDate forKey:@"registerDate"];
    [dataDic setValue:@"a3116c14e09424ba954e83a0cf179cfd" forKey:@"clientId"];
    [dataDic setValue:@4 forKey:@"device_type"];
    [dataDic setValue:[PSLocationManager sharedInstance].province forKey:@"province"];
    [dataDic setValue:[PSLocationManager sharedInstance].city forKey:@"city"];
    if (image) {
        NSString *imageBase64 = [Util base64StringWithImage:image];
        NSMutableDictionary *imageDic = [[NSMutableDictionary alloc] init];
        [imageDic setValue:imageBase64 forKey:@"image"];
        [imageDic setValue:@"png" forKey:@"imageExt"];
        NSMutableArray * array = [[NSMutableArray alloc] init];
        [array addObject:imageDic];
        
        [dataDic setValue:array forKey:@"images"];
    }
    
    
//    NSDictionary *dataDic = @{
//                              @"user_name": nick,
//                              @"password": passwordEny,
//                              @"phoneNumber": phone,
//                              @"sex": @0,
//                              @"registerDate": registerDate,
//                              @"clientId": @"a3116c14e09424ba954e83a0cf179cfd",
//                              @"device_type": @4
//                              };

    
    [self postWithMethodName:USER_REGISTER data:dataDic success:^(id JSON) {
        if ([JSON isKindOfClass:[NSDictionary class]])
        {
            int status = [[JSON objectForKey:STATUS] intValue];
            if (status == ResponseStatusSuccess)
            {
                NSDictionary *objDict = [JSON objectForKey:DATA];
                if (![objDict isEqual:[NSNull null]])
                {
                    [RegisterEntity map];
                    RegisterEntity *entity = [RegisterEntity objectWithKeyValues:objDict];
                    completion(YES,nil,entity);
                }
            }
            else if (status == ResponseStatusFailed)
            {
                NSDictionary *objDict = [JSON objectForKey:DATA];
                NSString *message = SERVER_ERROE_MESSAGE;
                if (![objDict isEqual:[NSNull null]])
                {
                    message = [objDict objectForKey:RESULT_MESSAGE];
                }
                completion(YES,message,nil);            }
        }
    } failure:^(NSError *error, id JSON) {
        completion(NO,[error.userInfo objectForKey:NSLocalizedFailureReasonErrorKey],nil);
    }];

}

- (void)login:(NSString *)userName password:(NSString *)password completion:(DMCompletionBlock)completion
{
    NSDictionary *postData = @{@"phoneNumber":userName, @"password":password};
    
    [self postWithMethodName:USER_LOGIN data:postData success:^(id JSON) {
        if ([JSON isKindOfClass:[NSDictionary class]])
        {
            int status = [[JSON objectForKey:STATUS] intValue];
            NSDictionary *dataDic = [JSON objectForKey:DATA];
            
            if (status == ResponseStatusSuccess)
            {
                if (![dataDic isEqual:[NSNull null]])
                {
                    UserEntity *entity = [UserEntity objectWithKeyValues:dataDic];
                    completion(YES,nil,entity);
                }
            }
            else if (status == ResponseStatusFailed)
            {
                NSString *message = SERVER_ERROE_MESSAGE;
                if (![dataDic isEqual:[NSNull null]])
                {
                    message = [dataDic objectForKey:RESULT_MESSAGE];
                }
                completion(YES,message,nil);
            }
        }
    } failure:^(NSError *error, id JSON) {
        completion(NO,[error.userInfo objectForKey:NSLocalizedFailureReasonErrorKey],nil);
    }];
}

- (void)sendTo:(NSString *)mobile forget:(NSInteger)forget completion:(DMCompletionBlock)completion
{
    NSDictionary *postData = @{@"phoneNumber":mobile, @"forget":@(forget)};
    
    [self postWithMethodName:VERIFICATION_CODE data:postData success:^(id JSON) {
        if ([JSON isKindOfClass:[NSDictionary class]])
        {
            int status = [[JSON objectForKey:STATUS] intValue];
            if (status == ResponseStatusSuccess)
            {
                id jsonData = [JSON objectForKey:DATA];
                VCodeEntity *entity = [VCodeEntity objectWithKeyValues:jsonData];
                completion(YES,nil,entity);
            }
            else if (status == ResponseStatusFailed)
            {
                NSString *msg = [[JSON objectForKey:DATA] objectForKey:RESULT_MESSAGE];
                completion(YES,msg,nil);
            }
        }
    } failure:^(NSError *error, id JSON) {
        completion(NO,[error.userInfo objectForKey:NSLocalizedFailureReasonErrorKey],nil);
    }];

}

- (void)changePassword:(NSString *)newPassword phone:(NSString *)phone completion:(DMCompletionBlock)completion
{
    NSDictionary *postData = @{@"phoneNumber":phone, @"password":newPassword};
    
    [self postWithMethodName:PASSWORD_UPDATE data:postData success:^(id JSON) {
        if ([JSON isKindOfClass:[NSDictionary class]])
        {
            int status = [[JSON objectForKey:STATUS] intValue];
            if (status == ResponseStatusSuccess)
            {
                NSString *msg = [[JSON objectForKey:DATA] objectForKey:RESULT_MESSAGE];
                completion(YES,nil,msg);
            }
            else if (status == ResponseStatusFailed)
            {
                NSString *msg = [[JSON objectForKey:DATA] objectForKey:RESULT_MESSAGE];
                completion(YES,msg,nil);
            }
        }
    } failure:^(NSError *error, id JSON) {
        completion(NO,[error.userInfo objectForKey:NSLocalizedFailureReasonErrorKey],nil);
    }];
}

- (void)loginByWeixin:(NSString *)code completion:(DMCompletionBlock)completion
{
    NSDictionary *postData = @{@"code":code};
    
    [self postWithMethodName:WCHAT_LOGIN data:postData success:^(id JSON) {
        if ([JSON isKindOfClass:[NSDictionary class]])
        {
            int status = [[JSON objectForKey:STATUS] intValue];
            if (status == ResponseStatusSuccess)
            {
                UserEntity *entity = [UserEntity objectWithKeyValues: [JSON objectForKey:DATA]];
                completion(YES,nil,entity);
            }
            else if (status == ResponseStatusFailed)
            {
                NSString *msg = [[JSON objectForKey:DATA] objectForKey:RESULT_MESSAGE];
                completion(YES,msg,nil);
            }
        }
    } failure:^(NSError *error, id JSON) {
        completion(NO,[error.userInfo objectForKey:NSLocalizedFailureReasonErrorKey],nil);
    }];
}

- (void)loginByQQ:(NSString *)code
            photo:(NSString *)photo
         username:(NSString *)username
              sex:(Sex)sex
       completion:(DMCompletionBlock)completion
{
    NSDictionary *parameter = [NSDictionary dictionaryWithObjectsAndKeys:
                               code,@"qqAccount",
                               photo,@"photo",
                               username,@"user_name",
                               @(sex),@"sex",
                               nil];
    
    [self postWithMethodName:QQ_LOGIN data:parameter success:^(id JSON) {
        if ([JSON isKindOfClass:[NSDictionary class]])
        {
            int status = [[JSON objectForKey:STATUS] intValue];
            if (status == ResponseStatusSuccess)
            {
                UserEntity *entity = [UserEntity objectWithKeyValues: [JSON objectForKey:DATA]];
                completion(YES,nil,entity);
            }
            else if (status == ResponseStatusFailed)
            {
                NSString *msg = [[JSON objectForKey:DATA] objectForKey:RESULT_MESSAGE];
                completion(YES,msg,nil);
            }
        }
    } failure:^(NSError *error, id JSON) {
        completion(NO,[error.userInfo objectForKey:NSLocalizedFailureReasonErrorKey],nil);
    }];
}

@end
