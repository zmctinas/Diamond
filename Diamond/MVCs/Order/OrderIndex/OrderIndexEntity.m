//
//  OrderIndexEntity.m
//  Diamond
//
//  Created by Pan on 15/9/15.
//  Copyright (c) 2015年 Pan. All rights reserved.
//

#import "OrderIndexEntity.h"

@implementation OrderIndexEntity


- (NSString *)paiedString
{
    return [NSString stringWithFormat:@"总支出%.2f元",[self.buyer_count_fee doubleValue]];
}

- (NSString *)earningString
{
    return [NSString stringWithFormat:@"总收入%.2f元",[self.seller_count_fee doubleValue]];
}

- (NSString *)buyedCountString
{
    return [NSString stringWithFormat:@"共买到%ld件商品",(long)[self.buyer_count_no integerValue]];
}

- (NSString *)selledCountString
{
    return [NSString stringWithFormat:@"共卖出%ld件商品",(long)[self.seller_count_no integerValue]];
}

-(NSString *)availableMoneyString
{
    return [NSString stringWithFormat:@"可提现金额%.2f元",self.balance.floatValue];
}


@end
