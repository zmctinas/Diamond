//
//  ReceiveGoodsAddressEntity.m
//  Diamond
//
//  Created by Leon Hu on 15/8/31.
//  Copyright (c) 2015年 Pan. All rights reserved.
//

#import "ReceiveGoodsAddressEntity.h"
#import "MJExtension.h"

@implementation ReceiveGoodsAddressEntity


- (NSString *)fullAddress
{
    return [NSString stringWithFormat:@"%@%@%@%@",_province,_city,_district,_address];
}

+ (NSDictionary *)replacedKeyFromPropertyName
{
    return @{
             @"addressId":@"id",
             @"easemob":@"easemob",
             @"phoneNumber":@"phoneNumber",
             @"province":@"province",
             @"city":@"city",
             @"district":@"district",
             @"address":@"address",
             @"linkman":@"linkman",
             @"status":@"status"
             };
}

+ (BOOL)isReferenceReplacedKeyWhenCreatingKeyValues
{
    return YES;
}

@end
