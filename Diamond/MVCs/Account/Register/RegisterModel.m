//
//  RegisterModel.m
//  Diamond
//
//  Created by Leon Hu on 15/7/14.
//  Copyright (c) 2015年 Pan. All rights reserved.
//

#import "RegisterModel.h"
#import "RegisterEntity.h"
#import "WebService+Account.h"

@interface RegisterModel()

@property (nonatomic, strong) WebService *webservice;

@end

@implementation RegisterModel

- (void)registerByMobile:(NSString *)phone
                nickName:(NSString *)nick
                password:(NSString *)password
                   image:(UIImage *)image
{
    [self.webService userRegister:phone
                         nickName:nick
                         password:password
                            image:image
                       completion:^(BOOL isSuccess, NSString *message, id result)
     {
         if (isSuccess && message.length<1)
         {
             [[NSNotificationCenter defaultCenter] postNotificationName:REGISTER_NOTIFICATION object:result];
         }
         else
         {
             [[NSNotificationCenter defaultCenter] postNotificationName:WebServiceErrorNotification object:message];
         }
     }];
}

-(WebService *) webservice
{
    if (!_webservice) {
        _webservice = [WebService service];
    }
    return _webservice;
}

@end
