//
//  OrderDetailModel.m
//  Diamond
//
//  Created by Pan on 15/9/3.
//  Copyright (c) 2015年 Pan. All rights reserved.
//

#import "OrderDetailModel.h"
#import "WebService+Order.h"
#import "OrderSubmitEntity.h"
#import "EditPriceRespone.h"
@implementation OrderDetailModel

- (void)giveMeOrderDetail
{
    [self.webService fetchOrderDetail:self.orderDetail.out_trade_no completion:^(BOOL isSuccess, NSString *message, id result)
    {
        if (isSuccess && !message)
        {
            self.orderDetail = result;
            [[NSNotificationCenter defaultCenter] postNotificationName:GET_ORDER_DETAIL object:result];
        }
        else
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:WebServiceErrorNotification object:message];
        }

    }];
}

- (void)submitOrderWithCartList:(NSArray *)cartList;
{
    OrderSubmitEntity *entity = [OrderSubmitEntity objectWithKeyValues:self.orderDetail.keyValues];
    for (OrderWare *ware in entity.list)
    {
        ware.nowprice = nil;
    }
    [self.webService commitOrder:entity cartList:cartList completion:^(BOOL isSuccess, NSString *message, id result) {
        if (isSuccess && !message)
        {
            self.orderDetail = result;
            [[NSNotificationCenter defaultCenter] postNotificationName:ORDER_SUBMITE object:nil];
        }
        else
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:WebServiceErrorNotification object:message];
        }
    }];
}


- (void)conformWareGetted
{
    [self.webService conformGetted:self.orderDetail.out_trade_no completion:^(BOOL isSuccess, NSString *message, id result) {
        if (isSuccess && !message)
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:CONFORM_ORDER object:self.orderDetail.out_trade_no];
        }
        else
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:WebServiceErrorNotification object:message];
        }

    }];
}

- (void)conformWareSended
{
    [self.webService conformSendded:self.orderDetail.out_trade_no completion:^(BOOL isSuccess, NSString *message, id result) {
        if (isSuccess && !message)
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:CONFORM_SEND object:self.orderDetail.out_trade_no];
        }
        else
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:WebServiceErrorNotification object:message];
        }

    }];
}

- (void)cancleOrder
{
    [self.webService cancleOrder:self.orderDetail.out_trade_no completion:^(BOOL isSuccess, NSString *message, id result) {
        if (isSuccess && !message)
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:CLOSE_ORDER object:self.orderDetail.out_trade_no];
        }
        else
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:WebServiceErrorNotification object:message];
        }
    }];
}

- (void)editPostage:(NSNumber *)price;
{
    [self.webService editPostage:price order:self.orderDetail.out_trade_no completion:^(BOOL isSuccess, NSString *message, id result) {
        if (isSuccess && !message)
        {
            EditPriceRespone *response = result;
            self.orderDetail.old_total_fee = response.old_total_fee;
            self.orderDetail.total_fee = response.total_fee;
            self.orderDetail.delivery_fee = response.delivery_fee;
            [[NSNotificationCenter defaultCenter] postNotificationName:EDIT_POSTAGE_NOTIFICATION object:self.orderDetail];
        }
        else
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:WebServiceErrorNotification object:message];
        }
    }];
}

- (void)editTotleFee:(NSNumber *)price;
{
    [self.webService editTotleFee:price order:self.orderDetail.out_trade_no completion:^(BOOL isSuccess, NSString *message, id result) {
        if (isSuccess && !message)
        {
            EditPriceRespone *response = result;
            self.orderDetail.old_total_fee = response.old_total_fee;
            self.orderDetail.total_fee = response.total_fee;
            self.orderDetail.delivery_fee = response.delivery_fee;
            [[NSNotificationCenter defaultCenter] postNotificationName:EDIT_TOTLE_FEE_NOTIFICATION object:self.orderDetail];
        }
        else
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:WebServiceErrorNotification object:message];
        }
    }];
}


- (NSString *)easemobToChat:(OrderOwner)owner
{
    return (owner == OrderOwnerBuyer) ? self.orderDetail.seller_easemob : self.orderDetail.buyer_easemob;
}
@end
