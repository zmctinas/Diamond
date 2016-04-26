//
//  UpdateGoodsEntity.m
//  Diamond
//
//  Created by Leon Hu on 15/8/18.
//  Copyright (c) 2015年 Pan. All rights reserved.
//

#import "UpdateGoodsEntity.h"
#import "ImageEntity.h"
#import "GoodsTypeEntity.h"

@implementation UpdateGoodsEntity

+ (NSDictionary *)objectClassInArray
{
    return @{
             @"images":[ImageEntity class],
             @"list":[GoodsTypeEntity class]
             };
}

@end
