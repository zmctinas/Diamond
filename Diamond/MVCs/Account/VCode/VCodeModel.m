//
//  VCodeModel.m
//  Diamond
//
//  Created by Leon Hu on 15/7/14.
//  Copyright (c) 2015年 Pan. All rights reserved.
//

#import "VCodeModel.h"
#import "VCodeEntity.h"
#import "WebService+Account.h"

@interface VCodeModel()

@end

@implementation VCodeModel

- (void)sendTo:(NSString *)mobile forget:(NSInteger)forget
{
    [self.webService sendTo:mobile forget:forget completion:^(BOOL isSuccess, NSString *message, id result)
     {
         if (isSuccess && message.length<1)
         {
             [[NSNotificationCenter defaultCenter] postNotificationName:SEND_CODE_NOTIFICATION object:result];
         }
         else
         {
             [[NSNotificationCenter defaultCenter] postNotificationName:WebServiceErrorNotification object:message];
         }
     }];
}

@end
