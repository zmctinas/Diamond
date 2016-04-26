//
//  OrderEnum.h
//  Diamond
//
//  Created by Pan on 15/9/1.
//  Copyright (c) 2015年 Pan. All rights reserved.
//

#ifndef Diamond_OrderEnum_h
#define Diamond_OrderEnum_h

//请求接口为空素组时，返回所有状态的订单
#define ORDER_STATUS_ALL @[]

typedef NS_ENUM(NSInteger, OrderStatus)
{
    OrderStatusWaitCommit = 0,/**< 等待提交的订单*/
    OrderStatusUnpay = 1,/**< 未付款订单*/
    OrderStatusPaied = 2,/**< 已付款，卖家未发货*/
    OrderStatusSellerConformed = 3,/**< 卖家已发货*/
    OrderStatusBuyerConformed = 4,/**< 买家已确认收货*/
    OrderStatusCancel = 5 /**< 订单撤销*/
};

typedef NS_ENUM(NSInteger, OrderOwner)
{
    OrderOwnerBuyer = 1,
    OrderOwnerSeller
};

//订单详情类型。因为提交订单 和订单详情略有不同，所以需要分开
typedef NS_ENUM(NSInteger, OrderDetailType)
{
    OrderDetailTypeCommit = 101,/**< 尚未提交的订单*/
    OrderDetailTypeNormal /**< 其他订单*/
};

typedef NS_ENUM(NSInteger, DeliveryType)
{
    DeliveryTypeBuyer = 0,/**< 买家自提*/
    DeliveryTypeSeller = 1 /**< 卖家送货*/
};

typedef NS_ENUM(NSInteger, PaymentType)
{
    PaymentTypeOffLine = 0,/**< 当面付款*/
    PaymentTypeOnLine = 1/**< 在线支付*/
};


#endif
