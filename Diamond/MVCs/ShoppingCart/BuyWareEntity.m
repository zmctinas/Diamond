//
//  BuyWareEntity.m
//  Diamond
//
//  Created by Leon Hu on 15/9/1.
//  Copyright (c) 2015年 Pan. All rights reserved.
//

#import "BuyWareEntity.h"

@implementation BuyWareEntity

+ (NSDictionary *)replacedKeyFromPropertyName
{
    return @{@"buyWaresId":@"id"};
}

+ (BOOL)isReferenceReplacedKeyWhenCreatingKeyValues
{
    return YES;
}

- (CGFloat)accountPrice
{
    CGFloat discount = [_discount doubleValue];
    CGFloat price = [_price doubleValue];
    return _is_promotion ? (price * discount) : price;
}
@end
