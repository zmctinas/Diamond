//
//  OrderUtil.m
//  Diamond
//
//  Created by Pan on 15/9/2.
//  Copyright (c) 2015年 Pan. All rights reserved.
//

#import "OrderUtil.h"
#import "Util.h"
@implementation OrderUtil

+ (NSString *)statusStringWithOwner:(OrderOwner)orderOwner status:(OrderStatus)status
{
    if (orderOwner == OrderOwnerBuyer)
    {
        switch (status)
        {
            case OrderStatusWaitCommit:
                return @"";
            case OrderStatusUnpay:
                return @"未付款";
            case OrderStatusPaied:
                return @"交易中";
            case OrderStatusSellerConformed:
                return @"已发货";
            case OrderStatusBuyerConformed:
                return @"交易完成";
            case OrderStatusCancel:
                return @"已取消";
        }
    }
    else if (orderOwner == OrderOwnerSeller)
    {
        switch (status)
        {
            case OrderStatusWaitCommit:
                return @"";
            case OrderStatusUnpay:
                return @"未收款";
            case OrderStatusPaied:
                return @"交易中";
            case OrderStatusSellerConformed:
                return @"待收货";
            case OrderStatusBuyerConformed:
                return @"交易完成";
            case OrderStatusCancel:
                return @"已取消";
        }
    }
    return @"";
}

+ (NSString *)checkBarButtonTitleWithOwner:(OrderOwner)owner status:(OrderStatus)status;
{
    if (owner == OrderOwnerBuyer)
    {
        switch (status)
        {
            case OrderStatusWaitCommit:
                return @"提交订单";
            case OrderStatusUnpay:
                return @"结算";
            case OrderStatusPaied:
                return @"等待发货";
            case OrderStatusSellerConformed:
                return @"确认收货";
            case OrderStatusBuyerConformed:
                return @"交易完成";
            case OrderStatusCancel:
                return @"已关闭";
        }
    }
    else if (owner == OrderOwnerSeller)
    {
        switch (status)
        {
            case OrderStatusWaitCommit:
                return nil;//业务上不会有这样的情况
            case OrderStatusUnpay:
                return @"等待买家付款";
            case OrderStatusPaied:
                return @"确认发货";
            case OrderStatusSellerConformed:
                return @"待收货";
            case OrderStatusBuyerConformed:
                return @"交易完成";
            case OrderStatusCancel:
                return @"已关闭";
            default:
                break;
        }
    }
    return @"";
}




+ (NSString *)timeStringWithOrderTime:(NSString *)time
{
    //TODO:将时间戳转化成设计图格式
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[time doubleValue]];
    NSString *dateString = [Util stringFormDate:date WithFormater:@"YYYY.MM.dd hh:mm"];
    
    return dateString;
}

@end
