//
//  RePasswordByPhoneModel.m
//  Diamond
//
//  Created by Leon Hu on 15/7/22.
//  Copyright (c) 2015年 Pan. All rights reserved.
//

#import "RePasswordByPhoneModel.h"
#import "WebService+Account.h"

@implementation RePasswordByPhoneModel

- (void)changePassword:(NSString *)newPassword phone:(NSString *)phone
{
    NSString *passwordencryption = [Util md5:newPassword];
    [self.webService changePassword:passwordencryption phone:phone completion:^(BOOL isSuccess, NSString *message, id result)
     {
         if (isSuccess && message.length<1)
         {
             [[NSNotificationCenter defaultCenter] postNotificationName:CHANGE_PASSWORD_NOTIFICATION object:result];
         }
         else
         {
             [[NSNotificationCenter defaultCenter] postNotificationName:WebServiceErrorNotification object:message];
         }
     }];

}

@end
