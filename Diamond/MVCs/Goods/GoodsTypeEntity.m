//
//  GoodsTypeEntity.m
//  Diamond
//
//  Created by Leon Hu on 15/8/27.
//  Copyright (c) 2015年 Pan. All rights reserved.
//

#import "GoodsTypeEntity.h"

@implementation GoodsTypeEntity

+ (NSDictionary *)replacedKeyFromPropertyName
{
    return @{
             @"typeId":@"id",
             @"typeName":@"type",
             @"stock":@"number"
             };
}

+ (BOOL)isReferenceReplacedKeyWhenCreatingKeyValues
{
    return YES;
}

@end
