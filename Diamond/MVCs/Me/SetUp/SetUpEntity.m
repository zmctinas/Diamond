//
//  SetUpEntity.m
//  Diamond
//
//  Created by Leon Hu on 15/8/14.
//  Copyright (c) 2015年 Pan. All rights reserved.
//

#import "SetUpEntity.h"
#import "ImageEntity.h"

@implementation SetUpEntity

+ (NSDictionary *)objectClassInArray
{
    return @{
             @"images":[ImageEntity class]
             };
}

@end
