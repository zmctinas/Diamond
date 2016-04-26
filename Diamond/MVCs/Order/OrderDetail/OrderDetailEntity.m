//
//  OrderDetailEntity.m
//  Diamond
//
//  Created by Pan on 15/9/1.
//  Copyright (c) 2015年 Pan. All rights reserved.
//

#import "OrderDetailEntity.h"
#import "OrderUtil.h"

@implementation OrderDetailEntity



- (NSString *)formattedTime
{
    return [OrderUtil timeStringWithOrderTime:_add_time];
}

- (NSString *)deliveryTypeString
{
    switch (self.delivery_type)
    {
        case DeliveryTypeBuyer:
            return @"自行提取";
        case DeliveryTypeSeller:
            return @"卖家配送";
    }
}
@end
