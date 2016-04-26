//
//  AddGoodsEntity.m
//  Diamond
//
//  Created by Leon Hu on 15/8/9.
//  Copyright (c) 2015年 Pan. All rights reserved.
//

#import "AddGoodsEntity.h"
#import "ImageEntity.h"
#import "GoodsTypeEntity.h"

@implementation AddGoodsEntity

+ (NSDictionary *)objectClassInArray
{
    return @{
             @"images":[ImageEntity class],
             @"list":[GoodsTypeEntity class]
             };
}

@end
