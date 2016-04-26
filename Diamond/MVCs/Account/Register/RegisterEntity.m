//
//  RegisterEntity.m
//  Diamond
//
//  Created by Leon Hu on 15/7/14.
//  Copyright (c) 2015年 Pan. All rights reserved.
//

#import "RegisterEntity.h"
#import "MJExtension.h"

@implementation RegisterEntity

+ (void)map
{
    [RegisterEntity setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{
                 @"userId":@"user_id",
                 @"userName":@"user_name",
                 @"phoneNumber":@"phoneNumber",
                 @"isSeller":@"is_seller",
                 @"shopId":@"shop_id",
                 @"latitude":@"latitude",
                 @"longtitude":@"longtitude",
                 @"password":@"password",
                 @"registerDate":@"registerDate",
                 @"easemob":@"easemob",
                 @"photo":@"photo",
                 @"lastlogin":@"lastlogin",
                 @"clientId":@"clientId",
                 @"deviceToken":@"deviceToken",
                 @"deviceType":@"device_type",
                 @"sex":@"sex",
                 @"cityCode":@"cityCode",
                 @"signature":@"signature",
                 @"userType":@"user_type"
                 };
    }];
}

@end
