//
//  WaresEntity.m
//  Diamond
//
//  Created by Pan on 15/7/27.
//  Copyright (c) 2015年 Pan. All rights reserved.
//

#import "WaresEntity.h"
#import "GoodsTypeEntity.h"

@implementation WaresEntity

+ (NSDictionary *)objectClassInArray
{
    return @{
             @"type":[GoodsTypeEntity class]
             };
}

@end
