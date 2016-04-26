//
//  OrderSubmitEntity.m
//  Diamond
//
//  Created by Pan on 15/9/10.
//  Copyright (c) 2015年 Pan. All rights reserved.
//

#import "OrderSubmitEntity.h"
#import "OrderDetailEntity.h"
@implementation OrderSubmitEntity

+ (NSDictionary *)objectClassInArray
{
    return @{@"list" : NSStringFromClass([OrderWare class])};
}
@end
