//
//  withDralEntity.m
//  Diamond
//
//  Created by daimangkeji on 16/4/26.
//  Copyright © 2016年 Pan. All rights reserved.
//

#import "withDralEntity.h"

@implementation withDralEntity

-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}

#pragma mark - getter

-(NSString*)money
{
    return [NSString stringWithFormat:@"%@元",self.cash];
}

-(NSString*)headLine
{
    return [NSString stringWithFormat:@"提现单号：%@",self.take_cash_no];
}

-(NSString*)state
{
    if ([self.type isEqualToString:@"ali_pay"]) {
        return @"提现到支付宝";
    }else
    {
        return @"提现到微信";
    }
}

-(NSString*)messages
{
    return [NSString stringWithFormat:@"%@ %@",self.date,[self state]];
}

-(NSString*)condition
{
    NSString* message ;
    switch (self.status.integerValue) {
        case 0:
        {
            message = @"正在审核";
        }
            break;
        case 1:
        {
            message = @"正在操作";
        }
            break;
        case 2:
        {
            message = @"已完成";
        }
            break;
        case 3:
        {
            message = @"操作失败";
        }
            break;
            
        default:
            break;
    }
    return [NSString stringWithFormat:@"%@",message];
}

@end
