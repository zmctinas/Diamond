//
//  UpLicenseEntity.m
//  Diamond
//
//  Created by Leon Hu on 15/8/11.
//  Copyright (c) 2015年 Pan. All rights reserved.
//

#import "UpLicenseEntity.h"
#import "ImageEntity.h"

@implementation UpLicenseEntity

+ (NSDictionary *)objectClassInArray
{
    return @{
             @"images":[ImageEntity class]
             };
}

@end